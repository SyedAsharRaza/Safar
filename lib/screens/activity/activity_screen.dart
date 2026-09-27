import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/router/transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../models/app_notification.dart';
import '../../models/taxonomy.dart';
import '../../state/checkin_provider.dart';
import '../../state/notifications_provider.dart';
import '../../state/reports_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import '../../widgets/reports/report_card.dart';
import '../checkin/checkin_setup_screen.dart';
import '../report/report_detail_screen.dart';
import '../report/report_flow_screen.dart';

/// Activity: alerts, the user's own reports, and past check-ins.
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: Gap.page(context),
          title: const Text('Activity'),
          actions: [
            Consumer<NotificationsProvider>(
              builder: (context, n, _) => n.unreadCount == 0
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        n.markAllRead();
                        Toast.show(context, 'All alerts marked as read.');
                      },
                      child: const Text('Mark all read'),
                    ),
            ),
            SizedBox(width: Gap.page(context) - Gap.md),
          ],
          bottom: TabBar(
            isScrollable: false,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: context.scheme.primary, width: 2.5),
              insets: const EdgeInsets.symmetric(horizontal: Gap.lg),
            ),
            tabs: const [
              Tab(text: 'Alerts'),
              Tab(text: 'My reports'),
              Tab(text: 'Check-ins'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AlertsTab(),
            _MyReportsTab(),
            _CheckinsTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _AlertsTab extends StatelessWidget {
  const _AlertsTab();

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationsProvider>();
    final gutter = Gap.page(context);

    if (notifications.isEmpty) {
      return EmptyState(
        icon: Icons.notifications_none_rounded,
        title: 'No alerts yet',
        message:
            'You will hear from us when a new report lands on a route you use, '
            'when someone confirms one of your reports, or when a check-in '
            'needs your attention.',
        primaryLabel: 'Browse the map',
        onPrimary: () => Navigator.of(context).maybePop(),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 120),
      itemCount: notifications.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: Gap.sm),
      itemBuilder: (context, i) {
        final item = notifications.items[i];
        return StaggeredFadeIn(
          index: i,
          child: _NotificationCard(item: item),
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SafarCard(
      padding: const EdgeInsets.all(Gap.md),
      color: item.read
          ? null
          : context.scheme.primary.withValues(alpha: context.isDark ? 0.08 : 0.04),
      borderColor: item.read
          ? null
          : context.scheme.primary.withValues(alpha: 0.28),
      onTap: () {
        context.read<NotificationsProvider>().markRead(item.id);
        if (item.reportId != null) {
          Navigator.of(context).push(
            SlideRoute(child: ReportDetailScreen(reportId: item.reportId!)),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.kind.color
                  .withValues(alpha: context.isDark ? 0.22 : 0.11),
              borderRadius: Radii.allSm,
            ),
            child: Icon(item.kind.icon, size: 18, color: item.kind.color),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: t.titleSmall?.copyWith(
                          fontWeight:
                              item.read ? FontWeight.w600 : FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: Gap.sm),
                    Text(
                      TimeUtils.compact(item.createdAt),
                      style: t.labelMedium
                          ?.copyWith(color: context.tokens.textTertiary),
                    ),
                    if (!item.read)
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(left: Gap.sm - 2),
                        decoration: BoxDecoration(
                          color: context.scheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Gap.xs),
                Text(
                  item.body,
                  style: t.bodySmall?.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _MyReportsTab extends StatelessWidget {
  const _MyReportsTab();

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<ReportsProvider>();
    final mine = reports.mine;
    final gutter = Gap.page(context);

    if (mine.isEmpty) {
      return EmptyState(
        icon: Icons.campaign_outlined,
        title: 'You have not reported anything yet',
        message:
            'The first time you tell other travellers about a blocked lane or a '
            'broken streetlight, it will show up here.',
        primaryLabel: 'Make your first report',
        onPrimary: () => Navigator.of(context)
            .push(SlideUpRoute(child: const ReportFlowScreen())),
      );
    }

    final live = mine.where((r) => r.isLive).toList();
    final past = mine.where((r) => !r.isLive).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 120),
      children: [
        StatTileRow(
          tiles: [
            StatTile(
                value: '${mine.length}',
                label: 'Total reports',
                icon: Icons.campaign_outlined,
              ),
            StatTile(
                value: '${live.length}',
                label: 'Live now',
                icon: Icons.sensors_rounded,
              ),
            StatTile(
                value:
                    '${mine.where((r) => r.status == ReportStatus.corroborated).length}',
                label: 'Confirmed by others',
                icon: Icons.verified_outlined,
              ),
          ],
        ),

        if (live.isNotEmpty) ...[
          const SizedBox(height: Gap.xxl),
          const SectionHeader(
            title: 'Live',
            subtitle: 'Still affecting route awareness',
            padding: EdgeInsets.only(bottom: Gap.md),
          ),
          for (var i = 0; i < live.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: StaggeredFadeIn(
                index: i,
                child: ReportCard(
                  report: live[i],
                  showRouteEffect: true,
                  onTap: () => Navigator.of(context).push(
                    SlideRoute(child: ReportDetailScreen(reportId: live[i].id)),
                  ),
                ),
              ),
            ),
        ],

        if (past.isNotEmpty) ...[
          const SizedBox(height: Gap.xxl),
          const SectionHeader(
            title: 'Expired and withheld',
            subtitle: 'No longer affecting routes',
            padding: EdgeInsets.only(bottom: Gap.md),
          ),
          for (final r in past)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: ReportCard(
                report: r,
                dense: true,
                onTap: () => Navigator.of(context).push(
                  SlideRoute(child: ReportDetailScreen(reportId: r.id)),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _CheckinsTab extends StatelessWidget {
  const _CheckinsTab();

  @override
  Widget build(BuildContext context) {
    final checkin = context.watch<CheckinProvider>();
    final gutter = Gap.page(context);
    final history = checkin.history;

    if (history.isEmpty && checkin.active == null) {
      return EmptyState(
        icon: Icons.timer_outlined,
        title: 'No check-ins yet',
        message:
            'A check-in is a timer you share with someone you trust. If you do '
            'not confirm you arrived, they know to look for you.',
        primaryLabel: 'Start a check-in',
        onPrimary: () => Navigator.of(context)
            .push(SlideUpRoute(child: const CheckinSetupScreen())),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 120),
      children: [
        if (checkin.active != null) ...[
          const SectionHeader(
            title: 'Running now',
            padding: EdgeInsets.only(bottom: Gap.md),
          ),
          SafarCard(
            accentEdge: context.scheme.tertiary,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        checkin.active!.destinationName.isEmpty
                            ? 'Check-in in progress'
                            : 'Heading to ${checkin.active!.destinationName}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${TimeUtils.clock(checkin.active!.remaining)} remaining',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    SlideUpRoute(child: const CheckinSetupScreen()),
                  ),
                  child: const Text('Open'),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xxl),
        ],

        if (history.isNotEmpty) ...[
          const SectionHeader(
            title: 'Past check-ins',
            padding: EdgeInsets.only(bottom: Gap.md),
          ),
          for (final c in history)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.sm),
              child: SafarCard(
                padding: const EdgeInsets.all(Gap.md),
                child: Row(
                  children: [
                    Icon(
                      switch (c.status.name) {
                        'arrived' => Icons.check_circle_outline,
                        'cancelled' => Icons.cancel_outlined,
                        _ => Icons.timer_off_outlined,
                      },
                      size: 19,
                      color: c.status.name == 'arrived'
                          ? context.scheme.tertiary
                          : context.tokens.textSecondary,
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            c.destinationName.isEmpty
                                ? c.status.label
                                : '${c.status.label} · ${c.destinationName}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '${TimeUtils.dayMonth(c.startedAt)} at ${TimeUtils.timeOfDay(c.startedAt)} · '
                            '${c.plannedDuration.inMinutes} min planned',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Pill(
                      label: '${c.contacts.length}',
                      icon: Icons.people_outline_rounded,
                      color: context.tokens.textTertiary,
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }
}
