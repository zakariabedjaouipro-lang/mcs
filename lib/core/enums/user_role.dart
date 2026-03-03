/// User roles in the system.
///
/// Values match the `user_role` PostgreSQL enum in Supabase.
library;

enum UserRole {
  superAdmin('super_admin', 'مدير النظام', 'Super Admin'),
  clinicManager('clinic_manager', 'مدير العيادة', 'Clinic Manager'),
  doctor('doctor', 'طبيب', 'Doctor'),
  patient('patient', 'مريض', 'Patient'),
  remotePatient('remote_patient', 'مريض عن بعد', 'Remote Patient'),
  guardian('guardian', 'ولي أمر', 'Guardian'),
  autismTherapist('autism_therapist', 'معالج توحد', 'Autism Therapist'),
  receptionist('receptionist', 'موظف استقبال', 'Receptionist'),
  nurse('nurse', 'ممرض', 'Nurse'),
  technician('technician', 'فني مختبر', 'Technician'),
  administrative('administrative', 'إداري', 'Administrative');

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
  bool get isAdmin => this == superAdmin || this == clinicManager;

  /// Whether this role is a type of patient.
  bool get isPatientType =>
      this == patient || this == remotePatient || this == guardian;

  /// Whether this role is a clinic employee (non-doctor).
  bool get isEmployee =>
      this == receptionist ||
      this == nurse ||
      this == technician ||
      this == administrative;

  /// Whether this role is a medical professional.
  bool get isMedical => this == doctor || this == nurse || this == technician;
}
