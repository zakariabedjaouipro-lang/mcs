/// Application text styles for app_theme.dart compatibility.
///
/// This file provides text styles for use with the app theme system.
/// Use TextStyles class from text_styles.dart for consistent styling.
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/text_styles.dart';

/// Text styles for AppTheme compatibility.
///
/// This class provides the same styles as TextStyles but with a different
/// naming convention for backward compatibility with existing code.
abstract class AppTextStyles {
  // ── Headlines ────────────────────────────────────────────
  static TextStyle get headline1 => TextStyles.headline1;
  static TextStyle get headline2 => TextStyles.headline2;
  static TextStyle get headline3 => TextStyles.headline3;
  static TextStyle get headline4 => TextStyles.headline4;
  static TextStyle get headline5 => TextStyles.headline5;
  static TextStyle get headline6 => TextStyles.headline6;

  // ── Display ─────────────────────────────────────────────
  static TextStyle get displayLarge => TextStyles.displayLarge;
  static TextStyle get displayMedium => TextStyles.displayMedium;

  // ── Title ───────────────────────────────────────────────
  static TextStyle get titleLarge => TextStyles.titleLarge;
  static TextStyle get titleMedium => TextStyles.titleMedium;
  static TextStyle get titleSmall => TextStyles.titleSmall;

  // ── Body ─────────────────────────────────────────────────
  static TextStyle get bodyLarge => TextStyles.bodyLarge;
  static TextStyle get bodyMedium => TextStyles.bodyMedium;
  static TextStyle get bodySmall => TextStyles.bodySmall;

  // ── Label ───────────────────────────────────────────────
  static TextStyle get labelLarge => TextStyles.labelLarge;
  static TextStyle get labelMedium => TextStyles.labelMedium;
  static TextStyle get labelSmall => TextStyles.labelSmall;

  // ── Button ─────────────────────────────────────────────
  static TextStyle get button => TextStyles.button;

  // ── Caption ─────────────────────────────────────────────
  static TextStyle get caption => TextStyles.caption;

  // ── Overline ────────────────────────────────────────────
  static TextStyle get overline => TextStyles.overline;

  // ── Legacy styles (for backward compatibility) ────────
  static TextStyle get heading1 => TextStyles.heading1;
  static TextStyle get heading2 => TextStyles.heading2;
  static TextStyle get heading3 => TextStyles.heading3;
  static TextStyle get heading4 => TextStyles.heading4;
  static TextStyle get heading5 => TextStyles.heading5;
  static TextStyle get heading6 => TextStyles.heading6;

  static TextStyle get body1 => TextStyles.body1;
  static TextStyle get body2 => TextStyles.body2;
  static TextStyle get subtitle1 => TextStyles.subtitle1;
  static TextStyle get subtitle2 => TextStyles.subtitle2;
}