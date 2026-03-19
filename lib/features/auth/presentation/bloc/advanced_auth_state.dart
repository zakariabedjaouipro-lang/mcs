/// Advanced Authentication States
/// حالات المصادقة المتقدمة متعددة المستويات
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/registration_request_model.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/core/models/role_permissions_model.dart';
import 'package:mcs/core/models/user_profile_model.dart';

// أضف هذا الكلاس في advanced_auth_state.dart
class LoginAttemptsCleared extends AdvancedAuthState {
  const LoginAttemptsCleared({
    required this.userId,
    required this.message,
  });

  final String userId;
  final String message;

  @override
  List<Object?> get props => [userId, message];
}

/// Base class for all advanced auth states
abstract class AdvancedAuthState extends Equatable {
  const AdvancedAuthState();

  @override
  List<Object?> get props => [];
}

// ══════════════════════════════════════════════════════════════════════════════
// INITIAL STATES
// ══════════════════════════════════════════════════════════════════════════════

/// Initial state
class AdvancedAuthInitial extends AdvancedAuthState {
  const AdvancedAuthInitial();
}

/// Loading state
class AdvancedAuthLoading extends AdvancedAuthState {
  const AdvancedAuthLoading();
}

// ══════════════════════════════════════════════════════════════════════════════
// ROLE SELECTION STATES
// ══════════════════════════════════════════════════════════════════════════════

/// Roles loaded successfully
class RolesLoadedSuccess extends AdvancedAuthState {
  const RolesLoadedSuccess(this.roles);

  final List<RoleModel> roles;

  @override
  List<Object?> get props => [roles];
}

/// Failed to load roles
class RolesLoadedFailure extends AdvancedAuthState {
  const RolesLoadedFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Role selected
class RoleSelectedState extends AdvancedAuthState {
  const RoleSelectedState({
    required this.selectedRole,
    required this.requiresEmailVerification,
    required this.requires2FA,
    required this.requiresApproval,
  });

  final RoleModel selectedRole;
  final bool requiresEmailVerification;
  final bool requires2FA;
  final bool requiresApproval;

  @override
  List<Object?> get props => [
        selectedRole,
        requiresEmailVerification,
        requires2FA,
        requiresApproval,
      ];
}

// ══════════════════════════════════════════════════════════════════════════════
// REGISTRATION STATES
// ══════════════════════════════════════════════════════════════════════════════

/// Role-based registration successful
class RoleBasedRegistrationSuccess extends AdvancedAuthState {
  const RoleBasedRegistrationSuccess({
    required this.userProfile,
    required this.message,
    this.registrationRequest,
    this.requiresEmailVerification = false,
    this.pendingApproval = false,
  });

  final UserProfile userProfile;
  final String message;
  final RegistrationRequest? registrationRequest;
  final bool requiresEmailVerification;
  final bool pendingApproval;

  @override
  List<Object?> get props => [
        userProfile,
        message,
        registrationRequest,
        requiresEmailVerification,
        pendingApproval,
      ];
}

/// Role-based registration failure
class RoleBasedRegistrationFailure extends AdvancedAuthState {
  const RoleBasedRegistrationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ══════════════════════════════════════════════════════════════════════════════
// EMAIL VERIFICATION STATES
// ══════════════════════════════════════════════════════════════════════════════

/// Email verification link sent
class EmailVerificationLinkSent extends AdvancedAuthState {
  const EmailVerificationLinkSent({
    required this.email,
    required this.message,
  });

  final String email;
  final String message;

  @override
  List<Object?> get props => [email, message];
}

/// Email verified successfully
class EmailVerifiedSuccess extends AdvancedAuthState {
  const EmailVerifiedSuccess({
    required this.userId,
    required this.message,
  });

  final String userId;
  final String message;

  @override
  List<Object?> get props => [userId, message];
}

/// Email verification failure
class EmailVerificationFailure extends AdvancedAuthState {
  const EmailVerificationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ══════════════════════════════════════════════════════════════════════════════
// TWO-FACTOR AUTHENTICATION STATES
// ══════════════════════════════════════════════════════════════════════════════

/// 2FA setup started (user receives QR code)
class TwoFactorAuthSetupStarted extends AdvancedAuthState {
  const TwoFactorAuthSetupStarted({
    required this.userId,
    required this.secret,
    required this.qrCode,
  });

  final String userId;
  final String secret;
  final String qrCode;

  @override
  List<Object?> get props => [userId, secret, qrCode];
}

/// 2FA enabled successfully
class TwoFactorAuthEnabledSuccess extends AdvancedAuthState {
  const TwoFactorAuthEnabledSuccess({
    required this.userId,
    required this.backupCodes,
    required this.message,
  });

  final String userId;
  final List<String> backupCodes;
  final String message;

  @override
  List<Object?> get props => [userId, backupCodes, message];
}

/// 2FA verification required during login
class TwoFactorAuthVerificationRequired extends AdvancedAuthState {
  const TwoFactorAuthVerificationRequired({
    required this.userId,
    required this.method, // 'totp' or 'sms'
  });

  final String userId;
  final String method;

  @override
  List<Object?> get props => [userId, method];
}

/// 2FA verification success
class TwoFactorAuthVerificationSuccess extends AdvancedAuthState {
  const TwoFactorAuthVerificationSuccess({
    required this.userId,
    required this.message,
  });

  final String userId;
  final String message;

  @override
  List<Object?> get props => [userId, message];
}

/// 2FA verification failure
class TwoFactorAuthVerificationFailure extends AdvancedAuthState {
  const TwoFactorAuthVerificationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ══════════════════════════════════════════════════════════════════════════════
// REGISTRATION REQUEST APPROVAL STATES
// ══════════════════════════════════════════════════════════════════════════════

/// Pending requests loaded
class PendingRegistrationRequestsLoaded extends AdvancedAuthState {
  const PendingRegistrationRequestsLoaded(this.requests);

  final List<RegistrationRequest> requests;

  @override
  List<Object?> get props => [requests];
}

/// Registration request approved successfully
class RegistrationRequestApprovedSuccess extends AdvancedAuthState {
  const RegistrationRequestApprovedSuccess({
    required this.requestId,
    required this.message,
  });

  final String requestId;
  final String message;

  @override
  List<Object?> get props => [requestId, message];
}

/// Registration request rejected successfully
class RegistrationRequestRejectedSuccess extends AdvancedAuthState {
  const RegistrationRequestRejectedSuccess({
    required this.requestId,
    required this.message,
  });

  final String requestId;
  final String message;

  @override
  List<Object?> get props => [requestId, message];
}

/// Registration request approval failure
class RegistrationRequestApprovalFailure extends AdvancedAuthState {
  const RegistrationRequestApprovalFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// User registration request status
class UserRegistrationRequestStatus extends AdvancedAuthState {
  const UserRegistrationRequestStatus({
    required this.status,
    this.request,
    required this.message,
  });

  final String status; // 'pending', 'approved', 'rejected', 'none'
  final RegistrationRequest? request;
  final String message;

  @override
  List<Object?> get props => [status, request, message];
}

// ══════════════════════════════════════════════════════════════════════════════
// ROLE PERMISSIONS STATES
// ══════════════════════════════════════════════════════════════════════════════

/// User permissions loaded
class UserPermissionsLoaded extends AdvancedAuthState {
  const UserPermissionsLoaded({
    required this.userId,
    required this.permissions,
  });

  final String userId;
  final RolePermissions permissions;

  @override
  List<Object?> get props => [userId, permissions];
}

/// Permission check result
class PermissionCheckResult extends AdvancedAuthState {
  const PermissionCheckResult({
    required this.userId,
    required this.permissionKey,
    required this.hasPermission,
  });

  final String userId;
  final String permissionKey;
  final bool hasPermission;

  @override
  List<Object?> get props => [userId, permissionKey, hasPermission];
}

/// Permissions loading failure
class PermissionsLoadingFailure extends AdvancedAuthState {
  const PermissionsLoadingFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ══════════════════════════════════════════════════════════════════════════════
// ACCOUNT SECURITY STATES
// ══════════════════════════════════════════════════════════════════════════════

/// User account locked due to multiple failed attempts
class UserAccountLockedState extends AdvancedAuthState {
  const UserAccountLockedState({
    required this.userId,
    required this.lockedUntil,
    required this.message,
  });

  final String userId;
  final DateTime lockedUntil;
  final String message;

  @override
  List<Object?> get props => [userId, lockedUntil, message];
}

// ══════════════════════════════════════════════════════════════════════════════
// VERIFICATION COMPLETE STATES
// ══════════════════════════════════════════════════════════════════════════════

/// Role verification complete
class RoleVerificationComplete extends AdvancedAuthState {
  const RoleVerificationComplete({
    required this.userId,
    required this.isComplete,
    required this.message,
  });

  final String userId;
  final bool isComplete;
  final String message;

  @override
  List<Object?> get props => [userId, isComplete, message];
}

// ══════════════════════════════════════════════════════════════════════════════
// ERROR STATES
// ══════════════════════════════════════════════════════════════════════════════

/// Generic error state
class AdvancedAuthError extends AdvancedAuthState {
  const AdvancedAuthError({
    required this.message,
    this.code,
  });

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}
