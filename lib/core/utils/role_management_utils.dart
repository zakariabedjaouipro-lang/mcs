/// Role Management Utilities
/// إدارة الأدوار والصلاحيات المتدرجة
library;

import 'package:flutter/material.dart';

/// نموذج لخيار الدور
class RoleOption {
  const RoleOption({
    required this.value,
    required this.label,
    required this.description,
    required this.icon,
    this.requiresClinicId = false,
  });

  final String value;
  final String label;
  final String description;
  final IconData icon;

  /// هل يتطلب هذا الدور معرّف عيادة
  final bool requiresClinicId;
}

/// فئة إدارة الأدوار المتدرجة
class RoleManagementUtils {
  RoleManagementUtils._();

  // ── الأدوار المتاحة لكل نوع مستخدم ──────────────────────────

  /// الأدوار المتاحة للمستخدم العام (التسجيل الذاتي)
  static const List<RoleOption> publicRoles = [
    RoleOption(
      value: 'patient',
      label: 'Patient',
      description: 'Access healthcare services',
      icon: Icons.person,
      requiresClinicId: false,
    ),
    RoleOption(
      value: 'relative',
      label: 'Relative',
      description: 'Patient family member',
      icon: Icons.family_restroom,
      requiresClinicId: false,
    ),
  ];

  /// الأدوار المتاحة لـ Clinic Admin (إضافة موظفين)
  static const List<RoleOption> clinicStaffRoles = [
    RoleOption(
      value: 'doctor',
      label: 'Doctor',
      description: 'Manage clinic and patients',
      icon: Icons.medical_services,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'nurse',
      label: 'Nurse',
      description: 'Provide patient care',
      icon: Icons.healing,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'receptionist',
      label: 'Receptionist',
      description: 'Manage appointments',
      icon: Icons.door_front_door,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'pharmacist',
      label: 'Pharmacist',
      description: 'Manage medications',
      icon: Icons.local_pharmacy,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'lab_technician',
      label: 'Lab Technician',
      description: 'Process lab tests',
      icon: Icons.science,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'radiographer',
      label: 'Radiographer',
      description: 'Perform imaging',
      icon: Icons.radar,
      requiresClinicId: true,
    ),
  ];

  /// الأدوار المتاحة لـ Super Admin (إضافة clinic admins)
  static const List<RoleOption> superAdminRoles = [
    RoleOption(
      value: 'clinic_admin',
      label: 'Clinic Admin',
      description: 'Manage clinic and staff',
      icon: Icons.business_center,
      requiresClinicId: true,
    ),
  ];

  /// جميع الأدوار (للعرض الكامل)
  static const List<RoleOption> allRoles = [
    RoleOption(
      value: 'patient',
      label: 'Patient',
      description: 'Access healthcare services',
      icon: Icons.person,
      requiresClinicId: false,
    ),
    RoleOption(
      value: 'doctor',
      label: 'Doctor',
      description: 'Manage clinic and patients',
      icon: Icons.medical_services,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'nurse',
      label: 'Nurse',
      description: 'Provide patient care',
      icon: Icons.healing,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'receptionist',
      label: 'Receptionist',
      description: 'Manage appointments',
      icon: Icons.door_front_door,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'pharmacist',
      label: 'Pharmacist',
      description: 'Manage medications',
      icon: Icons.local_pharmacy,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'lab_technician',
      label: 'Lab Technician',
      description: 'Process lab tests',
      icon: Icons.science,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'radiographer',
      label: 'Radiographer',
      description: 'Perform imaging',
      icon: Icons.radar,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'clinic_admin',
      label: 'Clinic Admin',
      description: 'Manage clinic and staff',
      icon: Icons.business_center,
      requiresClinicId: true,
    ),
    RoleOption(
      value: 'super_admin',
      label: 'Super Admin',
      description: 'Full system administration',
      icon: Icons.security,
      requiresClinicId: false,
    ),
    RoleOption(
      value: 'relative',
      label: 'Relative',
      description: 'Patient family member',
      icon: Icons.family_restroom,
      requiresClinicId: false,
    ),
  ];

  // ── دوال مساعدة ──────────────────────────────────────────────

  /// الحصول على الأدوار المتاحة بناءً على نوع المستخدم
  ///
  /// يُستخدم في شاشات التسجيل المختلفة:
  /// - تسجيل عام: فقط patient و relative
  /// - clinic admin: يمكن إضافة موظفين
  /// - super admin: يمكن إضافة clinic admins
  static List<RoleOption> getAvailableRoles({
    required String currentUserRole,
    bool isPublicRegistration = true,
  }) {
    if (isPublicRegistration) {
      return publicRoles;
    }

    switch (currentUserRole) {
      case 'clinic_admin':
        return clinicStaffRoles;
      case 'super_admin':
        return superAdminRoles;
      default:
        return publicRoles;
    }
  }

  /// التحقق من أن الدور يتطلب معرّف عيادة
  static bool roleRequiresClinicId(String role) {
    return clinicStaffRoles.any((r) => r.value == role) ||
        superAdminRoles.any((r) => r.value == role);
  }

  /// الحصول على خيار الدور بناءً على القيمة
  static RoleOption? getRoleOption(String value) {
    try {
      return allRoles.firstWhere((r) => r.value == value);
    } catch (e) {
      return null;
    }
  }

  /// تحديد نوع الموافقة بناءً على الدور
  /// - patient: موافقة فورية في معظم الحالات
  /// - clinic_admin: موافقة من super_admin
  /// - الموظفين: موافقة فورية من clinic_admin
  static String getApprovalStatusForRole(String role) {
    if (role == 'patient' || role == 'relative') {
      return 'approved'; // تسجيل ذاتي فوري
    }
    return 'pending'; // يحتاج موافقة من قبل المسؤول
  }

  /// التحقق من أن المستخدم يمكنه تعيين دور معين
  static bool canAssignRole({
    required String currentUserRole,
    required String targetRole,
  }) {
    // Super Admin يمكنه تعيين أي دور
    if (currentUserRole == 'super_admin') {
      return true;
    }

    // Clinic Admin يمكنه تعيين موظفين فقط
    if (currentUserRole == 'clinic_admin') {
      return clinicStaffRoles.any((r) => r.value == targetRole);
    }

    return false;
  }

  /// الحصول على الأدوار التي يمكن للمستخدم الحالي تعيينها
  static List<RoleOption> getAssignableRoles(String currentUserRole) {
    return getAvailableRoles(
      currentUserRole: currentUserRole,
      isPublicRegistration: false,
    );
  }
}
