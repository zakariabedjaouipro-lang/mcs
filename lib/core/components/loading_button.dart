/// Loading Button Component
/// Button that shows loading state and handles async operations
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';

enum LoadingButtonVariant { primary, secondary, outlined, text }

class LoadingButton extends StatefulWidget {
  const LoadingButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isHidden = false,
    this.icon,
    this.isPrimary = true,
    this.variant = LoadingButtonVariant.primary,
    this.width,
    this.fullWidth = false,
    this.onError,
  });
  final String label;
  final Future<void> Function() onPressed;
  final bool isHidden;
  final IconData? icon;
  final bool isPrimary;
  final LoadingButtonVariant variant;
  final double? width;
  final bool fullWidth;
  final VoidCallback? onError;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await widget.onPressed();
    } catch (e) {
      widget.onError?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: MedicalColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isHidden) return const SizedBox.shrink();

    Color getBackgroundColor() {
      switch (widget.variant) {
        case LoadingButtonVariant.primary:
          return MedicalColors.primary;
        case LoadingButtonVariant.secondary:
          return Colors.grey.shade200;
        case LoadingButtonVariant.outlined:
        case LoadingButtonVariant.text:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      switch (widget.variant) {
        case LoadingButtonVariant.primary:
          return Colors.white;
        case LoadingButtonVariant.secondary:
          return Colors.black87;
        case LoadingButtonVariant.outlined:
        case LoadingButtonVariant.text:
          return MedicalColors.primary;
      }
    }

    final buttonStyle = widget.variant == LoadingButtonVariant.primary
        ? ElevatedButton.styleFrom(
            backgroundColor: getBackgroundColor(),
            foregroundColor: getTextColor(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            disabledBackgroundColor: Colors.grey[400],
          )
        : OutlinedButton.styleFrom(
            side: const BorderSide(color: MedicalColors.primary, width: 2),
            foregroundColor: MedicalColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          );

    return SizedBox(
      width: widget.width,
      child: widget.isPrimary
          ? ElevatedButton(
              onPressed: _isLoading ? null : _handlePress,
              style: buttonStyle,
              child: _buildButtonContent(),
            )
          : OutlinedButton(
              onPressed: _isLoading ? null : _handlePress,
              style: buttonStyle,
              child: _buildButtonContent(),
            ),
    );
  }

  Widget _buildButtonContent() {
    if (_isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading...',
            style: TextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: TextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
