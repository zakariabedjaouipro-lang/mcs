/// Premium Dropdown Field Component
/// Beautiful dropdown with smooth animations
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class PremiumDropdownField<T> extends StatefulWidget {
  const PremiumDropdownField({
    required this.label,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    this.value,
    this.hint,
    this.validator,
    this.icon,
    super.key,
  });

  final String label;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? hint;
  final FormFieldValidator<T?>? validator;
  final IconData? icon;

  @override
  State<PremiumDropdownField<T>> createState() =>
      _PremiumDropdownFieldState<T>();
}

class _PremiumDropdownFieldState<T> extends State<PremiumDropdownField<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _borderColorAnimation;
  bool _isFocused = false;
  String? _error;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showDropdown() {
    if (_overlayEntry != null) return;

    _animationController.forward();
    setState(() => _isFocused = true);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: PremiumColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: PremiumColors.elevatedShadow,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        widget.onChanged(item);
                        _closeDropdown();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: widget.itemBuilder(item),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController.reverse();
    setState(() => _isFocused = false);
  }

  @override
  Widget build(BuildContext context) {
    final error = widget.validator?.call(widget.value);
    if (error != null) {
      _error = error;
    }

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

        // Dropdown Field
        AnimatedBuilder(
          animation: _borderColorAnimation,
          builder: (context, child) {
            return CompositedTransformTarget(
              link: _layerLink,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: PremiumColors.primaryBlue
                                .withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : PremiumColors.softShadow,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _isFocused ? _closeDropdown : _showDropdown,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _isFocused
                            ? PremiumColors.almostWhite
                            : PremiumColors.white,
                        border: Border.all(
                          color: _error != null
                              ? PremiumColors.errorRed
                              : _borderColorAnimation.value ??
                                  PremiumColors.mediumGrey,
                          width: _error != null || _isFocused ? 2 : 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: _isFocused
                                  ? PremiumColors.primaryBlue
                                  : PremiumColors.darkText,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Text(
                              widget.value != null
                                  ? widget
                                      .itemBuilder(widget.value as T)
                                      .toString()
                                  : widget.hint ?? 'Select...',
                              style: PremiumTextStyles.bodyRegular.copyWith(
                                color: widget.value != null
                                    ? PremiumColors.darkText
                                    : PremiumColors.lightText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            _isFocused ? Icons.expand_less : Icons.expand_more,
                            color: _isFocused
                                ? PremiumColors.primaryBlue
                                : PremiumColors.darkText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Error Message
        if (_error != null) ...[
          const SizedBox(height: 6),
          Text(
            _error!,
            style: PremiumTextStyles.caption.copyWith(
              color: PremiumColors.errorRed,
            ),
          ),
        ],
      ],
    );
  }
}
