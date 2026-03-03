/// Video session model for telemedicine appointments.
library;

import 'package:equatable/equatable.dart';

enum VideoSessionStatus { scheduled, active, completed, cancelled }

class VideoSessionModel extends Equatable {
  const VideoSessionModel({
    required this.id,
    required this.appointmentId,
    required this.roomId,
    required this.tokenDoctor,
    required this.tokenPatient,
    this.startedAt,
    this.endedAt,
    required this.status,
  });

  /// Create from JSON.
  factory VideoSessionModel.fromJson(Map<String, dynamic> json) =>
      VideoSessionModel(
        id: json['id'] as String,
        appointmentId: json['appointmentId'] as String,
        roomId: json['roomId'] as String,
        tokenDoctor: json['tokenDoctor'] as String,
        tokenPatient: json['tokenPatient'] as String,
        startedAt: json['startedAt'] != null
            ? DateTime.parse(json['startedAt'] as String)
            : null,
        endedAt: json['endedAt'] != null
            ? DateTime.parse(json['endedAt'] as String)
            : null,
        status: VideoSessionStatus.values.byName(json['status'] as String),
      );
  final String id;
  final String appointmentId;
  final String roomId;
  final String tokenDoctor;
  final String tokenPatient;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final VideoSessionStatus status;

  /// Create a copy with optional field overrides.
  VideoSessionModel copyWith({
    String? id,
    String? appointmentId,
    String? roomId,
    String? tokenDoctor,
    String? tokenPatient,
    DateTime? startedAt,
    DateTime? endedAt,
    VideoSessionStatus? status,
  }) =>
      VideoSessionModel(
        id: id ?? this.id,
        appointmentId: appointmentId ?? this.appointmentId,
        roomId: roomId ?? this.roomId,
        tokenDoctor: tokenDoctor ?? this.tokenDoctor,
        tokenPatient: tokenPatient ?? this.tokenPatient,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt ?? this.endedAt,
        status: status ?? this.status,
      );

  /// Check if session is currently active.
  bool get isActive => status == VideoSessionStatus.active;

  /// Check if session is scheduled (not yet started).
  bool get isScheduled => status == VideoSessionStatus.scheduled;

  /// Check if session is completed.
  bool get isCompleted => status == VideoSessionStatus.completed;

  /// Check if session is cancelled.
  bool get isCancelled => status == VideoSessionStatus.cancelled;

  /// Check if user can join the session (scheduled or active).
  bool get canJoin => isScheduled || isActive;

  /// Get session duration in seconds.
  int? get duration {
    final start = startedAt;
    final end = endedAt;
    if (start == null || end == null) return null;
    return end.difference(start).inSeconds;
  }

  /// Get session duration as formatted string (e.g., "45 minutes").
  String? getDurationFormatted() {
    final d = duration;
    if (d == null) return null;

    final minutes = d ~/ 60;
    final seconds = d % 60;

    if (minutes == 0) return '${seconds}s';
    if (seconds == 0) return '${minutes}min';
    return '${minutes}min ${seconds}s';
  }

  /// Get minutes until session starts (for scheduled sessions).
  int? getMinutesUntilStart() {
    if (!isScheduled) return null;
    final start = startedAt;
    if (start == null) return null;
    return start.difference(DateTime.now()).inMinutes;
  }

  /// Check if session is about to start (within 5 minutes).
  bool get isAboutToStart {
    final minutes = getMinutesUntilStart();
    return minutes != null && minutes <= 5 && minutes > 0;
  }

  /// Get session status name.
  String getStatusName() {
    switch (status) {
      case VideoSessionStatus.scheduled:
        return 'Scheduled';
      case VideoSessionStatus.active:
        return 'Active';
      case VideoSessionStatus.completed:
        return 'Completed';
      case VideoSessionStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get join link for doctor role (contains doctor token).
  String getJoinLinkForRole(String role) {
    // Format: room_id/token for joining
    final token = role.toLowerCase() == 'doctor' ? tokenDoctor : tokenPatient;
    return '$roomId/$token';
  }

  /// Get token for doctor.
  String getTokenForDoctor() => tokenDoctor;

  /// Get token for patient.
  String getTokenForPatient() => tokenPatient;

  /// Get all participants who have tokens.
  List<String> get participants => ['doctor', 'patient'];

  /// Check if session has ended.
  bool get hasEnded => isCompleted || isCancelled || endedAt != null;

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'appointmentId': appointmentId,
        'roomId': roomId,
        'tokenDoctor': tokenDoctor,
        'tokenPatient': tokenPatient,
        'startedAt': startedAt?.toIso8601String(),
        'endedAt': endedAt?.toIso8601String(),
        'status': status.toString().split('.').last,
      };

  @override
  List<Object?> get props => [
        id,
        appointmentId,
        roomId,
        tokenDoctor,
        tokenPatient,
        startedAt,
        endedAt,
        status,
      ];
}
