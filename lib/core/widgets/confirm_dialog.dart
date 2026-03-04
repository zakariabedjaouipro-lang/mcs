/// Confirm dialog widget for showing confirmation dialogs.
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/localization/app_localizations.dart';

/// Shows a confirmation dialog.
///
/// Returns `true` if the user confirms, `false` otherwise.
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  bool isDestructive = false,
  IconData? icon,
}) async {
  final localizations = AppLocalizations.of(context)!;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => _ConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText ?? localizations.confirm,
      cancelText: cancelText ?? localizations.cancel,
      isDestructive: isDestructive,
      icon: icon,
    ),
  );

  return result ?? false;
}

/// Shows a delete confirmation dialog.
Future<bool> showDeleteConfirmDialog({
  required BuildContext context,
  required String itemName,
}) async {
  final localizations = AppLocalizations.of(context)!;

  return showConfirmDialog(
    context: context,
    title: localizations.delete,
    message: 'Are you sure you want to delete $itemName?',
    confirmText: localizations.delete,
    cancelText: localizations.cancel,
    isDestructive: true,
    icon: Icons.delete_outline,
  );
}

/// Shows a logout confirmation dialog.
Future<bool> showLogoutConfirmDialog({
  required BuildContext context,
}) async {
  final localizations = AppLocalizations.of(context)!;

  return showConfirmDialog(
    context: context,
    title: localizations.logout,
    message: 'Are you sure you want to logout?',
    confirmText: localizations.logout,
    cancelText: localizations.cancel,
    icon: Icons.logout,
  );
}

/// Shows a custom confirmation dialog with custom actions.
Future<T?> showCustomConfirmDialog<T>({
  required BuildContext context,
  required String title,
  required String message,
  required List<Widget> actions,
  IconData? icon,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) => AlertDialog(
      icon: icon != null
          ? Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      title: Text(title),
      content: Text(message),
      actions: actions,
    ),
  );
}

/// Internal confirm dialog widget.
class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.isDestructive,
    this.icon,
  });
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color? iconColor;
    if (isDestructive) {
      iconColor = colorScheme.error;
    } else if (icon != null) {
      iconColor = colorScheme.primary;
    }

    return AlertDialog(
      icon: icon != null
          ? Icon(
              icon,
              size: 48,
              color: iconColor,
            )
          : null,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? colorScheme.error : null,
            foregroundColor: isDestructive ? colorScheme.onError : null,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Alert dialog with different severity levels.
enum AlertSeverity {
  info,
  success,
  warning,
  error,
}

/// Shows an alert dialog with specified severity.
Future<void> showAlert({
  required BuildContext context,
  required String title,
  required String message,
  AlertSeverity severity = AlertSeverity.info,
  String? actionText,
  VoidCallback? onActionPressed,
}) async {
  final localizations = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  IconData icon;
  Color iconColor;

  switch (severity) {
    case AlertSeverity.info:
      icon = Icons.info_outline;
      iconColor = colorScheme.primary;
    case AlertSeverity.success:
      icon = Icons.check_circle_outline;
      iconColor = Colors.green;
    case AlertSeverity.warning:
      icon = Icons.warning_amber_outlined;
      iconColor = Colors.orange;
    case AlertSeverity.error:
      icon = Icons.error_outline;
      iconColor = colorScheme.error;
  }

  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        icon,
        size: 48,
        color: iconColor,
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        if (actionText != null && onActionPressed != null)
          TextButton(
            onPressed: () {
              onActionPressed();
              Navigator.of(context).pop();
            },
            child: Text(actionText),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.ok),
        ),
      ],
    ),
  );
}

/// Shows a loading dialog.
///
/// Returns a function that should be called to dismiss the dialog.
void showLoadingDialog({
  required BuildContext context,
  String? message,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _LoadingDialog(message: message),
  );
}

/// Internal loading dialog widget.
class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog({this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!),
            ] else ...[
              const SizedBox(height: 16),
              Text(localizations.loading),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shows a snackbar with a confirmation action.
void showConfirmationSnackBar({
  required BuildContext context,
  required String message,
  String? actionLabel,
  VoidCallback? onActionPressed,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context)..showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      action: actionLabel != null && onActionPressed != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onActionPressed,
            )
          : null,
    ),
  );
}
