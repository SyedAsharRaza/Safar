import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';

enum ToastTone { neutral, success, warning, danger }

/// Single entry point for snackbars, so every confirmation in the app looks and
/// behaves the same way.
abstract final class Toast {
  static void show(
    BuildContext context,
    String message, {
    ToastTone tone = ToastTone.neutral,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final (bg, fg, defaultIcon) = switch (tone) {
      ToastTone.success => (
          AppColors.awarenessLow,
          Colors.white,
          Icons.check_circle_outline,
        ),
      ToastTone.warning => (
          AppColors.awarenessModerate,
          const Color(0xFF3A2606),
          Icons.warning_amber_rounded,
        ),
      ToastTone.danger => (
          AppColors.danger,
          Colors.white,
          Icons.error_outline,
        ),
      ToastTone.neutral => (
          context.isDark ? const Color(0xFF243447) : AppColors.brandNight,
          Colors.white,
          Icons.info_outline,
        ),
    };

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bg,
          duration: duration,
          content: Row(
            children: [
              Icon(icon ?? defaultIcon, size: 18, color: fg),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Jakarta',
                    fontSize: 13.5,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
          action: actionLabel == null
              ? null
              : SnackBarAction(
                  label: actionLabel,
                  textColor: tone == ToastTone.warning
                      ? const Color(0xFF3A2606)
                      : AppColors.accent,
                  onPressed: onAction ?? () {},
                ),
        ),
      );
  }
}

/// Confirmation dialog. Returns true only on explicit confirm.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool destructive = false,
  IconData? icon,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final accent =
          destructive ? context.scheme.error : context.scheme.primary;
      return AlertDialog(
        icon: icon == null
            ? null
            : Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: context.isDark ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
        title: Text(title),
        content: Text(message),
        actionsPadding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.lg),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelLabel),
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: FilledButton(
                  style: destructive
                      ? FilledButton.styleFrom(
                          backgroundColor: context.scheme.error,
                          foregroundColor: Colors.white,
                        )
                      : null,
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(confirmLabel),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
  return result ?? false;
}

/// Standard modal sheet wrapper: drag handle, title row, scrollable body.
Future<T?> showSafarSheet<T>(
  BuildContext context, {
  required String title,
  required Widget child,
  String? subtitle,
  Widget? footer,
  bool scrollable = true,
  double maxHeightFactor = 0.86,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      final body = Padding(
        padding: EdgeInsets.fromLTRB(
          Gap.xl,
          Gap.xs,
          Gap.xl,
          Gap.xl + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            if (subtitle != null) ...[
              const SizedBox(height: Gap.xs),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: context.tokens.textSecondary),
              ),
            ],
            const SizedBox(height: Gap.xl),
            child,
            if (footer != null) ...[const SizedBox(height: Gap.xl), footer],
          ],
        ),
      );

      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * maxHeightFactor,
        ),
        child: scrollable ? SingleChildScrollView(child: body) : body,
      );
    },
  );
}

/// Full-width primary action pinned above the system navigation bar.
class StickyActionBar extends StatelessWidget {
  const StickyActionBar({
    super.key,
    required this.primary,
    this.secondary,
    this.note,
  });

  final Widget primary;
  final Widget? secondary;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.scheme.surface,
        border: Border(top: BorderSide(color: context.tokens.border)),
        boxShadow: Shadows.sheet(context.isDark),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Gap.page(context),
            Gap.md,
            Gap.page(context),
            Gap.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (note != null) ...[
                Text(
                  note!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: context.tokens.textTertiary),
                ),
                const SizedBox(height: Gap.sm),
              ],
              SizedBox(width: double.infinity, child: primary),
              if (secondary != null) ...[
                const SizedBox(height: Gap.sm),
                SizedBox(width: double.infinity, child: secondary!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A heart/bookmark button that animates when toggled.
class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    super.key,
    required this.saved,
    required this.onToggle,
    this.size = 20,
    this.filledColor,
  });

  final bool saved;
  final VoidCallback onToggle;
  final double size;
  final Color? filledColor;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _tap() {
    if (!widget.saved) _c.forward(from: 0);
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.filledColor ?? context.scheme.secondary;
    return IconButton(
      tooltip: widget.saved ? 'Remove from saved' : 'Save this place',
      onPressed: _tap,
      icon: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          // A quick overshoot then settle — enough to register, not showy.
          final t = Curves.easeOutBack.transform(_c.value.clamp(0.0, 1.0));
          final scale = widget.saved ? 1 + 0.28 * (1 - (t - 1).abs()) : 1.0;
          return Transform.scale(scale: scale, child: child);
        },
        child: Icon(
          widget.saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          size: widget.size,
          color: widget.saved ? color : context.tokens.textSecondary,
        ),
      ),
    );
  }
}
