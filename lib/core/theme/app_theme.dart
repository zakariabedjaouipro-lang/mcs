/// Top-level theme manager.
///
/// Provides easy access to the light and dark [ThemeData] objects
/// and helpers for toggling / reading the current theme mode.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/theme/dark_theme.dart';
import 'package:mcs/core/theme/light_theme.dart';

class AppTheme {
  const AppTheme._();

  /// Pre-built light theme.
  static final ThemeData light = buildLightTheme();

  /// Pre-built dark theme.
  static final ThemeData dark = buildDarkTheme();

  /// Returns the appropriate [ThemeData] for the given [mode].
  static ThemeData fromMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return light;
      case ThemeMode.dark:
        return dark;
      case ThemeMode.system:
        // The MaterialApp will handle system mode automatically;
        // this fallback returns light.
        return light;
    }
  }
}
