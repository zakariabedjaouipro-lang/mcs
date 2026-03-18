/// Extended User Profile Model
/// نموذج ملف المستخدم الموسع مع الحقول المتعلقة بالمصادقة والأدوار
library;

import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.roleId,
    this.phone,
    this.avatarUrl,
    this.is2FAEnabled = false,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.registrationStatus =
        'pending', // 'pending', 'approved', 'rejected', 'active'
    this.approvalNotes,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.lockedUntil,
    this.loginAttempts = 0,
  });

  // ── Factory ────────────────────────────────────────────
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      roleId: json['role_id'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      is2FAEnabled: (json['is_2fa_enabled'] as bool?) ?? false,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      phoneVerifiedAt: json['phone_verified_at'] != null
          ? DateTime.parse(json['phone_verified_at'] as String)
          : null,
      registrationStatus: json['registration_status'] as String? ?? 'pending',
      approvalNotes: json['approval_notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      lockedUntil: json['locked_until'] != null
          ? DateTime.parse(json['locked_until'] as String)
          : null,
      loginAttempts: (json['login_attempts'] as int?) ?? 0,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String email;
  final String fullName;
  final String? roleId;
  final String? phone;
  final String? avatarUrl;
  final bool is2FAEnabled;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final String registrationStatus;
  final String? approvalNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final DateTime? lockedUntil;
  final int loginAttempts;

  // ── Computed Properties ────────────────────────────────
  bool get isEmailVerified => emailVerifiedAt != null;

  bool get isPhoneVerified => phoneVerifiedAt != null;

  bool get isActive => registrationStatus == 'active';

  bool get isPending => registrationStatus == 'pending';

  bool get isRejected => registrationStatus == 'rejected';

  bool get isApproved => registrationStatus == 'approved';

  bool get isAccountLocked =>
      lockedUntil != null && lockedUntil!.isAfter(DateTime.now());

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role_id': roleId,
      'phone': phone,
      'avatar_url': avatarUrl,
      'is_2fa_enabled': is2FAEnabled,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'phone_verified_at': phoneVerifiedAt?.toIso8601String(),
      'registration_status': registrationStatus,
      'approval_notes': approvalNotes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'locked_until': lockedUntil?.toIso8601String(),
      'login_attempts': loginAttempts,
    };
  }

  // ── Copy With ──────────────────────────────────────────
  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? roleId,
    String? phone,
    String? avatarUrl,
    bool? is2FAEnabled,
    DateTime? emailVerifiedAt,
    DateTime? phoneVerifiedAt,
    String? registrationStatus,
    String? approvalNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    DateTime? lockedUntil,
    int? loginAttempts,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      roleId: roleId ?? this.roleId,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      is2FAEnabled: is2FAEnabled ?? this.is2FAEnabled,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
      registrationStatus: registrationStatus ?? this.registrationStatus,
      approvalNotes: approvalNotes ?? this.approvalNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      loginAttempts: loginAttempts ?? this.loginAttempts,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        roleId,
        phone,
        avatarUrl,
        is2FAEnabled,
        emailVerifiedAt,
        phoneVerifiedAt,
        registrationStatus,
        approvalNotes,
        createdAt,
        updatedAt,
        lastLoginAt,
        lockedUntil,
        loginAttempts,
      ];
}
