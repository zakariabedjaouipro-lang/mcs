/// Theme Event - All theme-related events
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for all theme events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Toggle between light and dark theme
class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}

/// Set a specific theme mode
class SetThemeModeEvent extends ThemeEvent {
  const SetThemeModeEvent(this.themeMode);
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

/// Load saved theme from local storage
class LoadThemeEvent extends ThemeEvent {
  const LoadThemeEvent();
}
