import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/bahawalpur_geo.dart';
import '../../models/taxonomy.dart';
import '../../state/app_state.dart';
import '../../state/reports_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import '../../widgets/map/mock_map.dart';
import '../../widgets/map/safar_map.dart';
import '../../widgets/reports/report_card.dart';
import '../report/report_detail_screen.dart';
import '../report/report_flow_screen.dart';

/// Full-screen map of every community signal, with category filters and a
/// draggable list underneath.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final GlobalKey<SafarMapState> _mapKey = GlobalKey<SafarMapState>();
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<ReportsProvider>();
    final app = context.watch<AppState>();
    final visible = reports.visible;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SafarMap(
              key: _mapKey,
              bounds: BwpGeo.bounds,
              reports: visible,
              segmentTints: tintsForReports(visible),
              selectedReportId: _selectedId,
              userLocation: BwpGeo.fawaraChowk,
              showBadge: true,
              obscuredBottom: MediaQuery.sizeOf(context).height * 0.34,
              onReportTap: (r) => setState(() => _selectedId = r.id),
            ),
          ),

          // --- Filters ---------------------------------------------------------
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.paddingOf(context).top + Gap.sm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (app.offline) const OfflineBanner(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: Gap.page(context),
                    vertical: Gap.sm,
                  ),
                  child: Row(
                    children: [
                      SelectableChip(
                        label: 'All',
                        icon: Icons.layers_outlined,
                        selected: !reports.hasFilters,
                        count: reports.live.length,
                        onTap: reports.clearFilters,
                      ),
                      const SizedBox(width: Gap.sm),
                      for (final c in ReportCategory.pickable) ...[
                        SelectableChip(
                          label: c.label,
                          icon: c.icon,
                          accent: c.color,
                          selected: reports.filters.contains(c),
                          count: reports.countFor(c),
                          onTap: () => reports.toggleFilter(c),
                        ),
                        const SizedBox(width: Gap.sm),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Map controls -----------------------------------------------------
          Positioned(
            right: Gap.page(context),
            bottom: MediaQuery.sizeOf(context).height * 0.34 + Gap.lg,
            child: Column(
              children: [
                _Control(
                  icon: Icons.center_focus_strong_rounded,
                  tooltip: 'Recentre',
                  onTap: () => _mapKey.currentState?.recentre(),
                ),
                const SizedBox(height: Gap.sm),
                _Control(
                  icon: reports.includeExpired
                      ? Icons.history_toggle_off_rounded
                      : Icons.history_rounded,
                  tooltip: reports.includeExpired
                      ? 'Hide expired reports'
                      : 'Show expired reports',
                  active: reports.includeExpired,
                  onTap: () {
                    reports.setIncludeExpired(!reports.includeExpired);
                    Toast.show(
                      context,
                      reports.includeExpired
                          ? 'Showing expired reports too. They do not affect routes.'
                          : 'Hiding expired reports.',
                    );
                  },
                ),
              ],
            ),
          ),

          // --- Sheet -------------------------------------------------------------
          DraggableScrollableSheet(
            initialChildSize: 0.34,
            minChildSize: 0.16,
            maxChildSize: 0.88,
            snap: true,
            snapSizes: const [0.16, 0.34, 0.88],
            builder: (context, controller) => Container(
              decoration: BoxDecoration(
                color: context.scheme.surface,
                borderRadius: Radii.sheet,
                border: Border(top: BorderSide(color: context.tokens.border)),
                boxShadow: Shadows.sheet(context.isDark),
              ),
              child: ClipRRect(
                borderRadius: Radii.sheet,
                child: _list(context, controller, reports),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _list(
    BuildContext context,
    ScrollController controller,
    ReportsProvider reports,
  ) {
    final gutter = Gap.page(context);
    final visible = reports.visible;

    final handle = Column(
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
      ],
    );

    if (reports.state == LoadState.loading) {
      return ListView(
        controller: controller,
        children: [
          handle,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            child: const LoadingList(count: 3),
          ),
        ],
      );
    }

    if (reports.state == LoadState.error) {
      return ListView(
        controller: controller,
        children: [
          handle,
          ErrorStateView(
            message: reports.error ?? 'Could not load community signals.',
            onRetry: () => reports.load(),
          ),
        ],
      );
    }

    return ListView(
      controller: controller,
      padding: EdgeInsets.zero,
      children: [
        handle,
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
                      reports.hasFilters
                          ? '${visible.length} filtered signal${visible.length == 1 ? '' : 's'}'
                          : '${visible.length} community signal${visible.length == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: Gap.xxs),
                    Text(
                      'Tap a pin on the map, or scroll the list.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const DemoDataBadge(dense: true),
            ],
          ),
        ),
        const SizedBox(height: Gap.lg),

        if (visible.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            child: reports.hasFilters
                ? EmptyState(
                    compact: true,
                    icon: Icons.filter_alt_off_outlined,
                    title: 'Nothing matches these filters',
                    message:
                        'No live reports in the categories you selected. Clear '
                        'the filters to see everything in the demo area.',
                    primaryLabel: 'Clear filters',
                    onPrimary: reports.clearFilters,
                  )
                : EmptyState(
                    compact: true,
                    icon: Icons.map_outlined,
                    title: 'No signals in this area yet',
                    message:
                        'Limited data is not the same as a clear road. If you '
                        'see something, you can be the first to report it.',
                    primaryLabel: 'Add a report',
                    onPrimary: () => Navigator.of(context)
                        .push(SlideUpRoute(child: const ReportFlowScreen())),
                  ),
          )
        else
          for (var i = 0; i < visible.length; i++)
            Padding(
              padding: EdgeInsets.fromLTRB(gutter, 0, gutter, Gap.md),
              child: ReportCard(
                report: visible[i],
                dense: true,
                trailing: visible[i].id == _selectedId
                    ? Icon(
                        Icons.my_location_rounded,
                        size: 15,
                        color: context.scheme.primary,
                      )
                    : null,
                onTap: () => Navigator.of(context).push(
                  SlideRoute(
                    child: ReportDetailScreen(reportId: visible[i].id),
                  ),
                ),
              ),
            ),

        Padding(
          padding: EdgeInsets.fromLTRB(gutter, Gap.md, gutter, 0),
          child: const InfoPanel(
            text: AppText.demoDataExplainer,
            icon: Icons.science_outlined,
            dense: true,
          ),
        ),
        const SizedBox(height: 110),
      ],
    );
  }
}

class _Control extends StatelessWidget {
  const _Control({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: active ? context.scheme.primary : context.scheme.surface,
        borderRadius: Radii.allSm,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: Radii.allSm,
              border: Border.all(color: context.tokens.border),
            ),
            child: Icon(
              icon,
              size: 19,
              color: active ? Colors.white : context.tokens.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
