/// Theme Repository Implementation
library;

import 'package:flutter/material.dart';
import 'package:mcs/features/theme/data/datasources/theme_local_data_source.dart';
import 'package:mcs/features/theme/domain/repositories/theme_repository.dart';

/// Implementation of theme repository
class ThemeRepositoryImpl extends ThemeRepository {
  ThemeRepositoryImpl(this._localDataSource);

  final ThemeLocalDataSource _localDataSource;
  late ThemeMode _currentThemeMode;

  /// Load theme mode from local storage
  @override
  Future<ThemeMode> loadThemeMode() async {
    _currentThemeMode = await _localDataSource.loadThemeMode();
    return _currentThemeMode;
  }

  /// Save theme mode to local storage
  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    _currentThemeMode = themeMode;
    await _localDataSource.saveThemeMode(themeMode);
  }

  /// Get current theme mode
  @override
  ThemeMode getCurrentThemeMode() => _currentThemeMode;
}
