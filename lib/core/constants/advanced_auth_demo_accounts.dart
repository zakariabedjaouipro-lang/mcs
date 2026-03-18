/// Demo Accounts for Advanced Authentication Testing
/// حسابات توضيحية لاختبار المصادقة المتقدمة
library;

import 'package:mcs/core/models/role_model.dart';

class AdvancedAuthDemoAccounts {
  // ── Predefined Roles ─────────────────────────────────────

  static final List<RoleModel> demoRoles = [
    RoleModel(
      id: '1',
      name: 'super_admin',
      displayNameAr: 'المسؤول الأعلى',
      displayNameEn: 'Super Admin',
      requiresApproval: false,
      requires2FA: true,
      requiresEmailVerification: true,
    ),
    RoleModel(
      id: '2',
      name: 'admin',
      displayNameAr: 'مسؤول',
      displayNameEn: 'Admin',
      requiresApproval: false,
      requires2FA: true,
      requiresEmailVerification: true,
    ),
    RoleModel(
      id: '3',
      name: 'doctor',
      displayNameAr: 'دكتور',
      displayNameEn: 'Doctor',
      requiresApproval: true,
      requires2FA: false,
      requiresEmailVerification: true,
    ),
    RoleModel(
      id: '4',
      name: 'patient',
      displayNameAr: 'مريض',
      displayNameEn: 'Patient',
      requiresApproval: false,
      requires2FA: false,
      requiresEmailVerification: true,
    ),
    RoleModel(
      id: '5',
      name: 'receptionist',
      displayNameAr: 'موظف استقبال',
      displayNameEn: 'Receptionist',
      requiresApproval: true,
      requires2FA: false,
      requiresEmailVerification: true,
    ),
  ];

  // ── Demo Patient Account ─────────────────────────────────

  static const Map<String, String> demoPatientAccount = {
    'email': 'patient.demo@mcs.local',
    'password': 'Demo@Patient123',
    'fullName': 'محمد علي أحمد',
    'fullNameEn': 'Mohammed Ali Ahmed',
    'phone': '+20100000001',
    'roleId': '4', // Patient
  };

  // ── Demo Doctor Account (Requires Approval) ──────────────

  static const Map<String, String> demoDoctorAccount = {
    'email': 'doctor.demo@mcs.local',
    'password': 'Demo@Doctor123',
    'fullName': 'د. فاطمة محمود',
    'fullNameEn': 'Dr. Fatima Mahmoud',
    'phone': '+20100000002',
    'roleId': '3', // Doctor
    'specialty': 'قلبية', // Cardiology
  };

  // ── Demo Admin Account ───────────────────────────────────

  static const Map<String, String> demoAdminAccount = {
    'email': 'admin.demo@mcs.local',
    'password': 'Demo@Admin123',
    'fullName': 'أحمد محمود سالم',
    'fullNameEn': 'Ahmed Mahmoud Salem',
    'phone': '+20100000003',
    'roleId': '2', // Admin
  };

  // ── Demo Super Admin Account ────────────────────────────

  static const Map<String, String> demoSuperAdminAccount = {
    'email': 'superadmin.demo@mcs.local',
    'password': 'Demo@SuperAdmin123',
    'fullName': 'سارة أحمد محمد',
    'fullNameEn': 'Sarah Ahmed Mohammed',
    'phone': '+20100000004',
    'roleId': '1', // Super Admin
  };

  // ── Demo Receptionist Account ────────────────────────────

  static const Map<String, String> demoReceptionistAccount = {
    'email': 'receptionist.demo@mcs.local',
    'password': 'Demo@Receptionist123',
    'fullName': 'عائشة محمود علي',
    'fullNameEn': 'Aisha Mahmoud Ali',
    'phone': '+20100000005',
    'roleId': '5', // Receptionist
  };

  // ── All Demo Accounts ────────────────────────────────────

  static const List<Map<String, String>> allDemoAccounts = [
    demoPatientAccount,
    demoDoctorAccount,
    demoAdminAccount,
    demoSuperAdminAccount,
    demoReceptionistAccount,
  ];

  // ── Demo Verification Tokens ────────────────────────────

  static const Map<String, String> demoVerificationTokens = {
    'patient': 'patient_verify_token_12345',
    'doctor': 'doctor_verify_token_12345',
    'admin': 'admin_verify_token_12345',
    'superadmin': 'superadmin_verify_token_12345',
    'receptionist': 'receptionist_verify_token_12345',
  };

  // ── Demo 2FA Secrets ────────────────────────────────────

  static const Map<String, String> demo2FASecrets = {
    'admin': 'JBSWY3DPEBLW64TMMQ======',
    'superadmin': 'JBSWY3DPEBLW64TMMQ======',
  };

  // ── Get Demo Account by Role ────────────────────────────

  static Map<String, String> getAccountByRole(String roleId) {
    switch (roleId) {
      case '4':
        return demoPatientAccount;
      case '3':
        return demoDoctorAccount;
      case '2':
        return demoAdminAccount;
      case '1':
        return demoSuperAdminAccount;
      case '5':
        return demoReceptionistAccount;
      default:
        return demoPatientAccount;
    }
  }

  // ── Registration Test Scenarios ──────────────────────────

  /// Scenario 1: Register as patient (no approval required)
  static const Map<String, dynamic> patientRegistrationScenario = {
    'description_ar': 'تسجيل مريض بدون موافقة',
    'description_en': 'Patient registration without approval',
    'email': 'new.patient@mcs.local',
    'password': 'Secure@Pass123',
    'fullName': 'مريض جديد',
    'fullNameEn': 'New Patient',
    'phone': '+20100000100',
    'roleId': '4',
    'expectedFlow': [
      'Show registration form',
      'Submit registration',
      'Show email verification screen',
      'Verify email',
      'Account activated immediately',
    ],
  };

  /// Scenario 2: Register as doctor (approval required)
  static const Map<String, dynamic> doctorRegistrationScenario = {
    'description_ar': 'تسجيل دكتور مع الموافقة',
    'description_en': 'Doctor registration with approval',
    'email': 'new.doctor@mcs.local',
    'password': 'Secure@Pass123',
    'fullName': 'دكتور جديد',
    'fullNameEn': 'New Doctor',
    'phone': '+20100000101',
    'specialty': 'طب عام',
    'roleId': '3',
    'expectedFlow': [
      'Show registration form',
      'Submit registration',
      'Show "awaiting admin approval" message',
      'Admin reviews request in dashboard',
      'Admin approves or rejects',
      'User receives email notification',
      'If approved, user can login',
    ],
  };
}
