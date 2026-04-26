import 'package:flutter/material.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/core/theme/themes/dark_theme.dart';
import 'package:sirah_app/core/theme/themes/feminine_theme.dart';
import 'package:sirah_app/core/theme/themes/light_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData build(ThemeKey key) {
    return switch (key) {
      ThemeKey.light => lightTheme,
      ThemeKey.dark => darkTheme,
      ThemeKey.feminine => feminineTheme,
    };
  }
}
