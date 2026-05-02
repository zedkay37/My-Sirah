import 'package:flutter/material.dart';

class AppFontFamilies {
  const AppFontFamilies._();

  static const amiri = 'Amiri';
  static const amiriQuran = 'Amiri Quran';
  static const crimsonPro = 'Crimson Pro';
  static const inter = 'Inter';
  static const playfairDisplay = 'Playfair Display';
}

class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.arabicHero,
    required this.arabicLarge,
    required this.arabicMedium,
    required this.arabicBody,
    required this.displayLarge,
    required this.displayMedium,
    required this.headline,
    required this.bodyLarge,
    required this.body,
    required this.caption,
    required this.overline,
    required this.button,
  });

  // ── Arabe ──────────────────────────────────────────────────────────────
  final TextStyle arabicHero; // 88sp — Amiri Quran, calligraphie hero
  final TextStyle arabicLarge; // 56sp
  final TextStyle arabicMedium; // 32sp
  final TextStyle arabicBody; // 22sp

  // ── Serif éditorial ────────────────────────────────────────────────────
  final TextStyle displayLarge; // 36sp
  final TextStyle displayMedium; // 28sp
  final TextStyle headline; // 20sp
  final TextStyle bodyLarge; // 16sp
  final TextStyle body; // 14sp

  // ── Sans-serif UI ──────────────────────────────────────────────────────
  final TextStyle caption; // 12sp
  final TextStyle overline; // 10sp uppercase letter-spaced
  final TextStyle button; // 14sp medium

  // Construit les styles arabes (communs aux 3 thèmes, seule la couleur change)
  static AppTypography buildArabic({
    required TextStyle Function(TextStyle) applySerifDisplay,
    required Color inkColor,
  }) {
    final arabicQuranBase = TextStyle(
      fontFamily: AppFontFamilies.amiriQuran,
      color: inkColor,
    );
    final arabicBase = TextStyle(
      fontFamily: AppFontFamilies.amiri,
      color: inkColor,
    );
    final uiBase = TextStyle(
      fontFamily: AppFontFamilies.inter,
      color: inkColor,
    );

    return AppTypography(
      arabicHero: arabicQuranBase.copyWith(
        fontSize: 88,
        fontWeight: FontWeight.w400,
        height: 1.28,
      ),
      arabicLarge: arabicBase.copyWith(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      arabicMedium: arabicBase.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      arabicBody: arabicBase.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      displayLarge: applySerifDisplay(
        TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: inkColor),
      ),
      displayMedium: applySerifDisplay(
        TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: inkColor),
      ),
      headline: applySerifDisplay(
        TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: inkColor),
      ),
      bodyLarge: applySerifDisplay(
        TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: inkColor,
          height: 1.6,
        ),
      ),
      body: applySerifDisplay(
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: inkColor,
          height: 1.6,
        ),
      ),
      caption: uiBase.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
      overline: uiBase.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        wordSpacing: 0,
      ),
      button: uiBase.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  @override
  AppTypography copyWith({
    TextStyle? arabicHero,
    TextStyle? arabicLarge,
    TextStyle? arabicMedium,
    TextStyle? arabicBody,
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? headline,
    TextStyle? bodyLarge,
    TextStyle? body,
    TextStyle? caption,
    TextStyle? overline,
    TextStyle? button,
  }) {
    return AppTypography(
      arabicHero: arabicHero ?? this.arabicHero,
      arabicLarge: arabicLarge ?? this.arabicLarge,
      arabicMedium: arabicMedium ?? this.arabicMedium,
      arabicBody: arabicBody ?? this.arabicBody,
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      headline: headline ?? this.headline,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      body: body ?? this.body,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
      button: button ?? this.button,
    );
  }

  @override
  AppTypography lerp(covariant AppTypography? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      arabicHero: TextStyle.lerp(arabicHero, other.arabicHero, t)!,
      arabicLarge: TextStyle.lerp(arabicLarge, other.arabicLarge, t)!,
      arabicMedium: TextStyle.lerp(arabicMedium, other.arabicMedium, t)!,
      arabicBody: TextStyle.lerp(arabicBody, other.arabicBody, t)!,
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      overline: TextStyle.lerp(overline, other.overline, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
    );
  }
}
