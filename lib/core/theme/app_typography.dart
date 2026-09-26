import 'package:flutter/material.dart';

/// Type scale for Bahawalpur Safar. One family, five weights, tight headings.
abstract final class AppType {
  static const String family = 'Jakarta';

  static const TextStyle display = TextStyle(
    fontFamily: family,
    fontSize: 32,
    height: 1.14,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: family,
    fontSize: 26,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: family,
    fontSize: 21,
    height: 1.24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.35,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: family,
    fontSize: 17,
    height: 1.3,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: family,
    fontSize: 15.5,
    height: 1.34,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
  );

  static const TextStyle titleSm = TextStyle(
    fontFamily: family,
    fontSize: 14,
    height: 1.36,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: family,
    fontSize: 14.5,
    height: 1.48,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: family,
    fontSize: 13,
    height: 1.46,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle label = TextStyle(
    fontFamily: family,
    fontSize: 12.5,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: family,
    fontSize: 11.5,
    height: 1.34,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Small all-caps eyebrow used above section titles.
  static const TextStyle overline = TextStyle(
    fontFamily: family,
    fontSize: 10.5,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );

  /// Tabular figures for timers and durations so digits do not jitter.
  static const TextStyle mono = TextStyle(
    fontFamily: family,
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w700,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle timer = TextStyle(
    fontFamily: family,
    fontSize: 44,
    height: 1.05,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
