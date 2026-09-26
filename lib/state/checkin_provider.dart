import 'dart:async';

import 'package:flutter/material.dart';

import '../data/mock/mock_misc.dart';
import '../models/safety_checkin.dart';
import '../models/trusted_contact.dart';

/// Drives the safety check-in timer and the trusted-contact list.
///
/// No message is actually sent anywhere — the notification to contacts is
/// simulated, and every screen that mentions it says so.
class CheckinProvider extends ChangeNotifier {
  CheckinProvider() : _contacts = [...MockContacts.all];

  SafetyCheckin? _active;
  final List<SafetyCheckin> _history = [];
  List<TrustedContact> _contacts;
  Timer? _ticker;

  SafetyCheckin? get active => _active;
  List<SafetyCheckin> get history => List.unmodifiable(_history.reversed);
  List<TrustedContact> get contacts => List.unmodifiable(_contacts);

  bool get hasActive => _active?.isActive ?? false;
  bool get hasContacts => _contacts.isNotEmpty;

  TrustedContact? get primaryContact =>
      _contacts.where((c) => c.isPrimary).firstOrNull ?? _contacts.firstOrNull;

  void start({
    required Duration duration,
    required List<TrustedContact> notify,
    String destinationName = '',
    String routeName = '',
    bool shareLocation = true,
  }) {
    _active = SafetyCheckin(
      id: 'chk_${DateTime.now().microsecondsSinceEpoch}',
      startedAt: DateTime.now(),
      plannedDuration: duration,
      contacts: notify,
      status: CheckinStatus.active,
      destinationName: destinationName,
      routeName: routeName,
      shareLiveLocation: shareLocation,
    );
    _startTicker();
    notifyListeners();
  }

  void extend(Duration extra) {
    final a = _active;
    if (a == null || !a.isActive) return;
    _active = SafetyCheckin(
      id: a.id,
      startedAt: a.startedAt,
      plannedDuration: a.plannedDuration + extra,
      contacts: a.contacts,
      status: CheckinStatus.active,
      destinationName: a.destinationName,
      routeName: a.routeName,
      shareLiveLocation: a.shareLiveLocation,
    );
    notifyListeners();
  }

  void arrived() => _finish(CheckinStatus.arrived);

  void cancel() => _finish(CheckinStatus.cancelled);

  void _finish(CheckinStatus status) {
    final a = _active;
    if (a == null) return;
    final done = a.copyWith(status: status, endedAt: DateTime.now());
    _history.add(done);
    _active = null;
    _ticker?.cancel();
    _ticker = null;
    notifyListeners();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final a = _active;
      if (a == null) return;
      // Flip to overdue once the window passes, rather than silently ending.
      if (a.isActive && a.remaining == Duration.zero) {
        _active = a.copyWith(status: CheckinStatus.overdue);
      }
      notifyListeners();
    });
  }

  void addContact(TrustedContact c) {
    _contacts = [..._contacts, c];
    notifyListeners();
  }

  void removeContact(String id) {
    _contacts = _contacts.where((c) => c.id != id).toList();
    notifyListeners();
  }

  void makePrimary(String id) {
    _contacts = [
      for (final c in _contacts) c.copyWith(isPrimary: c.id == id),
    ];
    notifyListeners();
  }

  /// Demo switch: start with no contacts to show the empty state.
  void clearContacts() {
    _contacts = [];
    notifyListeners();
  }

  void restoreContacts() {
    _contacts = [...MockContacts.all];
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
