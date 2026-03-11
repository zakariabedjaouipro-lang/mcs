/// Premium Card Component
/// Elegant card with glassmorphism and smooth transitions
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class PremiumCard extends StatefulWidget {
  const PremiumCard({
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 16,
    this.useGlass = false,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsets padding;
  final double borderRadius;
  final bool useGlass;

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _colorAnimation = ColorTween(
      begin: PremiumColors.white,
      end: PremiumColors.almostWhite,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    if (widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(PremiumCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _animationController.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onEnter() {
    if (widget.onTap != null) {
      _animationController.forward();
      setState(() => _isHovered = true);
    }
  }

  void _onExit() {
    if (widget.onTap != null && !widget.isSelected) {
      _animationController.reverse();
      setState(() => _isHovered = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: _isHovered || widget.isSelected
                      ? PremiumColors.mediumShadow
                      : PremiumColors.softShadow,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    color: _colorAnimation.value,
                    border: Border.all(
                      color: widget.isSelected
                          ? PremiumColors.primaryBlue
                          : _isHovered
                              ? PremiumColors.primaryBlue.withValues(alpha: 0.3)
                              : PremiumColors.mediumGrey,
                      width: widget.isSelected ? 2 : 1.5,
                    ),
                  ),
                  padding: widget.padding,
                  child: widget.child,
                ),
              );
            },
          ),
        ),
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
          // Icon Container
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

          // Title
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

          // Description
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
