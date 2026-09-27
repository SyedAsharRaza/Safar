import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../state/app_state.dart';
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
import '../../widgets/routes/route_card.dart';
import '../report/report_detail_screen.dart';
import '../report/report_flow_screen.dart';
import 'route_details_screen.dart';

/// Route comparison: map on top, sortable route cards in a draggable sheet.
class RouteResultsScreen extends StatefulWidget {
  const RouteResultsScreen({super.key});

  @override
  State<RouteResultsScreen> createState() => _RouteResultsScreenState();
}

class _RouteResultsScreenState extends State<RouteResultsScreen> {
  final GlobalKey<SafarMapState> _mapKey = GlobalKey<SafarMapState>();
  String? _selectedReportId;

  Future<void> _retry() async {
    final routes = context.read<RoutesProvider>();
    await routes.plan(reports: context.read<ReportsProvider>().live);
  }

  @override
  Widget build(BuildContext context) {
    final routes = context.watch<RoutesProvider>();
    final reports = context.watch<ReportsProvider>();
    final app = context.watch<AppState>();

    final origin = routes.origin;
    final destination = routes.destination;

    // Frame the map on the trip, or the whole demo area before routes exist.
    final bounds = routes.options.isEmpty
        ? boundsFor([
            if (origin != null) origin.location,
            if (destination != null) destination.location,
          ])
        : boundsFor([
            for (final r in routes.options) ...r.polyline,
            if (origin != null) origin.location,
            if (destination != null) destination.location,
          ]);

    final selected = routes.selected;

    return Scaffold(
      body: Stack(
        children: [
          // --- Map -----------------------------------------------------------
          Positioned.fill(
            child: SafarMap(
              key: _mapKey,
              bounds: bounds,
              animateRoute: true,
              routeLines: [
                for (final r in routes.options)
                  MapRouteLine(
                    points: r.polyline,
                    color: routeColourFor(r.flavour),
                    selected: r.id == selected?.id,
                    dashed: r.id != selected?.id,
                  ),
              ],
              segmentTints: selected == null
                  ? tintsForReports(reports.live)
                  : tintsForReports(selected.reports),
              reports: selected?.reports ?? reports.live,
              selectedReportId: _selectedReportId,
              origin: origin?.location,
              destination: destination?.location,
              originLabel: origin?.name,
              destinationLabel: destination?.name,
              showBadge: true,
              obscuredBottom: MediaQuery.sizeOf(context).height * 0.52,
              onReportTap: (r) {
                setState(() => _selectedReportId = r.id);
                _showReportPreview(r.id);
              },
            ),
          ),

          // --- Top bar -------------------------------------------------------
          _TopBar(
            origin: origin?.name ?? 'Start',
            destination: destination?.name ?? 'Destination',
            onBack: () => Navigator.of(context).pop(),
            onSwap: () async {
              context.read<RoutesProvider>().swap();
              await _retry();
            },
            onRecentre: () => _mapKey.currentState?.recentre(),
          ),

          if (app.offline)
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.paddingOf(context).top + 92,
              child: const OfflineBanner(),
            ),

          // --- Sheet ---------------------------------------------------------
          _ResultsSheet(
            state: routes.state,
            onRetry: _retry,
          ),
        ],
      ),
    );
  }

  void _showReportPreview(String id) {
    showSafarSheet<void>(
      context,
      title: 'Community signal',
      subtitle: 'Tap through for the full report and its route effect.',
      child: Consumer<ReportsProvider>(
        builder: (context, reports, _) {
          final report = reports.byId(id);
          if (report == null) {
            return const Text('This report is no longer available.');
          }
          return Column(
            children: [
              Text(
                report.safePublicText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: Gap.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: Gap.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          SlideRoute(
                            child: ReportDetailScreen(reportId: id),
                          ),
                        );
                      },
                      child: const Text('Open report'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.origin,
    required this.destination,
    required this.onBack,
    required this.onSwap,
    required this.onRecentre,
  });

  final String origin;
  final String destination;
  final VoidCallback onBack;
  final VoidCallback onSwap;
  final VoidCallback onRecentre;

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);

    return Positioned(
      left: gutter,
      right: gutter,
      top: MediaQuery.paddingOf(context).top + Gap.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SafarCard(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.sm,
              vertical: Gap.sm,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  tooltip: 'Back',
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.trip_origin_rounded,
                            size: 11,
                            color: context.scheme.tertiary,
                          ),
                          const SizedBox(width: Gap.sm - 2),
                          Expanded(
                            child: Text(
                              origin,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.place_rounded,
                            size: 11,
                            color: context.scheme.error,
                          ),
                          const SizedBox(width: Gap.sm - 2),
                          Expanded(
                            child: Text(
                              destination,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onSwap,
                  icon: const Icon(Icons.swap_vert_rounded, size: 19),
                  tooltip: 'Reverse the trip',
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.sm),
          _MapButton(
            icon: Icons.center_focus_strong_rounded,
            tooltip: 'Recentre the map',
            onTap: onRecentre,
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: context.scheme.surface,
        borderRadius: Radii.allSm,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: Radii.allSm,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: Radii.allSm,
              border: Border.all(color: context.tokens.border),
            ),
            child: Icon(icon, size: 19, color: context.tokens.textPrimary),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ResultsSheet extends StatelessWidget {
  const _ResultsSheet({required this.state, required this.onRetry});

  final PlanState state;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.52,
      minChildSize: 0.24,
      maxChildSize: 0.92,
      snap: true,
      snapSizes: const [0.24, 0.52, 0.92],
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: context.scheme.surface,
            borderRadius: Radii.sheet,
            border: Border(top: BorderSide(color: context.tokens.border)),
            boxShadow: Shadows.sheet(context.isDark),
          ),
          child: ClipRRect(
            borderRadius: Radii.sheet,
            child: _body(context, controller),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, ScrollController controller) {
    final routes = context.watch<RoutesProvider>();
    final gutter = Gap.page(context);

    final header = Column(
      children: [
        const SizedBox(height: Gap.md),
        Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            color: context.tokens.textTertiary.withValues(alpha: 0.45),
            borderRadius: Radii.pill,
          ),
        ),
        const SizedBox(height: Gap.lg),
      ],
    );

    return switch (state) {
      PlanState.planning || PlanState.idle => ListView(
          controller: controller,
          padding: EdgeInsets.zero,
          children: [
            header,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comparing routes…',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: Gap.xs),
                  Text(
                    'Scoring each road segment against recent community reports.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: Gap.xl),
                  const LoadingList(count: 3, route: true),
                ],
              ),
            ),
            const SizedBox(height: Gap.x4l),
          ],
        ),
      PlanState.error => ListView(
          controller: controller,
          children: [
            header,
            ErrorStateView(
              message: routes.error ?? 'Route planning failed.',
              onRetry: onRetry,
              secondaryLabel: 'Change destination',
              onSecondary: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      PlanState.tooClose => ListView(
          controller: controller,
          children: [
            header,
            EmptyState(
              icon: Icons.near_me_disabled_outlined,
              title: 'These places are too close together',
              message:
                  'Your start and destination sit on the same junction of the '
                  'road network, so there is nothing to compare. Pick a '
                  'destination further away.',
              primaryLabel: 'Change destination',
              onPrimary: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      PlanState.empty => ListView(
          controller: controller,
          children: [
            header,
            EmptyState(
              icon: Icons.wrong_location_outlined,
              title: 'No route between these points',
              message:
                  'This prototype covers one demo area of Bahawalpur, so not '
                  'every pair of places is connected in the seeded road network. '
                  'Try a different destination.',
              primaryLabel: 'Change destination',
              onPrimary: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      PlanState.ready => _ReadyList(controller: controller),
    };
  }
}

class _ReadyList extends StatelessWidget {
  const _ReadyList({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final routes = context.watch<RoutesProvider>();
    final options = routes.options;
    final fastest = routes.fastest;
    final gutter = Gap.page(context);
    final selected = routes.selected;

    return ListView(
      controller: controller,
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: Gap.md),
        Center(
          child: Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: context.tokens.textTertiary.withValues(alpha: 0.45),
              borderRadius: Radii.pill,
            ),
          ),
        ),
        const SizedBox(height: Gap.lg),

        // --- Header + sort ---------------------------------------------------
        Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      options.length == 1
                          ? 'One sensible route'
                          : '${options.length} routes to compare',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: Gap.xxs),
                    Text(
                      'Route awareness, never a safety score.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: Gap.md),
                    RouteLegend(
                      flavours: options.map((r) => r.flavour).toList(),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Sort routes',
                onPressed: () => _sortSheet(context),
                icon: const Icon(Icons.sort_rounded, size: 20),
              ),
            ],
          ),
        ),

        if (options.length == 1)
          Padding(
            padding: EdgeInsets.fromLTRB(gutter, Gap.md, gutter, 0),
            child: const InfoPanel(
              text:
                  'The seeded road network offers no meaningfully different '
                  'alternative for this trip, so there is only one option to show.',
              icon: Icons.info_outline,
              dense: true,
            ),
          ),

        const SizedBox(height: Gap.lg),

        // --- Route cards ------------------------------------------------------
        for (var i = 0; i < options.length; i++)
          Padding(
            padding: EdgeInsets.fromLTRB(gutter, 0, gutter, Gap.md),
            child: StaggeredFadeIn(
              index: i,
              child: RouteCard(
                route: options[i],
                selected: options[i].id == selected?.id,
                deltaMinutes: fastest == null
                    ? null
                    : options[i].minutes - fastest.minutes,
                onTap: () => context.read<RoutesProvider>().select(options[i]),
                onDetails: () => Navigator.of(context).push(
                  SlideRoute(child: RouteDetailsScreen(route: options[i])),
                ),
              ),
            ),
          ),

        // --- Actions ------------------------------------------------------------
        Padding(
          padding: EdgeInsets.fromLTRB(gutter, Gap.sm, gutter, 0),
          child: Column(
            children: [
              FilledButton.icon(
                onPressed: selected == null
                    ? null
                    : () => Navigator.of(context).push(
                          SlideRoute(
                            child: RouteDetailsScreen(route: selected),
                          ),
                        ),
                icon: const Icon(Icons.navigation_rounded, size: 19),
                label: Text(
                  selected == null
                      ? 'Choose a route'
                      : 'Take ${selected.flavour.label.toLowerCase()}',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              const SizedBox(height: Gap.sm),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context)
                    .push(SlideUpRoute(child: const ReportFlowScreen())),
                icon: const Icon(Icons.add_comment_outlined, size: 18),
                label: const Text('Report an issue on this route'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(gutter, Gap.xl, gutter, 0),
          child: const Row(
            children: [DemoDataBadge(dense: true)],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(gutter, Gap.md, gutter, 0),
          child: const InfoPanel(
            text: AppText.disclaimer,
            icon: Icons.shield_outlined,
            dense: true,
          ),
        ),
        const SizedBox(height: Gap.x4l),
      ],
    );
  }

  void _sortSheet(BuildContext context) {
    final routes = context.read<RoutesProvider>();
    showSafarSheet<void>(
      context,
      title: 'Sort routes',
      scrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final s in RouteSort.values)
            RadioListTile<RouteSort>(
              value: s,
              // ignore: deprecated_member_use
              groupValue: routes.sort,
              contentPadding: EdgeInsets.zero,
              title: Text(s.label),
              // ignore: deprecated_member_use
              onChanged: (v) {
                if (v != null) routes.setSort(v);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
