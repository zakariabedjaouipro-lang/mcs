/// Responsive Design System
/// Centralized responsive values using ScreenUtil
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized responsive design values and utilities
class ResponsiveDesign {
  ResponsiveDesign._();

  // ── Screen Sizes ────────────────────────────────────────────
  static double get screenWidth => 1.sw;
  static double get screenHeight => 1.sh;

  static bool get isMobile => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  static bool get isDesktop => screenWidth >= 900;

  // ── Breakpoints ─────────────────────────────────────────────
  static const double mobileBreakpoint = 320;
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 900;
  static const double largeDesktopBreakpoint = 1200;

  // ── Padding & Spacing ───────────────────────────────────────
  /// Adaptive padding based on screen size
  static double get paddingXSmall => 8.r;
  static double get paddingSmall => 12.r;
  static double get paddingMedium => 16.r;
  static double get paddingLarge => 20.r;
  static double get paddingXLarge => 24.r;
  static double get paddingXXLarge => 32.r;

  /// Adaptive spacing based on screen size
  static double get spacingXSmall => 4.r;
  static double get spacingSmall => 8.r;
  static double get spacingMedium => 12.r;
  static double get spacingLarge => 16.r;
  static double get spacingXLarge => 20.r;
  static double get spacingXXLarge => 24.r;

  // ── Button Dimensions ───────────────────────────────────────
  /// Adaptive button height based on screen size
  static double get buttonHeight => isMobile ? 44.h : 48.h;
  static double get buttonHeightSmall => isMobile ? 36.h : 40.h;
  static double get buttonHeightLarge => isMobile ? 50.h : 56.h;

  /// Adaptive button padding
  static EdgeInsets get buttonPadding => EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: spacingSmall,
      );

  // ── Icon Sizes ──────────────────────────────────────────────
  static double get iconSizeSmall => 18.r;
  static double get iconSizeRegular => 24.r;
  static double get iconSizeMedium => 32.r;
  static double get iconSizeLarge => 48.r;

  // ── Border Radius ──────────────────────────────────────────
  static double get borderRadiusSmall => 8.r;
  static double get borderRadiusMedium => 12.r;
  static double get borderRadiusLarge => 16.r;
  static double get borderRadiusXLarge => 20.r;

  // ── Card Dimensions ────────────────────────────────────────
  static double get cardElevation => 2;
  static double get cardBorderRadius => borderRadiusMedium;

  // ── Font Sizes ─────────────────────────────────────────────
  static double get fontSizeXSmall => 10.sp;
  static double get fontSizeSmall => 12.sp;
  static double get fontSizeMedium => 14.sp;
  static double get fontSizeRegular => 16.sp;
  static double get fontSizeLarge => 18.sp;
  static double get fontSizeXLarge => 20.sp;
  static double get fontSizeXXLarge => 24.sp;
  static double get fontSizeHeading => 32.sp;

  // ── Grid Columns ───────────────────────────────────────────
  static int get gridColumns {
    if (isMobile) return 2;
    if (isTablet) return 3;
    return 4;
  }

  // ── Adaptive Aspect Ratio ──────────────────────────────────
  static double get cardAspectRatio {
    if (isMobile) return 1.2;
    if (isTablet) return 1.3;
    return 1.4;
  }

  // ── Adaptive SliverGrid Delegate ───────────────────────────
  static SliverGridDelegate get adaptiveGridDelegate {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: gridColumns,
      crossAxisSpacing: paddingMedium,
      mainAxisSpacing: paddingMedium,
      childAspectRatio: cardAspectRatio,
    );
  }
}

/// Extension for easier responsive access
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveDesign.isMobile;
  bool get isTablet => ResponsiveDesign.isTablet;
  bool get isDesktop => ResponsiveDesign.isDesktop;

  double get padding => ResponsiveDesign.paddingMedium;
  double get spacing => ResponsiveDesign.spacingMedium;
  double get buttonHeight => ResponsiveDesign.buttonHeight;
}
