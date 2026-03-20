/// Advanced Authentication Events
/// أحداث المصادقة المتقدمة متعددة المستويات
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/role_model.dart';

/// Base class for all advanced auth events
abstract class AdvancedAuthEvent extends Equatable {
  const AdvancedAuthEvent();

  @override
  List<Object?> get props => [];
}

// ══════════════════════════════════════════════════════════════════════════════
// ROLE SELECTION EVENTS
// ══════════════════════════════════════════════════════════════════════════════

/// Load available roles for registration
class LoadAvailableRolesRequested extends AdvancedAuthEvent {
  const LoadAvailableRolesRequested({this.publicOnly = false});

  final bool publicOnly; // Only roles that don't require approval

  @override
  List<Object?> get props => [publicOnly];
}

/// User selected a role
class RoleSelected extends AdvancedAuthEvent {
  const RoleSelected(this.role);

  final RoleModel role;

  @override
  List<Object?> get props => [role];
}

// ══════════════════════════════════════════════════════════════════════════════
// REGISTRATION EVENTS
// ══════════════════════════════════════════════════════════════════════════════

/// Register with role and additional data
class RoleBasedRegistrationSubmitted extends AdvancedAuthEvent {
  const RoleBasedRegistrationSubmitted({
    required this.email,
    required this.password,
    required this.fullName,
    required this.roleId,
    this.phone,
    this.additionalData,
  });

  final String email;
  final String password;
  final String fullName;
  final String roleId;
  final String? phone;
  final Map<String, dynamic>? additionalData;

  @override
  List<Object?> get props =>
      [email, password, fullName, roleId, phone, additionalData];
}

// ══════════════════════════════════════════════════════════════════════════════
// EMAIL VERIFICATION EVENTS
// ══════════════════════════════════════════════════════════════════════════════

/// Send email verification link
class EmailVerificationRequested extends AdvancedAuthEvent {
  const EmailVerificationRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Verify email with token
class EmailVerificationTokenSubmitted extends AdvancedAuthEvent {
  const EmailVerificationTokenSubmitted({
    required this.userId,
    required this.token,
  });

  final String userId;
  final String token;

  @override
  List<Object?> get props => [userId, token];
}

/// User verified email successfully
class EmailVerifiedSuccessfully extends AdvancedAuthEvent {
  const EmailVerifiedSuccessfully(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

// ══════════════════════════════════════════════════════════════════════════════
// TWO-FACTOR AUTHENTICATION EVENTS
// ══════════════════════════════════════════════════════════════════════════════

/// Start 2FA setup process
class TwoFactorAuthSetupRequested extends AdvancedAuthEvent {
  const TwoFactorAuthSetupRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Verify 2FA code during setup
class TwoFactorAuthCodeSubmitted extends AdvancedAuthEvent {
  const TwoFactorAuthCodeSubmitted({
    required this.userId,
    required this.code,
  });

  final String userId;
  final String code;

  @override
  List<Object?> get props => [userId, code];
}

/// User enabled 2FA successfully
class TwoFactorAuthEnabledSuccessfully extends AdvancedAuthEvent {
  const TwoFactorAuthEnabledSuccessfully(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Verify 2FA code during login
class TwoFactorAuthVerificationRequested extends AdvancedAuthEvent {
  const TwoFactorAuthVerificationRequested({
    required this.userId,
    required this.code,
  });

  final String userId;
  final String code;

  @override
  List<Object?> get props => [userId, code];
}

// ══════════════════════════════════════════════════════════════════════════════
// REGISTRATION REQUEST APPROVAL EVENTS
// ══════════════════════════════════════════════════════════════════════════════

/// Load pending registration requests (for admin)
class LoadPendingRegistrationRequestsRequested extends AdvancedAuthEvent {
  const LoadPendingRegistrationRequestsRequested();
}

/// Admin approves a registration request
class RegistrationRequestApprovalSubmitted extends AdvancedAuthEvent {
  const RegistrationRequestApprovalSubmitted({
    required this.requestId,
    required this.approverUserId,
  });

  final String requestId;
  final String approverUserId;

  @override
  List<Object?> get props => [requestId, approverUserId];
}

/// Admin rejects a registration request
class RegistrationRequestRejectionSubmitted extends AdvancedAuthEvent {
  const RegistrationRequestRejectionSubmitted({
    required this.requestId,
    required this.approverUserId,
    required this.rejectionReason,
  });

  final String requestId;
  final String approverUserId;
  final String rejectionReason;

  @override
  List<Object?> get props => [requestId, approverUserId, rejectionReason];
}

/// Check user's own registration request status
class CheckUserRegistrationRequestStatus extends AdvancedAuthEvent {
  const CheckUserRegistrationRequestStatus(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

// ══════════════════════════════════════════════════════════════════════════════
// ROLE PERMISSIONS EVENTS
// ══════════════════════════════════════════════════════════════════════════════

/// Check if user has specific permission
class CheckUserPermissionRequested extends AdvancedAuthEvent {
  const CheckUserPermissionRequested({
    required this.userId,
    required this.permissionKey,
  });

  final String userId;
  final String permissionKey;

  @override
  List<Object?> get props => [userId, permissionKey];
}

/// Load user permissions
class LoadUserPermissionsRequested extends AdvancedAuthEvent {
  const LoadUserPermissionsRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

// ══════════════════════════════════════════════════════════════════════════════
// ACCOUNT SECURITY EVENTS
// ══════════════════════════════════════════════════════════════════════════════

/// Track failed login attempt
class LoginAttemptFailed extends AdvancedAuthEvent {
  const LoginAttemptFailed(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Lock user account after multiple failed attempts
class LockUserAccountRequested extends AdvancedAuthEvent {
  const LockUserAccountRequested({
    required this.userId,
    required this.lockDurationMinutes,
  });

  final String userId;
  final int lockDurationMinutes;

  @override
  List<Object?> get props => [userId, lockDurationMinutes];
}

/// Clear login attempts counter
class ClearLoginAttemptsRequested extends AdvancedAuthEvent {
  const ClearLoginAttemptsRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

// ══════════════════════════════════════════════════════════════════════════════
// VERIFICATION EVENTS
// ══════════════════════════════════════════════════════════════════════════════

/// Check if role verification is complete
class CheckRoleVerificationStatusRequested extends AdvancedAuthEvent {
  const CheckRoleVerificationStatusRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}
