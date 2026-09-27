import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/time_utils.dart';
import '../../models/route_option.dart';
import '../common/badges.dart';
import '../common/surfaces.dart';

Color routeColourFor(RouteFlavour f) => switch (f) {
      RouteFlavour.fastest => AppColors.routeFastest,
      RouteFlavour.betterLit => AppColors.routeLit,
      RouteFlavour.fewerHazards => AppColors.routeCalm,
    };

IconData routeIconFor(RouteFlavour f) => switch (f) {
      RouteFlavour.fastest => Icons.bolt_rounded,
      RouteFlavour.betterLit => Icons.lightbulb_rounded,
      RouteFlavour.fewerHazards => Icons.shield_rounded,
    };

/// The route comparison card.
///
/// Every number on it is explainable: duration, distance, the awareness band,
/// how many recent reports sit on the route, and one plain-language sentence
/// about the tradeoff. No safety percentage anywhere.
class RouteCard extends StatelessWidget {
  const RouteCard({
    super.key,
    required this.route,
    required this.selected,
    required this.onTap,
    this.onDetails,
    this.deltaMinutes,
    this.compact = false,
  });

  final RouteOption route;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onDetails;

  /// Difference against the fastest option, for the "+6 min" chip.
  final int? deltaMinutes;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final colour = routeColourFor(route.flavour);
    final level = route.level;

    return SafarCard(
      onTap: onTap,
      padding: EdgeInsets.all(compact ? Gap.md : Gap.lg),
      borderColor: selected ? colour.withValues(alpha: 0.75) : null,
      color: selected
          ? (context.isDark
              ? colour.withValues(alpha: 0.10)
              : colour.withValues(alpha: 0.045))
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container
                (
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colour.withValues(alpha: context.isDark ? 0.24 : 0.12),
                  borderRadius: Radii.allSm,
                ),
                child: Icon(
                  routeIconFor(route.flavour),
                  size: 17,
                  color: colour,
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            route.flavour.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.titleMedium,
                          ),
                        ),
                        if (route.isRecommended) ...[
                          const SizedBox(width: Gap.sm - 2),
                          Pill(
                            label: 'Suggested',
                            color: context.scheme.tertiary,
                            dense: true,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      route.flavour.labelRoman,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelMedium
                          ?.copyWith(color: context.tokens.textTertiary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Gap.sm),
              // Selection state is explicit, not just a border tint.
              AnimatedContainer(
                duration: Motion.fast,
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? colour : Colors.transparent,
                  border: Border.all(
                    color: selected ? colour : context.tokens.border,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: Gap.md),

          // --- Headline figures -----------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                TimeUtils.minutes(route.totalMinutes),
                style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: Gap.sm),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  TimeUtils.distance(route.distanceKm),
                  style: t.bodySmall
                      ?.copyWith(color: context.tokens.textSecondary),
                ),
              ),
              if (deltaMinutes != null && deltaMinutes != 0) ...[
                const SizedBox(width: Gap.sm),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Pill(
                    label: deltaMinutes! > 0
                        ? '+$deltaMinutes min'
                        : '$deltaMinutes min',
                    color: deltaMinutes! > 0
                        ? AppColors.awarenessModerate
                        : AppColors.awarenessLow,
                    dense: true,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: Gap.md),

          // --- Awareness row ---------------------------------------------------
          Wrap(
            spacing: Gap.sm - 2,
            runSpacing: Gap.sm - 3,
            children: [
              AwarenessBadge(level: level, dense: true),
              ConfidenceChip(band: route.confidence),
              Pill(
                label: route.reports.isEmpty
                    ? 'No recent reports'
                    : '${route.reports.length} recent report${route.reports.length == 1 ? '' : 's'}',
                icon: Icons.campaign_outlined,
                color: context.tokens.textSecondary,
                dense: true,
              ),
              if (!route.avoidsBlockage)
                Pill(
                  label: 'Passes a blockage',
                  icon: Icons.block_outlined,
                  color: context.scheme.error,
                  dense: true,
                ),
            ],
          ),

          // --- Explanation -----------------------------------------------------
          const SizedBox(height: Gap.md),
          Container(
            padding: const EdgeInsets.all(Gap.md),
            decoration: BoxDecoration(
              color: context.tokens.isDark
                  ? context.tokens.surfaceAlt
                  : const Color(0xFFF4F6FA),
              borderRadius: Radii.allSm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.subdirectory_arrow_right_rounded,
                  size: 15,
                  color: context.tokens.textTertiary,
                ),
                const SizedBox(width: Gap.sm),
                Expanded(
                  child: Text(
                    route.explanation,
                    style: t.bodySmall?.copyWith(
                      height: 1.44,
                      color: context.tokens.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (!compact && route.highlights.isNotEmpty) ...[
            const SizedBox(height: Gap.md),
            for (final h in route.highlights)
              Padding(
                padding: const EdgeInsets.only(bottom: Gap.xs + 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 6, right: Gap.sm),
                      decoration: BoxDecoration(
                        color: context.tokens.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        h,
                        style: t.labelMedium
                            ?.copyWith(color: context.tokens.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
          ],

          if (onDetails != null) ...[
            const SizedBox(height: Gap.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onDetails,
                icon: const Icon(Icons.map_outlined, size: 16),
                label: const Text('See what is on this route'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: colour,
                  minimumSize: const Size(0, 34),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Map legend for the route comparison screen.
///
/// Lives inside the results sheet rather than floating over the map: anywhere
/// it floats it eventually covers a marker or a control.
class RouteLegend extends StatelessWidget {
  const RouteLegend({super.key, required this.flavours});

  final List<RouteFlavour> flavours;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Gap.md,
      runSpacing: Gap.sm - 2,
      children: [
        for (final f in flavours)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 3.5,
                decoration: BoxDecoration(
                  color: routeColourFor(f),
                  borderRadius: Radii.pill,
                ),
              ),
              const SizedBox(width: Gap.sm - 2),
              Text(
                f.label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: context.tokens.textSecondary,
                    ),
              ),
            ],
          ),
      ],
    );
  }
}
