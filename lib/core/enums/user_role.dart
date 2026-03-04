/// User roles in the system.
///
/// Values match the `user_role` PostgreSQL enum in Supabase exactly.
/// Database migration: 001_create_enums.sql
/// Version: 1.0.0
library;

enum UserRole {
  superAdmin('super_admin', 'مدير النظام', 'Super Admin'),
  clinicAdmin('clinic_admin', 'مدير العيادة', 'Clinic Administrator'),
  doctor('doctor', 'طبيب', 'Doctor'),
  nurse('nurse', 'ممرض', 'Nurse'),
  receptionist('receptionist', 'موظف استقبال', 'Receptionist'),
  pharmacist('pharmacist', 'صيدلي', 'Pharmacist'),
  labTechnician('lab_technician', 'فني مختبر', 'Lab Technician'),
  radiographer('radiographer', 'أخصائي أشعة', 'Radiographer'),
  patient('patient', 'مريض', 'Patient'),
  relative('relative', 'قريب', 'Relative');

  const UserRole(this.dbValue, this.labelAr, this.labelEn);

  /// The value stored in the database.
  final String dbValue;

  /// Arabic display label.
  final String labelAr;

  /// English display label.
  final String labelEn;

  /// Returns the localised label based on the given locale code.
  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  /// Resolves a [UserRole] from its database string value.
  ///
  /// Throws [ArgumentError] if no match is found.
  static UserRole fromDbValue(String value) {
    return UserRole.values.firstWhere(
      (r) => r.dbValue == value,
      orElse: () => throw ArgumentError('Unknown UserRole: $value'),
    );
  }

  // ── Role Group Helpers ───────────────────────────────────

  /// Whether this role has admin-level access.
  bool get isAdmin => this == superAdmin || this == clinicAdmin;

  /// Whether this role is a type of patient or family member.
  bool get isPatientType =>
      this == patient || this == relative;

  /// Whether this role is a clinic employee (non-doctor).
  bool get isEmployee =>
      this == receptionist ||
      this == nurse ||
      this == pharmacist ||
      this == labTechnician ||
      this == radiographer;

  /// Whether this role is a medical professional.
  bool get isMedical =>
      this == doctor ||
      this == nurse ||
      this == pharmacist ||
      this == labTechnician ||
      this == radiographer;

  /// Whether this role is technical staff.
  bool get isTechnical => this == labTechnician || this == radiographer;
}
