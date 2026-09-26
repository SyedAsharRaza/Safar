import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

enum NotificationKind {
  routeAlert('Route alert'),
  reportConfirmed('Report confirmed'),
  reportExpired('Report expired'),
  reportWithheld('Report not published'),
  checkin('Safety check-in'),
  community('Community'),
  system('System');

  const NotificationKind(this.label);
  final String label;

  IconData get icon => switch (this) {
        NotificationKind.routeAlert => Icons.alt_route_outlined,
        NotificationKind.reportConfirmed => Icons.verified_outlined,
        NotificationKind.reportExpired => Icons.history_toggle_off_outlined,
        NotificationKind.reportWithheld => Icons.visibility_off_outlined,
        NotificationKind.checkin => Icons.timer_outlined,
        NotificationKind.community => Icons.groups_outlined,
        NotificationKind.system => Icons.info_outline,
      };

  Color get color => switch (this) {
        NotificationKind.routeAlert => AppColors.awarenessElevated,
        NotificationKind.reportConfirmed => AppColors.awarenessLow,
        NotificationKind.reportExpired => AppColors.awarenessUnknown,
        NotificationKind.reportWithheld => AppColors.awarenessUnknown,
        NotificationKind.checkin => AppColors.teal,
        NotificationKind.community => AppColors.brand,
        NotificationKind.system => AppColors.awarenessUnknown,
      };
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
    this.reportId,
  });

  final String id;
  final NotificationKind kind;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final String? reportId;

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        kind: kind,
        title: title,
        body: body,
        createdAt: createdAt,
        read: read ?? this.read,
        reportId: reportId,
      );
}
