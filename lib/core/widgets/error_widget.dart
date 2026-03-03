/// Reusable error display widget.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/constants/ui_constants.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.message = 'Something went wrong',
    this.icon = Icons.error_outline,
    this.iconColor,
    this.onRetry,
    this.retryLabel = 'Retry',
  });

  final String message;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiConstants.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: UiConstants.iconXLarge,
              color: iconColor ?? theme.colorScheme.error,
            ),
            const SizedBox(height: UiConstants.spacing16),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: UiConstants.spacing20),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
