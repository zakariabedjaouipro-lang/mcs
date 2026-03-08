/// User data model mapped to the `users` Supabase table.
library;

import 'package:equatable/equatable.dart';

import 'package:mcs/core/enums/user_role.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.phone,
    this.fullName,
    this.avatarUrl,
    this.locale = 'ar',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // ── Factory ────────────────────────────────────────────
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      role: UserRole.fromDbValue(json['role'] as String),
      avatarUrl: json['avatar_url'] as String?,
      locale: (json['locale'] as String?) ?? 'ar',
      isActive: (json['is_active'] as bool?) ?? true,
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
  final String email;
  final String? phone;
  final String? fullName;
  final UserRole role;
  final String? avatarUrl;
  final String locale;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'role': role.dbValue,
      'avatar_url': avatarUrl,
      'locale': locale,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // ── Copy With ──────────────────────────────────────────
  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? fullName,
    UserRole? role,
    String? avatarUrl,
    String? locale,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      locale: locale ?? this.locale,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ── Helpers ────────────────────────────────────────────

  /// Returns the user's initials (up to 2 characters).
  String get initials {
    final name = fullName;
    if (name == null || name.isEmpty) {
      return email.substring(0, 1).toUpperCase();
    }
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Display name — falls back to email if no full name is set.
  String get displayName => (fullName != null && fullName!.isNotEmpty)
      ? fullName!
      : email;

  /// Alias for fullName for backward compatibility
  String? get name => fullName;

  /// Address (to be loaded from patient-specific table)
  String? get address => null;

  /// Blood type (to be loaded from patient-specific table)
  String? get bloodType => null;

  /// Allergies (to be loaded from patient-specific table)
  String? get allergies => null;

  /// Emergency contact name (to be loaded from patient-specific table)
  String? get emergencyContact => null;

  /// Emergency contact phone (to be loaded from patient-specific table)
  String? get emergencyPhone => null;

  /// Date of birth (to be loaded from patient-specific table)
  DateTime? get dateOfBirth => null;

  // ── Role Shortcuts ─────────────────────────────────────
  bool get isDoctor => role == UserRole.doctor;
  bool get isPatient => role.isPatientType;
  bool get isAdmin => role.isAdmin;
  bool get isEmployee => role.isEmployee;

  // ── Equatable ──────────────────────────────────────────
  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        fullName,
        role,
        avatarUrl,
        locale,
        isActive,
        createdAt,
        updatedAt,
      ];

  /// Empty user for placeholder / default states.
  static const empty = UserModel(
    id: '',
    email: '',
    role: UserRole.patient,
  );

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;
}
