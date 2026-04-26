import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/core/theme/app_elevation.dart';
import 'package:sirah_app/core/theme/app_radius.dart';
import 'package:sirah_app/core/theme/app_spacing.dart';
import 'package:sirah_app/core/theme/app_typography.dart';

// Thème A — Éditorial sobre
// bg crème, accent vert profond, serif Crimson Pro
final ThemeData lightTheme = _build();

ThemeData _build() {
  const ink = Color(0xFF1F1D18);

  const colors = AppColors(
    bg: Color(0xFFF5F1E8),
    bg2: Color(0xFFEFE9DB),
    ink: ink,
    muted: Color(0xFF7A7A6F),
    accent: Color(0xFF1F5942),
    accent2: Color(0xFF8B5A2A),
    line: Color(0xFFD8CCB4),
    success: Color(0xFF2E7D5B),
    warning: Color(0xFFB88A2A),
    error: Color(0xFFB83D3D),
    categoryColors: AppColors.lightCategoryColors,
  );

  final typo = AppTypography.buildArabic(
    inkColor: ink,
    applySerifDisplay: (style) => GoogleFonts.crimsonPro(
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      color: style.color,
      height: style.height,
      letterSpacing: style.letterSpacing,
    ),
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
