import 'package:flutter/material.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/core/theme/app_elevation.dart';
import 'package:sirah_app/core/theme/app_radius.dart';
import 'package:sirah_app/core/theme/app_spacing.dart';
import 'package:sirah_app/core/theme/app_typography.dart';

// Thème C — Constellation colorée
// bg lavande pâle, accent violet indigo, Playfair Display, shadow colorée
final ThemeData feminineTheme = _build();

ThemeData _build() {
  const ink = Color(0xFF161129);
  const accentViolet = Color(0xFF6B4EF2);

  const colors = AppColors(
    bg: Color(0xFFF7F4FF),
    bg2: Color(0xFFFFFFFF),
    ink: ink,
    muted: Color(0xFF7A7590),
    accent: accentViolet,
    accent2: Color(0xFFFF8A4C),
    line: Color(0xFFECE7FA),
    success: Color(0xFF18A87A),
    warning: Color(0xFFF4A622),
    error: Color(0xFFE63E6D),
    categoryColors: AppColors.feminineCategoryColors,
  );

  // Shadow colorée signature sous les cartes principales
  final elevation = AppElevation(
    card: 4,
    modal: 8,
    fab: 6,
    glow: accentViolet.withValues(alpha: 0.13),
  );

  final typo = AppTypography.buildArabic(
    inkColor: ink,
    applySerifDisplay: (style) =>
        style.copyWith(fontFamily: AppFontFamilies.playfairDisplay),
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
      elevation,
    ],
  );
}
