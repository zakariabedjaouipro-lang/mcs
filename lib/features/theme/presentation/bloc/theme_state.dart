/// Theme State - All theme-related states
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base class for all theme states
abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

/// Initial theme state
class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

/// Theme loading state
class ThemeLoading extends ThemeState {
  const ThemeLoading();
}

/// Theme changed successfully
class ThemeChanged extends ThemeState {
  const ThemeChanged(this.themeMode);
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

/// Theme changed to light
class ThemeLightState extends ThemeState {
  const ThemeLightState();
}

/// Theme changed to dark
class ThemeDarkState extends ThemeState {
  const ThemeDarkState();
}

/// Theme error state
class ThemeError extends ThemeState {
  const ThemeError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
