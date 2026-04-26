import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.bg2,
    required this.ink,
    required this.muted,
    required this.accent,
    required this.accent2,
    required this.line,
    required this.success,
    required this.warning,
    required this.error,
    required this.categoryColors,
  });

  final Color bg;
  final Color bg2;
  final Color ink;
  final Color muted;
  final Color accent;
  final Color accent2;
  final Color line;
  final Color success;
  final Color warning;
  final Color error;

  // Map<slug, Color> — valeurs spécifiques au thème (light/dark/feminine)
  final Map<String, Color> categoryColors;

  Color categoryColor(String slug) =>
      categoryColors[slug] ?? const Color(0xFF888888);

  // Fond teinté à 10% pour les chips et backgrounds catégorie
  Color categoryBg(String slug) =>
      categoryColor(slug).withValues(alpha: 0.10);

  // Palette catégorie — light theme
  static const Map<String, Color> lightCategoryColors = {
    'praise': Color(0xFFB86B2A),
    'prophethood': Color(0xFF2A5BA8),
    'intercession': Color(0xFF5B3FBE),
    'eschatology': Color(0xFFA83A7A),
    'purity': Color(0xFF1F7A6B),
    'virtues': Color(0xFF5E8A2A),
    'miraj': Color(0xFF3A3FBE),
    'guidance': Color(0xFFB88A0D),
    'light': Color(0xFFA8932A),
    'nobility': Color(0xFFB83D2A),
    'devotion': Color(0xFF2A8A5E),
  };

  // Palette catégorie — dark theme
  static const Map<String, Color> darkCategoryColors = {
    'praise': Color(0xFFD48757),
    'prophethood': Color(0xFF5A8BCC),
    'intercession': Color(0xFF8A6FD9),
    'eschatology': Color(0xFFD06FA0),
    'purity': Color(0xFF4FA593),
    'virtues': Color(0xFF8BB355),
    'miraj': Color(0xFF6E72D9),
    'guidance': Color(0xFFD9B040),
    'light': Color(0xFFD4BF57),
    'nobility': Color(0xFFD46B57),
    'devotion': Color(0xFF57B388),
  };

  // Palette catégorie — feminine theme
  static const Map<String, Color> feminineCategoryColors = {
    'praise': Color(0xFFFF9A4C),
    'prophethood': Color(0xFF4A7FDF),
    'intercession': Color(0xFF7B5EE8),
    'eschatology': Color(0xFFE063A8),
    'purity': Color(0xFF18A88C),
    'virtues': Color(0xFF8BC340),
    'miraj': Color(0xFF5E60E8),
    'guidance': Color(0xFFF4A622),
    'light': Color(0xFFF4D422),
    'nobility': Color(0xFFFF6A4C),
    'devotion': Color(0xFF18A87A),
  };

  @override
  AppColors copyWith({
    Color? bg,
    Color? bg2,
    Color? ink,
    Color? muted,
    Color? accent,
    Color? accent2,
    Color? line,
    Color? success,
    Color? warning,
    Color? error,
    Map<String, Color>? categoryColors,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      bg2: bg2 ?? this.bg2,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
      accent2: accent2 ?? this.accent2,
      line: line ?? this.line,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      categoryColors: categoryColors ?? this.categoryColors,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      bg2: Color.lerp(bg2, other.bg2, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accent2: Color.lerp(accent2, other.accent2, t)!,
      line: Color.lerp(line, other.line, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      categoryColors: {
        for (final key in categoryColors.keys)
          key: Color.lerp(
            categoryColors[key]!,
            other.categoryColors[key] ?? categoryColors[key]!,
            t,
          )!,
      },
    );
  }
}
