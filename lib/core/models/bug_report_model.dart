/// Bug Report Model for user feedback and bug tracking.
library;

import 'package:equatable/equatable.dart';

enum BugReportStatus { new_, inProgress, resolved, closed }

class BugReportModel extends Equatable {
  const BugReportModel({
    required this.id,
    required this.userEmail,
    required this.description,
    required this.deviceInfo,
    required this.status,
    required this.createdAt,
    this.screenshotUrl,
  });

  /// Create from JSON.
  factory BugReportModel.fromJson(Map<String, dynamic> json) => BugReportModel(
        id: json['id'] as String,
        userEmail: json['userEmail'] as String,
        description: json['description'] as String,
        screenshotUrl: json['screenshotUrl'] as String?,
        deviceInfo: json['deviceInfo'] as Map<String, dynamic>? ?? {},
        status: _parseStatus(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
  final String id;
  final String userEmail;
  final String description;
  final String? screenshotUrl;
  final Map<String, dynamic> deviceInfo;
  final BugReportStatus status;
  final DateTime createdAt;

  /// Create a copy with optional field overrides.
  BugReportModel copyWith({
    String? id,
    String? userEmail,
    String? description,
    String? screenshotUrl,
    Map<String, dynamic>? deviceInfo,
    BugReportStatus? status,
    DateTime? createdAt,
  }) =>
      BugReportModel(
        id: id ?? this.id,
        userEmail: userEmail ?? this.userEmail,
        description: description ?? this.description,
        screenshotUrl: screenshotUrl ?? this.screenshotUrl,
        deviceInfo: deviceInfo ?? this.deviceInfo,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  /// Get device summary string.
  /// Example: "iOS 15.2 on iPhone 13 Pro"
  String getDeviceSummary() {
    final osName = deviceInfo['osName'] ?? 'Unknown OS';
    final osVersion = deviceInfo['osVersion'] ?? '';
    final deviceModel = deviceInfo['deviceModel'] ?? 'Unknown Device';

    if ((osVersion as String?)?.isEmpty ?? true) {
      return '$osName on $deviceModel';
    }
    return '$osName $osVersion on $deviceModel';
  }

  /// Get app version from device info.
  String? getAppVersion() => deviceInfo['appVersion'] as String?;

  /// Get device locale.
  String? getDeviceLocale() => deviceInfo['locale'] as String?;

  /// Get bug report status name.
  String getStatusName() {
    switch (status) {
      case BugReportStatus.new_:
        return 'New';
      case BugReportStatus.inProgress:
        return 'In Progress';
      case BugReportStatus.resolved:
        return 'Resolved';
      case BugReportStatus.closed:
        return 'Closed';
    }
  }

  /// Check if screenshot is attached.
  bool get hasScreenshot => screenshotUrl != null && screenshotUrl!.isNotEmpty;

  /// Check if bug is new (created within last 24 hours).
  bool get isNew {
    final diff = DateTime.now().difference(createdAt);
    return diff.inHours < 24;
  }

  /// Check if bug is open (not resolved or closed).
  bool get isOpen =>
      status != BugReportStatus.resolved && status != BugReportStatus.closed;

  /// Check if bug is resolved.
  bool get isResolved => status == BugReportStatus.resolved;

  /// Days since bug report creation.
  int get daysSinceCreation => DateTime.now().difference(createdAt).inDays;

  /// Get all device info keys.
  List<String> getDeviceInfoKeys() => deviceInfo.keys.toList();

  /// Get formatted device info as string.
  String getFormattedDeviceInfo() {
    final buffer = StringBuffer();
    deviceInfo.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    return buffer.toString();
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'userEmail': userEmail,
        'description': description,
        'screenshotUrl': screenshotUrl,
        'deviceInfo': deviceInfo,
        'status': status.toString().split('.').last,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Helper to parse status string.
  static BugReportStatus _parseStatus(String status) {
    if (status == 'new_') return BugReportStatus.new_;
    return BugReportStatus.values.byName(status);
  }

  @override
  List<Object?> get props => [
        id,
        userEmail,
        description,
        screenshotUrl,
        deviceInfo,
        status,
        createdAt,
      ];
}
