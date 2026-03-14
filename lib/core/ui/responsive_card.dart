/// ═══════════════════════════════════════════════════════════════════════════
/// RESPONSIVE CARD | بطاقات متجاوبة
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Card widgets with adaptive padding and sizing based on screen size

library;

import 'package:flutter/material.dart';

import 'package:mcs/core/ui/responsive_container.dart';
import 'package:mcs/core/ui/spacing.dart';

/// Responsive card with adaptive padding and elevation
class ResponsiveCard extends StatelessWidget {
  const ResponsiveCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation = 1,
    this.borderRadius,
    this.border,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double elevation;
  final BorderRadius? borderRadius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final defaultPadding = context.isSmallScreen
        ? const EdgeInsets.all(AppSpacing.lg)
        : context.isMediumScreen
            ? const EdgeInsets.all(AppSpacing.xl)
            : const EdgeInsets.all(AppSpacing.xxl);

    final defaultMargin = context.isSmallScreen
        ? const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm,)
        : context.isMediumScreen
            ? const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md,)
            : const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl, vertical: AppSpacing.lg,);

    return Container(
      margin: margin ?? defaultMargin,
      child: Card(
        elevation: elevation,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.lg),
          side: (border is BorderSide) ? border! as BorderSide : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: padding ?? defaultPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Responsive stat card for displaying metrics
class ResponsiveStatCard extends StatelessWidget {
  const ResponsiveStatCard({
    required this.value,
    required this.label,
    super.key,
    this.icon,
    this.change,
    this.changeIsPositive = true,
    this.backgroundColor,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData? icon;
  final String? change;
  final bool changeIsPositive;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isSmall = context.isSmallScreen;
    final valueFontSize = isSmall
        ? 24
        : context.isMediumScreen
            ? 28
            : 32;
    final labelFontSize = isSmall ? 12 : 13;
    final changeFontSize = isSmall ? 11 : 12;

    return ResponsiveCard(
      onTap: onTap,
      backgroundColor: backgroundColor ?? Colors.grey.shade50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and label row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: labelFontSize * context.textScale,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: isSmall ? 20 : 24,
                  color: Colors.grey,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Value
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize * context.textScale,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (change != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  changeIsPositive ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: changeIsPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  change!,
                  style: TextStyle(
                    fontSize: changeFontSize * context.textScale,
                    color: changeIsPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Responsive list card with icon and description
class ResponsiveListCard extends StatelessWidget {
  const ResponsiveListCard({
    required this.title,
    required this.icon,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.leadingBackgroundColor,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? leadingBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final isSmall = context.isSmallScreen;
    final iconSize = isSmall ? 28 : 32;
    final leadingSize = isSmall ? 40 : 48;

    return ResponsiveCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      backgroundColor: backgroundColor,
      child: ListTile(
        leading: Container(
          width: leadingSize.toDouble(),
          height: leadingSize.toDouble(),
          decoration: BoxDecoration(
            color: leadingBackgroundColor ?? Colors.blue.shade100,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(
            icon,
            size: iconSize.toDouble(),
            color: Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: (isSmall ? 14 : 16) * context.textScale,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: (isSmall ? 12 : 13) * context.textScale,
                ),
              )
            : null,
        trailing: trailing,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}

/// Responsive section card with header and content
class ResponsiveSectionCard extends StatelessWidget {
  const ResponsiveSectionCard({
    required this.title,
    required this.child,
    super.key,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.divider = true,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final titleFontSize = context.isSmallScreen ? 14 : 16;

    return ResponsiveCard(
      backgroundColor: backgroundColor,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize * context.textScale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          if (divider)
            Divider(
              height: 0,
              thickness: 0.5,
              color: Colors.grey.shade300,
            ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Responsive image card with overlay and caption
class ResponsiveImageCard extends StatelessWidget {
  const ResponsiveImageCard({
    required this.image,
    required this.title,
    super.key,
    this.subtitle,
    this.onTap,
    this.height,
    this.backgroundColor,
  });

  final ImageProvider image;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final double? height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final cardHeight = height ??
        (context.isSmallScreen
            ? 150
            : context.isMediumScreen
                ? 180
                : 200);
    final titleFontSize = context.isSmallScreen ? 14 : 16;
    final subtitleFontSize = context.isSmallScreen ? 12 : 13;

    return ResponsiveCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      backgroundColor: backgroundColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            // Background image
            Container(
              height: cardHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Overlay gradient
            Container(
              height: cardHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // Text content
            Positioned(
              bottom: AppSpacing.lg,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleFontSize * context.textScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: subtitleFontSize * context.textScale,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
