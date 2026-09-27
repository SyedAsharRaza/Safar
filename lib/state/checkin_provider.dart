import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/safety_checkin.dart';
import '../models/trusted_contact.dart';

/// Drives the safety check-in timer and the trusted-contact list.
///
/// No message is actually sent anywhere — the notification to contacts is
/// simulated, and every screen that mentions it says so.
class CheckinProvider extends ChangeNotifier {
  CheckinProvider() {
    _restoreContacts();
  }

  static const _contactsKey = 'safar_trusted_contacts';

  SafetyCheckin? _active;
  final List<SafetyCheckin> _history = [];

  /// Starts empty. Contacts are whoever the user actually adds — seeding them
  /// with invented names would put fake people in a safety feature.
  List<TrustedContact> _contacts = [];
  Timer? _ticker;

  bool _contactsLoaded = false;
  bool get contactsLoaded => _contactsLoaded;

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

  /// Contacts live on this device only — they are never uploaded, so a
  /// check-in never puts someone else's number on a server.
  Future<void> _restoreContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_contactsKey);
      if (raw != null && raw.isNotEmpty) {
        final list = (jsonDecode(raw) as List<dynamic>)
            .cast<Map<String, dynamic>>();
        _contacts = list
            .map((m) => TrustedContact(
                  id: m['id'] as String,
                  name: m['name'] as String,
                  relation: m['relation'] as String? ?? 'Contact',
                  phone: m['phone'] as String? ?? '',
                  isPrimary: m['isPrimary'] as bool? ?? false,
                ))
            .toList();
      }
    } catch (_) {
      // Corrupt storage should not stop the app starting.
      _contacts = [];
    }
    _contactsLoaded = true;
    notifyListeners();
  }

  Future<void> _persistContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _contactsKey,
        jsonEncode([
          for (final c in _contacts)
            {
              'id': c.id,
              'name': c.name,
              'relation': c.relation,
              'phone': c.phone,
              'isPrimary': c.isPrimary,
            },
        ]),
      );
    } catch (_) {
      // Keep the in-memory list even if it could not be written.
    }
  }

  void addContact(TrustedContact c) {
    // The first contact added becomes primary, so a check-in always has
    // someone to notify without an extra step.
    final isFirst = _contacts.isEmpty;
    _contacts = [..._contacts, isFirst ? c.copyWith(isPrimary: true) : c];
    _persistContacts();
    notifyListeners();
  }

  void removeContact(String id) {
    final removed = _contacts.firstWhere(
      (c) => c.id == id,
      orElse: () => _contacts.first,
    );
    _contacts = _contacts.where((c) => c.id != id).toList();
    // Removing the primary promotes the next one rather than leaving none.
    if (removed.isPrimary && _contacts.isNotEmpty) {
      _contacts = [
        _contacts.first.copyWith(isPrimary: true),
        ..._contacts.skip(1),
      ];
    }
    _persistContacts();
    notifyListeners();
  }

  void makePrimary(String id) {
    _contacts = [
      for (final c in _contacts) c.copyWith(isPrimary: c.id == id),
    ];
    _persistContacts();
    notifyListeners();
  }

  void clearContacts() {
    _contacts = [];
    _persistContacts();
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
