import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../models/route_option.dart';
import '../../state/app_state.dart';
import '../../state/checkin_provider.dart';
import '../../state/reports_provider.dart';
import '../../state/routes_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import '../../widgets/map/map_painter.dart';
import '../../widgets/map/map_projection.dart';
import '../../widgets/map/mock_map.dart';
import '../../widgets/map/safar_map.dart';
import '../../widgets/reports/report_card.dart';
import '../../widgets/routes/awareness_breakdown.dart';
import '../../widgets/routes/route_card.dart';
import '../../widgets/routes/voice_warning.dart';
import '../checkin/checkin_setup_screen.dart';
import '../report/report_detail_screen.dart';
import '../report/report_flow_screen.dart';

/// Everything about one chosen route: the map, what is on it, why it scores the
/// way it does, the voice warning, and the check-in handoff.
class RouteDetailsScreen extends StatefulWidget {
  const RouteDetailsScreen({super.key, required this.route});

  final RouteOption route;

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  String? _selectedReportId;
  bool _showBreakdown = false;

  /// Reads the live route from the provider when available, so a report
  /// submitted from this screen updates the numbers in place.
  RouteOption get _route {
    final routes = context.watch<RoutesProvider>();
    return routes.options.where((r) => r.id == widget.route.id).firstOrNull ??
        widget.route;
  }

  void _playWarning() {
    final app = context.read<AppState>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => VoiceWarningSheet(
        lines: voiceLineFor(_route),
        initialLanguage: app.language,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final route = _route;
    final routes = context.watch<RoutesProvider>();
    final gutter = Gap.page(context);
    final colour = routeColourFor(route.flavour);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- Map header, collapses into a normal app bar --------------------
          SliverAppBar(
            pinned: true,
            expandedHeight: 286,
            collapsedHeight: 64,
            backgroundColor: context.scheme.surface,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(Gap.sm),
              child: _CircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(Gap.sm),
                child: _CircleButton(
                  icon: Icons.volume_up_rounded,
                  onTap: _playWarning,
                  tooltip: 'Play voice warning',
                ),
              ),
              SizedBox(width: gutter - Gap.sm),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SafarMap(
                bounds: boundsFor(route.polyline),
                animateRoute: true,
                routeLines: [
                  MapRouteLine(
                    points: route.polyline,
                    color: colour,
                    selected: true,
                  ),
                ],
                segmentTints: tintsForReports(route.reports),
                reports: route.reports,
                selectedReportId: _selectedReportId,
                showBadge: true,
                origin: routes.origin?.location,
                destination: routes.destination?.location,
                onReportTap: (r) => setState(() => _selectedReportId = r.id),
              ),
            ),
          ),

          // --- Headline ---------------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colour.withValues(
                            alpha: context.isDark ? 0.24 : 0.12,
                          ),
                          borderRadius: Radii.allSm,
                        ),
                        child: Icon(
                          routeIconFor(route.flavour),
                          size: 19,
                          color: colour,
                        ),
                      ),
                      const SizedBox(width: Gap.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(route.flavour.label, style: t.headlineSmall),
                            Text(
                              route.flavour.labelRoman,
                              style: t.labelMedium?.copyWith(
                                color: context.tokens.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AwarenessBadge(level: route.level, dense: true, short: true),
                    ],
                  ),
                  const SizedBox(height: Gap.lg),
                  StatTileRow(
                    tiles: [
                      StatTile(
                          value: TimeUtils.minutes(route.totalMinutes),
                          label: 'Estimated time',
                          icon: Icons.schedule_rounded,
                          tone: colour,
                        ),
                      StatTile(
                          value: TimeUtils.distance(route.distanceKm),
                          label: 'Distance',
                          icon: Icons.straighten_rounded,
                          tone: colour,
                        ),
                      StatTile(
                          value: '${route.reports.length}',
                          label: 'Live reports',
                          icon: Icons.campaign_outlined,
                          tone: colour,
                        ),
                    ],
                  ),
                  const SizedBox(height: Gap.lg),
                  SafarCard(
                    color: colour.withValues(alpha: context.isDark ? 0.10 : 0.05),
                    borderColor: colour.withValues(alpha: 0.32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18, color: colour),
                        const SizedBox(width: Gap.md),
                        Expanded(
                          child: Text(
                            route.explanation,
                            style: t.bodyMedium?.copyWith(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Voice warning ------------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 0),
              child: _VoiceWarningCard(
                route: route,
                onPlay: _playWarning,
              ),
            ),
          ),

          // --- Reports on this route ------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, Gap.xxl, gutter, Gap.md),
              child: SectionHeader(
                eyebrow: 'On this route',
                title: route.reports.isEmpty
                    ? 'No live reports'
                    : 'What travellers reported',
                subtitle: route.reports.isEmpty
                    ? null
                    : 'Newest first. Older reports count for less.',
                padding: EdgeInsets.zero,
                action: const DemoDataBadge(dense: true),
              ),
            ),
          ),

          if (route.reports.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                child: SafarCard(
                  child: EmptyState(
                    compact: true,
                    icon: Icons.help_outline_rounded,
                    title: 'Limited data on this route',
                    message:
                        'Nobody has reported anything here recently. That is not '
                        'a clear signal either way — it just means we do not know.',
                    primaryLabel: 'Report what you see',
                    onPrimary: () => Navigator.of(context)
                        .push(SlideUpRoute(child: const ReportFlowScreen())),
                  ),
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                child: SafarCard(
                  child: ReportTimeline(
                    reports: route.reports,
                    onTapReport: (r) => Navigator.of(context).push(
                      SlideRoute(child: ReportDetailScreen(reportId: r.id)),
                    ),
                  ),
                ),
              ),
            ),

          // --- Segment list ------------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, Gap.xxl, gutter, Gap.md),
              child: const SectionHeader(
                eyebrow: 'Step by step',
                title: 'Roads on this route',
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: SegmentList(
                parts: route.awareness,
                onTapSegment: (part) => _segmentSheet(context, part.segment.id),
              ),
            ),
          ),

          // --- Explainability -----------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, Gap.xxl, gutter, 0),
              child: SafarCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () =>
                          setState(() => _showBreakdown = !_showBreakdown),
                      borderRadius: Radii.allSm,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Why this awareness level?',
                              style: t.titleMedium,
                            ),
                          ),
                          AnimatedRotation(
                            turns: _showBreakdown ? 0.5 : 0,
                            duration: Motion.base,
                            child: Icon(
                              Icons.expand_more_rounded,
                              color: context.tokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedSize(
                      duration: Motion.base,
                      curve: Motion.emphasized,
                      alignment: Alignment.topCenter,
                      child: _showBreakdown
                          ? Padding(
                              padding: const EdgeInsets.only(top: Gap.lg),
                              child: AwarenessBreakdown(route: route),
                            )
                          : const SizedBox(width: double.infinity),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 0),
              child: const InfoPanel(
                text: AppText.disclaimer,
                icon: Icons.shield_outlined,
                dense: true,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: Gap.x3l)),
        ],
      ),
      bottomNavigationBar: StickyActionBar(
        note: 'Check-in notifications are simulated in this UI build.',
        primary: FilledButton.icon(
          onPressed: () => Navigator.of(context).push(
            SlideUpRoute(
              child: CheckinSetupScreen(
                destinationName: routes.destination?.name ?? '',
                routeName: route.flavour.label,
                suggestedMinutes: route.minutes,
              ),
            ),
          ),
          icon: const Icon(Icons.timer_outlined, size: 19),
          label: Text(
            context.watch<CheckinProvider>().hasActive
                ? 'Check-in already running'
                : 'Start safety check-in',
          ),
        ),
        secondary: OutlinedButton.icon(
          onPressed: () => Navigator.of(context)
              .push(SlideUpRoute(child: const ReportFlowScreen())),
          icon: const Icon(Icons.add_comment_outlined, size: 18),
          label: const Text('Report a nearby issue'),
        ),
      ),
    );
  }

  void _segmentSheet(BuildContext context, String segmentId) {
    final reports = context.read<ReportsProvider>();
    final part = reports.awarenessFor(segmentId);
    final onSegment = reports.forSegment(segmentId);

    showSafarSheet<void>(
      context,
      title: part.segment.name,
      subtitle:
          '${part.segment.area} · ${part.segment.lengthKm.toStringAsFixed(1)} km',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AwarenessBadge(level: part.level, dense: true),
              const SizedBox(width: Gap.sm),
              Pill(
                label: part.hasHardBlock
                    ? 'Reported blocked'
                    : '${onSegment.length} report${onSegment.length == 1 ? '' : 's'}',
                icon: part.hasHardBlock
                    ? Icons.block_outlined
                    : Icons.campaign_outlined,
                color: part.hasHardBlock
                    ? AppColors.danger
                    : context.tokens.textSecondary,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: Gap.lg),
          StatTileRow(
            tiles: [
              StatTile(
                  value: '${(part.segment.baseLightingScore * 100).round()}%',
                  label: 'Baseline lighting',
                  icon: Icons.lightbulb_outline,
                  tone: AppColors.accentDeep,
                ),
              StatTile(
                  value: '${(part.segment.activityScore * 100).round()}%',
                  label: 'How busy',
                  icon: Icons.groups_outlined,
                  tone: AppColors.teal,
                ),
              StatTile(
                  value: part.extraMinutes < 1
                      ? '—'
                      : '+${part.extraMinutes.round()}m',
                  label: 'Reported delay',
                  icon: Icons.timer_outlined,
                  tone: AppColors.awarenessModerate,
                ),
            ],
          ),
          if (onSegment.isNotEmpty) ...[
            const SizedBox(height: Gap.xl),
            for (final r in onSegment)
              Padding(
                padding: const EdgeInsets.only(bottom: Gap.sm),
                child: ReportMiniCard(
                  report: r,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      SlideRoute(child: ReportDetailScreen(reportId: r.id)),
                    );
                  },
                ),
              ),
          ] else ...[
            const SizedBox(height: Gap.lg),
            const InfoPanel(
              text:
                  'No community reports on this stretch. The level above comes '
                  'from its baseline lighting and how busy it usually is.',
              icon: Icons.help_outline,
              dense: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _VoiceWarningCard extends StatelessWidget {
  const _VoiceWarningCard({required this.route, required this.onPlay});

  final RouteOption route;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final lines = voiceLineFor(route);
    final app = context.watch<AppState>();
    final preview = lines[app.voiceKey] ?? lines['en']!;

    return SafarCard(
      onTap: onPlay,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.scheme.primary
                  .withValues(alpha: context.isDark ? 0.22 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: context.scheme.primary,
            ),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Voice warning',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(width: Gap.sm),
                    Pill(
                      label: app.language.nativeLabel,
                      color: context.tokens.textTertiary,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.4,
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

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap, this.tooltip});

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: context.scheme.surface,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 19, color: context.tokens.textPrimary),
        ),
      ),
    );
    return tooltip == null
        ? button
        : Tooltip(message: tooltip!, child: button);
  }
}
