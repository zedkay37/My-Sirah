import 'package:flutter/material.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/core/theme/app_elevation.dart';
import 'package:sirah_app/core/theme/app_radius.dart';
import 'package:sirah_app/core/theme/app_spacing.dart';
import 'package:sirah_app/core/theme/app_typography.dart';

// Thème A — Éditorial sobre
// bg crème, accent vert profond, serif Crimson Pro
final ThemeData lightTheme = _build();

ThemeData _build() {
  const ink = Color(0xFF18221D);

  const colors = AppColors(
    bg: Color(0xFFFAF8F1),
    bg2: Color(0xFFFFFFFF),
    ink: ink,
    muted: Color(0xFF6F7169),
    accent: Color(0xFF0F5A3F),
    accent2: Color(0xFFC4963A),
    line: Color(0xFFE4D9C7),
    success: Color(0xFF2F7D5C),
    warning: Color(0xFFC09432),
    error: Color(0xFFB83D3D),
    categoryColors: AppColors.lightCategoryColors,
  );

  final typo = AppTypography.buildArabic(
    inkColor: ink,
    applySerifDisplay: (style) =>
        style.copyWith(fontFamily: AppFontFamilies.crimsonPro),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: colors.bg,
    colorScheme: ColorScheme.light(
      primary: colors.accent,
      secondary: colors.accent2,
      surface: colors.bg2,
      error: colors.error,
      onPrimary: Colors.white,
      onSurface: colors.ink,
    ),
    extensions: [
      colors,
      typo,
      AppSpacing.defaults,
      AppRadius.defaults,
      AppElevation.defaults,
    ],
  );
}
