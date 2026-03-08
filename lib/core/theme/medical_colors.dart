/// Medical color palette for healthcare applications.
/// Uses soft, professional colors suitable for medical/clinical environments.
library;

import 'package:flutter/material.dart';

class MedicalColors {
  MedicalColors._();

  // Primary Medical Colors
  static const Color primary = Color(0xFF0FB5D4); // Turquoise
  static const Color primaryDark = Color(0xFF0A8FA3);
  static const Color primaryLight = Color(0xFFE0F7FA);

  // Secondary Medical Colors
  static const Color secondary = Color(0xFF26A69A); // Soft Green / Teal
  static const Color secondaryLight = Color(0xFFB2DFDB);

  // Accent Colors
  static const Color accent = Color(0xFF4DD0E1); // Cyan Accent
  static const Color success = Color(0xFF4CAF50); // Medical Green
  static const Color warning = Color(0xFFFFC107); // Caution Yellow
  static const Color danger = Color(0xFFE53935); // Alert Red
  static const Color error = Color(0xFFD32F2F); // Error Red

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF9E9E9E);
  static const Color charcoal = Color(0xFF424242);
  static const Color black = Colors.black;

  // Medical Card Colors
  static const Color cardBackground = Color(0xFFFAFAFA);
  static const Color cardBorder = Color(0xFFE8E8E8);

  // Background Gradients
  static const LinearGradient medicalGradient = LinearGradient(
    colors: [Color(0xFF0FB5D4), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightGradient = LinearGradient(
    colors: [Color(0xFFE0F7FA), Color(0xFFB2DFDB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Opacity helpers
  static Color withOpacity(Color color, double opacity) =>
      color.withValues(alpha: opacity);
}
