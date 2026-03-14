/// ═══════════════════════════════════════════════════════════════
/// ROLE MANAGEMENT SERVICE
/// Professional Production Version
/// ═══════════════════════════════════════════════════════════════

library;

import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// User roles enum
enum UserRole {
  superAdmin,
  clinicAdmin,
  doctor,
  nurse,
  receptionist,
  pharmacist,
  labTechnician,
  radiographer,
  patient,
  unknown;

  /// Convert string to role
  static UserRole fromString(String? role) {
    if (role == null || role.isEmpty) return UserRole.unknown;

    switch (role.toLowerCase()) {
      case 'super_admin':
        return UserRole.superAdmin;

      case 'clinic_admin':
        return UserRole.clinicAdmin;

      case 'doctor':
        return UserRole.doctor;

      case 'nurse':
        return UserRole.nurse;

      case 'receptionist':
        return UserRole.receptionist;

      case 'pharmacist':
        return UserRole.pharmacist;

      case 'lab_technician':
        return UserRole.labTechnician;

      case 'radiographer':
        return UserRole.radiographer;

      case 'patient':
        return UserRole.patient;

      default:
        return UserRole.unknown;
    }
  }

  /// Convert enum to database string
  String get dbValue {
    switch (this) {
      case UserRole.superAdmin:
        return 'super_admin';

      case UserRole.clinicAdmin:
        return 'clinic_admin';

      case UserRole.doctor:
        return 'doctor';

      case UserRole.nurse:
        return 'nurse';

      case UserRole.receptionist:
        return 'receptionist';

      case UserRole.pharmacist:
        return 'pharmacist';

      case UserRole.labTechnician:
        return 'lab_technician';

      case UserRole.radiographer:
        return 'radiographer';

      case UserRole.patient:
        return 'patient';

      case UserRole.unknown:
        return 'unknown';
    }
  }

  /// Home route
  String get homeRoute {
    switch (this) {
      case UserRole.superAdmin:
        return AppRoutes.superAdminHome;

      case UserRole.clinicAdmin:
        return AppRoutes.adminHome;

      case UserRole.doctor:
        return AppRoutes.doctorHome;

      case UserRole.nurse:
      case UserRole.receptionist:
      case UserRole.pharmacist:
      case UserRole.labTechnician:
      case UserRole.radiographer:
        return AppRoutes.employeeHome;

      case UserRole.patient:
        return AppRoutes.patientHome;

      case UserRole.unknown:
        return AppRoutes.login;
    }
  }
}

/// Role service
class RoleManagementService {
  RoleManagementService._();

  static final _client = SupabaseConfig.client;

  /// Cached role
  static UserRole? _cachedRole;

  /// Cache timestamp
  static DateTime? _cacheTime;

  /// Cache duration
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Get current user role
  static Future<UserRole> getCurrentUserRole({
    bool forceRefresh = false,
  }) async {
    try {
      final user = SupabaseConfig.currentUser;

      if (user == null) {
        return UserRole.unknown;
      }

      /// Return cached role if valid
      if (!forceRefresh && _cachedRole != null && _cacheTime != null) {
        final age = DateTime.now().difference(_cacheTime!);

        if (age < _cacheDuration) {
          return _cachedRole!;
        }
      }

      /// Strategy 1
      final role = _readRoleFromMetadata(user);

      if (role != null) {
        _updateCache(role);
        return role;
      }

      /// Strategy 2
      final dbRole = await _getRoleFromDatabase(user.id);

      if (dbRole != null) {
        final parsedRole = UserRole.fromString(dbRole);
        _updateCache(parsedRole);
        return parsedRole;
      }

      return UserRole.unknown;
    } catch (_) {
      return UserRole.unknown;
    }
  }

  /// Read role from metadata
  static UserRole? _readRoleFromMetadata(User user) {
    try {
      final role = user.appMetadata['role'] ?? user.userMetadata?['role'];

      if (role is String && role.isNotEmpty) {
        return UserRole.fromString(role);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Query database
  static Future<String?> _getRoleFromDatabase(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();

      if (response != null && response['role'] != null) {
        return response['role'] as String;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Update cache
  static void _updateCache(UserRole role) {
    _cachedRole = role;
    _cacheTime = DateTime.now();
  }

  /// Clear cache
  static void clearCache() {
    _cachedRole = null;
    _cacheTime = null;
  }

  /// Get approval status
  static Future<String?> getUserApprovalStatus() async {
    try {
      final user = SupabaseConfig.currentUser;

      if (user == null) return null;

      final status = user.userMetadata?['approvalStatus'];

      if (status is String && status.isNotEmpty) {
        return status;
      }

      final response = await _client
          .from('users')
          .select('approval_status')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        return response['approval_status'] as String?;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Check if role requires approval
  static bool requiresApproval(UserRole role) {
    const roles = [
      UserRole.doctor,
      UserRole.nurse,
      UserRole.receptionist,
      UserRole.pharmacist,
      UserRole.labTechnician,
      UserRole.radiographer,
    ];

    return roles.contains(role);
  }

  /// Get route for current user
  static Future<String> getHomeRoute() async {
    final role = await getCurrentUserRole();
    return role.homeRoute;
  }

  /// Validate role
  static bool isValidRole(UserRole role) {
    return role != UserRole.unknown;
  }
}
