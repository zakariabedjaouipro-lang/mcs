/// AppScaffold - Standard scaffold with premium styling
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';

class AppScaffold extends StatelessWidget {

  const AppScaffold({
    required this.title, required this.child, super.key,
    this.actions,
    this.drawer,
    this.appBar,
    this.showBackButton = true,
  });
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            leading: showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                    color: PremiumColors.darkText,
                  )
                : null,
            title: Text(
              title,
              style: PremiumTextStyles.headingLarge,
            ),
            backgroundColor: PremiumColors.white,
            elevation: 0,
            foregroundColor: PremiumColors.darkText,
            actions: actions,
          ),
      drawer: drawer,
      backgroundColor: PremiumColors.almostWhite,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}