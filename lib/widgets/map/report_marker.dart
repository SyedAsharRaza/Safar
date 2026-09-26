import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../models/safety_report.dart';
import '../../models/taxonomy.dart';

/// A teardrop pin for a community signal on the mock map.
class ReportMarker extends StatelessWidget {
  const ReportMarker({
    super.key,
    required this.report,
    this.selected = false,
    this.compact = false,
    this.onTap,
  });

  final SafetyReport report;
  final bool selected;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = report.category.color;
    final size = compact ? 26.0 : (selected ? 40.0 : 33.0);
    final expired = report.isExpired;

    return Semantics(
      button: onTap != null,
      label: '${report.category.label} report, ${report.areaName}',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: selected ? 1.0 : 0.94,
          duration: Motion.fast,
          curve: Motion.enter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: expired ? context.tokens.surfaceAlt : color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: expired ? 0.5 : 0.92),
                    width: selected ? 3 : 2.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: selected ? 0.45 : 0.28),
                      blurRadius: selected ? 14 : 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  report.specificType.icon,
                  size: size * 0.52,
                  color: expired ? context.tokens.textTertiary : Colors.white,
                ),
              ),
              // Little stem so the pin reads as attached to a point on the road.
              Transform.translate(
                offset: const Offset(0, -2),
                child: CustomPaint(
                  size: Size(compact ? 6 : 8, compact ? 5 : 7),
                  painter: _StemPainter(
                    color: expired ? context.tokens.surfaceAlt : color,
                  ),
                ),
              ),
              if (report.status == ReportStatus.corroborated && !compact)
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: Radii.pill,
                    boxShadow: context.tokens.cardShadow,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified,
                        size: 9,
                        color: Color(0xFF1B9E5A),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${report.confirmationCount}',
                        style: const TextStyle(
                          fontFamily: 'Jakarta',
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B9E5A),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StemPainter extends CustomPainter {
  const _StemPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_StemPainter old) => old.color != color;
}

/// Origin / destination markers for a planned trip.
class EndpointMarker extends StatelessWidget {
  const EndpointMarker({
    super.key,
    required this.isOrigin,
    this.label,
  });

  final bool isOrigin;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final color = isOrigin
        ? context.scheme.tertiary
        : context.tokens.isDark
            ? Colors.white
            : const Color(0xFF111A28);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            constraints: const BoxConstraints(maxWidth: 124),
            decoration: BoxDecoration(
              color: context.scheme.surface,
              borderRadius: Radii.pill,
              border: Border.all(color: context.tokens.border),
              boxShadow: context.tokens.cardShadow,
            ),
            child: Text(
              label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Jakarta',
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: context.tokens.textPrimary,
              ),
            ),
          ),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            isOrigin ? Icons.my_location : Icons.flag_rounded,
            size: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
