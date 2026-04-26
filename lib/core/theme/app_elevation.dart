import 'package:flutter/material.dart';

class AppElevation extends ThemeExtension<AppElevation> {
  const AppElevation({
    required this.card,
    required this.modal,
    required this.fab,
    required this.glow,
  });

  final double card;
  final double modal;
  final double fab;
  // Utilisé par le thème sombre pour le glow or autour de la calligraphie
  final Color? glow;

  static const AppElevation defaults = AppElevation(
    card: 2,
    modal: 8,
    fab: 6,
    glow: null,
  );

  @override
  AppElevation copyWith({
    double? card,
    double? modal,
    double? fab,
    Color? glow,
  }) {
    return AppElevation(
      card: card ?? this.card,
      modal: modal ?? this.modal,
      fab: fab ?? this.fab,
      glow: glow ?? this.glow,
    );
  }

  @override
  AppElevation lerp(covariant AppElevation? other, double t) {
    if (other is! AppElevation) return this;
    return AppElevation(
      card: card + (other.card - card) * t,
      modal: modal + (other.modal - modal) * t,
      fab: fab + (other.fab - fab) * t,
      glow: Color.lerp(glow, other.glow, t),
    );
  }
}
