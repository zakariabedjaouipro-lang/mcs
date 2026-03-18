/// Registration Request Model
/// نموذج طلب التسجيل للأدوار التي تتطلب موافقة
library;

import 'package:equatable/equatable.dart';

class RegistrationRequest extends Equatable {
  const RegistrationRequest({
    required this.id,
    required this.userId,
    required this.roleId,
    this.status = RegistrationRequestStatus.pending,
    this.requestedData,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  // ── Factory ────────────────────────────────────────────
  factory RegistrationRequest.fromJson(Map<String, dynamic> json) {
    return RegistrationRequest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      roleId: json['role_id'] as String,
      status: RegistrationRequestStatus.fromString(
        json['status'] as String? ?? 'pending',
      ),
      requestedData: json['requested_data'] as Map<String, dynamic>?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String userId;
  final String roleId;
  final RegistrationRequestStatus status;
  final Map<String, dynamic>? requestedData;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'role_id': roleId,
      'status': status.value,
      'requested_data': requestedData,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // ── Copy With ──────────────────────────────────────────
  RegistrationRequest copyWith({
    String? id,
    String? userId,
    String? roleId,
    RegistrationRequestStatus? status,
    Map<String, dynamic>? requestedData,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RegistrationRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      status: status ?? this.status,
      requestedData: requestedData ?? this.requestedData,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        roleId,
        status,
        requestedData,
        reviewedBy,
        reviewedAt,
        rejectionReason,
        createdAt,
        updatedAt,
      ];
}

enum RegistrationRequestStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  underReview('under_review');

  const RegistrationRequestStatus(this.value);

  final String value;

  static RegistrationRequestStatus fromString(String value) {
    return RegistrationRequestStatus.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => RegistrationRequestStatus.pending,
    );
  }

  String get displayName {
    switch (this) {
      case RegistrationRequestStatus.pending:
        return 'قيد الانتظار';
      case RegistrationRequestStatus.approved:
        return 'معتمد';
      case RegistrationRequestStatus.rejected:
        return 'مرفوض';
      case RegistrationRequestStatus.underReview:
        return 'قيد المراجعة';
    }
  }

  String get displayNameEn {
    switch (this) {
      case RegistrationRequestStatus.pending:
        return 'Pending';
      case RegistrationRequestStatus.approved:
        return 'Approved';
      case RegistrationRequestStatus.rejected:
        return 'Rejected';
      case RegistrationRequestStatus.underReview:
        return 'Under Review';
    }
  }
}
