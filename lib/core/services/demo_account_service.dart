/// Service for creating and managing demo/test accounts for development.
///
/// Provides methods to create and verify demo accounts for all user roles:
/// - Super Admin
/// - Admin
/// - Doctor
/// - Patient
/// - Employee
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

  static const String _demoPassword = 'Demo@123456';

  static const Map<String, String> demoAccounts = {
    'super_admin': 'superadmin@demo.com',
    'admin': 'admin@demo.com',
    'doctor': 'doctor@demo.com',
    'patient': 'patient@demo.com',
    'employee': 'employee@demo.com',
  };

  // ── Public Methods ────────────────────────────────────

  /// Creates all demo accounts if they don't already exist.
  /// Returns a map of created account details.
  Future<Map<String, DemoAccountResult>> createAllDemoAccounts() async {
    final results = <String, DemoAccountResult>{};

    log(
      '🚀 Starting demo account creation...',
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
      throw ArgumentError('Invalid role: $role');
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
          'name': _getDemoFullName(role),
          'phone': _getDemoPhone(role),
          'role': role,
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
      await _client.from('users').insert({
        'id': userId,
        'email': email,
        'full_name': _getDemoFullName(role),
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

  /// Creates role-specific records (doctor, patient, employee, etc.).
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
        case 'employee':
          await _createEmployeeRecord(userId);
        case 'admin':
        case 'super_admin':
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
    await _client.from('doctors').insert({
      'user_id': userId,
      'specialization': 'عام',
      'bio': 'طبيب تجريبي لاختبار النظام',
      'license_number': 'LIC-DEMO-001',
      'years_of_experience': 5,
      'is_available': true,
      'consultation_fee': 100,
      'created_by': userId,
    });
  }

  /// Creates a patient record.
  Future<void> _createPatientRecord(String userId) async {
    await _client.from('patients').insert({
      'user_id': userId,
      'date_of_birth': '1990-01-01',
      'gender': 'M',
      'blood_type': 'O+',
      'allergies': '[]',
      'medical_history': '[]',
      'emergency_contact_name': 'اسم آخر',
      'emergency_contact_phone': '0123456789',
      'created_by': userId,
    });
  }

  /// Creates an employee record.
  Future<void> _createEmployeeRecord(String userId) async {
    await _client.from('employees').insert({
      'user_id': userId,
      'position': 'موظف تجريبي',
      'department': 'عام',
      'hire_date': DateTime.now().toIso8601String(),
      'is_active': true,
      'created_by': userId,
    });
  }

  /// Gets the full name for a demo account by role.
  String _getDemoFullName(String role) {
    switch (role) {
      case 'super_admin':
        return 'Super Administrator';
      case 'admin':
        return 'Administrator';
      case 'doctor':
        return 'Dr. Demo Doctor';
      case 'patient':
        return 'Demo Patient';
      case 'employee':
        return 'Demo Employee';
      default:
        return 'Demo User';
    }
  }

  /// Gets the phone number for a demo account by role.
  String _getDemoPhone(String role) {
    return '+213612345678';
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

  /// The role of the account (super_admin, admin, doctor, patient, employee).
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
