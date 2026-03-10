/// Responsive Text Field - adapts to all screen sizes.
///
/// Features:
/// - Standard 48/56px height (Material Design 3)
/// - Proper padding and spacing
/// - Label and hint support
/// - Error state handling
/// - Loading state support
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/constants/responsive_constants.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

class ResponsiveTextField extends StatelessWidget {
  /// Controller for the text field.
  final TextEditingController? controller;

  /// Label text.
  final String? label;

  /// Hint text.
  final String? hintText;

  /// Error text.
  final String? errorText;

  /// Prefix icon.
  final IconData? prefixIcon;

  /// Suffix icon.
  final IconData? suffixIcon;

  /// Callback when suffix icon is tapped.
  final VoidCallback? onSuffixIconTap;

  /// Whether field is enabled.
  final bool enabled;

  /// Whether field is in loading state.
  final bool isLoading;

  /// Input type.
  final TextInputType keyboardType;

  /// Whether to obscure text (for passwords).
  final bool obscureText;

  /// Maximum lines.
  final int maxLines;

  /// Minimum lines.
  final int minLines;

  /// Max length.
  final int? maxLength;

  /// On changed callback.
  final ValueChanged<String>? onChanged;

  /// On submitted callback.
  final VoidCallback? onSubmitted;

  /// Custom height.
  final double? height;

  /// Whether field is full width.
  final bool isFullWidth;

  const ResponsiveTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.enabled = true,
    this.isLoading = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.height,
    this.isFullWidth = true,
  });

  double _getFieldHeight() {
    if (height != null) return height!;
    if (maxLines > 1) return ResponsiveConstants.inputHeightLarge * 2;
    return ResponsiveConstants.inputHeight;
  }

  @override
  Widget build(BuildContext context) {
    final fieldHeight = _getFieldHeight();
    const loadingSize = 20.0;

    return SizedBox(
      height: fieldHeight,
      width: isFullWidth ? double.infinity : null,
      child: TextField(
        controller: controller,
        enabled: enabled && !isLoading,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        onChanged: onChanged,
        onSubmitted: (_) => onSubmitted?.call(),
        style: context.textThemeSafe.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          errorText: errorText,
          filled: true,
          isDense: false,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.adaptivePaddingHorizontal,
            vertical: 12,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: ResponsiveConstants.iconSize)
              : null,
          suffixIcon: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: loadingSize,
                    width: loadingSize,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                    ),
                  ),
                )
              : suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixIconTap,
                      child: Icon(
                        suffixIcon,
                        size: ResponsiveConstants.iconSize,
                      ),
                    )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveConstants.radiusLarge,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveConstants.radiusLarge,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveConstants.radiusLarge,
            ),
            borderSide: BorderSide(
              color: context.colorSchemeSafe.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveConstants.radiusLarge,
            ),
            borderSide: BorderSide(
              color: context.colorSchemeSafe.error,
            ),
          ),
        ),
      ),
    );
  }
}
