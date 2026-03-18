/// Role Permissions Model
/// يحدد الصلاحيات المسموحة لكل دور
library;

import 'package:equatable/equatable.dart';

class RolePermission extends Equatable {
  const RolePermission({
    required this.id,
    required this.roleId,
    required this.permissionKey,
    this.isAllowed = true,
    this.createdAt,
  });

  // ── Factory ────────────────────────────────────────────
  factory RolePermission.fromJson(Map<String, dynamic> json) {
    return RolePermission(
      id: json['id'] as String,
      roleId: json['role_id'] as String,
      permissionKey: json['permission_key'] as String,
      isAllowed: (json['is_allowed'] as bool?) ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String roleId;
  final String permissionKey; // 'patients.create', 'appointments.view_all'
  final bool isAllowed;
  final DateTime? createdAt;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_id': roleId,
      'permission_key': permissionKey,
      'is_allowed': isAllowed,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, roleId, permissionKey, isAllowed, createdAt];
}

/// Role Permissions Collection
/// مجموعة من الصلاحيات المتعلقة بدور معين
class RolePermissions extends Equatable {
  const RolePermissions({
    required this.roleId,
    required this.permissions,
  });

  final String roleId;
  final List<RolePermission> permissions;

  /// Check if permission is allowed
  bool hasPermission(String permissionKey) {
    try {
      final permission = permissions.firstWhere(
        (p) => p.permissionKey == permissionKey,
        orElse: () => throw Exception('Permission not found'),
      );
      return permission.isAllowed;
    } catch (e) {
      // Default deny if permission doesn't exist
      return false;
    }
  }

  /// Check multiple permissions (requires ALL to be true)
  bool hasAllPermissions(List<String> permissionKeys) {
    return permissionKeys.every((key) => hasPermission(key));
  }

  /// Check multiple permissions (requires ANY to be true)
  bool hasAnyPermission(List<String> permissionKeys) {
    return permissionKeys.any((key) => hasPermission(key));
  }

  @override
  List<Object?> get props => [roleId, permissions];
}

/// Predefined permission keys
class PermissionKeys {
  // Patient permissions
  static const String patientViewProfile = 'patients.view_profile';
  static const String patientEditProfile = 'patients.edit_profile';
  static const String patientViewAppointments = 'patients.view_appointments';
  static const String patientCreateAppointments =
      'patients.create_appointments';
  static const String patientCancelAppointments =
      'patients.cancel_appointments';
  static const String patientViewPrescriptions = 'patients.view_prescriptions';
  static const String patientViewLabResults = 'patients.view_lab_results';
  static const String patientViewInvoices = 'patients.view_invoices';

  // Doctor permissions
  static const String doctorViewProfile = 'doctors.view_profile';
  static const String doctorEditProfile = 'doctors.edit_profile';
  static const String doctorViewAppointments = 'doctors.view_appointments';
  static const String doctorCreatePrescriptions =
      'doctors.create_prescriptions';
  static const String doctorViewPatients = 'doctors.view_patients';
  static const String doctorViewPatientRecords = 'doctors.view_patient_records';
  static const String doctorCreateLabRequests = 'doctors.create_lab_requests';
  static const String doctorViewLabRequests = 'doctors.view_lab_requests';

  // Admin permissions
  static const String adminViewAllPatients = 'admin.view_all_patients';
  static const String adminViewAllDoctors = 'admin.view_all_doctors';
  static const String adminViewAllAppointments = 'admin.view_all_appointments';
  static const String adminApproveRequests = 'admin.approve_requests';
  static const String adminRejectRequests = 'admin.reject_requests';
  static const String adminViewAnalytics = 'admin.view_analytics';
  static const String adminViewReports = 'admin.view_reports';
  static const String adminManageRoles = 'admin.manage_roles';
  static const String adminManagePermissions = 'admin.manage_permissions';

  // Super Admin permissions
  static const String superAdminFullAccess = 'super_admin.full_access';
  static const String superAdminManageAdmins = 'super_admin.manage_admins';
  static const String superAdminViewSystemLogs = 'super_admin.view_system_logs';
  static const String superAdminManageClinics = 'super_admin.manage_clinics';

  // Receptionist permissions
  static const String receptionistViewAppointments =
      'receptionist.view_appointments';
  static const String receptionistCreateAppointments =
      'receptionist.create_appointments';
  static const String receptionistCancelAppointments =
      'receptionist.cancel_appointments';
  static const String receptionistViewPatients = 'receptionist.view_patients';
  static const String receptionistEditPatients = 'receptionist.edit_patients';
}
