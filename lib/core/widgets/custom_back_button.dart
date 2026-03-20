/// Custom Back Button - زر العودة الموحد
/// Unified back button for all screens with RTL support
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';

/// زر العودة الموحد مع دعم الإيماءات
class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final String? tooltip;
  final bool enableSwipeBack;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.size = 24,
    this.tooltip,
    this.enableSwipeBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final actualColor = color ?? PremiumColors.primaryBlue;

    return Tooltip(
      message: tooltip ?? (isArabic ? 'عودة' : 'Back'),
      child: IconButton(
        icon: Icon(
          isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          size: size,
          color: actualColor,
        ),
        onPressed: onPressed ??
            () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
        highlightColor: actualColor.withValues(alpha: 0.1),
        splashColor: actualColor.withValues(alpha: 0.2),
      ),
    );
  }
}

/// زر العودة مع أيقونة مخصصة
class CustomBackButtonWithIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? color;
  final double size;
  final String? tooltip;

  const CustomBackButtonWithIcon({
    super.key,
    this.onPressed,
    required this.icon,
    this.color,
    this.size = 24,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? PremiumColors.primaryBlue;

    return IconButton(
      icon: Icon(icon, size: size, color: actualColor),
      tooltip: tooltip,
      onPressed: onPressed ??
          () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
    );
  }
}
