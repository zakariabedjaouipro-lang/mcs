/// Context Extensions
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/constants/responsive_constants.dart';
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

  // ── RESPONSIVE SIZING HELPERS ────────────────────────────────────

  /// Adaptive horizontal padding based on screen width.
  double get adaptivePaddingHorizontal =>
      ResponsiveConstants.adaptivePaddingHorizontal(screenWidth);

  /// Adaptive vertical padding based on screen width.
  double get adaptivePaddingVertical =>
      ResponsiveConstants.adaptivePaddingVertical(screenWidth);

  /// Adaptive padding for cards.
  double get adaptiveCardPadding =>
      ResponsiveConstants.adaptiveCardPadding(screenWidth);

  /// Adaptive spacing between grid items.
  double get adaptiveGridSpacing =>
      ResponsiveConstants.gridSpacing(screenWidth);

  /// Number of grid columns for current screen width.
  int get gridColumnsCount => ResponsiveConstants.gridColumnsCount(screenWidth);

  /// Font scale factor for current screen width.
  double get fontScaleFactor =>
      ResponsiveConstants.fontScaleFactor(screenWidth);

  /// Adaptive EdgeInsets for horizontal padding.
  EdgeInsets get adaptiveHPadding =>
      EdgeInsets.symmetric(horizontal: adaptivePaddingHorizontal);

  /// Adaptive EdgeInsets for vertical padding.
  EdgeInsets get adaptiveVPadding =>
      EdgeInsets.symmetric(vertical: adaptivePaddingVertical);

  /// Adaptive EdgeInsets for all sides.
  EdgeInsets get adaptiveAllPadding =>
      EdgeInsets.all(adaptivePaddingHorizontal);

  /// Safe padding including MediaQuery insets.
  EdgeInsets get safePaddingAll => EdgeInsets.fromLTRB(
        mediaQuerySafe.padding.left + adaptivePaddingHorizontal,
        mediaQuerySafe.padding.top + adaptivePaddingVertical,
        mediaQuerySafe.padding.right + adaptivePaddingHorizontal,
        mediaQuerySafe.padding.bottom + adaptivePaddingVertical,
      );

  /// Safe padding excluding bottom (for bottom sheet, modals).
  EdgeInsets get safePaddingTop => EdgeInsets.fromLTRB(
        mediaQuerySafe.padding.left + adaptivePaddingHorizontal,
        mediaQuerySafe.padding.top + adaptivePaddingVertical,
        mediaQuerySafe.padding.right + adaptivePaddingHorizontal,
        adaptivePaddingVertical,
      );

  /// Width constrained to max content width (useful for desktop).
  double get constrainedWidth =>
      screenWidth > ResponsiveConstants.maxContentWidth
          ? ResponsiveConstants.maxContentWidth
          : screenWidth;
}
