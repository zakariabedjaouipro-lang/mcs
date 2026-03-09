/// Multi-variant reusable button widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mcs/core/constants/ui_constants.dart';

enum ButtonVariant { primary, secondary, outline, text, icon }

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onPressed,
    super.key,
    this.label,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.isExpanded = false,
    this.height = 48,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String? label;
  final IconData? icon;
  final ButtonVariant variant;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isExpanded;
  final double height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  bool get _enabled => !isLoading && !isDisabled && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final child = _buildChild(context);
    final button = SizedBox(
      height: height.h,
      width: isExpanded ? double.infinity : null,
      child: _buildButton(context, child),
    );
    return button;
  }

  Widget _buildButton(BuildContext context, Widget child) {
    final radius = borderRadius ?? UiConstants.radiusMedium;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );

    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: _enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: shape,
            padding: padding,
          ),
          child: child,
        );
      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: _enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.secondary,
            foregroundColor:
                foregroundColor ?? Theme.of(context).colorScheme.onSecondary,
            shape: shape,
            padding: padding,
          ),
          child: child,
        );
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: _enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor:
                foregroundColor ?? Theme.of(context).colorScheme.primary,
            shape: shape,
            padding: padding,
          ),
          child: child,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: _enabled ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor:
                foregroundColor ?? Theme.of(context).colorScheme.primary,
            padding: padding,
          ),
          child: child,
        );
      case ButtonVariant.icon:
        return IconButton(
          onPressed: _enabled ? onPressed : null,
          icon: child,
          color: foregroundColor ?? Theme.of(context).colorScheme.primary,
        );
    }
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 20.w,
        height: 20.h,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (variant == ButtonVariant.icon) {
      return Icon(icon);
    }

    if (icon != null && label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp),
          SizedBox(width: 8.w),
          Text(label!, style: textStyle),
        ],
      );
    }

    if (icon != null) return Icon(icon, size: 18.sp);
    return Text(label ?? '', style: textStyle);
  }
}
