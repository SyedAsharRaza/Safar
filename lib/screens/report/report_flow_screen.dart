import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/bahawalpur_geo.dart';
import '../../models/geo.dart';
import '../../models/road_segment.dart';
import '../../models/taxonomy.dart';
import '../../state/app_state.dart';
import '../../state/reports_provider.dart';
import '../../widgets/common/badges.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/inputs.dart';
import '../../widgets/common/states.dart';
import '../../widgets/common/surfaces.dart';
import '../../widgets/map/safar_map.dart';
import 'report_review_screen.dart';
import '../../l10n/app_localizations.dart';

enum _Step { category, issue, location, describe }

enum LocationMode {
  current('Current location', Icons.my_location_rounded),
  pin('Drop a pin', Icons.place_outlined),
  approximate('Approximate area', Icons.blur_on_rounded);

  const LocationMode(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// The four-step report flow from the blueprint: category, exact issue,
/// location, description. Submitting hands off to the AI review screen.
class ReportFlowScreen extends StatefulWidget {
  const ReportFlowScreen({super.key, this.presetLocation, this.presetSegment});

  final GeoPoint? presetLocation;
  final String? presetSegment;

  @override
  State<ReportFlowScreen> createState() => _ReportFlowScreenState();
}

class _ReportFlowScreenState extends State<ReportFlowScreen> {
  final PageController _pages = PageController();
  final TextEditingController _description = TextEditingController();

  _Step _step = _Step.category;
  ReportCategory? _category;
  SpecificType? _issue;
  LocationMode _mode = LocationMode.current;
  late GeoPoint _location = widget.presetLocation ?? BwpGeo.fawaraChowk;
  late String _segmentId = widget.presetSegment ?? _nearestSegment(_location).id;

  @override
  void dispose() {
    _pages.dispose();
    _description.dispose();
    super.dispose();
  }

  // --- Navigation -------------------------------------------------------------

  void _goTo(_Step step) {
    setState(() => _step = step);
    _pages.animateToPage(
      _Step.values.indexOf(step),
      duration: Motion.base,
      curve: Motion.emphasized,
    );
  }

  Future<void> _back() async {
    final index = _Step.values.indexOf(_step);
    if (index == 0) {
      await _confirmExit();
      return;
    }
    _goTo(_Step.values[index - 1]);
  }

  Future<void> _confirmExit() async {
    final started = _category != null || _description.text.isNotEmpty;
    if (!started) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    final leave = await confirmAction(
      context,
      title: L.of(context).discardReport,
      message:
          L.of(context).whatEnteredSoFarWill,
      confirmLabel: L.of(context).discard,
      cancelLabel: L.of(context).keepEditing,
      destructive: true,
      icon: Icons.delete_outline_rounded,
    );
    if (leave && mounted) Navigator.of(context).pop();
  }

  void _pickCategory(ReportCategory c) {
    setState(() {
      _category = c;
      // Changing category invalidates a previously chosen issue.
      if (_issue != null && _issue!.category != c) _issue = null;
    });
    _goTo(_Step.issue);
  }

  void _pickIssue(SpecificType t) {
    setState(() => _issue = t);
    _goTo(_Step.location);
  }

  void _setLocation(GeoPoint point) {
    setState(() {
      _location = point;
      _segmentId = _nearestSegment(point).id;
    });
  }

  static RoadSegment _nearestSegment(GeoPoint p) {
    var best = BwpGeo.segments.first;
    var bestD = double.infinity;
    for (final seg in BwpGeo.segments) {
      for (final node in seg.path) {
        final d = node.distanceKmTo(p);
        if (d < bestD) {
          bestD = d;
          best = seg;
        }
      }
    }
    return best;
  }

  Future<void> _submit() async {
    final reports = context.read<ReportsProvider>();
    final app = context.read<AppState>();

    // Rate limiting: enforced locally here, server-side in production.
    if (reports.rateLimited) {
      await showSafarSheet<void>(
        context,
        title: L.of(context).hitHourlyLimit,
        subtitle:
            'Up to ${AppLimits.maxReportsPerHour} reports an hour keeps the '
            'signal useful and makes spam harder.',
        scrollable: false,
        child: Column(
          children: [
            InfoPanel(
              text:
                  L.of(context).rateLimitsExistSoOne,
              icon: Icons.speed_rounded,
            ),
            const SizedBox(height: Gap.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(L.of(context).understood),
              ),
            ),
          ],
        ),
      );
      return;
    }

    final segment = BwpGeo.segment(_segmentId);
    final approximate = _mode == LocationMode.approximate ||
        (app.approximateSensitive &&
            _category == ReportCategory.safetyConcern);

    if (!mounted) return;
    Navigator.of(context).push(
      SlideUpRoute(
        child: ReportReviewScreen(
          description: _description.text.trim(),
          userSelectedType: _issue,
          location: _location,
          segmentId: _segmentId,
          areaName: segment.name,
          approximate: approximate,
        ),
      ),
    );
  }

  // --- Build ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final index = _Step.values.indexOf(_step);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              index == 0 ? Icons.close_rounded : Icons.arrow_back_rounded,
            ),
            onPressed: _back,
          ),
          title: Text(L.of(context).reportAction),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: Gap.page(context)),
              child: Center(
                child: Text(
                  'Step ${index + 1} of 4',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (index + 1) / 4),
              duration: Motion.base,
              curve: Motion.enter,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 3,
              ),
            ),
          ),
        ),
        body: PageView(
          controller: _pages,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _CategoryStep(selected: _category, onPick: _pickCategory),
            _IssueStep(
              category: _category,
              selected: _issue,
              onPick: _pickIssue,
              onChangeCategory: () => _goTo(_Step.category),
            ),
            _LocationStep(
              mode: _mode,
              location: _location,
              segment: BwpGeo.segment(_segmentId),
              isSensitive: _category == ReportCategory.safetyConcern,
              onModeChanged: (m) {
                setState(() => _mode = m);
                if (m == LocationMode.current) {
                  _setLocation(BwpGeo.fawaraChowk);
                }
              },
              onLocationChanged: _setLocation,
              onNext: () => _goTo(_Step.describe),
            ),
            _DescribeStep(
              controller: _description,
              issue: _issue,
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 1 — category
// ---------------------------------------------------------------------------

class _CategoryStep extends StatelessWidget {
  const _CategoryStep({required this.selected, required this.onPick});

  final ReportCategory? selected;
  final ValueChanged<ReportCategory> onPick;

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);

    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
      children: [
        Text(
          L.of(context).whatReporting,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Gap.sm),
        Text(
          L.of(context).pickClosestCategoryCorrectLater,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        const SizedBox(height: Gap.xl),
        for (var i = 0; i < ReportCategory.pickable.length; i++)
          StaggeredFadeIn(
            index: i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: _CategoryTile(
                category: ReportCategory.pickable[i],
                selected: selected == ReportCategory.pickable[i],
                onTap: () => onPick(ReportCategory.pickable[i]),
              ),
            ),
          ),
        const SizedBox(height: Gap.sm),
        InfoPanel(
          text: AppText.privacyPromise,
          icon: Icons.lock_outline_rounded,
          title: L.of(context).anonymousByDefault,
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final ReportCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SafarCard(
      onTap: onTap,
      borderColor: selected ? category.color.withValues(alpha: 0.7) : null,
      color: selected
          ? category.color.withValues(alpha: context.isDark ? 0.12 : 0.05)
          : null,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: category.color
                  .withValues(alpha: context.isDark ? 0.22 : 0.11),
              borderRadius: Radii.allMd,
            ),
            child: Icon(category.icon, size: 22, color: category.color),
          ),
          const SizedBox(width: Gap.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(category.label, style: t.titleLarge),
                const SizedBox(height: 1),
                Text(
                  category.labelRoman,
                  style: t.labelMedium
                      ?.copyWith(color: context.tokens.textTertiary),
                ),
                const SizedBox(height: Gap.sm - 2),
                Text(
                  category.helper,
                  style: t.bodySmall?.copyWith(height: 1.4),
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

// ---------------------------------------------------------------------------
// Step 2 — specific issue
// ---------------------------------------------------------------------------

class _IssueStep extends StatelessWidget {
  const _IssueStep({
    required this.category,
    required this.selected,
    required this.onPick,
    required this.onChangeCategory,
  });

  final ReportCategory? category;
  final SpecificType? selected;
  final ValueChanged<SpecificType> onPick;
  final VoidCallback onChangeCategory;

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);
    if (category == null) {
      return EmptyState(
        icon: Icons.category_outlined,
        title: L.of(context).pickCategoryFirst,
        message: L.of(context).goBackStepChooseWhat,
        primaryLabel: L.of(context).chooseCategory,
        onPrimary: onChangeCategory,
      );
    }

    final options = SpecificType.forCategory(category!);

    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.x4l),
      children: [
        Row(
          children: [
            CategoryChip(category: category!, dense: false),
            const Spacer(),
            TextButton(onPressed: onChangeCategory, child: Text(L.of(context).change)),
          ],
        ),
        const SizedBox(height: Gap.lg),
        Text(
          L.of(context).whatExactly,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Gap.sm),
        Text(
          L.of(context).phraseUnderneathEachOptionHow,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Gap.xl),
        for (var i = 0; i < options.length; i++)
          StaggeredFadeIn(
            index: i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Gap.sm),
              child: SafarCard(
                onTap: () => onPick(options[i]),
                padding: const EdgeInsets.all(Gap.md),
                borderColor: selected == options[i]
                    ? category!.color.withValues(alpha: 0.7)
                    : null,
                child: Row(
                  children: [
                    Icon(options[i].icon, size: 20, color: category!.color),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            options[i].label,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '"${options[i].labelRoman}"',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: context.tokens.textTertiary,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Pill(
                      label: options[i].routeEffect,
                      color: context.tokens.textSecondary,
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step 3 — location
// ---------------------------------------------------------------------------

class _LocationStep extends StatelessWidget {
  const _LocationStep({
    required this.mode,
    required this.location,
    required this.segment,
    required this.isSensitive,
    required this.onModeChanged,
    required this.onLocationChanged,
    required this.onNext,
  });

  final LocationMode mode;
  final GeoPoint location;
  final RoadSegment segment;
  final bool isSensitive;
  final ValueChanged<LocationMode> onModeChanged;
  final ValueChanged<GeoPoint> onLocationChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.lg),
            children: [
              Text(
                L.of(context).whereIsIt,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: Gap.sm),
              Text(
                mode == LocationMode.pin
                    ? 'Tap the map to move the pin to the right spot.'
                    : 'Choose how precise this report should be.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: Gap.lg),

              SegmentedSelector<LocationMode>(
                values: LocationMode.values,
                selected: mode,
                labelOf: (m) => m.label,
                onChanged: onModeChanged,
              ),
              const SizedBox(height: Gap.lg),

              // --- Map -----------------------------------------------------------
              ClipRRect(
                borderRadius: Radii.allLg,
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: Radii.allLg,
                    border: Border.all(color: context.tokens.border),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SafarMap(
                          bounds: BwpGeo.bounds,
                          droppedPin: mode == LocationMode.approximate
                              ? location.blurred()
                              : location,
                          compactMarkers: true,
                          showLabels: true,
                          onMapTap: mode == LocationMode.pin
                              ? onLocationChanged
                              : null,
                        ),
                      ),
                      if (mode == LocationMode.pin)
                        Positioned(
                          left: Gap.md,
                          top: Gap.md,
                          child: Pill(
                            label: L.of(context).tapPlacePin,
                            icon: Icons.touch_app_outlined,
                            color: context.tokens.textPrimary,
                            background: context.scheme.surface,
                            dense: true,
                          ),
                        ),
                      if (mode == LocationMode.approximate)
                        Positioned(
                          left: Gap.md,
                          top: Gap.md,
                          child: Pill(
                            label: L.of(context).roundedAboutM,
                            icon: Icons.blur_on_rounded,
                            color: context.tokens.textPrimary,
                            background: context.scheme.surface,
                            dense: true,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Gap.lg),

              // --- Snapped road ---------------------------------------------------
              SafarCard(
                padding: const EdgeInsets.all(Gap.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.linear_scale_rounded,
                      size: 19,
                      color: context.scheme.primary,
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            segment.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            L.of(context).reportWillApplyRoadSegment,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (isSensitive) ...[
                const SizedBox(height: Gap.md),
                InfoPanel(
                  text:
                      L.of(context).safetyConcernReportsAlwaysRounded,
                  icon: Icons.privacy_tip_outlined,
                  tone: AppColors.awarenessModerate,
                  title: L.of(context).sensitiveCategory,
                ),
              ],
            ],
          ),
        ),
        StickyActionBar(
          primary: FilledButton(
            onPressed: onNext,
            child: Text(L.of(context).continueLabel),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step 4 — description
// ---------------------------------------------------------------------------

class _DescribeStep extends StatefulWidget {
  const _DescribeStep({
    required this.controller,
    required this.issue,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final SpecificType? issue;
  final VoidCallback onSubmit;

  @override
  State<_DescribeStep> createState() => _DescribeStepState();
}

class _DescribeStepState extends State<_DescribeStep> {
  /// Example phrases a resident might actually type, in the three languages the
  /// classifier handles.
  static const List<String> _examples = [
    'Aagay gali band hai, construction ka saman para hua hai',
    'Road par pani khara hai, bike slip ho sakti hai',
    'Streetlight kai din se band hai, raat ko bilkul andhera',
    'Road kharab hai, bohat gaddhe hain',
  ];

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);
    final length = widget.controller.text.characters.length;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(gutter, Gap.lg, gutter, Gap.lg),
            children: [
              Text(
                L.of(context).anythingToAdd,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: Gap.sm),
              Text(
                L.of(context).optionalWriteEnglishUrduRoman,
                style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: Gap.xl),

              TextField(
                controller: widget.controller,
                maxLines: 5,
                minLines: 4,
                maxLength: AppLimits.descriptionMaxChars,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: L.of(context).eGAagayGaliBand,
                  alignLabelWithHint: true,
                  counterText: '$length / ${AppLimits.descriptionMaxChars}',
                ),
              ),
              const SizedBox(height: Gap.md),

              Text(
                L.of(context).tapExampleUse,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: Gap.sm),
              Wrap(
                spacing: Gap.sm,
                runSpacing: Gap.sm,
                children: [
                  for (final e in _examples)
                    SelectableChip(
                      label: e.length > 34 ? '${e.substring(0, 32)}…' : e,
                      selected: widget.controller.text == e,
                      onTap: () {
                        widget.controller.text = e;
                        setState(() {});
                      },
                    ),
                ],
              ),
              const SizedBox(height: Gap.xl),

              InfoPanel(
                text:
                    L.of(context).doIncludeNamesPhoneNumbers,
                icon: Icons.shield_outlined,
                tone: AppColors.awarenessModerate,
                title: L.of(context).whatWrite,
              ),
              const SizedBox(height: Gap.md),
              Consumer<ReportsProvider>(
                builder: (context, reports, _) => Row(
                  children: [
                    Pill(
                      label:
                          '${reports.submissionsRemaining} of ${AppLimits.maxReportsPerHour} reports left this hour',
                      icon: Icons.speed_rounded,
                      color: context.tokens.textSecondary,
                      dense: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        StickyActionBar(
          note: widget.issue == null
              ? 'Pick an issue first so the app has something to check against.'
              : null,
          primary: FilledButton.icon(
            onPressed: widget.issue == null ? null : widget.onSubmit,
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: Text(L.of(context).reviewMyReport),
          ),
        ),
      ],
    );
  }
}
