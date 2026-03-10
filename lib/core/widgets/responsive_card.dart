/// Responsive Card - adapts padding and styling to screen size.
///
/// Features:
/// - Adaptive padding based on device
/// - Consistent elevation
/// - Optional tap callback
/// - Dark mode support
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/extensions/context_extensions.dart';

class ResponsiveCard extends StatelessWidget {
  const ResponsiveCard({
    required this.child,
    super.key,
    this.onTap,
    this.elevation = 2,
    this.borderRadius = 12,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.adaptivePadding = true,
  });

  /// Child widget inside the card.
  final Widget child;

  /// Callback when card is tapped.
  final VoidCallback? onTap;

  /// Card elevation (shadow depth).
  final double elevation;

  /// Border radius of the card.
  final double borderRadius;

  /// Padding inside the card.
  final EdgeInsets? padding;

  /// Margin around the card.
  final EdgeInsets? margin;

  /// Custom background color.
  final Color? backgroundColor;

  /// Whether card should adapt padding based on screen size.
  final bool adaptivePadding;

  @override
  Widget build(BuildContext context) {
    // Use custom padding or adaptive padding
    final cardPadding = padding ??
        (adaptivePadding
            ? EdgeInsets.all(context.adaptiveCardPadding)
            : const EdgeInsets.all(16));

    final cardMargin = margin ?? EdgeInsets.zero;

    return Card(
      margin: cardMargin,
      elevation: elevation,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: cardPadding,
          child: child,
        ),
      ),
    );
  }
}
