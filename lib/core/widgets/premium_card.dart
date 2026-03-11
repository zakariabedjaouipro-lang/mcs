/// Premium Card Component
/// Elegant card with glassmorphism and smooth transitions
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class PremiumCard extends StatelessWidget {

  const PremiumCard({
    required this.child, super.key,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.boxShadow,
    this.gradient,
    this.onTap,
    this.isSelected = false,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: boxShadow ?? PremiumColors.softShadow,
          gradient: gradient ?? PremiumColors.cardGradient,
          border: isSelected
              ? Border.all(
                  color: PremiumColors.primaryBlue,
                  width: 2,
                )
              : null,
        ),
        child: child,
      ),
    );
  }
}

/// Premium Role Card for registration
class PremiumRoleCard extends StatelessWidget {
  const PremiumRoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? PremiumColors.primaryGradient
                  : const LinearGradient(
                      colors: [
                        PremiumColors.lightGrey,
                        PremiumColors.mediumGrey,
                      ],
                    ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : PremiumColors.darkText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: PremiumTextStyles.headingSmall.copyWith(
              color: isSelected
                  ? PremiumColors.primaryBlue
                  : PremiumColors.darkText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: PremiumTextStyles.bodySmall.copyWith(
              color: PremiumColors.lightText,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          if (isSelected) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: PremiumColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 14,
                    color: PremiumColors.primaryBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Selected',
                    style: PremiumTextStyles.labelSmall.copyWith(
                      color: PremiumColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
