/// UI design-system constants.
///
/// Spacing, border radius, breakpoints, animation durations, etc.
library;

abstract class UiConstants {
  // ── Spacing ──────────────────────────────────────────────
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing64 = 64;

  // ── Border Radius ────────────────────────────────────────
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;
  static const double radiusRound = 999;

  // ── Icon Sizes ───────────────────────────────────────────
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 48;

  // ── Avatar Sizes ─────────────────────────────────────────
  static const double avatarSmall = 32;
  static const double avatarMedium = 48;
  static const double avatarLarge = 72;
  static const double avatarXLarge = 96;

  // ── Responsive Breakpoints ───────────────────────────────
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double wideBreakpoint = 1600;

  // ── Content Width ────────────────────────────────────────
  static const double maxContentWidth = 1200;
  static const double drawerWidth = 280;

  // ── Animation Durations ──────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);

  // ── Elevation ────────────────────────────────────────────
  static const double elevationLow = 1;
  static const double elevationMedium = 4;
  static const double elevationHigh = 8;

  // ── AppBar ───────────────────────────────────────────────
  static const double appBarHeight = 56;
  static const double appBarHeightLarge = 64;

  // ── Bottom Nav ───────────────────────────────────────────
  static const double bottomNavHeight = 60;

  // ── Card ─────────────────────────────────────────────────
  static const double cardPadding = 16;
  static const double cardElevation = 2;
}
