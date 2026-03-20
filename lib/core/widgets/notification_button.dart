/// Notification Button - زر الإشعارات
/// Shows notifications count with badge and animation
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';

/// زر الإشعارات مع عداد
class NotificationButton extends StatefulWidget {
  final int badgeCount;
  final VoidCallback onTap;
  final bool animate;
  final Color? color;
  final double size;

  const NotificationButton({
    super.key,
    required this.badgeCount,
    required this.onTap,
    this.animate = true,
    this.color,
    this.size = 24,
  });

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.animate && widget.badgeCount > 0) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NotificationButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.badgeCount > oldWidget.badgeCount && widget.animate) {
      _controller.forward(from: 0.0);
    } else if (widget.badgeCount == 0) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actualColor = widget.color ?? PremiumColors.errorRed;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              size: widget.size,
              color: actualColor,
            ),
            onPressed: widget.onTap,
            tooltip: 'Notifications',
          ),
        ),
        if (widget.badgeCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: actualColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: actualColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                widget.badgeCount > 99 ? '99+' : widget.badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Notification Center - مركز الإشعارات
class NotificationCenter extends StatelessWidget {
  final List<NotificationItem> notifications;
  final VoidCallback onClearAll;
  final void Function(String)? onNotificationTap;

  const NotificationCenter({
    super.key,
    required this.notifications,
    required this.onClearAll,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? 'الإشعارات' : 'Notifications',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: onClearAll,
                  child: Text(
                    isArabic ? 'مسح الكل' : 'Clear All',
                    style: const TextStyle(color: PremiumColors.errorRed),
                  ),
                ),
              ],
            ),
          ),
          if (notifications.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 48,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isArabic ? 'لا توجد إشعارات جديدة' : 'No notifications',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              itemCount: notifications.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: onNotificationTap != null
                      ? () => onNotificationTap!(notification.id)
                      : null,
                );
              },
            ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: notification.type.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          notification.type.icon,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        notification.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        notification.message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        notification.timeAgo,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      onTap: onTap,
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}د';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}س';
    } else {
      return '${difference.inDays}ي';
    }
  }
}

enum NotificationType {
  appointment,
  prescription,
  labResult,
  message,
  system;

  IconData get icon {
    switch (this) {
      case NotificationType.appointment:
        return Icons.calendar_today;
      case NotificationType.prescription:
        return Icons.local_pharmacy;
      case NotificationType.labResult:
        return Icons.science;
      case NotificationType.message:
        return Icons.mail;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case NotificationType.appointment:
        return Colors.blue;
      case NotificationType.prescription:
        return Colors.green;
      case NotificationType.labResult:
        return Colors.cyan;
      case NotificationType.message:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
    }
  }
}
