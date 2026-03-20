/// Authentication service built on Supabase GoTrue.
///
/// Handles email/password login, social login, OTP, password
/// management, and auth-state observation.
library;

import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/constants/app_constants.dart';
import 'package:mcs/core/errors/exceptions.dart' as app;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService({GoTrueClient? auth}) : _auth = auth ?? SupabaseConfig.auth;

  final GoTrueClient _auth;

  // ── Getters ──────────────────────────────────────────────

  User? get currentUser => _auth.currentUser;
  Session? get currentSession => _auth.currentSession;
  bool get isAuthenticated => currentUser != null;

  /// Stream of auth state changes (sign-in, sign-out, token refresh, etc.).
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  // ── Email / Password ─────────────────────────────────────

  /// Signs in with email and password.
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      log(
        'Attempting to sign in with email: $email',
        name: 'AuthService.signInWithEmail',
        level: 800,
      );
      return await _auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e, st) {
      _logError('signInWithEmail', e, st);
      log(
        '❌ Sign-in failed with error type: ${e.runtimeType}\n'
        'Error message: $e',
        name: 'AuthService.signInWithEmail',
        level: 1000,
      );
      throw _mapException(e);
    }
  }

  /// Registers a new user with email, password, and optional metadata.
  ///
  /// دعم إنشاء حسابات مع roles مختلفة:
  /// - patient: لا يتطلب clinicId
  /// - موظفين: يتطلب clinicId من Clinic Admin
  /// - clinic_admin: يتطلب موافقة Super Admin
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
    String? clinicId,
  }) async {
    try {
      // إضافة clinicId إلى metadata إذا كان موجوداً
      final finalMetadata = {
        ...?metadata,
        if (clinicId != null) 'clinicId': clinicId,
      };

      log(
        'Signing up user with email: $email, role: ${metadata?['role']}, clinicId: $clinicId',
        name: 'AuthService.signUpWithEmail',
        level: 800,
      );

      return await _auth.signUp(
        email: email,
        password: password,
        data: finalMetadata,
        emailRedirectTo: AppConstants.deepLinkUrl,
      );
    } catch (e, st) {
      _logError('signUpWithEmail', e, st);
      throw _mapException(e);
    }
  }

  // ── Social Login ─────────────────────────────────────────

  /// Initiates an OAuth sign-in flow for the given [provider].
  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    try {
      return await _auth.signInWithOAuth(
        provider,
        redirectTo: AppConstants.deepLinkUrl,
      );
    } catch (e, st) {
      _logError('signInWithOAuth($provider)', e, st);
      throw _mapException(e);
    }
  }

  /// Sign in with Google.
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final response = await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      return response;
    } catch (e, st) {
      _logError('signInWithGoogle', e, st);
      throw _mapException(e);
    }
  }

  /// Sign in with Facebook.
  Future<bool> signInWithFacebook() => signInWithOAuth(OAuthProvider.facebook);

  // ── OTP / Phone ──────────────────────────────────────────

  /// Sends an OTP code to the given [phone] number.
  Future<void> sendOtp({required String phone}) async {
    try {
      await _auth.signInWithOtp(phone: phone);
    } catch (e, st) {
      _logError('sendOtp', e, st);
      throw _mapException(e);
    }
  }

  /// Verifies the OTP [token] sent to [phone] or [email].
  ///
  /// Supports both SMS and email OTP verification based on [otpType].
  Future<AuthResponse> verifyOtp({
    required String contactInfo,
    required String token,
    OtpType otpType = OtpType.sms,
  }) async {
    try {
      if (otpType == OtpType.email) {
        return await _auth.verifyOTP(
          email: contactInfo,
          token: token,
          type: OtpType.email,
        );
      } else {
        return await _auth.verifyOTP(
          phone: contactInfo,
          token: token,
          type: OtpType.sms,
        );
      }
    } catch (e, st) {
      _logError('verifyOtp', e, st);
      throw _mapException(e);
    }
  }

  // ── Password Management ──────────────────────────────────

  /// Sends a password reset email.
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.resetPasswordForEmail(
        email,
        redirectTo: AppConstants.deepLinkUrl,
      );
    } catch (e, st) {
      _logError('resetPassword', e, st);
      throw _mapException(e);
    }
  }

  /// Updates the current user's password.
  Future<UserResponse> updatePassword({
    required String newPassword,
  }) async {
    try {
      return await _auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e, st) {
      _logError('updatePassword', e, st);
      throw _mapException(e);
    }
  }

  /// Re-authenticates the user with email and password.
  /// This is required before sensitive operations like password changes.
  Future<AuthResponse> reauthenticate({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e, st) {
      _logError('reauthenticate', e, st);
      throw _mapException(e);
    }
  }

  // ── Session ──────────────────────────────────────────────

  /// Refreshes the current session.
  Future<AuthResponse> refreshSession() async {
    try {
      return await _auth.refreshSession();
    } catch (e, st) {
      _logError('refreshSession', e, st);
      throw _mapException(e);
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, st) {
      _logError('signOut', e, st);
      throw _mapException(e);
    }
  }

  // ── User Metadata ────────────────────────────────────────

  /// Updates the current user's metadata (e.g. full_name, avatar_url).
  Future<UserResponse> updateUserMetadata(
    Map<String, dynamic> data,
  ) async {
    try {
      return await _auth.updateUser(UserAttributes(data: data));
    } catch (e, st) {
      _logError('updateUserMetadata', e, st);
      throw _mapException(e);
    }
  }

  // ── Error Handling ───────────────────────────────────────

  void _logError(String method, Object error, StackTrace st) {
    log(
      'AuthService.$method failed: $error',
      name: 'AuthService',
      error: error,
      stackTrace: st,
    );
  }

  app.AppException _mapException(Object error) {
    if (error is AuthException) {
      final code = int.tryParse(error.statusCode ?? '');
      if (code == 401 || error.message.contains('Invalid login')) {
        return app.AuthException(
          message: error.message,
          statusCode: code,
        );
      }
      return app.AuthException(
        message: error.message,
        statusCode: code,
      );
    }
    if (error is app.AppException) return error;
    return app.ServerException(message: error.toString());
  }
}
