/// Appointment data model mapped to the `appointments` Supabase table.
library;

import 'package:equatable/equatable.dart';

import 'package:mcs/core/enums/appointment_status.dart';

class AppointmentModel extends Equatable {
  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.clinicId,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.status,
    required this.type,
    this.remoteRequestStatus = RemoteRequestStatus.none,
    this.notes,
    this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String,
      clinicId: json['clinic_id'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      durationMinutes: (json['duration_minutes'] as int?) ?? 0,
      status: AppointmentStatus.fromDbValue(json['status'] as String),
      type: AppointmentType.fromDbValue(json['type'] as String),
      remoteRequestStatus: json['remote_request_status'] != null
          ? RemoteRequestStatus.fromDbValue(
              json['remote_request_status'] as String,
            )
          : RemoteRequestStatus.none,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String patientId;
  final String doctorId;
  final String clinicId;
  final DateTime scheduledAt;
  final int durationMinutes;
  final AppointmentStatus status;
  final AppointmentType type;
  final RemoteRequestStatus remoteRequestStatus;
  final String? notes;
  final DateTime? createdAt;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'clinic_id': clinicId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'duration_minutes': durationMinutes,
      'status': status.dbValue,
      'type': type.dbValue,
      'remote_request_status': remoteRequestStatus.dbValue,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // ── Copy With ──────────────────────────────────────────
  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? clinicId,
    DateTime? scheduledAt,
    int? durationMinutes,
    AppointmentStatus? status,
    AppointmentType? type,
    RemoteRequestStatus? remoteRequestStatus,
    String? notes,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      clinicId: clinicId ?? this.clinicId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      type: type ?? this.type,
      remoteRequestStatus: remoteRequestStatus ?? this.remoteRequestStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ── Helpers ────────────────────────────────────────────

  /// End time = scheduledAt + duration.
  DateTime get endsAt => scheduledAt.add(Duration(minutes: durationMinutes));

  /// Alias for scheduledAt for backward compatibility
  DateTime get appointmentDate => scheduledAt;

  /// Get time slot as formatted string (HH:MM)
  String get timeSlot =>
    '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}';

  /// Get patient name (to be loaded from patient model)
  String? get patientName => null;

  /// Get doctor name (to be loaded from doctor model)
  String? get doctorName => null;

  /// Get status color for UI display
  Color get statusColor {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.noShow:
        return Colors.grey;
    }
  }

  /// Check if appointment is in the past
  bool get isPast => scheduledAt.isBefore(DateTime.now());

  /// Check if appointment is today
  bool get isToday {
    final now = DateTime.now();
    return scheduledAt.year == now.year &&
        scheduledAt.month == now.month &&
        scheduledAt.day == now.day;
  }

  /// Check if appointment is in the future
  bool get isFuture => scheduledAt.isAfter(DateTime.now());

  bool get isPending => status == AppointmentStatus.pending;
  bool get isConfirmed => status == AppointmentStatus.confirmed;
  bool get isCancelled => status == AppointmentStatus.cancelled;
  bool get isCompleted => status == AppointmentStatus.completed;
  bool get isNoShow => status == AppointmentStatus.noShow;

  bool get canStartVideoCall =>
      type == AppointmentType.remote &&
      (remoteRequestStatus == RemoteRequestStatus.accepted ||
          remoteRequestStatus == RemoteRequestStatus.none) &&
      (isConfirmed || isPending);

  bool get isTerminal => status.isTerminal;

  // ── Equatable ──────────────────────────────────────────
  @override
  List<Object?> get props => [
        id,
        patientId,
        doctorId,
        clinicId,
        scheduledAt,
        durationMinutes,
        status,
        type,
        remoteRequestStatus,
        notes,
        createdAt,
      ];
}
