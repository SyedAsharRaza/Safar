import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// Illustrated empty state. Every list in the app has one.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.tone,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Color? tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = tone ?? context.scheme.primary;
    final t = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Gap.xxl,
          vertical: compact ? Gap.xxl : Gap.x4l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 62 : 84,
              height: compact ? 62 : 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accent.withValues(alpha: context.isDark ? 0.26 : 0.14),
                    accent.withValues(alpha: 0.03),
                  ],
                ),
              ),
              child: Icon(icon, size: compact ? 28 : 36, color: accent),
            ),
            SizedBox(height: compact ? Gap.lg : Gap.xl),
            Text(title, style: t.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: Gap.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: t.bodyMedium?.copyWith(
                color: context.tokens.textSecondary,
                height: 1.5,
              ),
            ),
            if (primaryLabel != null) ...[
              SizedBox(height: compact ? Gap.lg : Gap.xxl),
              FilledButton(onPressed: onPrimary, child: Text(primaryLabel!)),
            ],
            if (secondaryLabel != null) ...[
              const SizedBox(height: Gap.sm),
              TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state with a retry affordance. Never a bare exception string.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.message,
    this.title = 'Something went wrong',
    this.onRetry,
    this.retryLabel = 'Try again',
    this.secondaryLabel,
    this.onSecondary,
    this.icon = Icons.cloud_off_outlined,
  });

  final String message;
  final String title;
  final VoidCallback? onRetry;
  final String retryLabel;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData icon;

  @override
  Widget build(BuildContext context) => EmptyState(
        icon: icon,
        title: title,
        message: message,
        tone: context.scheme.error,
        primaryLabel: onRetry == null ? null : retryLabel,
        onPrimary: onRetry,
        secondaryLabel: secondaryLabel,
        onSecondary: onSecondary,
      );
}

/// Shimmering placeholder block. Hand-rolled so the project needs no extra
/// package for four skeleton shapes.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 14,
    this.radius = 8,
    this.shape = BoxShape.rectangle,
  });

  const Skeleton.circle({super.key, required double size})
      : width = size,
        height = size,
        radius = 999,
        shape = BoxShape.circle;

  final double? width;
  final double height;
  final double radius;
  final BoxShape shape;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1250),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.tokens.isDark
        ? context.tokens.surfaceAlt
        : const Color(0xFFE9EDF3);
    final highlight = context.tokens.isDark
        ? const Color(0xFF243447)
        : const Color(0xFFF5F7FA);

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.circle
                ? null
                : BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 - 2 * (1 - _c.value), 0),
              end: Alignment(1 + 2 * _c.value, 0),
              colors: [base, highlight, base],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton shaped like a report list row.
class ReportSkeletonCard extends StatelessWidget {
  const ReportSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Gap.lg),
      decoration: BoxDecoration(
        color: context.scheme.surface,
        borderRadius: Radii.allLg,
        border: Border.all(color: context.tokens.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Skeleton.circle(size: 40),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Skeleton(width: 120, height: 11),
                const SizedBox(height: Gap.sm),
                const Skeleton(height: 13),
                const SizedBox(height: Gap.xs + 2),
                Skeleton(
                  width: MediaQuery.sizeOf(context).width * 0.42,
                  height: 13,
                ),
                const SizedBox(height: Gap.md),
                Row(
                  children: const [
                    Skeleton(width: 70, height: 18, radius: 999),
                    SizedBox(width: Gap.sm),
                    Skeleton(width: 58, height: 18, radius: 999),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton shaped like a route card.
class RouteSkeletonCard extends StatelessWidget {
  const RouteSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Gap.lg),
      decoration: BoxDecoration(
        color: context.scheme.surface,
        borderRadius: Radii.allLg,
        border: Border.all(color: context.tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Skeleton(width: 130, height: 16),
              Spacer(),
              Skeleton(width: 74, height: 20, radius: 999),
            ],
          ),
          const SizedBox(height: Gap.md),
          const Skeleton(width: 168, height: 12),
          const SizedBox(height: Gap.md),
          const Skeleton(height: 12),
          const SizedBox(height: Gap.xs + 2),
          const Skeleton(width: 210, height: 12),
        ],
      ),
    );
  }
}

/// Full-width loading list used while community signals load.
class LoadingList extends StatelessWidget {
  const LoadingList({super.key, this.count = 4, this.route = false});

  final int count;
  final bool route;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == count - 1 ? 0 : Gap.md),
              child: route
                  ? const RouteSkeletonCard()
                  : const ReportSkeletonCard(),
            ),
        ],
      );
}

/// Banner shown when the app is in the simulated offline state.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.onDismiss});

  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Gap.lg,
        vertical: Gap.md,
      ),
      color: context.scheme.secondaryContainer,
      child: Row(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 17,
            color: context.scheme.onSecondaryContainer,
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Text(
              L.of(context).offlineBanner,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: context.scheme.onSecondaryContainer,
              ),
            ),
        ],
      ),
    );
  }
}
