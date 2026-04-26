enum TextSize { small, medium, large }

extension TextSizeX on TextSize {
  double get scaleFactor => switch (this) {
        TextSize.small => 0.875,
        TextSize.medium => 1.0,
        TextSize.large => 1.15,
      };
}
