import 'package:flutter/material.dart';

/// Converts a CSS hex color string (e.g. "#A83B7A" or "A83B7A") to a [Color].
Color hexToColor(String hex) {
  final h = hex.replaceFirst('#', '');
  return Color(int.parse('FF$h', radix: 16));
}
