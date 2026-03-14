/// ═══════════════════════════════════════════════════════════════════════════
/// PROFESSIONAL RESPONSIVE CONFIG | إعدادات التجاوب الاحترافية
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Integration of flutter_screenutil & responsive_framework for professional
/// responsive design across all platforms (mobile, tablet, web, desktop)

library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Professional responsive design configuration
class ResponsiveConfig {
  // ═══════════════════════════════════════════════════════════════════════
  // SCREEN SIZE BREAKPOINTS - تقسيم أحجام الشاشات
  // ═══════════════════════════════════════════════════════════════════════

  /// Mobile screen width < 600
  static const double mobileBreakpoint = 600;

  /// Tablet screen width 600-900
  static const double tabletBreakpoint = 900;

  /// Desktop screen width >= 900
  static const double desktopBreakpoint = 900;

  /// Design base size for flutter_screenutil (design mockup width)
  static const double designWidth = 360;

  /// Design base height for flutter_screenutil (design mockup height)
  static const double designHeight = 800;

  // ═══════════════════════════════════════════════════════════════════════
  // RESPONSIVE FONT SIZING - أحجام الخطوط المتجاوبة
  // ═══════════════════════════════════════════════════════════════════════

  /// Get responsive headline font size
  static double headlineFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 24;
    if (width < 900) return 32;
    return 40;
  }

  /// Get responsive title font size
  static double titleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 18;
    if (width < 900) return 22;
    return 26;
  }

  /// Get responsive body font size
  static double bodyFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 14;
    if (width < 900) return 16;
    return 18;
  }

  /// Get responsive caption font size
  static double captionFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 12;
    if (width < 900) return 13;
    return 14;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // RESPONSIVE SPACING - التباعد المتجاوب
  // ═══════════════════════════════════════════════════════════════════════

  /// Get responsive padding value
  static double responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 12;
    if (width < 900) return 16;
    return 20;
  }

  /// Get responsive margin value
  static double responsiveMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 8;
    if (width < 900) return 12;
    return 16;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // RESPONSIVE DIMENSIONS - الأبعاد المتجاوبة
  // ═══════════════════════════════════════════════════════════════════════

  /// Get responsive button height
  static double buttonHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 44;
    if (width < 900) return 48;
    return 52;
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 20;
    if (width < 900) return 24;
    return 28;
  }

  /// Get responsive card border radius
  static double cardBorderRadius(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 8;
    if (width < 900) return 12;
    return 16;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // FLUTTER SCREENUTIL HELPERS - مساعدات flutter_screenutil
  // ═══════════════════════════════════════════════════════════════════════

  /// Convert width to responsive size using screenutil
  static double responsiveW(double w) {
    return w.w;
  }

  /// Convert height to responsive size using screenutil
  static double responsiveH(double h) {
    return h.h;
  }

  /// Convert font size to responsive size using screenutil
  static double responsiveSP(double size) {
    return size.sp;
  }

  /// Convert radius to responsive size using screenutil
  static double responsiveR(double r) {
    return r.r;
  }
}

/// Extension for easier responsive access
extension ResponsiveExtensionPro on BuildContext {
  /// Check if device is mobile
  bool get isMobile => ResponsiveBreakpoints.of(this).isMobile;

  /// Check if device is tablet
  bool get isTablet => ResponsiveBreakpoints.of(this).isTablet;

  /// Check if device is desktop
  bool get isDesktop => ResponsiveBreakpoints.of(this).isDesktop;

  /// Check if device is 4K or larger
  bool get is4K => MediaQuery.of(this).size.width >= 1400;

  /// Get responsive font scale
  double get fontScale {
    if (isMobile) return 1;
    if (isTablet) return 1.1;
    if (isDesktop) return 1.2;
    return 1;
  }

  /// Get responsive spacing scale
  double get spacingScale {
    if (isMobile) return 1;
    if (isTablet) return 1.15;
    if (isDesktop) return 1.3;
    return 1;
  }

  /// Get responsive dimension scale
  double get dimensionScale {
    if (isMobile) return 1;
    if (isTablet) return 1.2;
    if (isDesktop) return 1.4;
    return 1;
  }
}
