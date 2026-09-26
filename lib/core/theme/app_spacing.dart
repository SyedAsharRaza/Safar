import 'package:flutter/material.dart';

/// 4pt spacing scale. Use these instead of raw numbers so density stays even.
abstract final class Gap {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double x3l = 32;
  static const double x4l = 40;
  static const double x5l = 56;

  /// Horizontal page gutter. Slightly tighter on very small phones.
  static double page(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 360 ? 16 : 20;
}

abstract final class Radii {
  static const Radius xs = Radius.circular(6);
  static const Radius sm = Radius.circular(10);
  static const Radius md = Radius.circular(14);
  static const Radius lg = Radius.circular(18);
  static const Radius xl = Radius.circular(24);
  static const Radius xxl = Radius.circular(32);

  static const BorderRadius allXs = BorderRadius.all(xs);
  static const BorderRadius allSm = BorderRadius.all(sm);
  static const BorderRadius allMd = BorderRadius.all(md);
  static const BorderRadius allLg = BorderRadius.all(lg);
  static const BorderRadius allXl = BorderRadius.all(xl);
  static const BorderRadius allXxl = BorderRadius.all(xxl);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
  static const BorderRadius sheet =
      BorderRadius.vertical(top: Radius.circular(28));
}

abstract final class Shadows {
  static List<BoxShadow> card(bool dark) => dark
      ? const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x0D101A28),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x08101A28),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ];

  static List<BoxShadow> raised(bool dark) => dark
      ? const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x1A101A28),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ];

  static List<BoxShadow> sheet(bool dark) => dark
      ? const [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 32,
            offset: Offset(0, -6),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x1F101A28),
            blurRadius: 32,
            offset: Offset(0, -6),
          ),
        ];
}

abstract final class Motion {
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration base = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration page = Duration(milliseconds: 340);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve spring = Curves.easeOutBack;
}
