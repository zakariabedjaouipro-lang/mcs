/// AppHeader - Standard header with title and actions
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final Widget? leading;
  final bool showBackButton;

  const AppHeader({
    super.key,
    required this.title,
    this.actions,
    this.onBack,
    this.leading,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: PremiumColors.mediumGrey,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: leading ??
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onBack ??
                        () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                    color: PremiumColors.darkText,
                  ),
            ),
          Expanded(
            child: Text(
              title,
              style: PremiumTextStyles.headingLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}