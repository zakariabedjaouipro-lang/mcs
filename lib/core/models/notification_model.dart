/// Notification model for user notifications.
library;

import 'package:equatable/equatable.dart';

enum NotificationType {
  appointment,
  prescription,
  payment,
  message,
  system,
  alert,
}

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  /// Create from JSON.
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        type: NotificationType.values.byName(json['type'] as String),
        data: json['data'] as Map<String, dynamic>? ?? {},
        isRead: json['isRead'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  /// Create a copy with optional field overrides.
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        body: body ?? this.body,
        type: type ?? this.type,
        data: data ?? this.data,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt ?? this.createdAt,
      );

  /// Mark notification as read.
  NotificationModel markAsRead() => copyWith(isRead: true);

  /// Get notification type name.
  String getNotificationType() {
    switch (type) {
      case NotificationType.appointment:
        return 'Appointment';
      case NotificationType.prescription:
        return 'Prescription';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.message:
        return 'Message';
      case NotificationType.system:
        return 'System';
      case NotificationType.alert:
        return 'Alert';
    }
  }

  /// Get relative time (e.g., "2 hours ago").
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }

  /// Get appointment ID from data if notification type is appointment.
  String? getAppointmentId() {
    if (type == NotificationType.appointment) {
      return data['appointmentId'] as String?;
    }
    return null;
  }

  /// Get prescription ID from data if notification type is prescription.
  String? getPrescriptionId() {
    if (type == NotificationType.prescription) {
      return data['prescriptionId'] as String?;
    }
    return null;
  }

  /// Get related entity ID from data.
  String? getRelatedEntityId(String key) => data[key] as String?;

  /// Check if notification is unread.
  bool get isUnread => !isRead;

  /// Check if notification is old (created more than 30 days ago).
  bool get isOld {
    final diff = DateTime.now().difference(createdAt);
    return diff.inDays > 30;
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
        'type': type.toString().split('.').last,
        'data': data,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        type,
        data,
        isRead,
        createdAt,
      ];
}
