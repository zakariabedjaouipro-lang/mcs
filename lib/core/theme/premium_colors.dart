/// Premium color palette for SaaS medical platform
/// Inspired by Stripe, Notion, and Linear
library;

import 'package:flutter/material.dart';

class PremiumColors {
  // ── Primary Gradients ───────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0066FF),
      Color(0xFF0052CC),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00D4FF),
      Color(0xFF0099FF),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8FAFC),
    ],
  );

  // ── Base Colors ────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF0066FF);
  static const Color primaryDeep = Color(0xFF0052CC);
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);

// ── Status Aliases (for compatibility) ───────────────────────
  static const Color green = successGreen;
  static const Color orange = warningOrange;
  static const Color red = errorRed;
  static const Color blue = primaryBlue;

  // ── Neutral Colors ─────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color almostWhite = Color(0xFFFAFBFC);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color mediumGrey = Color(0xFFE5E7EB);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color darkText = Color(0xFF111827);
  static const Color lightText = Color(0xFF9CA3AF);

  // ── Dark Mode ──────────────────────────────────────────────
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // ── Glassmorphism ──────────────────────────────────────────
  static Color glassLight = Colors.white.withValues(alpha: 0.8);
  static Color glassDark = Colors.white.withValues(alpha: 0.1);

  // ── Shadows ────────────────────────────────────────────────
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
