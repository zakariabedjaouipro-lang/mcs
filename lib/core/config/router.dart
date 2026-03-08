/// Application router using GoRouter.
///
/// Defines all routes and role-based navigation guards.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:mcs/features/admin/presentation/screens/super_admin_screen.dart';
// App Shell and new screens
import 'package:mcs/features/app/shells/app_shell.dart';
import 'package:mcs/features/appointment/presentation/screens/appointments_screen.dart';
import 'package:mcs/features/auth/screens/change_password_screen.dart';
import 'package:mcs/features/auth/screens/forgot_password_screen.dart';
// Auth screens
import 'package:mcs/features/auth/screens/login_screen.dart';
import 'package:mcs/features/auth/screens/otp_verification_screen.dart';
import 'package:mcs/features/auth/screens/register_screen.dart';
import 'package:mcs/features/dashboard/presentation/screens/dashboard_screen.dart';
// Role-based dashboards
import 'package:mcs/features/doctor/presentation/screens/doctor_dashboard_screen.dart';
import 'package:mcs/features/employee/presentation/screens/employee_dashboard_screen.dart';
import 'package:mcs/features/landing/screens/contact_screen.dart' as contact;
import 'package:mcs/features/landing/screens/download_screen.dart';
import 'package:mcs/features/landing/screens/features_screen.dart';
// Landing screens
import 'package:mcs/features/landing/screens/landing_screen.dart';
import 'package:mcs/features/landing/screens/pricing_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patients_screen.dart';
import 'package:mcs/features/records/presentation/screens/records_screen.dart';
import 'package:mcs/features/settings/presentation/screens/settings_screen.dart';

// ── Route Paths ────────────────────────────────────────────
abstract class AppRoutes {
  // Landing / public
  static const String landing = '/';
  static const String features = '/features';
  static const String pricing = '/pricing';
  static const String contact = '/contact';
  static const String download = '/download';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';

  // Dashboards (role-based)
  static const String dashboard = '/dashboard';
  static const String patientHome = '/patient';
  static const String doctorHome = '/doctor';
  static const String employeeHome = '/employee';
  static const String adminHome = '/admin';
  static const String superAdminHome = '/super-admin';

  // Patient
  static const String booking = '/patient/booking';
  static const String patientProfile = '/patient/profile';
  static const String patients = '/patient/patients';
  static const String appointments = '/patient/appointments';
  static const String records = '/patient/records';
  static const String settings = '/patient/settings';

  // Doctor
  static const String doctorAppointments = '/doctor/appointments';
  static const String doctorPatients = '/doctor/patients';

  // Error
  static const String notFound = '/404';
}

// ── Router Configuration ───────────────────────────────────
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
    errorBuilder: (context, state) => _ErrorScreen(
      error: state.error?.toString() ?? 'Page not found',
    ),
  );

  // ── Route Guard ────────────────────────────────────────
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

    // Allow public routes always.
    if (isPublicRoute) return null;

    // Redirect unauthenticated users to login.
    if (!isAuthenticated && !isAuthRoute) return AppRoutes.login;

    // Redirect authenticated users away from auth pages.
    if (isAuthenticated && isAuthRoute) {
      return _getRoleBasedHomePath();
    }

    // Redirect /dashboard to role-based home
    if (isAuthenticated && state.matchedLocation == AppRoutes.dashboard) {
      return _getRoleBasedHomePath();
    }

    return null;
  }

  /// Get the home route based on the authenticated user's role.
  static String _getRoleBasedHomePath() {
    try {
      final authUser = SupabaseConfig.client.auth.currentUser;
      if (authUser == null) return AppRoutes.patientHome;

      final roleStr = authUser.userMetadata?['role'] as String? ?? 'patient';

      switch (roleStr) {
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
        case 'patient':
        case 'relative':
        default:
          return AppRoutes.patientHome;
      }
    } catch (e) {
      // Fallback to patient home if anything goes wrong
      return AppRoutes.patientHome;
    }
  }

  // ── Routes ─────────────────────────────────────────────
  static final List<RouteBase> _routes = [
    // -- Public / Landing --
    GoRoute(
      path: AppRoutes.landing,
      name: 'landing',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: AppRoutes.features,
      name: 'features',
      builder: (context, state) => const FeaturesScreen(),
    ),
    GoRoute(
      path: AppRoutes.pricing,
      name: 'pricing',
      builder: (context, state) => const PricingScreen(),
    ),
    GoRoute(
      path: AppRoutes.contact,
      name: 'contact',
      builder: (context, state) => const contact.ContactScreenLanding(),
    ),
    GoRoute(
      path: AppRoutes.download,
      name: 'download',
      builder: (context, state) => const DownloadScreen(),
    ),

    // -- Auth --
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: 'otpVerification',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      name: 'changePassword',
      builder: (context, state) => const ChangePasswordScreen(),
    ),

    // -- Dashboard (redirects to /patient by default) --
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const AppShellScreen(
        child: DashboardScreen(),
      ),
    ),

    // -- Patient --
    GoRoute(
      path: AppRoutes.patientHome,
      name: 'patientHome',
      builder: (context, state) => const AppShellScreen(
        child: DashboardScreen(),
      ),
      routes: [
        GoRoute(
          path: 'dashboard',
          builder: (context, state) => const AppShellScreen(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: 'patients',
          builder: (context, state) => const AppShellScreen(
            child: PatientsScreen(),
          ),
        ),
        GoRoute(
          path: 'appointments',
          builder: (context, state) => const AppShellScreen(
            child: AppointmentsScreen(),
          ),
        ),
        GoRoute(
          path: 'records',
          builder: (context, state) => const AppShellScreen(
            child: RecordsScreen(),
          ),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const AppShellScreen(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),

    // -- Doctor --
    GoRoute(
      path: AppRoutes.doctorHome,
      name: 'doctorHome',
      builder: (context, state) => const DoctorDashboardScreen(),
    ),

    // -- Employee --
    GoRoute(
      path: AppRoutes.employeeHome,
      name: 'employeeHome',
      builder: (context, state) => const EmployeeDashboardScreen(),
    ),

    // -- Admin --
    GoRoute(
      path: AppRoutes.adminHome,
      name: 'adminHome',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.superAdminHome,
      name: 'superAdminHome',
      builder: (context, state) => const SuperAdminScreen(),
    ),
  ];
}

// ── Error Screen ────────────────────────────────────────────
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
