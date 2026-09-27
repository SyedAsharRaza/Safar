import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/app_notification.dart';

/// Handles a push that arrives while the app is terminated or backgrounded.
///
/// Must be a top-level function: Android spins up a separate isolate for it, so
/// anything captured from the app's state would not exist here.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  // Deliberately minimal. Android already shows the notification from the
  // `notification` block; doing real work here risks an ANR in a cold isolate.
  debugPrint('Background push: ${message.messageId}');
}

/// Push notifications for new community signals.
///
/// Subscribes to a topic rather than registering a device token, which keeps
/// the product's anonymity promise: no token is ever stored next to a location,
/// so there is nothing that could reconstruct where a handset has been.
///
/// Every failure path here is non-fatal. Notifications are an enhancement; an
/// app that cannot reach Firebase must still plan routes.
class PushService {
  PushService({this.topic = 'bwp_reports'});

  final String topic;

  static const _channelId = 'bwp_reports';

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  /// Emits when a notification arrives, so the UI can add it to the feed.
  final StreamController<AppNotification> _incoming =
      StreamController<AppNotification>.broadcast();
  Stream<AppNotification> get incoming => _incoming.stream;

  /// Emits a report id when a notification is tapped, for deep linking.
  final StreamController<String> _opened = StreamController<String>.broadcast();
  Stream<String> get opened => _opened.stream;

  bool _ready = false;
  bool _permissionGranted = false;

  bool get isReady => _ready;
  bool get hasPermission => _permissionGranted;

  /// Sets everything up. Safe to call more than once.
  Future<bool> initialise() async {
    if (_ready) return true;
    try {
      await Firebase.initializeApp();

      // Android 13+ will not deliver anything without this, and fails silently
      // rather than erroring — which makes it easy to lose an hour to.
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      _permissionGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;

      await _createChannel();

      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onOpened);

      // A notification may have launched the app from cold.
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) _onOpened(initial);

      if (_permissionGranted) {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
      }

      _ready = true;
      return true;
    } catch (error) {
      debugPrint('Push unavailable: $error');
      _ready = false;
      return false;
    }
  }

  /// Android needs an explicit channel or notifications are dropped silently.
  Future<void> _createChannel() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _local.initialize(
      settings: const InitializationSettings(android: androidInit),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) _opened.add(payload);
      },
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      'Community signals',
      description:
          'Alerts about blocked roads, hazards and safety concerns reported nearby.',
      importance: Importance.high,
    );

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Android does not display a notification while the app is in the
  /// foreground, so we raise a local one and mirror it into the in-app feed.
  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      await _local.show(
        id: message.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            'Community signals',
            importance: Importance.high,
            priority: Priority.high,
            color: Color(0xFF2563A8),
          ),
        ),
        payload: data['reportId'],
      );
    }

    _incoming.add(_toAppNotification(message));
  }

  void _onOpened(RemoteMessage message) {
    final reportId = message.data['reportId'];
    if (reportId != null && reportId.isNotEmpty) _opened.add(reportId);
    _incoming.add(_toAppNotification(message));
  }

  AppNotification _toAppNotification(RemoteMessage message) {
    final data = message.data;
    final category = data['category'] ?? '';
    return AppNotification(
      id: message.messageId ?? 'push_${DateTime.now().microsecondsSinceEpoch}',
      kind: category == 'safety_concern'
          ? NotificationKind.routeAlert
          : NotificationKind.community,
      title: message.notification?.title ?? 'New community report',
      body: message.notification?.body ?? '',
      createdAt: DateTime.now(),
      reportId: (data['reportId'] ?? '').isEmpty ? null : data['reportId'],
    );
  }

  Future<void> unsubscribe() async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    } catch (_) {
      // Nothing useful to do if this fails.
    }
  }

  void dispose() {
    _incoming.close();
    _opened.close();
  }
}
