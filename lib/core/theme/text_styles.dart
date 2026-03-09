/// Application text styles.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  // ── Base Font Families ───────────────────────────────────

  /// Latin text uses Inter.
  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  /// Arabic text uses Cairo.
  static String get _fontFamilyAr => GoogleFonts.cairo().fontFamily!;

  /// Returns the appropriate font family for the given [locale].
  static String fontFamilyFor(String locale) =>
      locale == 'ar' ? _fontFamilyAr : _fontFamily;

  // ── Headlines ────────────────────────────────────────────

  static TextStyle get headline1 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 1.25,
      );

  static TextStyle get headline2 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 1.3,
      );

  static TextStyle get headline3 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.3,
      );

  static TextStyle get headline4 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.35,
      );

  static TextStyle get headline5 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.4,
      );

  static TextStyle get headline6 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.4,
      );

  // ── Body ─────────────────────────────────────────────────

  static TextStyle get bodyLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 1.5,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 1.5,
      );

  // ── Labels / Buttons ─────────────────────────────────────

  static TextStyle get labelLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        letterSpacing: 0.5,
      );

  static TextStyle get button => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        letterSpacing: 0.8,
      );

  // ── Caption / Overline ───────────────────────────────────

  static TextStyle get caption => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        letterSpacing: 0.4,
      );

  static TextStyle get overline => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        letterSpacing: 1.5,
      );

  // ── Deprecated style getters (for backward compatibility) ──

  static TextStyle get heading1 => headline1;
  static TextStyle get heading2 => headline2;
  static TextStyle get heading3 => headline3;
  static TextStyle get heading4 => headline4;
  static TextStyle get heading5 => headline5;
  static TextStyle get heading6 => headline6;

  static TextStyle get body1 => bodyLarge;
  static TextStyle get body2 => bodyMedium;
  static TextStyle get subtitle1 => bodyMedium;
  static TextStyle get subtitle2 => bodySmall;

  static TextStyle get titleLarge => headline4;
  static TextStyle get titleMedium => headline5;
  static TextStyle get titleSmall => headline6;

  static TextStyle get displayLarge => headline2;
  static TextStyle get displayMedium => headline3;
  static TextStyle get labelMedium => labelSmall;
  static TextStyle get headlineLarge => headline1;
  static TextStyle get headlineMedium => headline3;
}
