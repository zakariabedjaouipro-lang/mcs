/// Advanced Authentication Mappers
/// محولات المصادقة المتقدمة للبيانات
library;

import 'package:mcs/core/models/registration_request_model.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/core/models/role_permissions_model.dart';
import 'package:mcs/core/models/user_profile_model.dart';

/// Mapper for RoleModel
class RoleMapper {
  /// Convert JSON to RoleModel
  static RoleModel fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      displayNameAr: json['display_name_ar'] as String? ?? '',
      displayNameEn: json['display_name_en'] as String? ?? '',
      requiresApproval: json['requires_approval'] as bool? ?? false,
      requires2FA: json['requires_2fa'] as bool? ?? false,
      requiresEmailVerification:
          json['requires_email_verification'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      description: json['description'] as String?,
      descriptionEn: json['description_en'] as String?,
    );
  }

  /// Convert RoleModel to JSON
  static Map<String, dynamic> toJson(RoleModel role) {
    return {
      'id': role.id,
      'name': role.name,
      'display_name_ar': role.displayNameAr,
      'display_name_en': role.displayNameEn,
      'requires_approval': role.requiresApproval,
      'requires_2fa': role.requires2FA,
      'requires_email_verification': role.requiresEmailVerification,
      'created_at': role.createdAt?.toIso8601String(),
      'description': role.description,
      'description_en': role.descriptionEn,
    };
  }
}

/// Mapper for RolePermission
class RolePermissionMapper {
  /// Convert JSON to RolePermission
  static RolePermission fromJson(Map<String, dynamic> json) {
    return RolePermission(
      id: json['id'] as String? ?? '',
      roleId: json['role_id'] as String? ?? '',
      permissionKey: json['permission_key'] as String? ?? '',
      isAllowed: json['is_allowed'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert RolePermission to JSON
  static Map<String, dynamic> toJson(RolePermission permission) {
    return {
      'id': permission.id,
      'role_id': permission.roleId,
      'permission_key': permission.permissionKey,
      'is_allowed': permission.isAllowed,
      'created_at': permission.createdAt?.toIso8601String(),
    };
  }
}

/// Mapper for RolePermissions
class RolePermissionsMapper {
  /// Convert JSON to RolePermissions
  static RolePermissions fromJson(Map<String, dynamic> json) {
    final permissionsList = (json['permissions'] as List?)
            ?.map((p) => RolePermissionMapper.fromJson(p as Map<String, dynamic>))
            .toList() ??
        [];

    return RolePermissions(
      roleId: json['role_id'] as String? ?? '',
      permissions: permissionsList,
    );
  }

  /// Convert RolePermissions to JSON
  static Map<String, dynamic> toJson(RolePermissions permissions) {
    return {
      'role_id': permissions.roleId,
      'permissions': permissions.permissions
          .map((p) => RolePermissionMapper.toJson(p))
          .toList(),
    };
  }
}

/// Mapper for RegistrationRequest
class RegistrationRequestMapper {
  /// Convert JSON to RegistrationRequest
  static RegistrationRequest fromJson(Map<String, dynamic> json) {
    return RegistrationRequest(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      roleId: json['role_id'] as String? ?? '',
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

  /// Convert RegistrationRequest to JSON
  static Map<String, dynamic> toJson(RegistrationRequest request) {
    return {
      'id': request.id,
      'user_id': request.userId,
      'role_id': request.roleId,
      'status': request.status.value,
      'requested_data': request.requestedData,
      'reviewed_by': request.reviewedBy,
      'reviewed_at': request.reviewedAt?.toIso8601String(),
      'rejection_reason': request.rejectionReason,
      'created_at': request.createdAt?.toIso8601String(),
      'updated_at': request.updatedAt?.toIso8601String(),
    };
  }
}

/// Mapper for UserProfile
class UserProfileMapper {
  /// Convert JSON to UserProfile
  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      roleId: json['role_id'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      is2FAEnabled: json['is_2fa_enabled'] as bool? ?? false,
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
      loginAttempts: json['login_attempts'] as int? ?? 0,
    );
  }

  /// Convert UserProfile to JSON
  static Map<String, dynamic> toJson(UserProfile profile) {
    return {
      'id': profile.id,
      'email': profile.email,
      'full_name': profile.fullName,
      'role_id': profile.roleId,
      'phone': profile.phone,
      'avatar_url': profile.avatarUrl,
      'is_2fa_enabled': profile.is2FAEnabled,
      'email_verified_at': profile.emailVerifiedAt?.toIso8601String(),
      'phone_verified_at': profile.phoneVerifiedAt?.toIso8601String(),
      'registration_status': profile.registrationStatus,
      'approval_notes': profile.approvalNotes,
      'created_at': profile.createdAt?.toIso8601String(),
      'updated_at': profile.updatedAt?.toIso8601String(),
      'last_login_at': profile.lastLoginAt?.toIso8601String(),
      'locked_until': profile.lockedUntil?.toIso8601String(),
      'login_attempts': profile.loginAttempts,
    };
  }
}
