/// Responsive design utilities and breakpoints for MCS application.
///
/// Provides standardized breakpoints, spacing, dimensions, and responsive
/// helpers for consistent mobile, tablet, and desktop layouts.
///
/// Features:
/// - Device size classification (small phone, standard, tablet, desktop)
/// - 8dp grid-based spacing system
/// - Responsive text scales
/// - Material Design compliant dimensions
/// - Safe area handling
library;

import 'package:flutter/material.dart';

/// Device Size Breakpoints (Material Design 3)
abstract class ResponsiveBreakpoints {
  /// Small phone screen width threshold (< 400 dp)
  static const double smallPhone = 400;

  /// Mobile screen width threshold (< 600 dp) - phones
  static const double mobile = 600;

  /// Tablet screen width threshold (600-900 dp)
  static const double tablet = 900;

  /// Desktop screen width threshold (>= 900 dp)
  static const double desktop = 900;

  /// Large desktop threshold (>= 1200 dp)
  static const double largeDesktop = 1200;
}

/// Responsive Spacing System (8dp grid base)
abstract class ResponsiveSpacing {
  static const double xs = 4; // Extra small
  static const double sm = 8; // Small
  static const double md = 16; // Medium (standard mobile)
  static const double lg = 24; // Large (tablet)
  static const double xl = 32; // Extra large
  static const double xxl = 48; // 2X large
}

/// Responsive Layout Helper
extension ResponsiveLayout on BuildContext {
  /// Get current screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get current screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get device pixel ratio for high-density displays
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Check if small phone (< 400 dp)
  bool get isSmallPhone => screenWidth < ResponsiveBreakpoints.smallPhone;

  /// Check if mobile device (< 600 dp) - all phone sizes
  bool get isMobile => screenWidth < ResponsiveBreakpoints.mobile;

  /// Check if tablet (600-900 dp)
  bool get isTablet =>
      screenWidth >= ResponsiveBreakpoints.mobile &&
      screenWidth < ResponsiveBreakpoints.tablet;

  /// Check if desktop (>= 900 dp)
  bool get isDesktop => screenWidth >= ResponsiveBreakpoints.tablet;

  /// Check if large desktop (>= 1200 dp)
  bool get isLargeDesktop => screenWidth >= ResponsiveBreakpoints.largeDesktop;

  /// Check if landscape orientation
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if portrait orientation
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Get safe padding (includes system bars)
  EdgeInsets get safePadding {
    final padding = MediaQuery.of(this).padding;
    final viewInsets = MediaQuery.of(this).viewInsets;
    return padding.copyWith(
      bottom: _max(padding.bottom, viewInsets.bottom),
    );
  }

  /// Responsive horizontal padding following 8dp grid
  double get horizontalPadding {
    if (isSmallPhone) return ResponsiveSpacing.sm; // 8dp
    if (isMobile) return ResponsiveSpacing.md; // 16dp
    if (isTablet) return ResponsiveSpacing.lg; // 24dp
    return ResponsiveSpacing.xl; // 32dp for desktop
  }

  /// Responsive vertical padding following 8dp grid
  double get verticalPadding {
    if (isMobile) return ResponsiveSpacing.md; // 16dp
    if (isTablet) return ResponsiveSpacing.lg; // 24dp
    return ResponsiveSpacing.xl; // 32dp for desktop
  }

  /// Button height (minimum 48dp per Material Design)
  double get buttonHeight {
    if (isMobile) return 48; // Minimum tap target
    if (isTablet) return 52;
    return 56;
  }

  /// Text field height (minimum 48dp)
  double get textFieldHeight {
    if (isMobile) return 48;
    if (isTablet) return 52;
    return 56;
  }

  /// Form field spacing
  double get formFieldSpacing {
    if (isMobile) return ResponsiveSpacing.sm; // 8dp
    if (isTablet) return ResponsiveSpacing.md; // 16dp
    return ResponsiveSpacing.lg; // 24dp
  }

  /// Responsive grid columns for layouts
  /// Mobile: 2, Tablet: 3, Desktop: 4
  int get gridColumns {
    if (isMobile) return 2;
    if (isTablet) return 3;
    return 4;
  }

  /// Grid spacing between items
  double get gridSpacing {
    if (isMobile) return ResponsiveSpacing.sm; // 8dp
    if (isTablet) return ResponsiveSpacing.md; // 16dp
    return ResponsiveSpacing.lg; // 24dp
  }

  /// Card padding (consistent with screen padding)
  double get cardPadding => horizontalPadding;

  /// Border radius responsive to screen size
  double get borderRadius {
    if (isMobile) return 8;
    if (isTablet) return 12;
    return 16;
  }

  /// Icon size - standard
  double get iconSize => isSmallPhone ? 20 : 24;

  /// Icon size - large
  double get largeIconSize => isSmallPhone ? 32 : 40;

  /// Max width for content (prevents stretching on huge screens)
  double get maxContentWidth {
    if (screenWidth < ResponsiveBreakpoints.tablet) return screenWidth;
    return 900; // Center content on very large screens
  }

  /// Responsive font scale factor
  double get fontScale {
    if (isSmallPhone) return 0.9;
    if (isMobile) return 1;
    if (isTablet) return 1.1;
    return 1.2;
  }

  /// Responsive heading 1 font size
  double get heading1Size {
    if (isSmallPhone) return 24;
    if (isMobile) return 28;
    if (isTablet) return 32;
    return 36;
  }

  /// Responsive heading 2 font size
  double get heading2Size {
    if (isSmallPhone) return 20;
    if (isMobile) return 24;
    if (isTablet) return 28;
    return 32;
  }

  /// Responsive heading 3 font size
  double get heading3Size {
    if (isSmallPhone) return 18;
    if (isMobile) return 20;
    if (isTablet) return 24;
    return 28;
  }

  /// Responsive body large font size
  double get bodyLargeSize {
    if (isSmallPhone) return 14;
    if (isMobile) return 16;
    if (isTablet) return 18;
    return 20;
  }

  /// Responsive body medium font size
  double get bodyMediumSize {
    if (isSmallPhone) return 12;
    if (isMobile) return 14;
    if (isTablet) return 16;
    return 18;
  }

  /// Responsive body small font size
  double get bodySmallSize {
    if (isSmallPhone) return 11;
    if (isMobile) return 12;
    if (isTablet) return 14;
    return 16;
  }

  /// Responsive button text font size
  double get buttonTextSize {
    if (isSmallPhone) return 13;
    if (isMobile) return 14;
    if (isTablet) return 16;
    return 18;
  }
}

/// Responsive widget that adapts layout based on screen size
class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    required this.mobile,
    required this.tablet,
    required this.desktop,
    super.key,
  });

  /// Widget for mobile layout (< 600 dp)
  final Widget Function(BuildContext context) mobile;

  /// Widget for tablet layout (600-900 dp)
  final Widget Function(BuildContext context) tablet;

  /// Widget for desktop layout (>= 900 dp)
  final Widget Function(BuildContext context) desktop;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return mobile(context);
    } else if (context.isTablet) {
      return tablet(context);
    } else {
      return desktop(context);
    }
  }
}

/// Helper class for responsive grid layouts
class ResponsiveGridHelper {
  ResponsiveGridHelper(this.context);

  final BuildContext context;

  /// Get column count for action grids
  int get actionGridColumns => context.gridColumns;

  /// Get spacing for grid items
  double get gridSpacing => context.gridSpacing;

  /// Get aspect ratio for grid items
  double get gridItemAspectRatio {
    if (context.isMobile) return 1.3;
    if (context.isTablet) return 1.5;
    return 1.6;
  }
}

/// Helper to calculate max value
double _max(double a, double b) => a > b ? a : b;
