/// Responsive design constants for adaptive layouts.
/// Provides screen-size-aware sizing, spacing, and breakpoint utilities.
library;

abstract class ResponsiveConstants {
  // ── Responsive Breakpoints ───────────────────────────────────────
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Returns adaptive horizontal padding based on device width.
  ///
  /// - Mobile (< 600): 12 px
  /// - Tablet (< 1024): 16 px
  /// - Desktop (≥ 1024): 20 px
  static double adaptivePaddingHorizontal(double width) {
    if (width < mobileBreakpoint) return 12;
    if (width < tabletBreakpoint) return 16;
    return 20;
  }

  /// Returns adaptive vertical padding based on device width.
  ///
  /// - Mobile: 12 px
  /// - Tablet: 16 px
  /// - Desktop: 20 px
  static double adaptivePaddingVertical(double width) {
    if (width < mobileBreakpoint) return 12;
    if (width < tabletBreakpoint) return 16;
    return 20;
  }

  /// Returns adaptive card padding based on device width.
  ///
  /// - Mobile: 12 px
  /// - Tablet: 16 px
  /// - Desktop: 20 px
  static double adaptiveCardPadding(double width) {
    if (width < mobileBreakpoint) return 12;
    if (width < tabletBreakpoint) return 16;
    return 20;
  }

  /// Returns grid column count based on device width.
  ///
  /// - Mobile (< 600): 2 columns
  /// - Tablet (< 1024): 3 columns
  /// - Desktop (≥ 1024): 4 columns
  static int gridColumnsCount(double width) {
    if (width < mobileBreakpoint) return 2;
    if (width < tabletBreakpoint) return 3;
    return 4;
  }

  /// Returns spacing between grid items based on device width.
  ///
  /// - Mobile: 12 px
  /// - Tablet: 16 px
  /// - Desktop: 20 px
  static double gridSpacing(double width) {
    if (width < mobileBreakpoint) return 12;
    if (width < tabletBreakpoint) return 16;
    return 20;
  }

  // ── Adaptive Font Sizes ──────────────────────────────────────────
  /// Returns font scale factor based on device type.
  ///
  /// - Mobile: 1.0x (no scaling)
  /// - Tablet: 1.1x
  /// - Desktop: 1.2x
  static double fontScaleFactor(double width) {
    if (width < mobileBreakpoint) return 1;
    if (width < tabletBreakpoint) return 1.1;
    return 1.2;
  }

  // ── Standard Sizing ──────────────────────────────────────────────
  /// Standard button height following Material Design 3 guidelines.
  static const double buttonHeight = 48;
  static const double buttonHeightSmall = 40;
  static const double buttonHeightLarge = 56;

  /// Standard input field height.
  static const double inputHeight = 48;
  static const double inputHeightLarge = 56;

  /// Standard icon size.
  static const double iconSize = 24;
  static const double iconSizeSmall = 20;
  static const double iconSizeLarge = 32;

  // Icon size aliases for convenience
  static const double iconSmall = iconSizeSmall; // 20
  static const double iconMedium = iconSize; // 24
  static const double iconLarge = iconSizeLarge; // 32

  // ── Touch Target Size ────────────────────────────────────────────
  /// Minimum touch target size: 48x48 (Material Design guideline).
  static const double minTouchSize = 48;

  // ── Max Content Width ────────────────────────────────────────────
  /// Maximum content width for large screens to prevent stretching.
  static const double maxContentWidth = 1200;

  // ── Spacing Scale ────────────────────────────────────────────────
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  // ── Border Radius ────────────────────────────────────────────────
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;
}
