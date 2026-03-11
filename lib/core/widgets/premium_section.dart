/// Premium Section Component
/// Elegant section container with title and content
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class PremiumSection extends StatelessWidget {

  const PremiumSection({
    required this.title, required this.child, super.key,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.showDivider = true,
  });
  final String title;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: PremiumTextStyles.headingSmall.copyWith(
                color: PremiumColors.darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (showDivider)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Divider(
                color: PremiumColors.mediumGrey,
                thickness: 1,
                height: 1,
              ),
            ),
          // Section content
          child,
        ],
      ),
    );
  }
}