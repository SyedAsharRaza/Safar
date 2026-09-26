import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../models/road_segment.dart';
import '../../models/route_option.dart';
import '../common/badges.dart';
import '../common/surfaces.dart';

/// Shows *why* a route carries the awareness level it does, term by term.
///
/// This is the answer to "is this just a made-up number?" — every weight and
/// input is on screen, and the copy says plainly that it is not a safety score.
class AwarenessBreakdown extends StatelessWidget {
  const AwarenessBreakdown({super.key, required this.route});

  final RouteOption route;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    // Aggregate the per-segment terms by length, matching the route formula.
    final totalKm = route.segments.fold<double>(0, (a, s) => a + s.lengthKm);
    final terms = <String, double>{};
    final weights = <String, double>{};
    for (final part in route.awareness) {
      final share = totalKm == 0 ? 0.0 : part.segment.lengthKm / totalKm;
      for (final b in part.breakdown) {
        terms[b.label] = (terms[b.label] ?? 0) + b.raw * share;
        weights[b.label] = b.weight;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('How this level was calculated', style: t.titleMedium),
            ),
            AwarenessBadge(level: route.level, dense: true, short: true),
          ],
        ),
        const SizedBox(height: Gap.lg),
        for (final entry in terms.entries)
          _TermBar(
            label: entry.key,
            weight: weights[entry.key] ?? 0,
            value: entry.value,
          ),
        const SizedBox(height: Gap.md),
        InfoPanel(
          text: AppText.awarenessExplainer,
          icon: Icons.functions_rounded,
          dense: true,
        ),
      ],
    );
  }
}

class _TermBar extends StatelessWidget {
  const _TermBar({
    required this.label,
    required this.weight,
    required this.value,
  });

  final String label;
  final double weight;
  final double value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final pct = (weight * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: t.titleSmall)),
              Text(
                'weight $pct%',
                style: t.labelMedium
                    ?.copyWith(color: context.tokens.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: Gap.sm - 2),
          Row(
            children: [
              Expanded(
                child: _MeterBar(
                  value: value.clamp(0.0, 1.0),
                  colour: context.scheme.primary,
                  track: context.tokens.isDark
                      ? context.tokens.surfaceAlt
                      : const Color(0xFFE6EAF1),
                ),
              ),
              const SizedBox(width: Gap.md),
              SizedBox(
                width: 34,
                child: Text(
                  _band(value),
                  textAlign: TextAlign.right,
                  style: t.labelMedium
                      ?.copyWith(color: context.tokens.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Words, not decimals — the raw term is an internal quantity.
  static String _band(double v) {
    if (v < 0.2) return 'Low';
    if (v < 0.45) return 'Some';
    if (v < 0.7) return 'Raised';
    return 'High';
  }
}

/// Animated meter that grows into place when the breakdown opens.
class _MeterBar extends StatelessWidget {
  const _MeterBar({
    required this.value,
    required this.colour,
    required this.track,
  });

  final double value;
  final Color colour;
  final Color track;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 7,
      child: DecoratedBox(
        decoration: BoxDecoration(color: track, borderRadius: Radii.pill),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: Motion.slow,
          curve: Motion.enter,
          builder: (context, v, _) => FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: v,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colour,
                borderRadius: Radii.pill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Segment-by-segment list for the route details screen.
class SegmentList extends StatelessWidget {
  const SegmentList({super.key, required this.parts, this.onTapSegment});

  final List<SegmentAwareness> parts;
  final ValueChanged<SegmentAwareness>? onTapSegment;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      children: [
        for (var i = 0; i < parts.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == parts.length - 1 ? 0 : Gap.sm,
            ),
            child: SafarCard(
              padding: const EdgeInsets.all(Gap.md),
              elevated: false,
              onTap: onTapSegment == null
                  ? null
                  : () => onTapSegment!(parts[i]),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: parts[i].level.color.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: t.labelMedium?.copyWith(
                        color: parts[i].level.color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: Gap.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          parts[i].segment.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.titleSmall,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          parts[i].reportCount == 0
                              ? 'No reports · ${parts[i].segment.lengthKm.toStringAsFixed(1)} km'
                              : '${parts[i].reportCount} report${parts[i].reportCount == 1 ? '' : 's'} · ${parts[i].segment.lengthKm.toStringAsFixed(1)} km',
                          style: t.labelMedium
                              ?.copyWith(color: context.tokens.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Gap.sm),
                  AwarenessBadge(
                    level: parts[i].level,
                    dense: true,
                    short: true,
                    showIcon: false,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
