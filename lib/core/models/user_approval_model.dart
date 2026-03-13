import 'package:equatable/equatable.dart';

/// نموذج حالة الموافقة على المستخدمين
/// User Approval Status Model
enum ApprovalStatus {
  pending, // في انتظار الموافقة - Awaiting approval
  approved, // تمت الموافقة - Approved
  rejected, // تم الرفض - Rejected
  suspended; // معلق - Suspended

  String get label {
    switch (this) {
      case ApprovalStatus.pending:
        return 'قيد المراجعة';
      case ApprovalStatus.approved:
        return 'موافق عليه';
      case ApprovalStatus.rejected:
        return 'مرفوض';
      case ApprovalStatus.suspended:
        return 'معلق';
    }
  }

  String get labelEn {
    switch (this) {
      case ApprovalStatus.pending:
        return 'Pending Review';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
      case ApprovalStatus.suspended:
        return 'Suspended';
    }
  }
}

/// نموذج طلب الموافقة على المستخدم
/// User Approval Request Model
class UserApprovalModel extends Equatable {
  const UserApprovalModel({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.role,
    required this.registrationType,
    required this.status,
    required this.createdAt,
    this.approvedAt,
    this.rejectedAt,
    this.approvalNotes,
    this.rejectionReason,
  });

  final String userId;
  final String email;
  final String fullName;
  final String role;
  final String registrationType; // email, google, facebook
  final ApprovalStatus status;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final String? approvalNotes;
  final String? rejectionReason;

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'email': email,
        'full_name': fullName,
        'role': role,
        'registration_type': registrationType,
        'status': status.name,
        'created_at': createdAt.toIso8601String(),
        'approved_at': approvedAt?.toIso8601String(),
        'rejected_at': rejectedAt?.toIso8601String(),
        'approval_notes': approvalNotes,
        'rejection_reason': rejectionReason,
      };

  /// Create from JSON
  factory UserApprovalModel.fromJson(Map<String, dynamic> json) {
    return UserApprovalModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      registrationType: json['registration_type'] as String,
      status: ApprovalStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'] as String)
          : null,
      rejectedAt: json['rejected_at'] != null
          ? DateTime.parse(json['rejected_at'] as String)
          : null,
      approvalNotes: json['approval_notes'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  /// Copy with for immutability
  UserApprovalModel copyWith({
    String? userId,
    String? email,
    String? fullName,
    String? role,
    String? registrationType,
    ApprovalStatus? status,
    DateTime? createdAt,
    DateTime? approvedAt,
    DateTime? rejectedAt,
    String? approvalNotes,
    String? rejectionReason,
  }) {
    return UserApprovalModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      registrationType: registrationType ?? this.registrationType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      approvalNotes: approvalNotes ?? this.approvalNotes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        fullName,
        role,
        registrationType,
        status,
        createdAt,
        approvedAt,
        rejectedAt,
        approvalNotes,
        rejectionReason,
      ];
}
