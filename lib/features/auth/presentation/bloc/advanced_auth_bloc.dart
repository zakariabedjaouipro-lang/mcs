/// Advanced Authentication BLoC
/// منطق المصادقة المتقدمة متعدد المستويات
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/services/role_based_authentication_service.dart';
import 'package:mcs/core/models/role_permissions_model.dart';
import 'package:mcs/core/models/user_profile_model.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/features/auth/domain/usecases/role_registration_usecases.dart';

import 'advanced_auth_event.dart';
import 'advanced_auth_state.dart';

/// BLoC for advanced role-based authentication
class AdvancedAuthBloc extends Bloc<AdvancedAuthEvent, AdvancedAuthState> {
  AdvancedAuthBloc({
    required this.roleBasedAuthService,
    required this.supabaseService,
    required this.getAllRolesUseCase,
    required this.getPublicRolesUseCase,
    required this.getRolePermissionsUseCase,
    required this.createRegistrationRequestUseCase,
    required this.verifyEmailUseCase,
    required this.enable2FAUseCase,
    required this.getPendingRegistrationRequestsUseCase,
    required this.approveRegistrationRequestUseCase,
    required this.rejectRegistrationRequestUseCase,
  }) : super(const AdvancedAuthInitial()) {
    // Role loading events
    on<LoadAvailableRolesRequested>(_onLoadAvailableRolesRequested);
    on<RoleSelected>(_onRoleSelected);

    // Registration events
    on<RoleBasedRegistrationSubmitted>(_onRoleBasedRegistrationSubmitted);

    // Email verification events
    on<EmailVerificationRequested>(_onEmailVerificationRequested);
    on<EmailVerificationTokenSubmitted>(_onEmailVerificationTokenSubmitted);
    on<EmailVerifiedSuccessfully>(_onEmailVerifiedSuccessfully);

    // 2FA setup events
    on<TwoFactorAuthSetupRequested>(_onTwoFactorAuthSetupRequested);
    on<TwoFactorAuthCodeSubmitted>(_onTwoFactorAuthCodeSubmitted);
    on<TwoFactorAuthEnabledSuccessfully>(_onTwoFactorAuthEnabledSuccessfully);

    // 2FA login verification
    on<TwoFactorAuthVerificationRequested>(
        _onTwoFactorAuthVerificationRequested);

    // Approval workflow events
    on<LoadPendingRegistrationRequestsRequested>(
      _onLoadPendingRegistrationRequestsRequested,
    );
    on<RegistrationRequestApprovalSubmitted>(
      _onRegistrationRequestApprovalSubmitted,
    );
    on<RegistrationRequestRejectionSubmitted>(
      _onRegistrationRequestRejectionSubmitted,
    );

    // Request status check
    on<CheckUserRegistrationRequestStatus>(
        _onCheckUserRegistrationRequestStatus);

    // Permissions events
    on<CheckUserPermissionRequested>(_onCheckUserPermissionRequested);
    on<LoadUserPermissionsRequested>(_onLoadUserPermissionsRequested);

    // Account security events
    on<LoginAttemptFailed>(_onLoginAttemptFailed);
    on<LockUserAccountRequested>(_onLockUserAccountRequested);
    on<ClearLoginAttemptsRequested>(_onClearLoginAttemptsRequested);

    // Verification status
    on<CheckRoleVerificationStatusRequested>(
        _onCheckRoleVerificationStatusRequested);
  }

  final RoleBasedAuthenticationService roleBasedAuthService;
  final SupabaseService supabaseService;
  final GetAllRolesUseCase getAllRolesUseCase;
  final GetPublicRolesUseCase getPublicRolesUseCase;
  final GetRolePermissionsUseCase getRolePermissionsUseCase;
  final CreateRegistrationRequestUseCase createRegistrationRequestUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final Enable2FAUseCase enable2FAUseCase;
  final GetPendingRegistrationRequestsUseCase
      getPendingRegistrationRequestsUseCase;
  final ApproveRegistrationRequestUseCase approveRegistrationRequestUseCase;
  final RejectRegistrationRequestUseCase rejectRegistrationRequestUseCase;

  // ═══════════════════════════════════════════════════════════════════════════
  // Role Loading Handlers
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _onLoadAvailableRolesRequested(
    LoadAvailableRolesRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      final result = event.publicOnly
          ? await getPublicRolesUseCase(const NoParams())
          : await getAllRolesUseCase(const NoParams());

      result.fold(
        (failure) {
          _handleFailure(failure, emit);
        },
        (roles) {
          emit(RolesLoadedSuccess(roles));
        },
      );
    } catch (e) {
      _log('Error loading roles: $e');
      emit(AdvancedAuthError(message: 'Failed to load roles: $e'));
    }
  }

  Future<void> _onRoleSelected(
    RoleSelected event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    try {
      final role = event.role;
      emit(RoleSelectedState(
        selectedRole: role,
        requiresEmailVerification: role.requiresEmailVerification,
        requires2FA: role.requires2FA,
        requiresApproval: role.requiresApproval,
      ));
    } catch (e) {
      _log('Error selecting role: $e');
      emit(AdvancedAuthError(message: 'Failed to select role: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Registration Handlers
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _onRoleBasedRegistrationSubmitted(
    RoleBasedRegistrationSubmitted event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      // Note: In a real implementation, you would create the user account via Auth
      // and get the userId from there. This is a placeholder implementation.
      _log('Registering user with role: ${event.roleId}');

      // Check if approval is required
      final role = await roleBasedAuthService.getRoleById(event.roleId);

      if (role != null && role.requiresApproval) {
        // For approval-required roles, just emit success for now
        // In a real app, you'd create a registration request
        emit(RoleBasedRegistrationSuccess(
          userProfile: UserProfile(
            id: 'temp_id',
            email: event.email,
            fullName: event.fullName,
            roleId: event.roleId,
            phone: event.phone,
          ),
          message: 'Registration submitted. Awaiting admin approval.',
        ));
      } else {
        // No approval required
        emit(RoleBasedRegistrationSuccess(
          userProfile: UserProfile(
            id: 'temp_id',
            email: event.email,
            fullName: event.fullName,
            roleId: event.roleId,
            phone: event.phone,
          ),
          message: 'Registration successful!',
        ));
      }
    } catch (e) {
      _log('Error during role-based registration: $e');
      emit(RoleBasedRegistrationFailure('Registration failed: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Email Verification Handlers
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _onEmailVerificationRequested(
    EmailVerificationRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      // Get user profile to retrieve email
      final userProfile =
          await roleBasedAuthService.getUserProfile(event.userId);

      if (userProfile == null) {
        emit(EmailVerificationFailure('User profile not found'));
        return;
      }

      // Send verification link (implementation depends on email service)
      _log('Sending verification email to ${userProfile.email}');

      // Placeholder for actual email sending
      await Future<void>.delayed(const Duration(milliseconds: 500));

      emit(EmailVerificationLinkSent(
        email: userProfile.email,
        message: 'Verification link sent. Please check your email.',
      ));
    } catch (e) {
      _log('Error requesting email verification: $e');
      emit(EmailVerificationFailure('Failed to send verification email: $e'));
    }
  }

  Future<void> _onEmailVerificationTokenSubmitted(
    EmailVerificationTokenSubmitted event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      final params = VerifyEmailParams(
        userId: event.userId,
      );

      final result = await verifyEmailUseCase(params);

      result.fold(
        (failure) {
          _handleFailure(failure, emit);
        },
        (isVerified) {
          if (isVerified) {
            emit(EmailVerifiedSuccess(
              userId: event.userId,
              message: 'Email verified successfully!',
            ));
          } else {
            emit(EmailVerificationFailure('Email verification failed'));
          }
        },
      );
    } catch (e) {
      _log('Error verifying email token: $e');
      emit(EmailVerificationFailure('Verification failed: $e'));
    }
  }

  Future<void> _onEmailVerifiedSuccessfully(
    EmailVerifiedSuccessfully event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    try {
      _log('Email verification completed for user: ${event.userId}');
      emit(EmailVerifiedSuccess(
        userId: event.userId,
        message: 'Email verified successfully!',
      ));
    } catch (e) {
      _log('Error handling email verification success: $e');
      emit(AdvancedAuthError(message: 'Failed to process verification: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Two-Factor Authentication Handlers
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _onTwoFactorAuthSetupRequested(
    TwoFactorAuthSetupRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      // Generate 2FA secret and QR code
      // Implementation would use a library like google_authenticator or similar
      final secret = _generate2FASecret();
      final qrCode = _generateQRCode(event.userId, secret);

      emit(TwoFactorAuthSetupStarted(
        userId: event.userId,
        secret: secret,
        qrCode: qrCode,
      ));
    } catch (e) {
      _log('Error setting up 2FA: $e');
      emit(AdvancedAuthError(message: 'Failed to setup 2FA: $e'));
    }
  }

  Future<void> _onTwoFactorAuthCodeSubmitted(
    TwoFactorAuthCodeSubmitted event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      // Verify the submitted code
      // In a real app, this would verify against stored secret
      final isValid = _verify2FACode('placeholder_secret', event.code);

      if (!isValid) {
        emit(AdvancedAuthError(message: 'Invalid 2FA code'));
        return;
      }

      // Enable 2FA for user
      final params = Enable2FAParams(
        userId: event.userId,
      );

      final result = await enable2FAUseCase(params);

      result.fold(
        (failure) {
          _handleFailure(failure, emit);
        },
        (isEnabled) {
          if (isEnabled) {
            // Generate backup codes
            final backupCodes = _generateBackupCodes();
            emit(TwoFactorAuthEnabledSuccess(
              userId: event.userId,
              backupCodes: backupCodes,
              message: 'Two-factor authentication enabled successfully!',
            ));
          } else {
            emit(AdvancedAuthError(message: '2FA activation failed'));
          }
        },
      );
    } catch (e) {
      _log('Error during 2FA code verification: $e');
      emit(AdvancedAuthError(message: 'Code verification failed: $e'));
    }
  }

  Future<void> _onTwoFactorAuthEnabledSuccessfully(
    TwoFactorAuthEnabledSuccessfully event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    try {
      _log('2FA enabled for user: ${event.userId}');
      emit(TwoFactorAuthEnabledSuccess(
        userId: event.userId,
        backupCodes: event.backupCodes,
        message: event.message,
      ));
    } catch (e) {
      _log('Error handling 2FA enabled: $e');
      emit(AdvancedAuthError(message: 'Failed to process 2FA enablement: $e'));
    }
  }

  Future<void> _onTwoFactorAuthVerificationRequested(
    TwoFactorAuthVerificationRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    try {
      _log('2FA verification requested for user: ${event.userId}');

      // Verify the submitted 2FA code
      final isValid = _verify2FACode('placeholder_secret', event.code);

      if (isValid) {
        emit(const TwoFactorAuthVerificationSuccess(
          userId: event.userId,
          message: '2FA verification successful!',
        ));
      } else {
        emit(const TwoFactorAuthVerificationFailure('Invalid 2FA code'));
      }
    } catch (e) {
      _log('Error during 2FA verification: $e');
      emit(AdvancedAuthError(message: 'Failed to verify 2FA: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Registration Approval Handlers
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _onLoadPendingRegistrationRequestsRequested(
    LoadPendingRegistrationRequestsRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      final result =
          await getPendingRegistrationRequestsUseCase(const NoParams());

      result.fold(
        (failure) {
          _handleFailure(failure, emit);
        },
        (requests) {
          emit(PendingRegistrationRequestsLoaded(requests));
        },
      );
    } catch (e) {
      _log('Error loading pending registration requests: $e');
      emit(AdvancedAuthError(message: 'Failed to load requests: $e'));
    }
  }

  Future<void> _onRegistrationRequestApprovalSubmitted(
    RegistrationRequestApprovalSubmitted event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      final params = ApproveRegistrationRequestParams(
        requestId: event.requestId,
        reviewedBy: event.approverUserId,
      );

      final result = await approveRegistrationRequestUseCase(params);

      result.fold(
        (failure) {
          _handleFailure(failure, emit);
        },
        (request) {
          emit(RegistrationRequestApprovedSuccess(
            requestId: event.requestId,
            message: 'Registration request approved successfully!',
          ));
        },
      );
    } catch (e) {
      _log('Error approving registration request: $e');
      emit(RegistrationRequestApprovalFailure('Approval failed: $e'));
    }
  }

  Future<void> _onRegistrationRequestRejectionSubmitted(
    RegistrationRequestRejectionSubmitted event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      final params = RejectRegistrationRequestParams(
        requestId: event.requestId,
        reviewedBy: event.approverUserId,
        rejectionReason: event.rejectionReason,
      );

      final result = await rejectRegistrationRequestUseCase(params);

      result.fold(
        (failure) {
          _handleFailure(failure, emit);
        },
        (request) {
          emit(RegistrationRequestRejectedSuccess(
            requestId: event.requestId,
            message: 'Registration request rejected.',
          ));
        },
      );
    } catch (e) {
      _log('Error rejecting registration request: $e');
      emit(RegistrationRequestApprovalFailure('Rejection failed: $e'));
    }
  }

  Future<void> _onCheckUserRegistrationRequestStatus(
    CheckUserRegistrationRequestStatus event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      // Get user's registration request
      final request = await roleBasedAuthService.getUserRegistrationRequest(
        event.userId,
      );

      if (request != null) {
        emit(UserRegistrationRequestStatus(
          status: request.status.toString().split('.').last,
          request: request,
          message: 'Registration status: ${request.status}',
        ));
      } else {
        emit(const UserRegistrationRequestStatus(
          status: 'none',
          request: null,
          message: 'No pending registration request',
        ));
      }
    } catch (e) {
      _log('Error checking registration request status: $e');
      emit(AdvancedAuthError(message: 'Failed to check status: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Permissions Handlers
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _onCheckUserPermissionRequested(
    CheckUserPermissionRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      // Get user's role
      final userProfile = await roleBasedAuthService.getUserProfile(
        event.userId,
      );

      if (userProfile == null) {
        emit(PermissionsLoadingFailure('User profile not found'));
        return;
      }

      // Get role permissions
      final params = GetRolePermissionsParams(roleId: userProfile.roleId);
      final result = await getRolePermissionsUseCase(params);

      result.fold(
        (failure) {
          _handleFailure(failure, emit);
        },
        (permissions) {
          final hasPermission = permissions.hasPermission(event.permissionKey);
          emit(PermissionCheckResult(
            userId: event.userId,
            permissionKey: event.permissionKey,
            hasPermission: hasPermission,
          ));
        },
      );
    } catch (e) {
      _log('Error checking permission: $e');
      emit(PermissionsLoadingFailure('Permission check failed: $e'));
    }
  }

  Future<void> _onLoadUserPermissionsRequested(
    LoadUserPermissionsRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      // Get user's profile and permissions
      final userProfile = await roleBasedAuthService.getUserProfile(
        event.userId,
      );

      if (userProfile == null) {
        emit(PermissionsLoadingFailure('User profile not found'));
        return;
      }

      final params = GetRolePermissionsParams(roleId: userProfile.roleId);
      final result = await getRolePermissionsUseCase(params);

      result.fold(
        (failure) {
          _handleFailure(failure, emit);
        },
        (permissions) {
          emit(UserPermissionsLoaded(
            userId: event.userId,
            permissions: permissions,
          ));
        },
      );
    } catch (e) {
      _log('Error loading user permissions: $e');
      emit(PermissionsLoadingFailure('Failed to load permissions: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Account Security Handlers
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _onLoginAttemptFailed(
    LoginAttemptFailed event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    try {
      _log('Login attempt failed for email: ${event.email}');

      // In a real implementation, you would track login attempts
      // and lock the account after 5 failed attempts
      emit(AdvancedAuthError(
        message:
            'Login failed for ${event.email}. Please check your credentials.',
      ));
    } catch (e) {
      _log('Error handling login attempt failure: $e');
      emit(AdvancedAuthError(message: 'Failed to handle login attempt: $e'));
    }
  }

  Future<void> _onLockUserAccountRequested(
    LockUserAccountRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    try {
      _log('Locking account for user: ${event.userId}');

      final lockedUntil =
          DateTime.now().add(Duration(minutes: event.lockDurationMinutes));
      emit(UserAccountLockedState(
        userId: event.userId,
        lockedUntil: lockedUntil,
        message: 'Account locked for security reasons.',
      ));
    } catch (e) {
      _log('Error locking user account: $e');
      emit(AdvancedAuthError(message: 'Failed to lock account: $e'));
    }
  }

  Future<void> _onClearLoginAttemptsRequested(
    ClearLoginAttemptsRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    try {
      _log('Clearing login attempts for user: ${event.userId}');

      // Update user profile to clear login attempts
      await roleBasedAuthService.clearLoginAttempts(event.userId);

      emit(AdvancedAuthError(message: 'Login attempts cleared'));
    } catch (e) {
      _log('Error clearing login attempts: $e');
      emit(AdvancedAuthError(message: 'Failed to clear attempts: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Verification Status Handler
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _onCheckRoleVerificationStatusRequested(
    CheckRoleVerificationStatusRequested event,
    Emitter<AdvancedAuthState> emit,
  ) async {
    emit(const AdvancedAuthLoading());

    try {
      final userProfile = await roleBasedAuthService.getUserProfile(
        event.userId,
      );

      if (userProfile == null) {
        emit(AdvancedAuthError(message: 'User not found'));
        return;
      }

      // Check if all required verifications are complete
      final isEmailVerified = userProfile.isEmailVerified;
      final is2FAEnabled = userProfile.is2FAEnabled;

      final roleModel = await roleBasedAuthService.getRoleById(
        userProfile.roleId,
      );

      if (roleModel == null) {
        emit(AdvancedAuthError(message: 'Role not found'));
        return;
      }

      // Determine if verification is complete
      bool isComplete = true;
      if (roleModel.requiresEmailVerification && !isEmailVerified) {
        isComplete = false;
      }
      if (roleModel.requires2FA && !is2FAEnabled) {
        isComplete = false;
      }

      emit(RoleVerificationComplete(
        userId: event.userId,
        isComplete: isComplete,
        message: isComplete
            ? 'All verifications complete'
            : 'Additional verifications required',
      ));
    } catch (e) {
      _log('Error checking verification status: $e');
      emit(AdvancedAuthError(message: 'Failed to check status: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleFailure(Failure failure, Emitter<AdvancedAuthState> emit) {
    if (failure is ServerException) {
      emit(AdvancedAuthError(
        message: failure.message,
        code: 'SERVER_ERROR',
      ));
    } else if (failure is CacheException) {
      emit(AdvancedAuthError(
        message: 'Cache error: ${failure.message}',
        code: 'CACHE_ERROR',
      ));
    } else {
      emit(AdvancedAuthError(
        message: 'An error occurred',
        code: 'UNKNOWN_ERROR',
      ));
    }
  }

  String _generate2FASecret() {
    // Generate a random secret for TOTP
    // In production, use a library like 'totp' or 'google_authenticator'
    return 'GENERATED_SECRET_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateQRCode(String userId, String secret) {
    // Generate QR code data URL
    // In production, use 'qr' package
    return 'otpauth://totp/$userId?secret=$secret';
  }

  bool _verify2FACode(String secret, String code) {
    // Verify the 2FA code against the secret
    // In production, use proper TOTP verification
    _log('Verifying 2FA code for secret: $secret');
    return code.length == 6; // Basic validation
  }

  List<String> _generateBackupCodes() {
    // Generate 10 backup codes
    final codes = <String>[];
    for (int i = 0; i < 10; i++) {
      codes.add('${DateTime.now().millisecondsSinceEpoch}-$i');
    }
    return codes;
  }

  void _log(String message) {
    // Developer logging
    // ignore: avoid_print
    print('[AdvancedAuthBloc] $message');
  }
}

// Exception classes (if not already defined in failures.dart)
class ServerException implements Exception {
  ServerException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class CacheException implements Exception {
  CacheException(this.message);

  final String message;

  @override
  String toString() => message;
}
