/// ═══════════════════════════════════════════════════════════════
/// ROLE MANAGEMENT SERVICE
/// Professional Production Version
/// ═══════════════════════════════════════════════════════════════

library;

import 'dart:io' show SocketException;

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

  /// Get current user role from profiles table
  ///
  /// Process:
  /// 1. Check if cached and valid
  /// 2. Query profiles table directly (source of truth)
  /// 3. Cache the result for 5 minutes
  /// 4. Return UserRole.unknown only if profile not found
  static Future<UserRole> getCurrentUserRole({
    bool forceRefresh = false,
  }) async {
    try {
      final user = SupabaseConfig.currentUser;

      if (user == null) {
        return UserRole.unknown;
      }

      /// ✅ Return cached role if valid and not forcing refresh
      if (!forceRefresh && _cachedRole != null && _cacheTime != null) {
        final age = DateTime.now().difference(_cacheTime!);
        if (age < _cacheDuration) {
          return _cachedRole!;
        }
      }

      /// ✅ Query profiles table directly (source of truth)
      final roleFromDb = await _fetchRoleFromProfiles(user.id);

      if (roleFromDb != null) {
        _updateCache(roleFromDb);
        return roleFromDb;
      }

      /// ✅ No role found in profiles
      return UserRole.unknown;
    } catch (_) {
      /// Fallback to cache on error (graceful degradation)
      return _cachedRole ?? UserRole.unknown;
    }
  }

  /// Fetch role directly from profiles table
  ///
  /// This is the ONLY source of truth for user roles.
  /// profiles.id matches auth.users.id
  static Future<UserRole?> _fetchRoleFromProfiles(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .maybeSingle()
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Database query timeout');
        },
      );

      if (response == null) {
        return null;
      }

      final roleString = response['role'] as String?;
      if (roleString == null || roleString.isEmpty) {
        return null;
      }

      return UserRole.fromString(roleString);
    } on PostgrestException catch (e) {
      /// Handle Supabase-specific errors
      return null;
    } on SocketException catch (_) {
      /// Network error
      return null;
    } catch (_) {
      /// Generic error - gracefully return null
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

  /// Get approval status for current user
  /// Returns: 'pending', 'approved', 'rejected', or null if not found
  static Future<String?> getUserApprovalStatus() async {
    try {
      final user = SupabaseConfig.currentUser;

      if (user == null) return null;

      /// Query profiles table for approval status
      final response = await _client
          .from('profiles')
          .select('is_active')
          .eq('id', user.id)
          .maybeSingle()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => null,
          );

      if (response == null) {
        return null;
      }

      /// Return status based on is_active flag
      final isActive = response['is_active'] as bool?;
      if (isActive == true) {
        return 'approved';
      } else if (isActive == false) {
        return 'rejected';
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
