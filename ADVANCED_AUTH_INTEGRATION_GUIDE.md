/// Advanced Authentication Integration Guide
/// دليل دمج المصادقة المتقدمة
///
/// This document provides comprehensive instructions for integrating
/// the advanced role-based authentication system into the MCS application.
///
/// # تعليمات الدمج المتقدمة
/// هذا الدليل يوفر تعليمات شاملة لدمج نظام المصادقة المتقدم القائم على الأدوار

library;

// STEP 1: UPDATE DEPENDENCY INJECTION CONTAINER
// ══════════════════════════════════════════════════════════════════════════════
// File: lib/core/config/injection_container.dart
//
// Add the following imports and registrations:
//
// ```dart
// import 'package:mcs/core/models/role_based_authentication_service.dart';
// import 'package:mcs/features/auth/domain/usecases/role_registration_usecases.dart';
// import 'package:mcs/features/auth/presentation/bloc/advanced_auth_bloc.dart';
//
// // Register advanced authentication service
// sl.registerLazySingleton<RoleBasedAuthenticationService>(
//   () => RoleBasedAuthenticationService(),
// );
//
// // Register all use cases
// sl.registerLazySingleton<GetAllRolesUseCase>(
//   () => GetAllRolesUseCase(sl<RoleBasedAuthenticationService>()),
// );
// sl.registerLazySingleton<GetPublicRolesUseCase>(
//   () => GetPublicRolesUseCase(sl<RoleBasedAuthenticationService>()),
// );
// sl.registerLazySingleton<GetRolePermissionsUseCase>(
//   () => GetRolePermissionsUseCase(sl<RoleBasedAuthenticationService>()),
// );
// sl.registerLazySingleton<CreateRegistrationRequestUseCase>(
//   () => CreateRegistrationRequestUseCase(sl<RoleBasedAuthenticationService>()),
// );
// sl.registerLazySingleton<VerifyEmailUseCase>(
//   () => VerifyEmailUseCase(sl<RoleBasedAuthenticationService>()),
// );
// sl.registerLazySingleton<Enable2FAUseCase>(
//   () => Enable2FAUseCase(sl<RoleBasedAuthenticationService>()),
// );
// sl.registerLazySingleton<GetPendingRegistrationRequestsUseCase>(
//   () => GetPendingRegistrationRequestsUseCase(
//     sl<RoleBasedAuthenticationService>(),
//   ),
// );
// sl.registerLazySingleton<ApproveRegistrationRequestUseCase>(
//   () => ApproveRegistrationRequestUseCase(
//     sl<RoleBasedAuthenticationService>(),
//   ),
// );
// sl.registerLazySingleton<RejectRegistrationRequestUseCase>(
//   () => RejectRegistrationRequestUseCase(
//     sl<RoleBasedAuthenticationService>(),
//   ),
// );
//
// // Register AdvancedAuthBloc
// sl.registerFactory<AdvancedAuthBloc>(
//   () => AdvancedAuthBloc(
//     roleBasedAuthService: sl<RoleBasedAuthenticationService>(),
//     supabaseService: sl<SupabaseService>(),
//     getAllRolesUseCase: sl<GetAllRolesUseCase>(),
//     getPublicRolesUseCase: sl<GetPublicRolesUseCase>(),
//     getRolePermissionsUseCase: sl<GetRolePermissionsUseCase>(),
//     createRegistrationRequestUseCase: sl<CreateRegistrationRequestUseCase>(),
//     verifyEmailUseCase: sl<VerifyEmailUseCase>(),
//     enable2FAUseCase: sl<Enable2FAUseCase>(),
//     getPendingRegistrationRequestsUseCase:
//         sl<GetPendingRegistrationRequestsUseCase>(),
//     approveRegistrationRequestUseCase: sl<ApproveRegistrationRequestUseCase>(),
//     rejectRegistrationRequestUseCase: sl<RejectRegistrationRequestUseCase>(),
//   ),
// );
// ```

// STEP 2: ADD ROUTES TO GO_ROUTER
// ══════════════════════════════════════════════════════════════════════════════
// File: lib/core/config/app_routes.dart
//
// Add the following routes:
//
// ```dart
// GoRoute(
//   path: '/advanced-auth/registration',
//   name: 'advanced-registration',
//   builder: (context, state) => const UnifiedRegistrationScreen(),
// ),
// GoRoute(
//   path: '/advanced-auth/email-verification',
//   name: 'email-verification',
//   builder: (context, state) {
//     final userId = state.queryParameters['userId'] ?? '';
//     return EmailVerificationScreen(userId: userId);
//   },
// ),
// GoRoute(
//   path: '/advanced-auth/2fa-setup',
//   name: '2fa-setup',
//   builder: (context, state) {
//     final userId = state.queryParameters['userId'] ?? '';
//     return TwoFactorAuthSetupScreen(userId: userId);
//   },
// ),
// GoRoute(
//   path: '/advanced-auth/2fa-verify',
//   name: '2fa-verify',
//   builder: (context, state) {
//     final userId = state.queryParameters['userId'] ?? '';
//     return TwoFactorAuthVerifyScreen(userId: userId);
//   },
// ),
// GoRoute(
//   path: '/advanced-auth/approval-dashboard',
//   name: 'approval-dashboard',
//   builder: (context, state) => const RegistrationApprovalDashboard(),
// ),
// ```

// STEP 3: PROVIDE BLOC IN ROOT WIDGET
// ══════════════════════════════════════════════════════════════════════════════
// File: lib/app.dart or lib/main.dart
//
// Add BlocProvider in your MaterialApp:
//
// ```dart
// MultiBlocProvider(
//   providers: [
//     BlocProvider<AdvancedAuthBloc>(
//       create: (context) => sl<AdvancedAuthBloc>(),
//     ),
//     // ... other BLoCs
//   ],
//   child: MaterialApp(
//     // ... your app configuration
//   ),
// )
// ```

// STEP 4: DEPLOY DATABASE MIGRATION
// ══════════════════════════════════════════════════════════════════════════════
// File: supabase/migrations/20260318000001_setup_role_based_authentication.sql
//
// Steps:
// 1. Copy the migration file to your supabase/migrations directory
// 2. Run: supabase migration up
// 3. Verify roles table has default roles (super_admin, admin, doctor, etc.)
// 4. Verify role_permissions table is populated
//
// To verify in Supabase console:
// - Go to SQL Editor
// - Run: SELECT COUNT(*) FROM roles; -- Should return 8+
// - Run: SELECT COUNT(*) FROM role_permissions; -- Should return 40+

// STEP 5: USAGE EXAMPLES
// ══════════════════════════════════════════════════════════════════════════════
//
// A. NAVIGATE TO REGISTRATION SCREEN
// ```dart
// context.go('/advanced-auth/registration');
// ```
//
// B. LOAD AND SELECT ROLES
// ```dart
// context.read<AdvancedAuthBloc>().add(
//   const LoadAvailableRolesRequested(publicOnly: true),
// );
// ```
//
// C. LISTEN TO REGISTRATION SUCCESS
// ```dart
// context.read<AdvancedAuthBloc>().add(
//   RoleBasedRegistrationSubmitted(
//     email: email,
//     password: password,
//     fullName: fullName,
//     roleId: selectedRole.id,
//     phone: phone,
//   ),
// );
// ```
//
// D. CHECK USER ROLE AND PERMISSIONS
// ```dart
// context.read<AdvancedAuthBloc>().add(
//   CheckUserPermissionRequested(
//     userId: userId,
//     permissionKey: 'patients.create', // Use PermissionKeys constants
//   ),
// );
//
// // Listen to result
// if (state is PermissionCheckResult) {
//   if (state.hasPermission) {
//     // User can create patients
//   }
// }
// ```
//
// E. APPROVE REGISTRATION REQUEST (Admin)
// ```dart
// context.read<AdvancedAuthBloc>().add(
//   RegistrationRequestApprovalSubmitted(
//     requestId: requestId,
//     approverUserId: adminUserId,
//   ),
// );
// ```

// STEP 6: LOCALIZATION SETUP
// ══════════════════════════════════════════════════════════════════════════════
// The screens already support Arabic/English localization via context.isArabic
// No additional setup required! RTL/LTR is automatically handled.

// STEP 7: CUSTOM GUARDS (Optional)
// ══════════════════════════════════════════════════════════════════════════════
//
// Create route guards to protect advanced registration routes:
//
// ```dart
// class RequireRoleGuard extends GoRouteGuard {
//   @override
//   Future<bool> canPop(
//     BuildContext context,
//     GoRouterState state,
//   ) async => true;
// }
// ```

// STEP 8: ERROR HANDLING
// ══════════════════════════════════════════════════════════════════════════════
//
// Listen to error states in BlocBuilder:
//
// ```dart
// BlocBuilder<AdvancedAuthBloc, AdvancedAuthState>(
//   builder: (context, state) {
//     if (state is AdvancedAuthError) {
//       return Column(
//         children: [
//           Text('Error: ${state.message}'),
//           if (state.code != null) Text('Code: ${state.code}'),
//         ],
//       );
//     }
//     return SizedBox.shrink();
//   },
// )
// ```

// STEP 9: TESTING WORKFLOW
// ══════════════════════════════════════════════════════════════════════════════
//
// 1. Register with a patient role (no approval required)
//    - Should go directly to email verification
// 2. Register with a doctor role (approval required)
//    - Should show "awaiting admin approval" message
// 3. As admin, navigate to approval dashboard
//    - Should see pending requests
// 4. Approve a request
//    - Should see success message
// 5. User can now login with their approved account

// STEP 10: PRODUCTION CHECKLIST
// ══════════════════════════════════════════════════════════════════════════════
// ✓ Database migration deployed to Supabase
// ✓ AdvancedAuthBloc registered in dependency injection
// ✓ Routes added to GoRouter configuration
// ✓ BlocProvider added to app root
// ✓ Email service configured (for email verification)
// ✓ SMS service configured (optional, for SMS 2FA)
// ✓ Environment variables set (.env file)
// ✓ Role-based RLS policies verified in Supabase
// ✓ Test registration flow end-to-end
// ✓ Test approval workflow
// ✓ Test 2FA setup and verification

// SERVICES TO IMPLEMENT (Not included in core files)
// ══════════════════════════════════════════════════════════════════════════════
//
// 1. EMAIL VERIFICATION SERVICE
//    - Integrate with SendGrid, Gmail, or similar
//    - Generate verification tokens
//    - Send verification emails
//
// 2. 2FA SMS SERVICE
//    - Integrate with Twilio or similar
//    - Send OTP codes via SMS
//
// 3. TOTP PROVIDER
//    - Use google_authenticator or similar package
//    - Generate secrets and QR codes
//    - Verify TOTP codes

// FILE STRUCTURE CREATED
// ══════════════════════════════════════════════════════════════════════════════
//
// lib/core/models/
// ├── role_model.dart
// ├── role_permissions_model.dart
// ├── registration_request_model.dart
// └── user_profile_model.dart
//
// lib/core/services/
// └── role_based_authentication_service.dart
//
// lib/features/auth/domain/usecases/
// └── role_registration_usecases.dart
//
// lib/features/auth/presentation/bloc/
// ├── advanced_auth_bloc.dart
// ├── advanced_auth_event.dart
// ├── advanced_auth_state.dart
// └── advanced_auth_index.dart
//
// lib/features/auth/presentation/screens/
// ├── unified_registration_screen.dart
// ├── email_verification_screen.dart
// ├── two_factor_auth_setup_screen.dart
// ├── two_factor_auth_verify_screen.dart
// ├── registration_approval_dashboard.dart
// └── screens_index.dart
//
// lib/features/auth/presentation/config/
// └── advanced_auth_routes.dart
//
// supabase/migrations/
// └── 20260318000001_setup_role_based_authentication.sql

/// This module provides complete advanced authentication with:
/// - Role-based user registration
/// - Email verification workflow
/// - Two-factor authentication (TOTP)
/// - Admin approval system
/// - Dynamic permission checking
/// - Account security (login attempts, account locking)
/// - Full Arabic/English localization
/// - Material Design 3 UI
/// - Clean Architecture pattern
/// - Comprehensive error handling
