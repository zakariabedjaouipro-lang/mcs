/// Theme BLoC - Manages theme state and events
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/features/theme/domain/repositories/theme_repository.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_event.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_state.dart';

/// BLoC for theme management
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({required ThemeRepository themeRepository})
      : _themeRepository = themeRepository,
        super(const ThemeInitial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeModeEvent>(_onSetThemeMode);
    on<LoadThemeEvent>(_onLoadTheme);

    // Load theme immediately after initialization
    Future.microtask(() => add(const LoadThemeEvent()));
  }

  final ThemeRepository _themeRepository;

  /// Get current theme mode
  ThemeMode get currentThemeMode => _themeRepository.getCurrentThemeMode();

  /// Handle toggle theme
  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(const ThemeLoading());
    try {
      final newMode = currentThemeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

      await _themeRepository.saveThemeMode(newMode);
      emit(ThemeChanged(newMode));

      if (newMode == ThemeMode.light) {
        emit(const ThemeLightState());
      } else {
        emit(const ThemeDarkState());
      }
    } catch (e) {
      emit(ThemeError('فشل تغيير الثيم: $e'));
    }
  }

  /// Handle set theme mode
  Future<void> _onSetThemeMode(
    SetThemeModeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(const ThemeLoading());
    try {
      await _themeRepository.saveThemeMode(event.themeMode);
      emit(ThemeChanged(event.themeMode));

      if (event.themeMode == ThemeMode.light) {
        emit(const ThemeLightState());
      } else {
        emit(const ThemeDarkState());
      }
    } catch (e) {
      emit(ThemeError('فشل حفظ اختيار الثيم: $e'));
    }
  }

  /// Handle load theme
  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(const ThemeLoading());
    try {
      final savedMode = await _themeRepository.loadThemeMode();
      emit(ThemeChanged(savedMode));

      if (savedMode == ThemeMode.light) {
        emit(const ThemeLightState());
      } else {
        emit(const ThemeDarkState());
      }
    } catch (e) {
      emit(ThemeError('فشل تحميل الثيم: $e'));
    }
  }
}
