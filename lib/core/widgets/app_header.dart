/// AppHeader - Standard header with title and actions
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.title,
    super.key,
    this.actions,
    this.onBack,
    this.leading,
    this.showBackButton = true,
  });

  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final Widget? leading;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: PremiumColors.mediumGrey,
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
                    color: PremiumColors.darkText,
                    onPressed: onBack ??
                        () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/');
                          }
                        },
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
