/// Role Model for Supabase roles table
/// يحدد معلومات الدور والمتطلبات المرتبطة به
library;

import 'package:equatable/equatable.dart';

class RoleModel extends Equatable {
  const RoleModel({
    required this.id,
    required this.name,
    required this.displayNameAr,
    required this.displayNameEn,
    this.requiresApproval = false,
    this.requires2FA = false,
    this.requiresEmailVerification = true,
    this.createdAt,
    this.description,
    this.descriptionEn,
  });

  // ── Factory ────────────────────────────────────────────
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      displayNameAr: json['display_name_ar'] as String,
      displayNameEn: json['display_name_en'] as String,
      requiresApproval: (json['requires_approval'] as bool?) ?? false,
      requires2FA: (json['requires_2fa'] as bool?) ?? false,
      requiresEmailVerification:
          (json['requires_email_verification'] as bool?) ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      description: json['description'] as String?,
      descriptionEn: json['description_en'] as String?,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String name; // 'admin', 'doctor', 'patient', 'receptionist'
  final String displayNameAr; // 'مسؤول'
  final String displayNameEn; // 'Admin'
  final bool requiresApproval;
  final bool requires2FA;
  final bool requiresEmailVerification;
  final DateTime? createdAt;
  final String? description;
  final String? descriptionEn;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name_ar': displayNameAr,
      'display_name_en': displayNameEn,
      'requires_approval': requiresApproval,
      'requires_2fa': requires2FA,
      'requires_email_verification': requiresEmailVerification,
      'created_at': createdAt?.toIso8601String(),
      'description': description,
      'description_en': descriptionEn,
    };
  }

  // ── Copy With ──────────────────────────────────────────
  RoleModel copyWith({
    String? id,
    String? name,
    String? displayNameAr,
    String? displayNameEn,
    bool? requiresApproval,
    bool? requires2FA,
    bool? requiresEmailVerification,
    DateTime? createdAt,
    String? description,
    String? descriptionEn,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayNameAr: displayNameAr ?? this.displayNameAr,
      displayNameEn: displayNameEn ?? this.displayNameEn,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      requires2FA: requires2FA ?? this.requires2FA,
      requiresEmailVerification:
          requiresEmailVerification ?? this.requiresEmailVerification,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        displayNameAr,
        displayNameEn,
        requiresApproval,
        requires2FA,
        requiresEmailVerification,
        createdAt,
        description,
        descriptionEn,
      ];
}
