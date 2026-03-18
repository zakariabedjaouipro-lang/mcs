/// Advanced Authentication Repository Interface
/// واجهة مستودع المصادقة المتقدمة
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/registration_request_model.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/core/models/role_permissions_model.dart';
import 'package:mcs/core/models/user_profile_model.dart';

abstract class AdvancedAuthRepository {
  // ── Role Management ──────────────────────────────────────

  /// Get all available roles
  Future<Either<Failure, List<RoleModel>>> getAllRoles();

  /// Get public roles only (no approval required)
  Future<Either<Failure, List<RoleModel>>> getPublicRoles();

  /// Get role by ID
  Future<Either<Failure, RoleModel?>> getRoleById(String roleId);

  // ── Permission Management ────────────────────────────────

  /// Get permissions for a specific role
  Future<Either<Failure, RolePermissions>> getRolePermissions(String roleId);

  // ── Registration Requests ────────────────────────────────

  /// Create a new registration request
  Future<Either<Failure, RegistrationRequest>> createRegistrationRequest({
    required String userId,
    required String roleId,
    Map<String, dynamic>? requestedData,
  });

  /// Get a specific registration request
  Future<Either<Failure, RegistrationRequest?>> getRegistrationRequest(
    String requestId,
  );

  /// Get user's own registration request
  Future<Either<Failure, RegistrationRequest?>> getUserRegistrationRequest(
    String userId,
  );

  /// Get all pending registration requests (for admin)
  Future<Either<Failure, List<RegistrationRequest>>>
      getPendingRegistrationRequests();

  /// Approve a registration request
  Future<Either<Failure, RegistrationRequest>> approveRegistrationRequest({
    required String requestId,
    required String reviewedBy,
  });

  /// Reject a registration request
  Future<Either<Failure, RegistrationRequest>> rejectRegistrationRequest({
    required String requestId,
    required String reviewedBy,
    required String rejectionReason,
  });

  // ── User Profile Management ──────────────────────────────

  /// Create a user profile
  Future<Either<Failure, UserProfile>> createUserProfile({
    required String userId,
    required String email,
    required String fullName,
    String? roleId,
    String? phone,
    String? avatarUrl,
  });

  /// Get user profile
  Future<Either<Failure, UserProfile?>> getUserProfile(String userId);

  /// Update user profile
  Future<Either<Failure, UserProfile>> updateUserProfile({
    required String userId,
    String? email,
    String? fullName,
    String? phone,
    String? avatarUrl,
  });

  // ── Verification Management ──────────────────────────────

  /// Mark email as verified for user
  Future<Either<Failure, bool>> verifyEmailForUser(String userId);

  /// Check if email is verified
  Future<Either<Failure, bool>> isEmailVerified(String userId);

  /// Enable 2FA for user
  Future<Either<Failure, bool>> enable2FAForUser(String userId);

  /// Check if 2FA is enabled
  Future<Either<Failure, bool>> is2FAEnabled(String userId);

  // ── Helper Methods ───────────────────────────────────────

  /// Check if email verification is required for role
  bool isEmailVerificationRequiredForRole(RoleModel role);

  /// Check if 2FA is required for role
  bool is2FARequiredForRole(RoleModel role);

  /// Check if approval is required for role
  bool isApprovalRequiredForRole(RoleModel role);
}
