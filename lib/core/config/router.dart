/// Application router using GoRouter.
/// Defines all routes and role-based navigation guards.

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/constants/app_routes.dart';
// Admin
import 'package:mcs/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:mcs/features/admin/presentation/screens/super_admin_screen.dart';
// App shell
import 'package:mcs/features/app/shells/app_shell.dart';
// Appointment
import 'package:mcs/features/appointment/presentation/screens/appointments_screen.dart';
// Auth
import 'package:mcs/features/auth/screens/change_password_screen.dart';
import 'package:mcs/features/auth/screens/forgot_password_screen.dart';
import 'package:mcs/features/auth/screens/otp_verification_screen.dart';
import 'package:mcs/features/auth/screens/premium_login_screen.dart';
import 'package:mcs/features/auth/screens/premium_register_screen.dart';
// Dashboard
import 'package:mcs/features/dashboard/screens/premium_dashboard_screen.dart';
// Doctor
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

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.landing,
    debugLogDiagnostics: true,
    redirect: _guard,
    routes: _routes,
    errorBuilder: (context, state) =>
        _ErrorScreen(error: state.error?.toString() ?? 'Page not found'),
  );

  /// ─────────────────────────────────────────────────
  /// Route Guard
  /// ─────────────────────────────────────────────────
  static String? _guard(BuildContext context, GoRouterState state) {
    final isAuthenticated = SupabaseConfig.isAuthenticated;

    final isAuthRoute = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register ||
        state.matchedLocation == AppRoutes.forgotPassword ||
        state.matchedLocation == AppRoutes.otpVerification;

    final isPublicRoute = state.matchedLocation == AppRoutes.landing ||
        state.matchedLocation == AppRoutes.features ||
        state.matchedLocation == AppRoutes.pricing ||
        state.matchedLocation == AppRoutes.contact ||
        state.matchedLocation == AppRoutes.download;

    if (isPublicRoute) return null;

    if (!isAuthenticated && !isAuthRoute) {
      return AppRoutes.login;
    }

    if (isAuthenticated && isAuthRoute) {
      return _getRoleBasedHomePath();
    }

    if (isAuthenticated && state.matchedLocation == AppRoutes.dashboard) {
      return _getRoleBasedHomePath();
    }

    return null;
  }

  /// Get role-based home
  static String _getRoleBasedHomePath() {
    try {
      final authUser = SupabaseConfig.client.auth.currentUser;

      if (authUser == null) {
        return AppRoutes.patientHome;
      }

      final role = authUser.userMetadata?['role'] as String? ?? 'patient';

      switch (role) {
        case 'super_admin':
          return AppRoutes.superAdminHome;

        case 'clinic_admin':
          return AppRoutes.adminHome;

        case 'doctor':
          return AppRoutes.doctorHome;

        case 'nurse':
        case 'receptionist':
        case 'pharmacist':
        case 'lab_technician':
        case 'radiographer':
          return AppRoutes.employeeHome;

        default:
          return AppRoutes.patientHome;
      }
    } catch (_) {
      return AppRoutes.patientHome;
    }
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
      builder: (context, state) => const DoctorDashboardScreen(isPremium: true),
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
      builder: (context, state) => const AdminDashboardScreen(),
    ),

    /// Super Admin
    GoRoute(
      path: AppRoutes.superAdminHome,
      builder: (context, state) => const SuperAdminScreen(),
    ),

    /// Splash
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
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
