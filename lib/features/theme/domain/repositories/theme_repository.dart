/// Theme Repository Interface
library;

import 'package:flutter/material.dart';

/// Abstract repository for theme management
abstract class ThemeRepository {
  /// Load theme mode from local storage
  Future<ThemeMode> loadThemeMode();

  /// Save theme mode to local storage
  Future<void> saveThemeMode(ThemeMode themeMode);

  /// Get current theme mode
  ThemeMode getCurrentThemeMode();
}
