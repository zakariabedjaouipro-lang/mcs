/// ═══════════════════════════════════════════════════════════════════════════
/// SPACING SYSTEM | نظام المسافات
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Unified spacing constants for consistent layout across the app
/// ثوابت موحدة للمسافات لضمان تناسق التخطيط في التطبيق

library;

/// Spacing constants following Material Design guidelines
class AppSpacing {
  const AppSpacing._();

  /// No spacing
  static const double none = 0;

  /// Extra small spacing (4px)
  static const double xs = 4;

  /// Small spacing (8px)
  static const double sm = 8;

  /// Medium spacing (12px)
  static const double md = 12;

  /// Large spacing (16px)
  static const double lg = 16;

  /// Extra large spacing (20px)
  static const double xl = 20;

  /// 2x Large spacing (24px)
  static const double xxl = 24;

  /// 3x Large spacing (32px)
  static const double xxxl = 32;

  /// Extra extra extra large spacing (40px)
  static const double huge = 40;

  /// Very large spacing (48px)
  static const double massive = 48;
}

/// Border radius constants
class AppRadius {
  const AppRadius._();

  /// No radius (sharp corners)
  static const double none = 0;

  /// Small radius (4px)
  static const double sm = 4;

  /// Medium radius (8px)
  static const double md = 8;

  /// Large radius (12px)
  static const double lg = 12;

  /// Extra large radius (16px)
  static const double xl = 16;

  /// Full circle radius (used as circular/pill buttons)
  static const double full = 9999;
}

/// Standard padding values
class AppPadding {
  const AppPadding._();

  /// Screen padding (safe area margin from edges)
  static const double screen = 16;

  /// Card padding (internal card spacing)
  static const double card = 16;

  /// Button padding (horizontal)
  static const double buttonH = 24;

  /// Button padding (vertical)
  static const double buttonV = 12;

  /// List item padding
  static const double listItem = 16;
}
