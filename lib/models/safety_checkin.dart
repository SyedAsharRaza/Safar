import 'trusted_contact.dart';

enum CheckinStatus {
  active('Active'),
  arrived('Arrived safely'),
  cancelled('Cancelled'),
  overdue('Overdue');

  const CheckinStatus(this.label);
  final String label;
}

/// A "let someone know I'm travelling" timer. Contacts are notified only in
/// the real product; here the notification is simulated.
class SafetyCheckin {
  SafetyCheckin({
    required this.id,
    required this.startedAt,
    required this.plannedDuration,
    required this.contacts,
    required this.status,
    this.destinationName = '',
    this.routeName = '',
    this.endedAt,
    this.shareLiveLocation = true,
  });

  final String id;
  final DateTime startedAt;
  final Duration plannedDuration;
  final List<TrustedContact> contacts;
  final CheckinStatus status;
  final String destinationName;
  final String routeName;
  final DateTime? endedAt;
  final bool shareLiveLocation;

  DateTime get dueAt => startedAt.add(plannedDuration);

  Duration get remaining {
    final left = dueAt.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  Duration get overdueBy {
    final over = DateTime.now().difference(dueAt);
    return over.isNegative ? Duration.zero : over;
  }

  bool get isActive => status == CheckinStatus.active;

  double get progress {
    if (plannedDuration.inSeconds == 0) return 1;
    final elapsed = DateTime.now().difference(startedAt).inSeconds;
    return (elapsed / plannedDuration.inSeconds).clamp(0.0, 1.0);
  }

  SafetyCheckin copyWith({CheckinStatus? status, DateTime? endedAt}) =>
      SafetyCheckin(
        id: id,
        startedAt: startedAt,
        plannedDuration: plannedDuration,
        contacts: contacts,
        status: status ?? this.status,
        destinationName: destinationName,
        routeName: routeName,
        endedAt: endedAt ?? this.endedAt,
        shareLiveLocation: shareLiveLocation,
      );
}
