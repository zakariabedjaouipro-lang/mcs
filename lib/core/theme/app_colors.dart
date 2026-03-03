/// Application colour palette.
///
/// All colours are defined here so they can be referenced
/// consistently across light and dark themes.
library;

import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Primary ──────────────────────────────────────────────
  static const Color primary = Color(0xFF1565C0); // Blue 800
  static const Color primaryLight = Color(0xFF42A5F5); // Blue 400
  static const Color primaryDark = Color(0xFF0D47A1); // Blue 900
  static const Color onPrimary = Colors.white;

  // ── Secondary ────────────────────────────────────────────
  static const Color secondary = Color(0xFF00897B); // Teal 600
  static const Color secondaryLight = Color(0xFF4DB6AC); // Teal 300
  static const Color secondaryDark = Color(0xFF00695C); // Teal 800
  static const Color onSecondary = Colors.white;

  // ── Accent ───────────────────────────────────────────────
  static const Color accent = Color(0xFFFFA726); // Orange 400

  // ── Grey ──────────────────────────────────────────────────
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ── Semantic ─────────────────────────────────────────────
  static const Color success = Color(0xFF43A047); // Green 600
  static const Color warning = Color(0xFFFFA000); // Amber 700
  static const Color error = Color(0xFFE53935); // Red 600
  static const Color info = Color(0xFF1E88E5); // Blue 600

  static const Color onSuccess = Colors.white;
  static const Color onWarning = Colors.black;
  static const Color onError = Colors.white;
  static const Color onInfo = Colors.white;

  // ── Light Theme ──────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textHintLight = Color(0xFFBDBDBD);
  static const Color disabledLight = Color(0xFFBDBDBD);
  static const Color iconLight = Color(0xFF616161);
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);

  // ── Dark Theme ───────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color dividerDark = Color(0xFF424242);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color textHintDark = Color(0xFF616161);
  static const Color disabledDark = Color(0xFF616161);
  static const Color iconDark = Color(0xFFBDBDBD);
  static const Color shimmerBaseDark = Color(0xFF2C2C2C);
  static const Color shimmerHighlightDark = Color(0xFF3E3E3E);

  // ── Status Colours for Appointments ──────────────────────
  static const Color statusPending = Color(0xFFFFA726);
  static const Color statusConfirmed = Color(0xFF42A5F5);
  static const Color statusCompleted = Color(0xFF66BB6A);
  static const Color statusCancelled = Color(0xFFEF5350);
  static const Color statusNoShow = Color(0xFF78909C);
}
