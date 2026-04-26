import 'package:flutter/material.dart';

class AppRadius extends ThemeExtension<AppRadius> {
  const AppRadius({
    required this.sm,
    required this.md,
    required this.lg,
    required this.pill,
  });

  final double sm;
  final double md;
  final double lg;
  final double pill;

  static const AppRadius defaults = AppRadius(sm: 6, md: 12, lg: 18, pill: 999);

  BorderRadius get smAll => BorderRadius.circular(sm);
  BorderRadius get mdAll => BorderRadius.circular(md);
  BorderRadius get lgAll => BorderRadius.circular(lg);
  BorderRadius get pillAll => BorderRadius.circular(pill);

  @override
  AppRadius copyWith({
    double? sm,
    double? md,
    double? lg,
    double? pill,
  }) {
    return AppRadius(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      pill: pill ?? this.pill,
    );
  }

  @override
  AppRadius lerp(covariant AppRadius? other, double t) {
    if (other is! AppRadius) return this;
    return AppRadius(
      sm: sm + (other.sm - sm) * t,
      md: md + (other.md - md) * t,
      lg: lg + (other.lg - lg) * t,
      pill: pill + (other.pill - pill) * t,
    );
  }
}
