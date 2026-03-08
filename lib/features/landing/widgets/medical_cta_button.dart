/// Professional Medical CTA Button
/// Used for primary actions like Login, Register, Get Started
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';

class MedicalCTAButton extends StatefulWidget {
  const MedicalCTAButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
    this.isPrimary = true,
    this.isSmall = false,
    this.icon,
  });
  final String label;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool isPrimary;
  final bool isSmall;
  final IconData? icon;

  @override
  State<MedicalCTAButton> createState() => _MedicalCTAButtonState();
}

class _MedicalCTAButtonState extends State<MedicalCTAButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => _animationController.forward(),
      onExit: (_) => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_animationController.value * 0.05),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.isPrimary
                        ? MedicalColors.primary.withValues(
                            alpha: 0.2 + (_animationController.value * 0.2),
                          )
                        : Colors.transparent,
                    blurRadius: 8 + (_animationController.value * 8),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: widget.onPressed,
                style: widget.style ??
                    (widget.isPrimary
                        ? ElevatedButton.styleFrom(
                            backgroundColor: MedicalColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.isSmall ? 16 : 32,
                              vertical: widget.isSmall ? 10 : 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )
                        : OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: MedicalColors.primary,
                              width: 2,
                            ),
                            foregroundColor: MedicalColors.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.isSmall ? 16 : 32,
                              vertical: widget.isSmall ? 10 : 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: TextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: widget.isSmall ? 12 : 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
