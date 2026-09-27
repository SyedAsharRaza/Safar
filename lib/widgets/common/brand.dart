import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// The Bahawalpur Safar mark: a route line threading through an arch, nodding to
/// the city's palace architecture, with a streetlight glow at the top.
class SafarLogo extends StatelessWidget {
  const SafarLogo({super.key, this.size = 56, this.onDark = false});

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brand, AppColors.brandDeep],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.brand.withValues(alpha: onDark ? 0.5 : 0.32),
              blurRadius: size * 0.36,
              offset: Offset(0, size * 0.12),
            ),
          ],
        ),
        child: CustomPaint(painter: _MarkPainter()),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Arch outline.
    final arch = Path()
      ..moveTo(w * 0.26, h * 0.78)
      ..lineTo(w * 0.26, h * 0.46)
      ..arcToPoint(
        Offset(w * 0.74, h * 0.46),
        radius: Radius.circular(w * 0.24),
      )
      ..lineTo(w * 0.74, h * 0.78);

    canvas.drawPath(
      arch,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.055
        ..strokeCap = StrokeCap.round,
    );

    // Route line running through the arch.
    final route = Path()
      ..moveTo(w * 0.16, h * 0.7)
      ..quadraticBezierTo(w * 0.42, h * 0.72, w * 0.5, h * 0.52)
      ..quadraticBezierTo(w * 0.58, h * 0.33, w * 0.84, h * 0.34);

    canvas.drawPath(
      route,
      Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.085
        ..strokeCap = StrokeCap.round,
    );

    // Endpoint dot and the streetlight glow.
    canvas.drawCircle(
      Offset(w * 0.84, h * 0.34),
      w * 0.075,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.3),
      w * 0.12,
      Paint()
        ..color = AppColors.accent.withValues(alpha: 0.32)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.06),
    );
  }

  @override
  bool shouldRepaint(_MarkPainter old) => false;
}

/// Wordmark with the tagline, used on the splash and onboarding screens.
///
/// The product is "Safar" — short, and the same word in Urdu, Punjabi and
/// Roman Urdu. The city name lives in the tagline instead of the mark.
class SafarWordmark extends StatelessWidget {
  const SafarWordmark({
    super.key,
    this.showTagline = true,
    this.alignment = CrossAxisAlignment.center,
    this.onDark = false,
  });

  final bool showTagline;
  final CrossAxisAlignment alignment;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final primary = onDark ? Colors.white : null;
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Safar',
          textAlign: alignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: primary,
                letterSpacing: -0.6,
              ),
        ),
        if (showTagline) ...[
          const SizedBox(height: Gap.xs),
          Text(
            'Bahawalpur · Know the road before you take it.',
            textAlign: alignment == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.start,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: onDark
                      ? Colors.white.withValues(alpha: 0.78)
                      : null,
                ),
          ),
        ],
      ],
    );
  }
}

/// Decorative night-sky backdrop with a few drifting streetlight glows. Used
/// behind the splash and onboarding so the brand reads before any content does.
class NightBackdrop extends StatelessWidget {
  const NightBackdrop({super.key, this.child, this.animationValue = 0});

  final Widget? child;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0B1B31),
            Color(0xFF122B4B),
            Color(0xFF0B1B31),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _GlowPainter(animationValue)),
          ),
          if (child != null) Positioned.fill(child: child!),
        ],
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  const _GlowPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    // Faint road grid, as if looking down on a lit city.
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 1; i < 8; i++) {
      final y = size.height * i / 8;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (var i = 1; i < 5; i++) {
      final x = size.width * i / 5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }

    const spots = [
      (0.18, 0.22, 0.30),
      (0.82, 0.16, 0.22),
      (0.68, 0.74, 0.26),
      (0.24, 0.82, 0.20),
      (0.5, 0.48, 0.16),
    ];

    for (var i = 0; i < spots.length; i++) {
      final (fx, fy, strength) = spots[i];
      // Each glow breathes on its own offset phase.
      final pulse =
          0.72 + 0.28 * math.sin(t * math.pi * 2 + i * math.pi / 2.4);
      final radius = size.width * 0.34 * strength * pulse;
      canvas.drawCircle(
        Offset(size.width * fx, size.height * fy),
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              AppColors.accent.withValues(alpha: 0.24 * strength * pulse),
              AppColors.accent.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * fx, size.height * fy),
              radius: radius,
            ),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(_GlowPainter old) => old.t != t;
}
