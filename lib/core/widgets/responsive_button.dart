/// Responsive Button - adapts to all screen sizes.
///
/// Features:
/// - Standard 48px height (Material Design 3)
/// - Full width by default
/// - Loading state support
/// - Consistent sizing across devices
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/constants/responsive_constants.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

enum ResponsiveButtonSize { small, medium, large }

enum ResponsiveButtonStyle { primary, secondary, outline, text }

class ResponsiveButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Callback when button is pressed.
  final VoidCallback? onPressed;

  /// Whether button is in loading state.
  final bool isLoading;

  /// Size variant of the button.
  final ResponsiveButtonSize size;

  /// Style variant of the button.
  final ResponsiveButtonStyle style;

  /// Leading icon.
  final IconData? leadingIcon;

  /// Trailing icon.
  final IconData? trailingIcon;

  /// Custom width (optional, defaults to full width).
  final double? width;

  /// Whether button should be full width.
  final bool isFullWidth;

  const ResponsiveButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.size = ResponsiveButtonSize.medium,
    this.style = ResponsiveButtonStyle.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.isFullWidth = true,
  });

  double _getButtonHeight() {
    return switch (size) {
      ResponsiveButtonSize.small => ResponsiveConstants.buttonHeightSmall,
      ResponsiveButtonSize.medium => ResponsiveConstants.buttonHeight,
      ResponsiveButtonSize.large => ResponsiveConstants.buttonHeightLarge,
    };
  }

  @override
  Widget build(BuildContext context) {
    const loadingSize = 20.0;

    final buttonContent = isLoading
        ? SizedBox(
            height: loadingSize,
            width: loadingSize,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                _getButtonTextColor(context),
              ),
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: ResponsiveConstants.iconSize),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: ResponsiveConstants.iconSize),
              ],
            ],
          );

    final button = SizedBox(
      height: _getButtonHeight(),
      width: isFullWidth ? width ?? double.infinity : width,
      child: _buildButton(context, buttonContent),
    );

    return button;
  }

  Widget _buildButton(BuildContext context, Widget child) {
    return switch (style) {
      ResponsiveButtonStyle.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      ResponsiveButtonStyle.secondary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.grey[800],
          ),
          child: child,
        ),
      ResponsiveButtonStyle.outline => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      ResponsiveButtonStyle.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
    };
  }

  Color _getButtonTextColor(BuildContext context) {
    return switch (style) {
      ResponsiveButtonStyle.primary => Colors.white,
      ResponsiveButtonStyle.secondary => Colors.grey[800] ?? Colors.black,
      ResponsiveButtonStyle.outline => context.colorSchemeSafe.primary,
      ResponsiveButtonStyle.text => context.colorSchemeSafe.primary,
    };
  }
}
