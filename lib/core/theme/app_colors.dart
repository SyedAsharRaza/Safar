import 'package:flutter/material.dart';

/// Bahawalpur Safar palette.
///
/// The mood is "evening travel in a desert city": deep indigo night sky for
/// surfaces, streetlight amber for accents, and a calm awareness scale that
/// never reads as a safety guarantee.
abstract final class AppColors {
  // ---- Brand ----------------------------------------------------------------
  static const Color brand = Color(0xFF2563A8); // Safar blue
  static const Color brandDeep = Color(0xFF17396B);
  static const Color brandNight = Color(0xFF0B1B31);
  static const Color brandSoft = Color(0xFFE8F0FA);

  static const Color accent = Color(0xFFF2A33C); // streetlight amber
  static const Color accentDeep = Color(0xFFC57A14);
  static const Color accentSoft = Color(0xFFFDF1DE);

  static const Color teal = Color(0xFF0E9594);
  static const Color tealSoft = Color(0xFFDFF3F3);

  // ---- Awareness scale ------------------------------------------------------
  // Deliberately NOT a "safety score" palette: labels read as caution levels.
  static const Color awarenessLow = Color(0xFF1B9E5A);
  static const Color awarenessLowSoft = Color(0xFFE2F6EB);
  static const Color awarenessModerate = Color(0xFFE2A014);
  static const Color awarenessModerateSoft = Color(0xFFFDF3DC);
  static const Color awarenessElevated = Color(0xFFDE5B33);
  static const Color awarenessElevatedSoft = Color(0xFFFCEBE5);
  static const Color awarenessUnknown = Color(0xFF7A8899);
  static const Color awarenessUnknownSoft = Color(0xFFEDF0F4);

  // ---- Semantic -------------------------------------------------------------
  static const Color danger = Color(0xFFD4342B);
  static const Color dangerSoft = Color(0xFFFCEAE9);
  static const Color success = Color(0xFF1B9E5A);
  static const Color successSoft = Color(0xFFE2F6EB);
  static const Color warning = Color(0xFFE2A014);
  static const Color warningSoft = Color(0xFFFDF3DC);
  static const Color info = Color(0xFF2563A8);
  static const Color infoSoft = Color(0xFFE8F0FA);

  // ---- Light surfaces -------------------------------------------------------
  static const Color lightBg = Color(0xFFF6F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF0F2F7);
  static const Color lightBorder = Color(0xFFE2E6EE);
  static const Color lightTextPrimary = Color(0xFF111A28);
  static const Color lightTextSecondary = Color(0xFF5A6679);
  static const Color lightTextTertiary = Color(0xFF8B96A7);

  // ---- Dark surfaces --------------------------------------------------------
  static const Color darkBg = Color(0xFF080F1B);
  static const Color darkSurface = Color(0xFF111C2E);
  static const Color darkSurfaceAlt = Color(0xFF1A2839);
  static const Color darkBorder = Color(0xFF243447);
  static const Color darkTextPrimary = Color(0xFFF2F5FA);
  static const Color darkTextSecondary = Color(0xFFA7B4C6);
  static const Color darkTextTertiary = Color(0xFF6F7F94);

  // ---- Mock map palette -----------------------------------------------------
  static const Color mapLandLight = Color(0xFFEDEFE9);
  static const Color mapLandDark = Color(0xFF0E1826);
  static const Color mapBlockLight = Color(0xFFE3E7DE);
  static const Color mapBlockDark = Color(0xFF162335);
  static const Color mapGreenLight = Color(0xFFD7E7CE);
  static const Color mapGreenDark = Color(0xFF14261D);
  static const Color mapWaterLight = Color(0xFFC5DDEB);
  static const Color mapWaterDark = Color(0xFF122B3D);
  static const Color mapRoadLight = Color(0xFFFFFFFF);
  static const Color mapRoadDark = Color(0xFF243447);
  static const Color mapRoadCasingLight = Color(0xFFDDE1DA);
  static const Color mapRoadCasingDark = Color(0xFF16222F);
  static const Color mapArterialLight = Color(0xFFFDEBC8);
  static const Color mapArterialDark = Color(0xFF34404F);
  static const Color mapLabelLight = Color(0xFF7D8794);
  static const Color mapLabelDark = Color(0xFF7E8DA1);

  // ---- Route line colours ---------------------------------------------------
  static const Color routeFastest = Color(0xFF2563A8);
  static const Color routeLit = Color(0xFFE2A014);
  static const Color routeCalm = Color(0xFF1B9E5A);
  static const Color routeDimmed = Color(0xFF9AA7B8);
}
