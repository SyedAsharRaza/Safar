import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../models/safety_report.dart';
import '../../models/taxonomy.dart';
import '../common/badges.dart';
import '../common/surfaces.dart';

/// The standard community-signal row. Used on the explore list, route details,
/// my-reports and the home feed, so the signal always reads the same way.
class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    this.onTap,
    this.showSegment = true,
    this.showRouteEffect = false,
    this.trailing,
    this.dense = false,
  });

  final SafetyReport report;
  final VoidCallback? onTap;
  final bool showSegment;

  /// Adds the "what this does to routing" line — used on route details.
  final bool showRouteEffect;
  final Widget? trailing;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final expired = report.isExpired;
    final withheld = report.status == ReportStatus.withheld;
    final color = report.category.color;

    // A withheld report has no public text, so the reporter sees why instead.
    final body = withheld
        ? 'This report was not published because it appeared to identify a person.'
        : report.safePublicText;

    return SafarCard(
      onTap: onTap,
      padding: EdgeInsets.all(dense ? Gap.md : Gap.lg),
      accentEdge: expired || withheld ? null : color,
      child: Opacity(
        opacity: expired || withheld ? 0.72 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: dense ? 34 : 40,
                  height: dense ? 34 : 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: context.isDark ? 0.2 : 0.1),
                    borderRadius: Radii.allSm,
                  ),
                  child: Icon(
                    report.specificType.icon,
                    size: dense ? 17 : 20,
                    color: color,
                  ),
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
                              report.specificType.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.titleMedium,
                            ),
                          ),
                          const SizedBox(width: Gap.sm),
                          Text(
                            TimeUtils.compact(report.createdAt),
                            style: t.labelMedium
                                ?.copyWith(color: context.tokens.textTertiary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      if (showSegment)
                        Text(
                          report.areaName.isEmpty
                              ? report.category.label
                              : report.areaName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodySmall
                              ?.copyWith(color: context.tokens.textSecondary),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: Gap.sm),
                  trailing!,
                ],
              ],
            ),
            if (body.isNotEmpty) ...[
              SizedBox(height: dense ? Gap.sm : Gap.md),
              Text(
                body,
                maxLines: dense ? 2 : 3,
                overflow: TextOverflow.ellipsis,
                style: t.bodyMedium?.copyWith(height: 1.45),
              ),
            ],
            if (showRouteEffect && !expired && !withheld) ...[
              const SizedBox(height: Gap.md),
              Row(
                children: [
                  Icon(
                    Icons.alt_route_rounded,
                    size: 14,
                    color: context.tokens.textTertiary,
                  ),
                  const SizedBox(width: Gap.sm - 2),
                  Expanded(
                    child: Text(
                      'Route effect: ${report.specificType.routeEffect.toLowerCase()}',
                      style: t.labelMedium
                          ?.copyWith(color: context.tokens.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: dense ? Gap.sm : Gap.md),
            Wrap(
              spacing: Gap.sm - 2,
              runSpacing: Gap.sm - 3,
              children: [
                StatusChip(status: report.status),
                if (!withheld) ConfidenceChip(band: report.confidenceBand),
                if (report.confirmationCount > 0)
                  Pill(
                    label:
                        '${report.confirmationCount} confirmed${report.confirmationCount == 1 ? '' : ''}',
                    icon: Icons.how_to_reg_outlined,
                    color: context.scheme.tertiary,
                    dense: true,
                  ),
                if (report.disputeCount > 0)
                  Pill(
                    label: '${report.disputeCount} disputed',
                    icon: Icons.thumb_down_outlined,
                    color: context.scheme.error,
                    dense: true,
                  ),
                if (report.approximated)
                  Pill(
                    label: 'Approximate location',
                    icon: Icons.blur_on_rounded,
                    color: context.tokens.textSecondary,
                    dense: true,
                  ),
                if (!report.classifiedByAi && !withheld)
                  Pill(
                    label: 'Manually categorised',
                    icon: Icons.touch_app_outlined,
                    color: context.tokens.textSecondary,
                    dense: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Condensed single-line variant for the map's bottom carousel.
class ReportMiniCard extends StatelessWidget {
  const ReportMiniCard({
    super.key,
    required this.report,
    this.onTap,
    this.selected = false,
  });

  final SafetyReport report;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final color = report.category.color;

    return SafarCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Gap.md),
      borderColor: selected ? color.withValues(alpha: 0.6) : null,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: context.isDark ? 0.2 : 0.1),
              borderRadius: Radii.allSm,
            ),
            child: Icon(report.specificType.icon, size: 18, color: color),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  report.specificType.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleSmall,
                ),
                const SizedBox(height: 1),
                Text(
                  '${report.areaName} · ${TimeUtils.relative(report.createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.labelMedium
                      ?.copyWith(color: context.tokens.textSecondary),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: context.tokens.textTertiary,
          ),
        ],
      ),
    );
  }
}

/// Vertical timeline of reports along a route, newest at the top.
class ReportTimeline extends StatelessWidget {
  const ReportTimeline({
    super.key,
    required this.reports,
    this.onTapReport,
  });

  final List<SafetyReport> reports;
  final ValueChanged<SafetyReport>? onTapReport;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      children: [
        for (var i = 0; i < reports.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rail: dot plus connecting line.
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: reports[i].category.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.scheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                    if (i != reports.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: context.tokens.border,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: i == reports.length - 1 ? 0 : Gap.lg,
                    ),
                    child: InkWell(
                      onTap: onTapReport == null
                          ? null
                          : () => onTapReport!(reports[i]),
                      borderRadius: Radii.allSm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  reports[i].specificType.label,
                                  style: t.titleSmall,
                                ),
                              ),
                              Text(
                                TimeUtils.relative(reports[i].createdAt),
                                style: t.labelMedium?.copyWith(
                                  color: context.tokens.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            reports[i].areaName,
                            style: t.labelMedium
                                ?.copyWith(color: context.tokens.textSecondary),
                          ),
                          const SizedBox(height: Gap.sm - 2),
                          Text(
                            reports[i].safePublicText,
                            style: t.bodySmall?.copyWith(height: 1.42),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
