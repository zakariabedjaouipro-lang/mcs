/// Responsive design utilities and breakpoints for MCS application.
///
/// Provides standardized breakpoints and responsive helpers for consistent
/// mobile, tablet, and desktop layouts across the application.
library;

import 'package:flutter/material.dart';

/// Responsive breakpoints for the application.
///
/// Standard sizes:
/// - Mobile: < 600px
/// - Tablet: 600px - 900px
/// - Desktop: >= 900px
abstract class ResponsiveBreakpoints {
  /// Mobile screen width threshold (small phones)
  static const double mobile = 600;

  /// Tablet screen width threshold (tablets and large phones)
  static const double tablet = 900;

  /// Extra large screen threshold (desktop)
  static const double desktop = 1200;
}

/// Responsive layout helper for adaptive UI
extension ResponsiveLayout on BuildContext {
  /// Get the current screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get the current screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if device is in mobile range (< 600px)
  bool get isMobile => screenWidth < ResponsiveBreakpoints.mobile;

  /// Check if device is in tablet range (600px - 900px)
  bool get isTablet =>
      screenWidth >= ResponsiveBreakpoints.mobile &&
      screenWidth < ResponsiveBreakpoints.tablet;

  /// Check if device is in desktop range (>= 900px)
  bool get isDesktop => screenWidth >= ResponsiveBreakpoints.tablet;

  /// Check if device is in large desktop range (>= 1200px)
  bool get isLargeDesktop => screenWidth >= ResponsiveBreakpoints.desktop;

  /// Check if device is in landscape orientation
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if device is in portrait orientation
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Get responsive grid column count based on screen size
  ///
  /// - Mobile: 2 columns
  /// - Tablet: 3 columns
  /// - Desktop: 4 columns
  int get responsiveGridColumns {
    if (isMobile) return 2;
    if (isTablet) return 3;
    return 4;
  }

  /// Get responsive padding based on screen size
  double get responsivePadding {
    if (isMobile) return 12;
    if (isTablet) return 16;
    return 20;
  }

  /// Get responsive border radius
  double get responsiveBorderRadius {
    if (isMobile) return 8;
    if (isTablet) return 12;
    return 16;
  }

  /// Get responsive font scale factor
  double get fontScaleFactor {
    if (isMobile) return 1.0;
    if (isTablet) return 1.1;
    return 1.2;
  }
}

/// Responsive widget that adapts layout based on screen size
class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  /// Widget for mobile layout (< 600px)
  final Widget Function(BuildContext context) mobile;

  /// Widget for tablet layout (600px - 900px)
  final Widget Function(BuildContext context) tablet;

  /// Widget for desktop layout (>= 900px)
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

/// Helper class for responsive grid column count
class ResponsiveGridHelper {
  ResponsiveGridHelper(this.context);

  final BuildContext context;

  /// Get column count for action grids (quick actions, buttons)
  /// - Mobile: 2
  /// - Tablet: 3
  /// - Desktop: 4
  int get actionGridColumns {
    if (context.isMobile) return 2;
    if (context.isTablet) return 3;
    return 4;
  }

  /// Get column count for stat cards
  /// - Mobile: 2
  /// - Tablet: 3
  /// - Desktop: 4
  int get statGridColumns => context.responsiveGridColumns;

  /// Get spacing for grid items
  double get gridSpacing => context.responsivePadding;

  /// Get aspect ratio for grid items
  /// Higher on smaller screens for better visibility
  double get gridItemAspectRatio {
    if (context.isMobile) return 1.3;
    if (context.isTablet) return 1.5;
    return 1.6;
  }
}

/// Responsive spacing helper
class ResponsiveSpacing {
  ResponsiveSpacing(this.context);

  final BuildContext context;

  /// Extra small spacing (4px / 6px / 8px)
  double get xs {
    if (context.isMobile) return 4;
    if (context.isTablet) return 6;
    return 8;
  }

  /// Small spacing (8px / 12px / 16px)
  double get sm {
    if (context.isMobile) return 8;
    if (context.isTablet) return 12;
    return 16;
  }

  /// Medium spacing (12px / 16px / 20px)
  double get md {
    if (context.isMobile) return 12;
    if (context.isTablet) return 16;
    return 20;
  }

  /// Large spacing (16px / 20px / 24px)
  double get lg {
    if (context.isMobile) return 16;
    if (context.isTablet) return 20;
    return 24;
  }

  /// Extra large spacing (20px / 24px / 32px)
  double get xl {
    if (context.isMobile) return 20;
    if (context.isTablet) return 24;
    return 32;
  }
}
