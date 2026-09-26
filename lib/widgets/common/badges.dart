import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../models/taxonomy.dart';

/// Generic pill. Everything chip-shaped in the app routes through this so
/// padding, radius and type stay identical.
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.background,
    this.dense = false,
    this.outlined = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final Color? background;
  final bool dense;
  final bool outlined;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? context.tokens.textSecondary;
    final bg = background ??
        (outlined ? Colors.transparent : fg.withValues(alpha: 0.10));

    final content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? Gap.sm : Gap.md,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: Radii.pill,
        border: Border.all(
          color: outlined ? fg.withValues(alpha: 0.4) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: dense ? 11 : 13, color: fg),
            SizedBox(width: dense ? 3 : 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Jakarta',
              fontSize: dense ? 10.5 : 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
              color: fg,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: Radii.pill,
      child: content,
    );
  }
}

/// The route-awareness badge. Deliberately word-based — the product never shows
/// a safety percentage.
class AwarenessBadge extends StatelessWidget {
  const AwarenessBadge({
    super.key,
    required this.level,
    this.dense = false,
    this.showIcon = true,
    this.short = false,
  });

  final AwarenessLevel level;
  final bool dense;
  final bool showIcon;
  final bool short;

  @override
  Widget build(BuildContext context) {
    return Pill(
      label: short ? level.shortLabel : level.label,
      icon: showIcon ? level.icon : null,
      color: level.color,
      background: context.isDark
          ? level.color.withValues(alpha: 0.18)
          : level.softColor,
      dense: dense,
    );
  }
}

class ConfidenceChip extends StatelessWidget {
  const ConfidenceChip({super.key, required this.band, this.dense = true});

  final ConfidenceBand band;
  final bool dense;

  @override
  Widget build(BuildContext context) => Pill(
        label: band.label,
        icon: Icons.insights_outlined,
        color: band.color,
        dense: dense,
      );
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.dense = true});

  final ReportStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) => Pill(
        label: status.label,
        icon: status.icon,
        color: status.color,
        dense: dense,
      );
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.category, this.dense = true});

  final ReportCategory category;
  final bool dense;

  @override
  Widget build(BuildContext context) => Pill(
        label: category.label,
        icon: category.icon,
        color: category.color,
        dense: dense,
      );
}

/// Selectable filter chip for the explore map and report lists.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.accent,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? accent;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? context.scheme.primary;
    final tokens = context.tokens;

    return AnimatedContainer(
      duration: Motion.fast,
      curve: Motion.enter,
      decoration: BoxDecoration(
        color: selected
            ? color.withValues(alpha: context.isDark ? 0.24 : 0.12)
            : context.scheme.surface,
        borderRadius: Radii.pill,
        border: Border.all(
          color: selected ? color.withValues(alpha: 0.7) : tokens.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: Radii.pill,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.md,
              vertical: Gap.sm + 1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 15,
                    color: selected ? color : tokens.textSecondary,
                  ),
                  const SizedBox(width: Gap.sm - 2),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Jakarta',
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? color : tokens.textPrimary,
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: Gap.sm - 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? color.withValues(alpha: 0.22)
                          : tokens.surfaceAlt,
                      borderRadius: Radii.pill,
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontFamily: 'Jakarta',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: selected ? color : tokens.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The "Demonstration community signals" marker. Appears wherever seeded data
/// is shown, because the blueprint requires it never to look official.
class DemoDataBadge extends StatelessWidget {
  const DemoDataBadge({super.key, this.dense = false, this.onTap});

  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Pill(
        label: dense ? 'Demo data' : 'Demonstration community signals',
        icon: Icons.science_outlined,
        color: context.tokens.textSecondary,
        background: context.tokens.surfaceAlt,
        dense: dense,
        onTap: onTap,
      );
}

/// Small numeric badge for the bottom navigation.
class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count, this.color});

  final int count;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final bg = color ?? context.scheme.error;
    return Container(
      constraints: const BoxConstraints(minWidth: 17),
      height: 17,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: Radii.pill,
        border: Border.all(color: context.scheme.surface, width: 1.6),
      ),
      alignment: Alignment.center,
      child: Text(
        count > 9 ? '9+' : '$count',
        style: const TextStyle(
          fontFamily: 'Jakarta',
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}
