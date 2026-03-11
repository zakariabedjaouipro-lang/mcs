/// AppButton - Standard button with premium styling
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class AppButton extends StatelessWidget {

  const AppButton({
    required this.label, required this.onPressed, super.key,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = AppButtonSize.medium,
    this.variant = AppButtonVariant.primary,
    this.width,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonSize size;
  final AppButtonVariant variant;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: _getButtonHeight(),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getTextColor(),
          disabledBackgroundColor: PremiumColors.mediumGrey,
          disabledForegroundColor: PremiumColors.lightText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: _getIconSize()),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: _getTextStyle(),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return PremiumColors.primaryBlue;
      case AppButtonVariant.secondary:
        return PremiumColors.almostWhite;
      case AppButtonVariant.tertiary:
        return Colors.transparent;
      case AppButtonVariant.danger:
        return PremiumColors.errorRed;
      case AppButtonVariant.success:
        return PremiumColors.successGreen;
    }
  }

  Color _getTextColor() {
    if (variant == AppButtonVariant.secondary || variant == AppButtonVariant.tertiary) {
      return PremiumColors.darkText;
    }
    return Colors.white;
  }

  TextStyle _getTextStyle() {
    return switch (size) {
      AppButtonSize.small => PremiumTextStyles.labelMedium,
      AppButtonSize.medium => PremiumTextStyles.bodyMedium,
      AppButtonSize.large => PremiumTextStyles.bodyLarge,
    };
  }

  double _getButtonHeight() {
    return switch (size) {
      AppButtonSize.small => 36,
      AppButtonSize.medium => 44,
      AppButtonSize.large => 52,
    };
  }

  double _getHorizontalPadding() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 24;
      case AppButtonSize.large:
        return 32;
    }
  }

  double _getIconSize() {
    return switch (size) {
      AppButtonSize.small => 16,
      AppButtonSize.medium => 18,
      AppButtonSize.large => 20,
    };
  }
}

enum AppButtonSize { small, medium, large }

enum AppButtonVariant { primary, secondary, tertiary, danger, success }