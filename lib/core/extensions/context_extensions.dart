/// Context Extensions
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/localization/app_localizations.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations? get appLocalizations => AppLocalizations.of(this);

  String translateSafe(String key, {String? fallback}) {
    final l10n = AppLocalizations.of(this);
    if (l10n == null) return fallback ?? key;
    return l10n.translate(key);
  }

  ThemeData get themeSafe => Theme.of(this);
  MediaQueryData get mediaQuerySafe => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isTablet => MediaQuery.of(this).size.shortestSide >= 600;
  bool get isMobile => MediaQuery.of(this).size.shortestSide < 600;
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  TextTheme get textThemeSafe => Theme.of(this).textTheme;
  ColorScheme get colorSchemeSafe => Theme.of(this).colorScheme;

  /// Dark mode detection
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Responsive breakpoints
  bool get isSmall => screenWidth < 600;
  bool get isMedium => screenWidth >= 600 && screenWidth < 1024;
  bool get isLarge => screenWidth >= 1024;
}
