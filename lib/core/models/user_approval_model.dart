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
    this.reviewedBy,
    this.approvalNotes,
    this.rejectionReason,
  });

  /// Create from JSON
  factory UserApprovalModel.fromJson(Map<String, dynamic> json) {
    final reviewedAt = json['reviewed_at'] != null
        ? DateTime.parse(json['reviewed_at'] as String)
        : null;
    final status = ApprovalStatus.values.byName(json['status'] as String);
    
    return UserApprovalModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      registrationType: json['registration_type'] as String,
      status: status,
      createdAt: DateTime.parse(json['requested_at'] as String),
      approvedAt: status == ApprovalStatus.approved ? reviewedAt : null,
      rejectedAt: status == ApprovalStatus.rejected ? reviewedAt : null,
      reviewedBy: json['reviewed_by'] as String?,
      approvalNotes: status == ApprovalStatus.approved ? json['notes'] as String? : null,
      rejectionReason: status == ApprovalStatus.rejected ? json['notes'] as String? : null,
    );
  }

  final String userId;
  final String email;
  final String fullName;
  final String role;
  final String registrationType; // email, google, facebook
  final ApprovalStatus status;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final String? reviewedBy;
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
        'requested_at': createdAt.toIso8601String(),
        'reviewed_at': approvedAt?.toIso8601String(),
        'reviewed_by': reviewedBy,
        'notes': approvalNotes ?? rejectionReason,
      };

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
    String? reviewedBy,
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
      reviewedBy: reviewedBy ?? this.reviewedBy,
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
        reviewedBy,
        approvalNotes,
        rejectionReason,
      ];
}
