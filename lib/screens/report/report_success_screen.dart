import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/router/transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../state/reports_provider.dart';
import '../../state/routes_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/surfaces.dart';
import '../../widgets/reports/report_card.dart';
import 'report_detail_screen.dart';

/// Confirmation after publishing. Two variants: published, or withheld because
/// the report identified a person.
class ReportSuccessScreen extends StatefulWidget {
  const ReportSuccessScreen({
    super.key,
    required this.reportId,
    this.withheld = false,
    this.withheldReason,
  });

  final String reportId;
  final bool withheld;
  final String? withheldReason;

  @override
  State<ReportSuccessScreen> createState() => _ReportSuccessScreenState();
}

class _ReportSuccessScreenState extends State<ReportSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<ReportsProvider>();
    final routes = context.watch<RoutesProvider>();
    final report = reports.byId(widget.reportId);
    final gutter = Gap.page(context);
    final t = Theme.of(context).textTheme;

    final tone = widget.withheld ? AppColors.awarenessUnknown : AppColors.awarenessLow;

    // If routes are on screen, say how this report changed them.
    final affected = routes.options
        .where((r) => r.reports.any((x) => x.id == widget.reportId))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(gutter, Gap.x3l, gutter, Gap.xxl),
          children: [
            Center(
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _c,
                  curve: Motion.spring,
                ),
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tone.withValues(alpha: context.isDark ? 0.2 : 0.11),
                  ),
                  child: Icon(
                    widget.withheld
                        ? Icons.visibility_off_rounded
                        : Icons.check_circle_rounded,
                    size: 44,
                    color: tone,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Gap.xxl),
            Text(
              widget.withheld
                  ? 'Report not published'
                  : 'Your report is live',
              textAlign: TextAlign.center,
              style: t.headlineMedium,
            ),
            const SizedBox(height: Gap.sm),
            Text(
              widget.withheld
                  ? widget.withheldReason ??
                      'This report identified a person, so it was not published.'
                  : 'It is now visible to other travellers as an unverified '
                      'community signal.',
              textAlign: TextAlign.center,
              style: t.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: Gap.xxl),

            if (report != null)
              ReportCard(
                report: report,
                showRouteEffect: !widget.withheld,
                onTap: () => Navigator.of(context).push(
                  SlideRoute(child: ReportDetailScreen(reportId: report.id)),
                ),
              ),

            if (!widget.withheld) ...[
              const SizedBox(height: Gap.lg),

              // --- What happens next ------------------------------------------
              SafarCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('What happens next', style: t.titleMedium),
                    const SizedBox(height: Gap.md),
                    _Step(
                      icon: Icons.how_to_reg_outlined,
                      title: 'Other travellers can confirm it',
                      body:
                          'Two independent confirmations move it from unverified '
                          'to confirmed, which makes it count for more.',
                    ),
                    _Step(
                      icon: Icons.trending_down_rounded,
                      title: 'It fades over time',
                      body: report?.expiresAt == null
                          ? 'Older reports gradually stop affecting routes.'
                          : '${TimeUtils.untilExpiry(report!.expiresAt)}. Older '
                              'reports gradually stop affecting routes.',
                    ),
                    _Step(
                      icon: Icons.edit_outlined,
                      title: 'You stay in control',
                      body:
                          'You can correct the category or withdraw the report '
                          'from your reports list at any time.',
                      last: true,
                    ),
                  ],
                ),
              ),

              // --- Route impact -----------------------------------------------
              if (affected.isNotEmpty) ...[
                const SizedBox(height: Gap.lg),
                SafarCard(
                  borderColor: context.scheme.primary.withValues(alpha: 0.35),
                  color: context.scheme.primary
                      .withValues(alpha: context.isDark ? 0.10 : 0.045),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.alt_route_rounded,
                            size: 18,
                            color: context.scheme.primary,
                          ),
                          const SizedBox(width: Gap.sm),
                          Text('Routes updated', style: t.titleSmall),
                        ],
                      ),
                      const SizedBox(height: Gap.md),
                      for (final r in affected)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Gap.sm - 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  r.flavour.label,
                                  style: t.bodySmall,
                                ),
                              ),
                              AwarenessBadge(
                                level: r.level,
                                dense: true,
                                short: true,
                                showIcon: false,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: Gap.sm),
                      Text(
                        'Your report is already part of how these routes are '
                        'scored.',
                        style: t.labelMedium?.copyWith(
                          color: context.tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: Gap.lg),
              Row(
                children: [
                  const Expanded(child: DemoDataBadge(dense: true)),
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: StickyActionBar(
        primary: FilledButton(
          onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
          child: const Text('Done'),
        ),
        secondary: widget.withheld
            ? null
            : OutlinedButton.icon(
                onPressed: () {
                  Toast.show(
                    context,
                    'Sharing is not wired up in this UI build.',
                  );
                },
                icon: const Icon(Icons.ios_share_rounded, size: 17),
                label: const Text('Share this signal'),
              ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.icon,
    required this.title,
    required this.body,
    this.last = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : Gap.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: context.scheme.primary),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 1),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
