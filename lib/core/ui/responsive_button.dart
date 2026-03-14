/// ═══════════════════════════════════════════════════════════════════════════
/// RESPONSIVE BUTTON | أزرار متجاوبة
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Button widgets with adaptive sizing based on screen size

library;

import 'package:flutter/material.dart';
import 'package:mcs/core/ui/responsive_container.dart';
import 'package:mcs/core/ui/responsive_text.dart';
import 'package:mcs/core/ui/spacing.dart';

/// Responsive elevated button with adaptive sizing
class ResponsiveElevatedButton extends StatelessWidget {
  const ResponsiveElevatedButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.fullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final bool fullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: context.isSmallScreen ? AppSpacing.xl : AppSpacing.xxl,
      vertical: context.isSmallScreen ? AppSpacing.md : AppSpacing.lg,
    );

    final fontSize = context.isSmallScreen
        ? 14
        : context.isMediumScreen
            ? 15
            : 16;
    final minHeight = context.isSmallScreen ? 44.0 : 48.0;

    Widget child;
    if (isLoading) {
      child = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? Colors.white,
          ),
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.isSmallScreen ? 20 : 24),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize * context.textScale,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      child = Text(
        label,
        style: TextStyle(
          fontSize: fontSize * context.textScale,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: minHeight,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Responsive outlined button with adaptive sizing
class ResponsiveOutlinedButton extends StatelessWidget {
  const ResponsiveOutlinedButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.fullWidth = false,
    this.borderColor,
    this.textColor,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final bool fullWidth;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: context.isSmallScreen ? AppSpacing.xl : AppSpacing.xxl,
      vertical: context.isSmallScreen ? AppSpacing.md : AppSpacing.lg,
    );

    final fontSize = context.isSmallScreen
        ? 14
        : context.isMediumScreen
            ? 15
            : 16;
    final minHeight = context.isSmallScreen ? 44.0 : 48.0;

    Widget child;
    if (isLoading) {
      child = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Theme.of(context).primaryColor,
          ),
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.isSmallScreen ? 20 : 24),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize * context.textScale,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      child = Text(
        label,
        style: TextStyle(
          fontSize: fontSize * context.textScale,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: minHeight,
      child: OutlinedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(
            color: borderColor ?? Theme.of(context).primaryColor,
          ),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Responsive text button with adaptive sizing
class ResponsiveTextButton extends StatelessWidget {
  const ResponsiveTextButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.textColor,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final fontSize = context.isSmallScreen
        ? 14
        : context.isMediumScreen
            ? 15
            : 16;

    Widget child;
    if (isLoading) {
      child = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Theme.of(context).primaryColor,
          ),
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.isSmallScreen ? 20 : 24),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize * context.textScale,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      child = Text(
        label,
        style: TextStyle(
          fontSize: fontSize * context.textScale,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return TextButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
      ),
      child: child,
    );
  }
}

/// Responsive floating action button with adaptive sizing
class ResponsiveFAB extends StatelessWidget {
  const ResponsiveFAB({
    required this.onPressed,
    required this.icon,
    super.key,
    this.label,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final Object? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final iconSize = context.isSmallScreen ? 24.0 : 28.0;

    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        heroTag: heroTag,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        icon: Icon(icon, size: iconSize),
        label: BodyMedium(label!),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      heroTag: heroTag,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: Icon(icon, size: iconSize),
    );
  }
}

/// Responsive icon button with adaptive sizing
class ResponsiveIconButton extends StatelessWidget {
  const ResponsiveIconButton({
    required this.onPressed,
    required this.icon,
    super.key,
    this.tooltip,
    this.isEnabled = true,
    this.iconColor,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final bool isEnabled;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final size = context.isSmallScreen ? 24.0 : 28.0;

    return IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
      tooltip: tooltip,
    );
  }
}

/// Responsive button with customizable appearance and adaptive sizing
class ResponsiveButton extends StatelessWidget {
  const ResponsiveButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.type = ButtonType.elevated,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.fullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final VoidCallback onPressed;
  final String label;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final bool fullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ButtonType.elevated => ResponsiveElevatedButton(
          onPressed: onPressed,
          label: label,
          icon: icon,
          isLoading: isLoading,
          isEnabled: isEnabled,
          fullWidth: fullWidth,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
      ButtonType.outlined => ResponsiveOutlinedButton(
          onPressed: onPressed,
          label: label,
          icon: icon,
          isLoading: isLoading,
          isEnabled: isEnabled,
          fullWidth: fullWidth,
          borderColor: borderColor,
          textColor: foregroundColor,
        ),
      ButtonType.text => ResponsiveTextButton(
          onPressed: onPressed,
          label: label,
          icon: icon,
          isLoading: isLoading,
          isEnabled: isEnabled,
          textColor: foregroundColor,
        ),
    };
  }
}

/// Button type enum
enum ButtonType {
  elevated,
  outlined,
  text,
}
