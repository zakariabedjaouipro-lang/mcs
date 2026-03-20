/// Service for creating and managing demo/test accounts for development.
///
/// Provides methods to create and verify demo accounts for all user roles:
/// - Super Admin (super_admin)
/// - Clinic Admin (clinic_admin)
/// - Doctor (doctor)
/// - Nurse (nurse)
/// - Receptionist (receptionist)
/// - Pharmacist (pharmacist)
/// - Lab Technician (lab_technician)
/// - Radiographer (radiographer)
/// - Patient (patient)
/// - Relative (relative)
library;

import 'dart:developer';

import 'package:mcs/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DemoAccountService {
  DemoAccountService({SupabaseClient? client, GoTrueClient? auth})
      : _client = client ?? SupabaseConfig.client,
        _auth = auth ?? SupabaseConfig.auth;

  final SupabaseClient _client;
  final GoTrueClient _auth;

  // ── Demo Account Credentials ──────────────────────────

  static const String _demoPassword = 'Password123!';

  /// جميع الأدوار العشرة مع بريد إلكتروني لكل دور
  static const Map<String, String> demoAccounts = {
    'super_admin': 'super@example.com',
    'clinic_admin': 'clinic@example.com',
    'doctor': 'doctor@example.com',
    'nurse': 'nurse@example.com',
    'receptionist': 'reception@example.com',
    'pharmacist': 'pharmacy@example.com',
    'lab_technician': 'lab@example.com',
    'radiographer': 'radio@example.com',
    'patient': 'patient@example.com',
    'relative': 'relative@example.com',
  };

  // ── Public Methods ────────────────────────────────────

  /// Creates all demo accounts if they don't already exist.
  /// Returns a map of created account details.
  Future<Map<String, DemoAccountResult>> createAllDemoAccounts() async {
    final results = <String, DemoAccountResult>{};

    log(
      '🚀 Starting demo account creation for all 10 roles...',
      name: 'DemoAccountService',
      level: 800,
    );

    for (final entry in demoAccounts.entries) {
      final role = entry.key;
      final email = entry.value;

      try {
        final result = await _createDemoAccount(
          role: role,
          email: email,
        );
        results[role] = result;

        log(
          '✅ $role account created/verified: $email',
          name: 'DemoAccountService',
          level: 800,
        );
      } catch (e, st) {
        log(
          '❌ Failed to create $role account: $e',
          name: 'DemoAccountService',
          level: 1000,
          stackTrace: st,
        );
        results[role] = DemoAccountResult(
          role: role,
          email: email,
          success: false,
          message: 'Error: $e',
        );
      }
    }

    return results;
  }

  /// Creates a specific demo account by role.
  Future<DemoAccountResult> createDemoAccountByRole(String role) async {
    if (!demoAccounts.containsKey(role)) {
      throw ArgumentError(
          'Invalid role: $role. Available roles: ${demoAccounts.keys.join(', ')}');
    }

    final email = demoAccounts[role]!;
    return _createDemoAccount(role: role, email: email);
  }

  /// Checks if a demo account exists in Auth.
  Future<bool> demoAccountExists(String role) async {
    if (!demoAccounts.containsKey(role)) {
      return false;
    }

    final email = demoAccounts[role]!;

    try {
      // Try to sign in with the demo account
      await _auth.signInWithPassword(
        email: email,
        password: _demoPassword,
      );
      return true;
    } catch (e) {
      // Account doesn't exist or password is wrong
      return false;
    }
  }

  /// Gets all demo account credentials (for testing purposes only).
  Map<String, Map<String, String>> getAllDemoCredentials() {
    return {
      for (final entry in demoAccounts.entries)
        entry.key: {'email': entry.value, 'password': _demoPassword},
    };
  }

  // ── Private Methods ───────────────────────────────────

  /// Creates a demo account with the given role and email.
  Future<DemoAccountResult> _createDemoAccount({
    required String role,
    required String email,
  }) async {
    try {
      // Check if account already exists
      if (await demoAccountExists(role)) {
        return DemoAccountResult(
          role: role,
          email: email,
          success: true,
          message: 'Demo account already exists',
        );
      }

      final authResponse = await _auth.signUp(
        email: email,
        password: _demoPassword,
        data: {
          'full_name': _getDemoFullName(role),
          'phone': _getDemoPhone(role),
          'role': role,
          'approvalStatus': 'approved', // الموافقة التلقائية للحسابات التجريبية
          'registrationType': 'demo',
        },
      );

      final userId = authResponse.user?.id;
      if (userId == null) {
        throw Exception('Failed to create user in auth');
      }

      // Create user record in users table
      await _createUserRecord(userId, email, role);

      // Create role-specific records
      await _createRoleSpecificRecords(userId, role);

      // Create approval record
      await _createApprovalRecord(userId, email, role);

      return DemoAccountResult(
        role: role,
        email: email,
        userId: userId,
        success: true,
        message: 'Demo account created successfully',
        isNewlyCreated: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a user record in the users table.
  Future<void> _createUserRecord(
    String userId,
    String email,
    String role,
  ) async {
    try {
      await _client.from('users').upsert({
        'id': userId,
        'email': email,
        'first_name': _getDemoFirstName(role),
        'last_name': _getDemoLastName(role),
        'phone': _getDemoPhone(role),
        'role': role,
        'is_active': true,
        'locale': 'ar',
      });
    } catch (e) {
      // User record might already exist, that's okay
      log(
        'Info: User record creation skipped (might already exist): $e',
        name: 'DemoAccountService',
        level: 500,
      );
    }
  }

  /// Creates an approval record in the user_approvals table.
  Future<void> _createApprovalRecord(
    String userId,
    String email,
    String role,
  ) async {
    try {
      await _client.from('user_approvals').upsert({
        'user_id': userId,
        'email': email,
        'full_name': _getDemoFullName(role),
        'role': role,
        'registration_type': 'demo',
        'status': 'approved', // موافقة تلقائية للحسابات التجريبية
      });
    } catch (e) {
      log(
        'Warning: Failed to create approval record: $e',
        name: 'DemoAccountService',
        level: 900,
      );
    }
  }

  /// Creates role-specific records (doctor, patient, nurse, etc.).
  Future<void> _createRoleSpecificRecords(
    String userId,
    String role,
  ) async {
    try {
      switch (role) {
        case 'doctor':
          await _createDoctorRecord(userId);
        case 'patient':
          await _createPatientRecord(userId);
        case 'nurse':
          await _createNurseRecord(userId);
        case 'receptionist':
          await _createReceptionistRecord(userId);
        case 'pharmacist':
          await _createPharmacistRecord(userId);
        case 'lab_technician':
          await _createLabTechnicianRecord(userId);
        case 'radiographer':
          await _createRadiographerRecord(userId);
        case 'relative':
          await _createRelativeRecord(userId);
        case 'super_admin':
        case 'clinic_admin':
          // Admin roles don't need specific records
          break;
      }
    } catch (e) {
      log(
        'Warning: Failed to create role-specific record: $e',
        name: 'DemoAccountService',
        level: 900,
      );
    }
  }

  /// Creates a doctor record.
  Future<void> _createDoctorRecord(String userId) async {
    await _client.from('doctors').upsert({
      'user_id': userId,
      'specialization': 'طب عام',
      'bio': 'طبيب تجريبي لاختبار النظام',
      'license_number': 'DOC-DEMO-001',
      'years_of_experience': 8,
      'is_available': true,
      'consultation_fee': 150.00,
      'rating': 4.5,
    });
  }

  /// Creates a patient record.
  Future<void> _createPatientRecord(String userId) async {
    await _client.from('patients').upsert({
      'user_id': userId,
      'date_of_birth': '1985-05-15',
      'gender': 'male',
      'blood_type': 'O+',
      'allergies': ['بنسلين'],
      'medical_history': ['لا يوجد'],
      'emergency_contact_name': 'أحمد المريض',
      'emergency_contact_phone': '+213551234567',
    });
  }

  /// Creates a nurse record.
  Future<void> _createNurseRecord(String userId) async {
    await _client.from('nurses').upsert({
      'user_id': userId,
      'specialization': 'تمريض عام',
      'license_number': 'NRS-DEMO-001',
      'years_of_experience': 5,
      'shift': 'صباحي',
    });
  }

  /// Creates a receptionist record.
  Future<void> _createReceptionistRecord(String userId) async {
    await _client.from('receptionists').upsert({
      'user_id': userId,
      'department': 'استقبال',
      'languages': ['العربية', 'الإنجليزية'],
      'years_of_experience': 3,
    });
  }

  /// Creates a pharmacist record.
  Future<void> _createPharmacistRecord(String userId) async {
    await _client.from('pharmacists').upsert({
      'user_id': userId,
      'license_number': 'PHM-DEMO-001',
      'specialization': 'صيدلة سريرية',
      'years_of_experience': 4,
    });
  }

  /// Creates a lab technician record.
  Future<void> _createLabTechnicianRecord(String userId) async {
    await _client.from('lab_technicians').upsert({
      'user_id': userId,
      'specialization': 'تحاليل طبية',
      'license_number': 'LAB-DEMO-001',
      'years_of_experience': 6,
    });
  }

  /// Creates a radiographer record.
  Future<void> _createRadiographerRecord(String userId) async {
    await _client.from('radiographers').upsert({
      'user_id': userId,
      'specialization': 'أشعة تشخيصية',
      'license_number': 'RAD-DEMO-001',
      'years_of_experience': 7,
    });
  }

  /// Creates a relative record.
  Future<void> _createRelativeRecord(String userId) async {
    await _client.from('relatives').upsert({
      'user_id': userId,
      'relationship_type': 'parent',
      'is_primary_contact': true,
    });
  }

  /// Gets the full name for a demo account by role.
  String _getDemoFullName(String role) {
    switch (role) {
      case 'super_admin':
        return 'مدير النظام';
      case 'clinic_admin':
        return 'مدير العيادة';
      case 'doctor':
        return 'د. أحمد محمد';
      case 'nurse':
        return 'م. فاطمة علي';
      case 'receptionist':
        return 'موظف استقبال';
      case 'pharmacist':
        return 'صيدلي';
      case 'lab_technician':
        return 'فني مختبر';
      case 'radiographer':
        return 'أخصائي أشعة';
      case 'patient':
        return 'مريض';
      case 'relative':
        return 'قريب';
      default:
        return 'مستخدم تجريبي';
    }
  }

  /// Gets the first name for a demo account by role.
  String _getDemoFirstName(String role) {
    switch (role) {
      case 'super_admin':
        return 'مدير';
      case 'clinic_admin':
        return 'مدير';
      case 'doctor':
        return 'أحمد';
      case 'nurse':
        return 'فاطمة';
      case 'receptionist':
        return 'موظف';
      case 'pharmacist':
        return 'صيدلي';
      case 'lab_technician':
        return 'فني';
      case 'radiographer':
        return 'أخصائي';
      case 'patient':
        return 'مريض';
      case 'relative':
        return 'قريب';
      default:
        return 'مستخدم';
    }
  }

  /// Gets the last name for a demo account by role.
  String _getDemoLastName(String role) {
    switch (role) {
      case 'super_admin':
        return 'النظام';
      case 'clinic_admin':
        return 'العيادة';
      case 'doctor':
        return 'محمد';
      case 'nurse':
        return 'علي';
      case 'receptionist':
        return 'استقبال';
      case 'pharmacist':
        return '';
      case 'lab_technician':
        return 'مختبر';
      case 'radiographer':
        return 'أشعة';
      case 'patient':
        return '';
      case 'relative':
        return '';
      default:
        return '';
    }
  }

  /// Gets the phone number for a demo account by role.
  String _getDemoPhone(String role) {
    return '+213666123456';
  }
}

/// Result of a demo account creation attempt.
class DemoAccountResult {
  const DemoAccountResult({
    required this.role,
    required this.email,
    required this.success,
    required this.message,
    this.userId,
    this.isNewlyCreated = false,
  });

  /// The role of the account.
  final String role;

  /// The email address of the account.
  final String email;

  /// Whether the account creation was successful.
  final bool success;

  /// Status message describing the result.
  final String message;

  /// The user ID if created successfully.
  final String? userId;

  /// Whether this is a newly created account (vs. already existed).
  final bool isNewlyCreated;

  @override
  String toString() {
    return 'DemoAccountResult(role: $role, email: $email, success: $success, message: $message)';
  }
}
