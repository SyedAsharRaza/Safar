import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Extra tokens the Material [ThemeData] has no home for.
@immutable
class SafarTokens extends ThemeExtension<SafarTokens> {
  const SafarTokens({
    required this.isDark,
    required this.surfaceAlt,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.mapLand,
    required this.mapBlock,
    required this.mapGreen,
    required this.mapWater,
    required this.mapRoad,
    required this.mapRoadCasing,
    required this.mapArterial,
    required this.mapLabel,
    required this.cardShadow,
    required this.raisedShadow,
  });

  final bool isDark;
  final Color surfaceAlt;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color mapLand;
  final Color mapBlock;
  final Color mapGreen;
  final Color mapWater;
  final Color mapRoad;
  final Color mapRoadCasing;
  final Color mapArterial;
  final Color mapLabel;
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> raisedShadow;

  static const SafarTokens light = SafarTokens(
    isDark: false,
    surfaceAlt: AppColors.lightSurfaceAlt,
    border: AppColors.lightBorder,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    textTertiary: AppColors.lightTextTertiary,
    mapLand: AppColors.mapLandLight,
    mapBlock: AppColors.mapBlockLight,
    mapGreen: AppColors.mapGreenLight,
    mapWater: AppColors.mapWaterLight,
    mapRoad: AppColors.mapRoadLight,
    mapRoadCasing: AppColors.mapRoadCasingLight,
    mapArterial: AppColors.mapArterialLight,
    mapLabel: AppColors.mapLabelLight,
    cardShadow: [
      BoxShadow(color: Color(0x0D101A28), blurRadius: 14, offset: Offset(0, 4)),
      BoxShadow(color: Color(0x08101A28), blurRadius: 3, offset: Offset(0, 1)),
    ],
    raisedShadow: [
      BoxShadow(color: Color(0x1A101A28), blurRadius: 28, offset: Offset(0, 10)),
    ],
  );

  static const SafarTokens dark = SafarTokens(
    isDark: true,
    surfaceAlt: AppColors.darkSurfaceAlt,
    border: AppColors.darkBorder,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,
    mapLand: AppColors.mapLandDark,
    mapBlock: Color(0xFF162335),
    mapGreen: AppColors.mapGreenDark,
    mapWater: AppColors.mapWaterDark,
    mapRoad: AppColors.mapRoadDark,
    mapRoadCasing: AppColors.mapRoadCasingDark,
    mapArterial: AppColors.mapArterialDark,
    mapLabel: AppColors.mapLabelDark,
    cardShadow: [
      BoxShadow(color: Color(0x40000000), blurRadius: 16, offset: Offset(0, 4)),
    ],
    raisedShadow: [
      BoxShadow(color: Color(0x66000000), blurRadius: 28, offset: Offset(0, 10)),
    ],
  );

  @override
  SafarTokens copyWith({bool? isDark}) => this;

  @override
  SafarTokens lerp(ThemeExtension<SafarTokens>? other, double t) {
    if (other is! SafarTokens) return this;
    return t < 0.5 ? this : other;
  }
}

/// Convenience accessors so widgets read `context.tokens.border`.
extension SafarThemeX on BuildContext {
  SafarTokens get tokens =>
      Theme.of(this).extension<SafarTokens>() ?? SafarTokens.light;
  ColorScheme get scheme => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

abstract final class AppTheme {
  static ThemeData light() => _base(
        brightness: Brightness.light,
        tokens: SafarTokens.light,
        scheme: const ColorScheme.light(
          primary: AppColors.brand,
          onPrimary: Colors.white,
          primaryContainer: AppColors.brandSoft,
          onPrimaryContainer: AppColors.brandDeep,
          secondary: AppColors.accent,
          onSecondary: Color(0xFF3A2606),
          secondaryContainer: AppColors.accentSoft,
          onSecondaryContainer: AppColors.accentDeep,
          tertiary: AppColors.teal,
          onTertiary: Colors.white,
          error: AppColors.danger,
          onError: Colors.white,
          errorContainer: AppColors.dangerSoft,
          onErrorContainer: Color(0xFF8A1C16),
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightTextPrimary,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: AppColors.lightBg,
          surfaceContainer: AppColors.lightSurfaceAlt,
          surfaceContainerHigh: Color(0xFFE8EBF2),
          onSurfaceVariant: AppColors.lightTextSecondary,
          outline: AppColors.lightBorder,
          outlineVariant: Color(0xFFEDF0F5),
          inverseSurface: AppColors.brandNight,
          onInverseSurface: Colors.white,
        ),
        scaffold: AppColors.lightBg,
      );

  static ThemeData dark() => _base(
        brightness: Brightness.dark,
        tokens: SafarTokens.dark,
        scheme: const ColorScheme.dark(
          primary: Color(0xFF6BA6E8),
          onPrimary: Color(0xFF07203C),
          primaryContainer: Color(0xFF1B3A5C),
          onPrimaryContainer: Color(0xFFCBE1FA),
          secondary: AppColors.accent,
          onSecondary: Color(0xFF3A2606),
          secondaryContainer: Color(0xFF4A3410),
          onSecondaryContainer: Color(0xFFFBE4C1),
          tertiary: Color(0xFF3FC3C2),
          onTertiary: Color(0xFF00312F),
          error: Color(0xFFF08076),
          onError: Color(0xFF4A0C08),
          errorContainer: Color(0xFF5A1712),
          onErrorContainer: Color(0xFFFBD9D5),
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          surfaceContainerLowest: Color(0xFF060C16),
          surfaceContainerLow: AppColors.darkBg,
          surfaceContainer: AppColors.darkSurfaceAlt,
          surfaceContainerHigh: Color(0xFF223246),
          onSurfaceVariant: AppColors.darkTextSecondary,
          outline: AppColors.darkBorder,
          outlineVariant: Color(0xFF1C2A3B),
          inverseSurface: Color(0xFFF2F5FA),
          onInverseSurface: AppColors.brandNight,
        ),
        scaffold: AppColors.darkBg,
      );

  static ThemeData _base({
    required Brightness brightness,
    required SafarTokens tokens,
    required ColorScheme scheme,
    required Color scaffold,
  }) {
    final text = _textTheme(tokens);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      fontFamily: AppType.family,
      textTheme: text,
      extensions: <ThemeExtension<dynamic>>[tokens],
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        surfaceTintColor: Colors.transparent,
        foregroundColor: tokens.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppType.h3.copyWith(color: tokens.textPrimary),
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: Radii.allLg),
      ),
      dividerTheme: DividerThemeData(
        color: tokens.border,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: Gap.xxl),
          shape: const RoundedRectangleBorder(borderRadius: Radii.allMd),
          textStyle: AppType.titleMd,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: Gap.xxl),
          shape: const RoundedRectangleBorder(borderRadius: Radii.allMd),
          side: BorderSide(color: tokens.border, width: 1.4),
          foregroundColor: tokens.textPrimary,
          textStyle: AppType.titleMd,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: Gap.md),
          shape: const RoundedRectangleBorder(borderRadius: Radii.allSm),
          textStyle: AppType.titleSm,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(44, 44),
          foregroundColor: tokens.textPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.isDark ? tokens.surfaceAlt : AppColors.lightSurface,
        hintStyle: AppType.body.copyWith(color: tokens.textTertiary),
        labelStyle: AppType.titleSm.copyWith(color: tokens.textSecondary),
        floatingLabelStyle: AppType.titleSm.copyWith(color: scheme.primary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Gap.lg,
          vertical: Gap.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: Radii.allMd,
          borderSide: BorderSide(color: tokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Radii.allMd,
          borderSide: BorderSide(color: tokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.allMd,
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.allMd,
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Radii.allMd,
          borderSide: BorderSide(color: scheme.error, width: 1.6),
        ),
        errorStyle: AppType.caption.copyWith(color: scheme.error),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: tokens.isDark ? tokens.surfaceAlt : Colors.white,
        side: BorderSide(color: tokens.border),
        labelStyle: AppType.titleSm.copyWith(color: tokens.textPrimary),
        shape: const RoundedRectangleBorder(borderRadius: Radii.pill),
        padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm),
        showCheckmark: false,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: Radii.sheet),
        showDragHandle: true,
        dragHandleColor: tokens.textTertiary.withValues(alpha: 0.45),
        dragHandleSize: const Size(44, 4),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: Radii.allXl),
        titleTextStyle: AppType.h3.copyWith(color: tokens.textPrimary),
        contentTextStyle: AppType.body.copyWith(color: tokens.textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: tokens.isDark
            ? const Color(0xFF243447)
            : AppColors.brandNight,
        contentTextStyle: AppType.titleSm.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: Radii.allMd),
        insetPadding: const EdgeInsets.all(Gap.lg),
        elevation: 6,
        actionTextColor: AppColors.accent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.brandNight.withValues(alpha: 0.94),
          borderRadius: Radii.allSm,
        ),
        textStyle: AppType.caption.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: AppType.titleSm,
        unselectedLabelStyle: AppType.titleSm,
        labelColor: scheme.primary,
        unselectedLabelColor: tokens.textSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? scheme.primary
              : tokens.isDark
                  ? tokens.surfaceAlt
                  : const Color(0xFFD6DCE6),
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? Colors.transparent
              : tokens.border,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: tokens.isDark
            ? tokens.surfaceAlt
            : const Color(0xFFE0E5EE),
        thumbColor: Colors.white,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
        trackHeight: 6,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: tokens.isDark
            ? tokens.surfaceAlt
            : const Color(0xFFE4E9F0),
        linearMinHeight: 6,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: AppType.titleMd.copyWith(color: tokens.textPrimary),
        subtitleTextStyle: AppType.bodySm.copyWith(color: tokens.textSecondary),
        iconColor: tokens.textSecondary,
        shape: const RoundedRectangleBorder(borderRadius: Radii.allMd),
        contentPadding: const EdgeInsets.symmetric(horizontal: Gap.lg),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _textTheme(SafarTokens t) {
    Color p = t.textPrimary;
    Color s = t.textSecondary;
    return TextTheme(
      displaySmall: AppType.display.copyWith(color: p),
      headlineLarge: AppType.h1.copyWith(color: p),
      headlineMedium: AppType.h2.copyWith(color: p),
      headlineSmall: AppType.h3.copyWith(color: p),
      titleLarge: AppType.h3.copyWith(color: p),
      titleMedium: AppType.titleMd.copyWith(color: p),
      titleSmall: AppType.titleSm.copyWith(color: p),
      bodyLarge: AppType.body.copyWith(color: p),
      bodyMedium: AppType.body.copyWith(color: s),
      bodySmall: AppType.bodySm.copyWith(color: s),
      labelLarge: AppType.label.copyWith(color: p),
      labelMedium: AppType.caption.copyWith(color: s),
      labelSmall: AppType.overline.copyWith(color: t.textTertiary),
    );
  }
}
