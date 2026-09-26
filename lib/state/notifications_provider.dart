import 'package:flutter/material.dart';

import '../data/mock/mock_misc.dart';
import '../models/app_notification.dart';

class NotificationsProvider extends ChangeNotifier {
  NotificationsProvider() : _items = MockNotifications.seed();

  List<AppNotification> _items;

  List<AppNotification> get items {
    final list = [..._items]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  int get unreadCount => _items.where((n) => !n.read).length;
  bool get isEmpty => _items.isEmpty;

  void markRead(String id) {
    _items = [
      for (final n in _items) n.id == id ? n.copyWith(read: true) : n,
    ];
    notifyListeners();
  }

  void markAllRead() {
    _items = [for (final n in _items) n.copyWith(read: true)];
    notifyListeners();
  }

  void clearAll() {
    _items = [];
    notifyListeners();
  }

  /// Pushes a local notification when the user's own action produces one, e.g.
  /// publishing a report that affects a route.
  void push(AppNotification n) {
    _items = [n, ..._items];
    notifyListeners();
  }
}
