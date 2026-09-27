import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../models/safety_report.dart';
import '../../models/taxonomy.dart';
import '../../state/app_state.dart';
import '../../state/reports_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import '../../widgets/map/map_painter.dart';
import '../../widgets/map/map_projection.dart';
import '../../widgets/map/safar_map.dart';
import '../../l10n/app_localizations.dart';

/// One community signal in full, with confirm / dispute / withdraw actions.
class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key, required this.reportId});

  final String reportId;

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  /// Tracks what this user has already done, so a second tap is refused rather
  /// than silently counted twice.
  bool _confirmed = false;
  bool _disputed = false;

  Future<void> _confirm(SafetyReport report) async {
    if (_confirmed || _disputed) return;
    final ok = await confirmAction(
      context,
      title: 'Confirm this report?',
      message:
          'Only confirm if you have seen this yourself. Confirmations are what '
          'move a signal from unverified to confirmed.',
      confirmLabel: 'Yes, I saw this',
      icon: Icons.how_to_reg_outlined,
    );
    if (!ok || !mounted) return;

    final reports = context.read<ReportsProvider>();
    reports.confirm(report.id);
    unawaited(reports.confirmRemote(report.id));
    context.read<AppState>().recordConfirmation();
    setState(() => _confirmed = true);
    Toast.show(
      context,
      'Thanks — your confirmation makes this signal stronger.',
      tone: ToastTone.success,
    );
  }

  Future<void> _dispute(SafetyReport report) async {
    if (_confirmed || _disputed) return;
    final ok = await confirmAction(
      context,
      title: 'Dispute this report?',
      message:
          'Use this when the condition is no longer there, or was never there. '
          'Two disputes mark the report as disputed for everyone.',
      confirmLabel: 'Dispute it',
      destructive: true,
      icon: Icons.gpp_maybe_outlined,
    );
    if (!ok || !mounted) return;

    context.read<ReportsProvider>().dispute(report.id);
    setState(() => _disputed = true);
    Toast.show(context, 'Recorded. Thanks for keeping the map honest.');
  }

  Future<void> _withdraw(SafetyReport report) async {
    final ok = await confirmAction(
      context,
      title: 'Withdraw your report?',
      message:
          'It will stop affecting routes immediately and will no longer be '
          'shown to other travellers.',
      confirmLabel: 'Withdraw',
      destructive: true,
      icon: Icons.undo_rounded,
    );
    if (!ok || !mounted) return;
    final reports = context.read<ReportsProvider>();
    reports.withdraw(report.id);
    unawaited(reports.withdrawRemote(report.id));
    Toast.show(context, 'Your report has been withdrawn.');
  }

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<ReportsProvider>();
    final report = reports.byId(widget.reportId);
    final gutter = Gap.page(context);

    if (report == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Report')),
        body: EmptyState(
          icon: Icons.search_off_rounded,
          title: 'This report is no longer available',
          message:
              'It may have expired or been withdrawn by whoever submitted it.',
          primaryLabel: 'Go back',
          onPrimary: () => Navigator.of(context).pop(),
        ),
      );
    }

    final t = Theme.of(context).textTheme;
    final colour = report.category.color;
    final withheld = report.status == ReportStatus.withheld;
    final part = reports.awarenessFor(report.roadSegmentId);
    final others = reports
        .forSegment(report.roadSegmentId)
        .where((r) => r.id != report.id)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            collapsedHeight: 64,
            backgroundColor: context.scheme.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: SafarMap(
                bounds: boundsFor(
                  [report.location, ...part.segment.path],
                  marginFactor: 0.5,
                ),
                reports: [report, ...others],
                selectedReportId: report.id,
                segmentTints: [
                  MapSegmentTint(
                    segmentId: report.roadSegmentId,
                    color: colour,
                    strong: part.hasHardBlock,
                  ),
                ],
                interactive: false,
                preferDesigned: true,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header --------------------------------------------------
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colour.withValues(
                            alpha: context.isDark ? 0.22 : 0.11,
                          ),
                          borderRadius: Radii.allMd,
                        ),
                        child: Icon(
                          report.specificType.icon,
                          size: 23,
                          color: colour,
                        ),
                      ),
                      const SizedBox(width: Gap.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.specificType.label,
                              style: t.headlineSmall,
                            ),
                            Text(
                              '${report.areaName} · ${TimeUtils.relative(report.createdAt)}',
                              style: t.labelMedium?.copyWith(
                                color: context.tokens.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Gap.lg),

                  Wrap(
                    spacing: Gap.sm - 2,
                    runSpacing: Gap.sm - 3,
                    children: [
                      StatusChip(status: report.status, dense: false),
                      if (!withheld)
                        ConfidenceChip(band: report.confidenceBand, dense: false),
                      CategoryChip(category: report.category, dense: false),
                      if (report.approximated)
                        Pill(
                          label: 'Approximate location',
                          icon: Icons.blur_on_rounded,
                          color: context.tokens.textSecondary,
                        ),
                      if (report.isMine)
                        Pill(
                          label: 'Your report',
                          icon: Icons.person_outline_rounded,
                          color: context.scheme.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: Gap.lg),

                  // --- Public text or withheld notice ---------------------------
                  if (withheld)
                    InfoPanel(
                      title: 'Not published',
                      text:
                          'This report was withheld because it appeared to '
                          'identify a specific person. It never affected routes '
                          'and no other traveller can see it.',
                      icon: Icons.person_off_outlined,
                      tone: AppColors.danger,
                    )
                  else
                    SafarCard(
                      accentEdge: colour,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('What travellers see', style: t.labelSmall),
                          const SizedBox(height: Gap.sm),
                          Text(
                            report.safePublicText,
                            style: t.bodyLarge?.copyWith(height: 1.5),
                          ),
                        ],
                      ),
                    ),

                  // --- Reporter's own words (only for their own report) ---------
                  if (report.isMine && report.description != null) ...[
                    const SizedBox(height: Gap.md),
                    SafarCard(
                      elevated: false,
                      color: context.tokens.surfaceAlt,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('What you wrote', style: t.labelSmall),
                          const SizedBox(height: Gap.sm - 2),
                          Text('"${report.description}"', style: t.bodySmall),
                          const SizedBox(height: Gap.sm),
                          Text(
                            'Visible only to you.',
                            style: t.labelMedium?.copyWith(
                              color: context.tokens.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: Gap.lg),

                  // --- Facts grid -------------------------------------------------
                  StatTileRow(
                    tiles: [
                      StatTile(
                          value: report.severity.label,
                          label: 'Severity',
                          icon: Icons.speed_rounded,
                          tone: report.severity.color,
                        ),
                      StatTile(
                          value: '${report.confirmationCount}',
                          label: 'Confirmations',
                          icon: Icons.how_to_reg_outlined,
                          tone: AppColors.awarenessLow,
                        ),
                      StatTile(
                          value: '${report.disputeCount}',
                          label: 'Disputes',
                          icon: Icons.thumb_down_outlined,
                          tone: AppColors.awarenessElevated,
                        ),
                    ],
                  ),
                  const SizedBox(height: Gap.md),

                  SafarCard(
                    padding: const EdgeInsets.all(Gap.md),
                    child: Column(
                      children: [
                        _Fact(
                          icon: Icons.alt_route_rounded,
                          label: 'Route effect',
                          value: report.specificType.routeEffect,
                        ),
                        _Fact(
                          icon: Icons.hourglass_bottom_rounded,
                          label: 'Expiry',
                          value: TimeUtils.untilExpiry(report.expiresAt),
                        ),
                        _Fact(
                          icon: Icons.translate_rounded,
                          label: 'Reported in',
                          value: report.language.label,
                        ),
                        _Fact(
                          icon: report.classifiedByAi
                              ? Icons.auto_awesome_rounded
                              : Icons.touch_app_outlined,
                          label: 'Categorised',
                          value: report.classifiedByAi
                              ? 'Automatically, confirmed by the reporter'
                              : 'Manually by the reporter',
                        ),
                        _Fact(
                          icon: Icons.person_outline_rounded,
                          label: 'Reported by',
                          value: report.anonymous && !report.isMine
                              ? 'Anonymous resident'
                              : report.reporterHandle,
                          last: true,
                        ),
                      ],
                    ),
                  ),

                  // --- Segment context ---------------------------------------------
                  const SizedBox(height: Gap.xxl),
                  SectionHeader(
                    title: 'On ${part.segment.name}',
                    subtitle: others.isEmpty
                        ? 'No other live reports on this road'
                        : '${others.length} other live report${others.length == 1 ? '' : 's'}',
                    padding: const EdgeInsets.only(bottom: Gap.md),
                    action: AwarenessBadge(
                      level: part.level,
                      dense: true,
                      short: true,
                    ),
                  ),
                  if (others.isEmpty)
                    const InfoPanel(
                      text:
                          'This is the only live report on this stretch, so the '
                          'signal rests on one person. Confirmations from other '
                          'travellers make it more reliable.',
                      icon: Icons.person_outline_rounded,
                      dense: true,
                    )
                  else
                    for (final other in others)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Gap.sm),
                        child: SafarCard(
                          padding: const EdgeInsets.all(Gap.md),
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ReportDetailScreen(reportId: other.id),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                other.specificType.icon,
                                size: 18,
                                color: other.category.color,
                              ),
                              const SizedBox(width: Gap.md),
                              Expanded(
                                child: Text(
                                  other.specificType.label,
                                  style: t.titleSmall,
                                ),
                              ),
                              Text(
                                TimeUtils.compact(other.createdAt),
                                style: t.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),

                  const SizedBox(height: Gap.lg),
                  const InfoPanel(
                    text: AppText.demoDataExplainer,
                    icon: Icons.science_outlined,
                    dense: true,
                  ),
                  const SizedBox(height: Gap.x3l),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: withheld
          ? null
          : _actions(context, report),
    );
  }

  Widget _actions(BuildContext context, SafetyReport report) {
    if (report.isExpired) {
      return StickyActionBar(
        note: 'Expired reports no longer affect routes.',
        primary: OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(L.of(context).back),
        ),
      );
    }

    if (report.isMine) {
      return StickyActionBar(
        primary: OutlinedButton.icon(
          onPressed: () => _withdraw(report),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.scheme.error,
          ),
          icon: const Icon(Icons.undo_rounded, size: 18),
          label: const Text('Withdraw this report'),
        ),
      );
    }

    final acted = _confirmed || _disputed;

    return StickyActionBar(
      note: acted
          ? _confirmed
              ? 'You confirmed this report. One response per person.'
              : 'You disputed this report. One response per person.'
          : 'Have you seen this yourself?',
      primary: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: acted ? null : () => _confirm(report),
              icon: Icon(
                _confirmed ? Icons.check_circle_rounded : Icons.check_rounded,
                size: 18,
              ),
              label: Text(_confirmed ? 'Confirmed' : 'I saw this too'),
            ),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: acted ? null : () => _dispute(report),
              icon: const Icon(Icons.gpp_maybe_outlined, size: 18),
              label: Text(_disputed ? 'Disputed' : 'Not there'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : Gap.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: context.tokens.textTertiary),
          const SizedBox(width: Gap.md),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.tokens.textSecondary,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
