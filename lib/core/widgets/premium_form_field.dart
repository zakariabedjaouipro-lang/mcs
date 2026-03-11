/// Premium Form Field Component
/// Beautiful, animated input field with micro-interactions
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class PremiumFormField extends StatefulWidget {
  const PremiumFormField({
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    super.key,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final int maxLines;
  final int? minLines;

  @override
  State<PremiumFormField> createState() => _PremiumFormFieldState();
}

class _PremiumFormFieldState extends State<PremiumFormField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<Color?> _borderColorAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: PremiumColors.mediumGrey,
      end: PremiumColors.primaryBlue,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            widget.label,
            style: PremiumTextStyles.labelLarge.copyWith(
              color: _isFocused
                  ? PremiumColors.primaryBlue
                  : PremiumColors.darkText,
            ),
          ),
        ),

        // Input Field
        AnimatedBuilder(
          animation: _borderColorAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color:
                              PremiumColors.primaryBlue.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : PremiumColors.softShadow,
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                onChanged: widget.onChanged,
                enabled: widget.enabled,
                maxLines: widget.obscureText ? 1 : widget.maxLines,
                minLines: widget.minLines,
                validator: (value) {
                  final error = widget.validator?.call(value);
                  setState(() {
                    _isFocused = error != null;
                  });
                  return error;
                },
                style: PremiumTextStyles.bodyRegular,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: PremiumTextStyles.bodySmall.copyWith(
                    color: PremiumColors.lightText,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: widget.prefixIcon,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: widget.suffixIcon,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
