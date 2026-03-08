/// Theme Local Data Source
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Data source for theme persistence
class ThemeLocalDataSource {
  ThemeLocalDataSource(this.sharedPreferences);

  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'theme_mode';

  /// Load theme mode from local storage
  Future<ThemeMode> loadThemeMode() async {
    final savedTheme = sharedPreferences.getString(_themeKey);

    if (savedTheme == null) {
      return ThemeMode.system;
    }

    switch (savedTheme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Save theme mode to local storage
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final themeName = _themeModeToString(themeMode);
    await sharedPreferences.setString(_themeKey, themeName);
  }

  /// Convert ThemeMode to string
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
