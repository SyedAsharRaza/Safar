import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';

/// The app's standard card. One place to change elevation, radius and border.
class SafarCard extends StatelessWidget {
  const SafarCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Gap.lg),
    this.onTap,
    this.borderRadius = Radii.allLg,
    this.color,
    this.borderColor,
    this.elevated = true,
    this.accentEdge,
    this.margin = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final Color? color;
  final Color? borderColor;
  final bool elevated;

  /// Draws a coloured rail down the leading edge, used for awareness levels.
  final Color? accentEdge;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final body = Padding(padding: padding, child: child);

    return Padding(
      padding: margin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? context.scheme.surface,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor ?? tokens.border),
          boxShadow: elevated ? tokens.cardShadow : null,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              // The rail is painted over the card rather than laid out beside
              // it: a Row with CrossAxisAlignment.stretch would demand an
              // infinite height inside a scroll view.
              child: accentEdge == null
                  ? body
                  : Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: body,
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: 4,
                          child: ColoredBox(color: accentEdge!),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A tinted panel for inline notes: disclaimers, tips, privacy reminders.
class InfoPanel extends StatelessWidget {
  const InfoPanel({
    super.key,
    required this.text,
    this.icon = Icons.info_outline,
    this.tone,
    this.title,
    this.action,
    this.dense = false,
  });

  final String text;
  final IconData icon;
  final Color? tone;
  final String? title;
  final Widget? action;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final accent = tone ?? context.scheme.primary;
    return Container(
      padding: EdgeInsets.all(dense ? Gap.md : Gap.lg),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: context.isDark ? 0.14 : 0.07),
        borderRadius: Radii.allMd,
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: dense ? 16 : 18, color: accent),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: accent),
                  ),
                  const SizedBox(height: Gap.xs),
                ],
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.tokens.textSecondary,
                        height: 1.44,
                      ),
                ),
                if (action != null) ...[
                  const SizedBox(height: Gap.sm),
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section heading with optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.action,
    this.padding = const EdgeInsets.only(bottom: Gap.md),
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null) ...[
                  Text(
                    eyebrow!.toUpperCase(),
                    style: t.labelSmall?.copyWith(color: context.scheme.primary),
                  ),
                  const SizedBox(height: Gap.xs),
                ],
                Text(title, style: t.titleLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: Gap.xxs),
                  Text(
                    subtitle!,
                    style: t.bodySmall
                        ?.copyWith(color: context.tokens.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(width: Gap.sm), action!],
        ],
      ),
    );
  }
}

/// A row of [StatTile]s, all rendered at the same height.
///
/// Laying tiles out in a plain Row lets each size itself, so a tile whose label
/// wraps to two lines ends up visibly taller than its neighbours. IntrinsicHeight
/// measures the tallest and stretches the rest to match.
class StatTileRow extends StatelessWidget {
  const StatTileRow({super.key, required this.tiles, this.spacing = Gap.sm});

  final List<Widget> tiles;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (tiles.isEmpty) return const SizedBox.shrink();
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(child: tiles[i]),
          ],
        ],
      ),
    );
  }
}

/// Small stat block used on the profile and route-detail screens.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.tone,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final accent = tone ?? context.scheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Gap.md,
        vertical: Gap.md,
      ),
      decoration: BoxDecoration(
        color: context.tokens.isDark
            ? context.tokens.surfaceAlt
            : accent.withValues(alpha: 0.06),
        borderRadius: Radii.allMd,
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: accent),
            const SizedBox(height: Gap.sm),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: accent, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: Gap.xxs),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: context.tokens.textSecondary),
          ),
        ],
      ),
    );
  }
}
