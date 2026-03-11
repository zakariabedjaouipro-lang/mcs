/// Premium Button Component
/// High-end button with gradient, animations, and micro-interactions
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class PremiumButton extends StatefulWidget {
  const PremiumButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = PremiumButtonSize.large,
    this.variant = PremiumButtonVariant.primary,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final PremiumButtonSize size;
  final PremiumButtonVariant variant;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

enum PremiumButtonSize { small, medium, large }

enum PremiumButtonVariant { primary, secondary, danger, success }

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.isFullWidth ? double.infinity : null,
            height: _getButtonHeight(),
            decoration: BoxDecoration(
              gradient: _getGradient(),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isHovered
                  ? PremiumColors.mediumShadow
                  : PremiumColors.softShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isDisabled ? null : widget.onPressed,
                splashColor: Colors.white.withValues(alpha: 0.2),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getTextColor(),
                            ),
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: _getTextColor(),
                                size: _getIconSize(),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.label,
                              style: _getTextStyle().copyWith(
                                color: _getTextColor(),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Gradient _getGradient() {
    if (widget.onPressed == null || widget.isLoading) {
      return LinearGradient(
        colors: [
          PremiumColors.mediumGrey.withValues(alpha: 0.5),
          PremiumColors.mediumGrey.withValues(alpha: 0.3),
        ],
      );
    }

    switch (widget.variant) {
      case PremiumButtonVariant.primary:
        return _isHovered
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0052CC),
                  Color(0xFF0066FF),
                ],
              )
            : PremiumColors.primaryGradient;
      case PremiumButtonVariant.secondary:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PremiumColors.almostWhite,
            PremiumColors.lightGrey,
          ],
        );
      case PremiumButtonVariant.danger:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            if (_isHovered) const Color(0xFFDC2626) else PremiumColors.errorRed,
            if (_isHovered)
              const Color(0xFFEF4444)
            else
              const Color(0xFFF87171),
          ],
        );
      case PremiumButtonVariant.success:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            if (_isHovered)
              const Color(0xFF059669)
            else
              PremiumColors.successGreen,
            if (_isHovered)
              const Color(0xFF10B981)
            else
              const Color(0xFF34D399),
          ],
        );
    }
  }

  Color _getTextColor() {
    if (widget.variant == PremiumButtonVariant.secondary) {
      return PremiumColors.darkText;
    }
    return Colors.white;
  }

  TextStyle _getTextStyle() {
    return switch (widget.size) {
      PremiumButtonSize.small => PremiumTextStyles.labelMedium,
      PremiumButtonSize.medium => PremiumTextStyles.bodyMedium,
      PremiumButtonSize.large => PremiumTextStyles.bodyLarge,
    };
  }

  double _getButtonHeight() {
    return switch (widget.size) {
      PremiumButtonSize.small => 36,
      PremiumButtonSize.medium => 44,
      PremiumButtonSize.large => 52,
    };
  }

  double _getIconSize() {
    return switch (widget.size) {
      PremiumButtonSize.small => 16,
      PremiumButtonSize.medium => 18,
      PremiumButtonSize.large => 20,
    };
  }
}
