import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../data/mock/bahawalpur_geo.dart';
import '../../models/saved_place.dart';
import '../../models/taxonomy.dart';
import '../../state/app_state.dart';
import '../../state/checkin_provider.dart';
import '../../state/places_provider.dart';
import '../../state/reports_provider.dart';
import '../../state/routes_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/brand.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/inputs.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import '../../widgets/map/mock_map.dart';
import '../../widgets/map/safar_map.dart';
import '../../widgets/reports/report_card.dart';
import '../checkin/checkin_active_screen.dart';
import '../checkin/checkin_setup_screen.dart';
import '../info/demo_panel_screen.dart';
import '../info/emergency_sheet.dart';
import '../info/help_screen.dart';
import '../report/report_detail_screen.dart';
import '../report/report_flow_screen.dart';
import '../routes/route_results_screen.dart';
import '../search/place_picker_screen.dart';
import 'app_shell.dart';

/// Home: plan a trip, see what is happening nearby, start a check-in.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _pick({required bool isOrigin}) async {
    final routes = context.read<RoutesProvider>();
    final place = await Navigator.of(context).push<Place>(
      SlideUpRoute(
        child: PlacePickerScreen(
          title: isOrigin ? 'Where from?' : 'Where to?',
          excludeId: isOrigin ? routes.destination?.id : routes.origin?.id,
        ),
      ),
    );
    if (place == null || !mounted) return;
    context.read<PlacesProvider>().recordSearch(place);
    if (isOrigin) {
      routes.setOrigin(place);
    } else {
      routes.setDestination(place);
    }
  }

  Future<void> _compare() async {
    final routes = context.read<RoutesProvider>();
    final reports = context.read<ReportsProvider>();
    if (!routes.canPlan) {
      Toast.show(
        context,
        'Choose a start and a destination first.',
        tone: ToastTone.warning,
      );
      return;
    }
    context.read<AppState>().recordTripCompared();
    // Push first so the results screen shows its own loading state, then plan.
    // `plan` only touches the provider, so no BuildContext crosses the gap.
    final planning = routes.plan(reports: reports.live);
    await Navigator.of(context).push(
      SlideUpRoute(child: const RouteResultsScreen()),
    );
    await planning;
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final reports = context.watch<ReportsProvider>();
    final routes = context.watch<RoutesProvider>();
    final checkin = context.watch<CheckinProvider>();
    final places = context.watch<PlacesProvider>();
    final gutter = Gap.page(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await reports.refresh();
          if (context.mounted) {
            Toast.show(context, 'Community signals refreshed.');
          }
        },
        child: CustomScrollView(
          slivers: [
            _appBar(context, app),

            if (app.offline)
              const SliverToBoxAdapter(child: OfflineBanner()),

            // --- Active check-in takes priority over everything else ----------
            if (checkin.active != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(gutter, Gap.md, gutter, 0),
                  child: const _ActiveCheckinStrip(),
                ),
              ),

            // --- Trip planner ---------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 0),
                child: _TripPlanner(
                  origin: routes.origin,
                  destination: routes.destination,
                  onPickOrigin: () => _pick(isOrigin: true),
                  onPickDestination: () => _pick(isOrigin: false),
                  onSwap: routes.origin != null && routes.destination != null
                      ? routes.swap
                      : null,
                  onCompare: _compare,
                  savedPlaces: places.saved,
                  onQuickPick: (p) {
                    routes
                      ..setOrigin(routes.origin ?? _defaultOrigin(places))
                      ..setDestination(p);
                  },
                ),
              ),
            ),

            // --- Area snapshot ---------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 0),
                child: const _AreaSnapshot(),
              ),
            ),

            // --- Quick actions ----------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, 0),
                child: const _QuickActions(),
              ),
            ),

            // --- Live signals ------------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, Gap.xxl, gutter, Gap.md),
                child: SectionHeader(
                  eyebrow: 'Happening now',
                  title: 'Recent community signals',
                  subtitle: reports.state == LoadState.ready
                      ? '${reports.live.length} live in the demo area'
                      : null,
                  padding: EdgeInsets.zero,
                  action: const DemoDataBadge(dense: true),
                ),
              ),
            ),

            _signals(context, reports, gutter),

            // --- Disclaimer ---------------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, Gap.xxl, gutter, 0),
                child: const InfoPanel(
                  text: AppText.disclaimer,
                  icon: Icons.shield_outlined,
                  title: 'Before you rely on this',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, Gap.md, gutter, 0),
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context)
                      .push(SlideRoute(child: const HelpScreen())),
                  icon: const Icon(Icons.help_outline_rounded, size: 17),
                  label: const Text('How route awareness is calculated'),
                ),
              ),
            ),

            // Clears the docked report button.
            const SliverToBoxAdapter(child: SizedBox(height: 108)),
          ],
        ),
      ),
    );
  }

  Place _defaultOrigin(PlacesProvider places) =>
      places.saved.isNotEmpty ? places.saved.first.place : _fallbackOrigin;

  static final Place _fallbackOrigin = Place(
    id: 'pl_current',
    name: 'Current location',
    area: 'Fawara Chowk area',
    kind: PlaceKind.landmark,
    location: BwpGeo.fawaraChowk,
    subtitle: 'Simulated position for this prototype',
  );

  SliverAppBar _appBar(BuildContext context, AppState app) {
    final afterDark = TimeUtils.isAfterDark();
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      toolbarHeight: 66,
      titleSpacing: Gap.page(context),
      title: Row(
        children: [
          const SafarLogo(size: 36),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TimeUtils.greeting(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: context.tokens.textTertiary,
                      ),
                ),
                Text(
                  'Bahawalpur',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (afterDark)
          Tooltip(
            message: 'After dark, lighting reports count for more',
            child: Padding(
              padding: const EdgeInsets.only(right: Gap.xs),
              child: Pill(
                label: 'Night',
                icon: Icons.nightlight_round,
                color: AppColors.accent,
                dense: true,
              ),
            ),
          ),
        IconButton(
          tooltip: 'Emergency numbers',
          onPressed: () => showEmergencySheet(context),
          icon: const Icon(Icons.emergency_outlined, size: 21),
        ),
        IconButton(
          tooltip: 'Demo controls',
          onPressed: () => Navigator.of(context)
              .push(SlideUpRoute(child: const DemoPanelScreen())),
          icon: const Icon(Icons.tune_rounded, size: 21),
        ),
        SizedBox(width: Gap.page(context) - Gap.md),
      ],
    );
  }

  Widget _signals(BuildContext context, ReportsProvider reports, double gutter) {
    if (reports.state == LoadState.loading ||
        reports.state == LoadState.initial) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: const LoadingList(count: 3),
        ),
      );
    }

    if (reports.state == LoadState.error) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: SafarCard(
            child: ErrorStateView(
              title: 'Could not load signals',
              message: reports.error ??
                  'The community signal service did not respond.',
              onRetry: () => reports.load(),
            ),
          ),
        ),
      );
    }

    final list = reports.live.take(4).toList();
    if (list.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: gutter),
          child: SafarCard(
            child: EmptyState(
              compact: true,
              icon: Icons.sentiment_satisfied_outlined,
              title: 'No live reports right now',
              message:
                  'Nothing has been reported in the demo area recently. That is '
                  'not the same as "all clear" — it means we have no data.',
              primaryLabel: 'Be the first to report',
              onPrimary: () => Navigator.of(context)
                  .push(SlideUpRoute(child: const ReportFlowScreen())),
            ),
          ),
        ),
      );
    }

    return SliverList.separated(
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: Gap.md),
      itemBuilder: (context, i) => Padding(
        padding: EdgeInsets.symmetric(horizontal: gutter),
        child: StaggeredFadeIn(
          index: i,
          child: ReportCard(
            report: list[i],
            dense: true,
            onTap: () => Navigator.of(context).push(
              SlideRoute(child: ReportDetailScreen(reportId: list[i].id)),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trip planner
// ---------------------------------------------------------------------------

class _TripPlanner extends StatelessWidget {
  const _TripPlanner({
    required this.origin,
    required this.destination,
    required this.onPickOrigin,
    required this.onPickDestination,
    required this.onSwap,
    required this.onCompare,
    required this.savedPlaces,
    required this.onQuickPick,
  });

  final Place? origin;
  final Place? destination;
  final VoidCallback onPickOrigin;
  final VoidCallback onPickDestination;
  final VoidCallback? onSwap;
  final VoidCallback onCompare;
  final List<SavedPlace> savedPlaces;
  final ValueChanged<Place> onQuickPick;

  @override
  Widget build(BuildContext context) {
    return SafarCard(
      padding: const EdgeInsets.all(Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    PickerField(
                      label: 'From',
                      value: origin?.name,
                      hint: 'Choose a starting point',
                      leading: Icons.trip_origin_rounded,
                      leadingColor: context.scheme.tertiary,
                      onTap: onPickOrigin,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38),
                      child: Divider(height: 1, color: context.tokens.border),
                    ),
                    PickerField(
                      label: 'To',
                      value: destination?.name,
                      hint: 'Where are you going?',
                      leading: Icons.place_rounded,
                      leadingColor: context.scheme.error,
                      onTap: onPickDestination,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Swap',
                onPressed: onSwap,
                icon: const Icon(Icons.swap_vert_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: Gap.md),
          FilledButton.icon(
            onPressed: onCompare,
            icon: const Icon(Icons.alt_route_rounded, size: 19),
            label: const Text('Compare routes'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          if (savedPlaces.isNotEmpty) ...[
            const SizedBox(height: Gap.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final s in savedPlaces)
                    Padding(
                      padding: const EdgeInsets.only(right: Gap.sm),
                      child: SelectableChip(
                        label: s.title,
                        icon: s.label == 'Home'
                            ? Icons.home_rounded
                            : s.place.kind.icon,
                        selected: destination?.id == s.place.id,
                        onTap: () => onQuickPick(s.place),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Area snapshot — a live mini map plus the current awareness band
// ---------------------------------------------------------------------------

class _AreaSnapshot extends StatelessWidget {
  const _AreaSnapshot();

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<ReportsProvider>();
    final level = reports.areaLevel;
    final blocked = reports.blockedSegments;
    final t = Theme.of(context).textTheme;

    return SafarCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // --- Mini map ---------------------------------------------------------
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radii.lg),
            child: SizedBox(
              height: 152,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SafarMap(
                      bounds: BwpGeo.bounds,
                      reports: reports.live,
                      segmentTints: tintsForReports(reports.live),
                      userLocation: BwpGeo.fawaraChowk,
                      interactive: false,
                      compactMarkers: true,
                      showLabels: false,
                      detail: 0.8,
                      preferDesigned: true,
                    ),
                  ),
                  Positioned(
                    left: Gap.md,
                    top: Gap.md,
                    child: AwarenessBadge(level: level, dense: true),
                  ),
                  Positioned(
                    right: Gap.md,
                    bottom: Gap.md,
                    child: Pill(
                      label: 'Open map',
                      icon: Icons.open_in_full_rounded,
                      color: context.tokens.textPrimary,
                      background: context.scheme.surface,
                      dense: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Summary ----------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(Gap.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Around you right now', style: t.titleMedium),
                const SizedBox(height: Gap.sm),
                Text(
                  _summaryLine(reports, blocked.length),
                  style: t.bodySmall?.copyWith(height: 1.45),
                ),
                const SizedBox(height: Gap.md),
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        value: '${reports.live.length}',
                        label: 'Live signals',
                        icon: Icons.campaign_outlined,
                      ),
                    ),
                    const SizedBox(width: Gap.sm),
                    Expanded(
                      child: StatTile(
                        value: '${reports.freshCount}',
                        label: 'In the last hour',
                        icon: Icons.schedule_rounded,
                        tone: AppColors.accentDeep,
                      ),
                    ),
                    const SizedBox(width: Gap.sm),
                    Expanded(
                      child: StatTile(
                        value: '${blocked.length}',
                        label: 'Roads reported blocked',
                        icon: Icons.block_outlined,
                        tone: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _summaryLine(ReportsProvider reports, int blockedCount) {
    if (reports.live.isEmpty) {
      return 'No live community signals in the demo area. Limited data is not '
          'the same as a clear road.';
    }
    final parts = <String>[];
    if (blockedCount > 0) {
      parts.add(
        '$blockedCount road${blockedCount == 1 ? '' : 's'} reported blocked',
      );
    }
    final lighting = reports.countFor(ReportCategory.lightingProblem);
    if (lighting > 0) parts.add('$lighting lighting report${lighting == 1 ? '' : 's'}');
    final water = reports.countFor(ReportCategory.waterOrDrainage);
    if (water > 0) parts.add('$water water report${water == 1 ? '' : 's'}');
    final safety = reports.countFor(ReportCategory.safetyConcern);
    if (safety > 0) {
      parts.add('$safety safety concern${safety == 1 ? '' : 's'}');
    }
    if (parts.isEmpty) {
      return '${reports.live.length} community signals are live in this area.';
    }
    return '${parts.join(', ')}. Compare routes to see which ones you would pass.';
  }
}

// ---------------------------------------------------------------------------
// Quick actions
// ---------------------------------------------------------------------------

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final checkin = context.watch<CheckinProvider>();

    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: Icons.timer_outlined,
            title: checkin.hasActive ? 'Check-in running' : 'Safety check-in',
            subtitle: checkin.hasActive
                ? TimeUtils.clock(checkin.active!.remaining)
                : 'Tell someone you are travelling',
            tone: AppColors.teal,
            onTap: () => Navigator.of(context).push(
              SlideUpRoute(
                child: checkin.hasActive
                    ? const CheckinActiveScreen()
                    : const CheckinSetupScreen(),
              ),
            ),
          ),
        ),
        const SizedBox(width: Gap.md),
        Expanded(
          child: _ActionTile(
            icon: Icons.travel_explore_rounded,
            title: 'Browse the map',
            subtitle: 'See every signal nearby',
            tone: AppColors.brand,
            onTap: () => ShellNav.maybeOf(context)?.goToTab(1),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tone,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SafarCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: context.isDark ? 0.22 : 0.1),
              borderRadius: Radii.allSm,
            ),
            child: Icon(icon, size: 17, color: tone),
          ),
          const SizedBox(height: Gap.md),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: context.tokens.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active check-in strip
// ---------------------------------------------------------------------------

class _ActiveCheckinStrip extends StatelessWidget {
  const _ActiveCheckinStrip();

  @override
  Widget build(BuildContext context) {
    final checkin = context.watch<CheckinProvider>();
    final active = checkin.active;
    if (active == null) return const SizedBox.shrink();

    final overdue = active.status.name == 'overdue';
    final tone = overdue ? AppColors.danger : AppColors.teal;

    return SafarCard(
      onTap: () => Navigator.of(context)
          .push(SlideUpRoute(child: const CheckinActiveScreen())),
      borderColor: tone.withValues(alpha: 0.5),
      color: tone.withValues(alpha: context.isDark ? 0.12 : 0.055),
      padding: const EdgeInsets.all(Gap.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              overdue ? Icons.notification_important_rounded : Icons.timer_rounded,
              size: 19,
              color: tone,
            ),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  overdue ? 'Check-in overdue' : 'Check-in running',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: tone),
                ),
                const SizedBox(height: 1),
                Text(
                  overdue
                      ? 'Overdue by ${TimeUtils.clock(active.overdueBy)} — let them know you are safe'
                      : '${TimeUtils.clock(active.remaining)} left · ${active.contacts.length} contact${active.contacts.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: context.tokens.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.tokens.textTertiary,
          ),
        ],
      ),
    );
  }
}
