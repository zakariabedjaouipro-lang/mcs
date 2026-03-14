/// ═══════════════════════════════════════════════════════════════════════════
/// RESPONSIVE CONTAINER | حاوية متجاوبة
/// ═══════════════════════════════════════════════════════════════════════════
///
/// A responsive container that adapts to screen size changes

library;

import 'package:flutter/material.dart';

/// Extension to build responsive values based on screen size
extension ResponsiveExtension on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if device is in portrait mode
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Check if device is in landscape mode
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if screen is small (< 600 width)
  bool get isSmallScreen => screenWidth < 600;

  /// Check if screen is medium (600-900 width)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 900;

  /// Check if screen is large (>= 900 width)
  bool get isLargeScreen => screenWidth >= 900;

  /// Get responsive padding based on screen size
  EdgeInsets get responsivePadding {
    if (isSmallScreen) {
      return const EdgeInsets.all(12);
    } else if (isMediumScreen) {
      return const EdgeInsets.all(16);
    } else {
      return const EdgeInsets.all(20);
    }
  }

  /// Get responsive text scale
  double get textScale {
    if (isSmallScreen) return 1.0;
    if (isMediumScreen) return 1.1;
    return 1.15;
  }
}

/// Responsive container widget
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.maxWidth,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: margin ??
            EdgeInsets.symmetric(horizontal: context.isSmallScreen ? 12 : 16),
        padding: padding ?? EdgeInsets.all(context.isSmallScreen ? 12 : 16),
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}

/// Responsive padding wrapper
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    super.key,
    required this.child,
    this.all,
    this.horizontal,
    this.vertical,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  final Widget child;
  final double? all;
  final double? horizontal;
  final double? vertical;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0,
      bottom: bottom ?? vertical ?? all ?? 0,
      left: left ?? horizontal ?? all ?? 0,
      right: right ?? horizontal ?? all ?? 0,
    );

    return Padding(
      padding: padding * context.textScale,
      child: child,
    );
  }
}

/// Responsive gap spacer
class ResponsiveGap extends StatelessWidget {
  const ResponsiveGap({
    super.key,
    this.horizontal = false,
    this.size = 16,
  });

  final bool horizontal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scaledSize = size * context.textScale;

    if (horizontal) {
      return SizedBox(width: scaledSize);
    }
    return SizedBox(height: scaledSize);
  }
}
