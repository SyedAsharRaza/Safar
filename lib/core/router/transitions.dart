import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Slide-up route used for flows that feel like a task: reporting, check-in.
class SlideUpRoute<T> extends PageRouteBuilder<T> {
  SlideUpRoute({required this.child, super.settings})
      : super(
          transitionDuration: Motion.page,
          reverseTransitionDuration: Motion.base,
          pageBuilder: (_, _, _) => child,
          transitionsBuilder: (context, animation, secondary, page) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Motion.emphasized,
              reverseCurve: Motion.exit,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curved),
              child: FadeTransition(opacity: curved, child: page),
            );
          },
        );

  final Widget child;
}

/// Gentle fade-and-scale, used for the splash handoff and confirmation screens
/// where a horizontal slide would imply "back" is available.
class FadeScaleRoute<T> extends PageRouteBuilder<T> {
  FadeScaleRoute({required this.child, super.settings})
      : super(
          transitionDuration: Motion.page,
          reverseTransitionDuration: Motion.base,
          pageBuilder: (_, _, _) => child,
          transitionsBuilder: (context, animation, secondary, page) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Motion.emphasized,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.97, end: 1).animate(curved),
                child: page,
              ),
            );
          },
        );

  final Widget child;
}

/// Standard horizontal push. Matches platform expectations for drill-down.
class SlideRoute<T> extends PageRouteBuilder<T> {
  SlideRoute({required this.child, super.settings})
      : super(
          transitionDuration: Motion.page,
          reverseTransitionDuration: Motion.base,
          pageBuilder: (_, _, _) => child,
          transitionsBuilder: (context, animation, secondary, page) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Motion.emphasized,
              reverseCurve: Motion.exit,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.16, 0),
                end: Offset.zero,
              ).animate(curved),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.4, end: 1).animate(curved),
                child: page,
              ),
            );
          },
        );

  final Widget child;
}

/// Staggered entrance for list children. Keeps long lists from popping in all
/// at once without turning scrolling into a light show.
class StaggeredFadeIn extends StatelessWidget {
  const StaggeredFadeIn({
    super.key,
    required this.index,
    required this.child,
    this.itemDelay = const Duration(milliseconds: 45),
    this.maxIndex = 8,
  });

  final int index;
  final Widget child;
  final Duration itemDelay;

  /// Beyond this index items appear immediately, so deep scrolls stay snappy.
  final int maxIndex;

  @override
  Widget build(BuildContext context) {
    final effective = index.clamp(0, maxIndex);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Motion.base + itemDelay * effective,
      curve: Interval(
        (effective * 0.06).clamp(0.0, 0.6),
        1,
        curve: Motion.enter,
      ),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
