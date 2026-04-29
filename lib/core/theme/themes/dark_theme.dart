import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/core/theme/app_elevation.dart';
import 'package:sirah_app/core/theme/app_radius.dart';
import 'package:sirah_app/core/theme/app_spacing.dart';
import 'package:sirah_app/core/theme/app_typography.dart';

// Thème B — Nuit + or
// bg nuit profonde, accent or brûlé, glow signature autour de la calligraphie
final ThemeData darkTheme = _build();

ThemeData _build() {
  const ink = Color(0xFFF2ECE0);
  const accentGold = Color(0xFFD4A857);

  const colors = AppColors(
    bg: Color(0xFF141312),
    bg2: Color(0xFF1C1A16),
    ink: ink,
    muted: Color(0xFF8C8578),
    accent: accentGold,
    accent2: Color(0xFF9E7A3C),
    line: Color(0xFF26231F),
    success: Color(0xFF7FB997),
    warning: Color(0xFFE0B45C),
    error: Color(0xFFD67070),
    categoryColors: AppColors.darkCategoryColors,
  );

  final elevation = AppElevation(
    card: 0,
    modal: 0,
    fab: 0,
    // Glow or discret — 0xD4A857 à 33% opacité
    glow: accentGold.withValues(alpha: 0.33),
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
    brightness: Brightness.dark,
    scaffoldBackgroundColor: colors.bg,
    colorScheme: ColorScheme.dark(
      primary: colors.accent,
      secondary: colors.accent2,
      surface: colors.bg2,
      error: colors.error,
      onPrimary: const Color(0xFF141312),
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
