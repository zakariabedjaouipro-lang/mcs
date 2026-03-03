/// Responsive layout builder that renders different widgets
/// depending on the current screen width.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/constants/ui_constants.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    super.key,
    this.tablet,
    this.desktop,
  });

  /// Widget to show on mobile screens (< 600 dp).
  final Widget mobile;

  /// Widget to show on tablet screens (600–1199 dp).
  /// Falls back to [mobile] if not provided.
  final Widget? tablet;

  /// Widget to show on desktop screens (>= 1200 dp).
  /// Falls back to [tablet] → [mobile] if not provided.
  final Widget? desktop;

  /// Returns the current device category based on [width].
  static DeviceType deviceType(double width) {
    if (width >= UiConstants.desktopBreakpoint) return DeviceType.desktop;
    if (width >= UiConstants.mobileBreakpoint) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  /// Convenience — check device type from [BuildContext].
  static DeviceType of(BuildContext context) =>
      deviceType(MediaQuery.sizeOf(context).width);

  static bool isMobile(BuildContext context) =>
      of(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      of(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      of(context) == DeviceType.desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final type = deviceType(constraints.maxWidth);
        switch (type) {
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.mobile:
            return mobile;
        }
      },
    );
  }
}

enum DeviceType { mobile, tablet, desktop }

/// A simple wrapper that constrains content to [maxWidth] and
/// centres it — useful for wide screens.
class ContentConstraint extends StatelessWidget {
  const ContentConstraint({
    required this.child,
    super.key,
    this.maxWidth = UiConstants.maxContentWidth,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}
