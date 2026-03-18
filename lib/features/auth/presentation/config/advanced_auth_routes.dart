/// Advanced Authentication Routes Configuration
/// إعدادات المسارات للمصادقة المتقدمة
library;

import 'package:go_router/go_router.dart';
import 'package:mcs/features/auth/presentation/screens/screens_index.dart';

/// Route paths for advanced authentication
class AdvancedAuthRoutes {
  static const String registration = '/advanced-auth/registration';
  static const String emailVerification = '/advanced-auth/email-verification';
  static const String twoFactorSetup = '/advanced-auth/2fa-setup';
  static const String twoFactorVerify = '/advanced-auth/2fa-verify';
  static const String approvalDashboard = '/advanced-auth/approval-dashboard';
}

/// Advanced Authentication Routes
/// Add these to your GoRouter configuration:
///
/// Example:
/// ```dart
/// GoRoute(
///   path: AdvancedAuthRoutes.registration,
///   builder: (context, state) => const UnifiedRegistrationScreen(),
/// ),
/// GoRoute(
///   path: AdvancedAuthRoutes.emailVerification,
///   builder: (context, state) {
///     final userId = state.queryParameters['userId'] ?? '';
///     return EmailVerificationScreen(userId: userId);
///   },
/// ),
/// GoRoute(
///   path: AdvancedAuthRoutes.twoFactorSetup,
///   builder: (context, state) {
///     final userId = state.queryParameters['userId'] ?? '';
///     return TwoFactorAuthSetupScreen(userId: userId);
///   },
/// ),
/// GoRoute(
///   path: AdvancedAuthRoutes.twoFactorVerify,
///   builder: (context, state) {
///     final userId = state.queryParameters['userId'] ?? '';
///     return TwoFactorAuthVerifyScreen(userId: userId);
///   },
/// ),
/// GoRoute(
///   path: AdvancedAuthRoutes.approvalDashboard,
///   builder: (context, state) => const RegistrationApprovalDashboard(),
/// ),
/// ```

extension AdvancedAuthRouteExtension on GoRouter {
  /// Navigate to unified registration screen
  void toAdvancedRegistration() {
    push(AdvancedAuthRoutes.registration);
  }

  /// Navigate to email verification
  void toEmailVerification(String userId) {
    push('${AdvancedAuthRoutes.emailVerification}?userId=$userId');
  }

  /// Navigate to 2FA setup
  void to2FASetup(String userId) {
    push('${AdvancedAuthRoutes.twoFactorSetup}?userId=$userId');
  }

  /// Navigate to 2FA verification
  void to2FAVerify(String userId) {
    push('${AdvancedAuthRoutes.twoFactorVerify}?userId=$userId');
  }

  /// Navigate to approval dashboard
  void toApprovalDashboard() {
    push(AdvancedAuthRoutes.approvalDashboard);
  }
}
