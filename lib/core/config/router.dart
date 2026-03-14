/// Application router using GoRouter.
/// Defines all routes and role-based navigation guards.

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/constants/app_routes.dart';
// Admin
import 'package:mcs/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:mcs/features/admin/presentation/screens/premium_admin_dashboard_screen.dart';
import 'package:mcs/features/admin/presentation/screens/premium_super_admin_dashboard.dart';
// App shell
import 'package:mcs/features/app/shells/app_shell.dart';
// Appointment
import 'package:mcs/features/appointment/presentation/screens/appointments_screen.dart';
// Auth
import 'package:mcs/features/auth/screens/change_password_screen.dart';
import 'package:mcs/features/auth/screens/forgot_password_screen.dart';
import 'package:mcs/features/auth/screens/otp_verification_screen.dart';
import 'package:mcs/features/auth/screens/pending_approval_screen.dart';
import 'package:mcs/features/auth/screens/premium_login_screen.dart';
import 'package:mcs/features/auth/screens/premium_register_screen.dart';
// Dashboard
import 'package:mcs/features/dashboard/screens/premium_dashboard_screen.dart';
// Doctor
import 'package:mcs/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:mcs/features/doctor/presentation/screens/doctor_dashboard_screen.dart';
// Employee
import 'package:mcs/features/employee/presentation/screens/employee_dashboard_screen.dart';
import 'package:mcs/features/employee/presentation/screens/inventory_screen.dart';
// Landing
import 'package:mcs/features/landing/screens/contact_screen.dart' as contact;
import 'package:mcs/features/landing/screens/download_screen.dart';
import 'package:mcs/features/landing/screens/features_screen.dart';
import 'package:mcs/features/landing/screens/premium_landing_screen.dart'
    as premium_landing;
import 'package:mcs/features/landing/screens/pricing_screen.dart';
// Patient
import 'package:mcs/features/patient/presentation/screens/patient_home_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patients_screen.dart';
// Records
import 'package:mcs/features/records/presentation/screens/records_screen.dart';
// Settings
import 'package:mcs/features/settings/presentation/screens/settings_screen.dart';
// Splash
import 'package:mcs/features/splash/screens/splash_screen.dart';

/// ─────────────────────────────────────────────────
/// Router Configuration
/// ─────────────────────────────────────────────────
class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GoRouter get router => _router ??= _createRouter();

  static GoRouter? _router;

  static GoRouter _createRouter() => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: '/splash',
        debugLogDiagnostics: true,
        redirect: _guard,
        routes: _routes,
        errorBuilder: (context, state) =>
            _ErrorScreen(error: state.error?.toString() ?? 'Page not found'),
      );

  /// ═══════════════════════════════════════════════════════════════════════════
  /// ADVANCED ROUTE GUARD - منطق الحماية المتقدم للمسارات
  /// ═══════════════════════════════════════════════════════════════════════════
  ///
  /// Handles:
  /// 1. Authentication checks (unauthenticated → /login)
  /// 2. Public routes (no restrictions)
  /// 3. Auth-in-progress routes (login, register, etc.)
  /// 4. Role-based routing (each role → its specific dashboard)
  /// 5. Approval status checks (pending → /pending-approval)
  /// 6. Race condition prevention (waits for splash screen)
  /// 7. No fallback to /patient for non-patient users
  static String? _guard(BuildContext context, GoRouterState state) {
    final isAuthenticated = SupabaseConfig.isAuthenticated;
    final currentPath = state.matchedLocation;

    // ✅ ALLOW public routes without any checks
    const publicRoutes = [
      AppRoutes.landing,
      AppRoutes.features,
      AppRoutes.pricing,
      AppRoutes.contact,
      AppRoutes.download,
    ];

    if (publicRoutes.contains(currentPath)) {
      return null;
    }

    // ✅ ALLOW splash screen without any checks
    if (currentPath == '/splash') {
      return null;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // UNAUTHENTICATED USERS
    // ═══════════════════════════════════════════════════════════════════════

    const authRoutes = [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.otpVerification,
      AppRoutes.forgotPassword,
      AppRoutes.changePassword,
      AppRoutes.pendingApproval,
    ];

    if (!isAuthenticated) {
      // Not logged in - allow auth flows
      if (authRoutes.contains(currentPath)) {
        return null;
      }
      // Not logged in + trying to access protected route → /login
      return AppRoutes.login;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // AUTHENTICATED USERS
    // ═══════════════════════════════════════════════════════════════════════

    // ✅ Allow auth-in-progress routes to complete without redirect
    // (except pending approval which needs its own handling)
    if ((currentPath == AppRoutes.register ||
            currentPath == AppRoutes.otpVerification ||
            currentPath == AppRoutes.forgotPassword ||
            currentPath == AppRoutes.changePassword) &&
        isAuthenticated) {
      // Allow these flows to complete if user is authenticated
      return null;
    }

    // ✅ If already on pending approval, allow it
    if (currentPath == AppRoutes.pendingApproval) {
      return null;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // APPROVAL STATUS CHECK
    // ═══════════════════════════════════════════════════════════════════════

    try {
      final authUser = SupabaseConfig.currentUser;

      if (authUser != null) {
        // Check approval status from metadata
        final approvalStatus =
            (authUser.userMetadata?['approvalStatus'] as String?) ?? '';

        if (approvalStatus == 'pending') {
          // User is pending approval - redirect to pending screen
          if (currentPath != AppRoutes.pendingApproval) {
            return AppRoutes.pendingApproval;
          }
        } else if (approvalStatus == 'rejected') {
          // User was rejected - force logout and go to login
          if (currentPath != AppRoutes.login) {
            return AppRoutes.login;
          }
        }
      }
    } catch (e) {
      // Error checking approval - allow to proceed to prevent blockade
      debugPrint('Error checking approval status: $e');
    }

    // ═══════════════════════════════════════════════════════════════════════
    // ROLE-BASED ROUTING
    // ═══════════════════════════════════════════════════════════════════════

    // If user tries to access /dashboard, redirect to role-based home
    if (currentPath == AppRoutes.dashboard) {
      return _getRoleBasedHomePath();
    }

    if (currentPath == AppRoutes.login) {
      // Authenticated user on login screen → redirect to role home
      return _getRoleBasedHomePath();
    }

    // ✅ All checks passed - allow to proceed
    return null;
  }

  /// ═════════════════════════════════════════════════════════════════════════
  /// GET ROLE-BASED HOME PATH - تحديد المسار بناءً على الدور
  /// ═════════════════════════════════════════════════════════════════════════
  ///
  /// Safely determines home path for authenticated user based on role.
  /// Does NOT fallback to /patient for non-patient users.
  ///
  /// Mapping:
  /// - super_admin → /super-admin
  /// - clinic_admin → /admin
  /// - doctor → /doctor
  /// - nurse/receptionist/pharmacist/lab_technician/radiographer → /employee
  /// - patient → /patient
  /// - unknown → /splash (to re-fetch role)
  static String _getRoleBasedHomePath() {
    try {
      final authUser = SupabaseConfig.currentUser;

      // ✅ SAFETY: User not loaded yet (race condition)
      // Go back to splash to wait for session initialization
      if (authUser == null) {
        debugPrint('[GO_ROUTER] User is null - returning to splash');
        return '/splash';
      }

      // ═════════════════════════════════════════════════════════════════════
      // PRIORITY 1: Try appMetadata['role'] (set by admin)
      // ═════════════════════════════════════════════════════════════════════
      final appMetadata = authUser.appMetadata;

      try {
        final appRole = appMetadata['role'];
        if (appRole != null && appRole.toString().isNotEmpty) {
          debugPrint('[GO_ROUTER] Found role in appMetadata: $appRole');
          return _mapRoleToPath(appRole.toString());
        }
      } catch (_) {
        // Continue to next priority if access fails
      }

      // ═════════════════════════════════════════════════════════════════════
      // PRIORITY 2: Try userMetadata['role']
      // ═════════════════════════════════════════════════════════════════════
      final userMetadata = authUser.userMetadata;
      if (userMetadata != null) {
        try {
          final userRole = userMetadata['role'];
          if (userRole != null && userRole.toString().isNotEmpty) {
            debugPrint('[GO_ROUTER] Found role in userMetadata: $userRole');
            return _mapRoleToPath(userRole.toString());
          }
        } catch (_) {
          // Continue to fallback if userMetadata access fails
        }
      }

      // ═════════════════════════════════════════════════════════════════════
      // FALLBACK: Role not found in metadata
      // ═════════════════════════════════════════════════════════════════════
      debugPrint(
        '[GO_ROUTER] WARNING: User ${authUser.id} has no role in metadata. '
        'Returning to splash for role resolution.',
      );

      return '/splash';
    } catch (e) {
      // ✅ SAFE: Never crash - return to splash on error
      debugPrint('[GO_ROUTER] ERROR in _getRoleBasedHomePath: $e');
      return '/splash';
    }
  }

  /// Map role string to route path
  /// Returns splash if role is unknown to prevent incorrect routing
  static String _mapRoleToPath(String role) {
    return switch (role.toLowerCase()) {
      'super_admin' => AppRoutes.superAdminHome,
      'clinic_admin' || 'admin' => AppRoutes.adminHome,
      'doctor' => AppRoutes.doctorHome,
      'nurse' ||
      'receptionist' ||
      'pharmacist' ||
      'lab_technician' ||
      'radiographer' =>
        AppRoutes.employeeHome,
      'patient' => AppRoutes.patientHome,
      _ => '/splash', // Unknown role - go back to splash for resolution
    };
  }

  /// ─────────────────────────────────────────────────
  /// Routes
  /// ─────────────────────────────────────────────────
  static final List<RouteBase> _routes = [
    /// Public
    GoRoute(
      path: AppRoutes.landing,
      builder: (context, state) => const premium_landing.PremiumLandingScreen(),
    ),

    GoRoute(
      path: AppRoutes.features,
      builder: (context, state) => const FeaturesScreen(),
    ),

    GoRoute(
      path: AppRoutes.pricing,
      builder: (context, state) => const PricingScreen(),
    ),

    GoRoute(
      path: AppRoutes.contact,
      builder: (context, state) => const contact.ContactScreenLanding(),
    ),

    GoRoute(
      path: AppRoutes.download,
      builder: (context, state) => const DownloadScreen(),
    ),

    /// Auth
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const PremiumLoginScreen(),
    ),

    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const PremiumRegisterScreen(),
    ),

    GoRoute(
      path: AppRoutes.otpVerification,
      builder: (context, state) => const OtpVerificationScreen(),
    ),

    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    GoRoute(
      path: AppRoutes.changePassword,
      builder: (context, state) => const ChangePasswordScreen(),
    ),

    /// Pending Approval
    GoRoute(
      path: AppRoutes.pendingApproval,
      builder: (context, state) => const PendingApprovalScreen(),
    ),

    /// Dashboard
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) =>
          const AppShellScreen(child: PremiumDashboardScreen()),
    ),

    /// Patient
    GoRoute(
      path: AppRoutes.patientHome,
      builder: (context, state) =>
          const AppShellScreen(child: PatientHomeScreen(isPremium: true)),
      routes: [
        GoRoute(
          path: 'patients',
          builder: (context, state) =>
              const AppShellScreen(child: PatientsScreen()),
        ),
        GoRoute(
          path: 'appointments',
          builder: (context, state) =>
              const AppShellScreen(child: AppointmentsScreen(isPremium: true)),
        ),
        GoRoute(
          path: 'records',
          builder: (context, state) =>
              const AppShellScreen(child: RecordsScreen()),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const AppShellScreen(child: SettingsScreen(isPremium: true)),
        ),
      ],
    ),

    /// Doctor
    GoRoute(
      path: AppRoutes.doctorHome,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<DoctorBloc>(),
        child: const DoctorDashboardScreen(isPremium: true),
      ),
    ),

    /// Employee
    GoRoute(
      path: AppRoutes.employeeHome,
      builder: (context, state) => const EmployeeDashboardScreen(),
      routes: [
        GoRoute(
          path: 'inventory',
          builder: (context, state) => const InventoryScreen(),
        ),
        // TODO: Implement InvoicesScreen
        // GoRoute(
        //   path: 'invoices',
        //   builder: (context, state) => const InvoicesScreen(),
        // ),
      ],
    ),

    /// Admin
    GoRoute(
      path: AppRoutes.adminHome,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AdminBloc>(),
        child: const PremiumAdminDashboardScreen(),
      ),
    ),

    /// Super Admin (Premium Dashboard)
    GoRoute(
      path: AppRoutes.superAdminHome,
      builder: (context, state) => const PremiumSuperAdminDashboard(),
    ),

    /// Premium Super Admin
    GoRoute(
      path: AppRoutes.premiumSuperAdminHome,
      builder: (context, state) => const PremiumSuperAdminDashboard(),
    ),

    /// Splash
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

    /// ═══════════════════════════════════════════════════════════
    /// TEST ROUTES (لاختبار الشاشات بسهولة - قم بحذفها بعد الانتهاء)
    /// ═══════════════════════════════════════════════════════════
    GoRoute(
      path: '/test-super-admin',
      builder: (context, state) => const PremiumSuperAdminDashboard(),
    ),

    GoRoute(
      path: '/test-admin',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AdminBloc>(),
        child: const PremiumAdminDashboardScreen(),
      ),
    ),

    GoRoute(
      path: '/test-doctor',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<DoctorBloc>(),
        child: const DoctorDashboardScreen(isPremium: true),
      ),
    ),

    GoRoute(
      path: '/test-patient',
      builder: (context, state) =>
          const AppShellScreen(child: PatientHomeScreen(isPremium: true)),
    ),

    GoRoute(
      path: '/test-employee',
      builder: (context, state) => const EmployeeDashboardScreen(),
    ),
  ];
}

/// ─────────────────────────────────────────────────
/// Error Screen
/// ─────────────────────────────────────────────────
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(error)),
    );
  }
}
