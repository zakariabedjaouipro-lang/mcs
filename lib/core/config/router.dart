/// Application router using GoRouter.
///
/// Defines all routes and role-based navigation guards.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mcs/core/config/supabase_config.dart';

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
    if (isAuthenticated && isAuthRoute) return AppRoutes.dashboard;

    return null;
  }

  // ── Routes ─────────────────────────────────────────────
  static final List<RouteBase> _routes = [
    // -- Public / Landing --
    GoRoute(
      path: AppRoutes.landing,
      name: 'landing',
      builder: (context, state) => const _PlaceholderScreen(title: 'Landing'),
    ),
    GoRoute(
      path: AppRoutes.features,
      name: 'features',
      builder: (context, state) => const _PlaceholderScreen(title: 'Features'),
    ),
    GoRoute(
      path: AppRoutes.pricing,
      name: 'pricing',
      builder: (context, state) => const _PlaceholderScreen(title: 'Pricing'),
    ),
    GoRoute(
      path: AppRoutes.contact,
      name: 'contact',
      builder: (context, state) => const _PlaceholderScreen(title: 'Contact'),
    ),
    GoRoute(
      path: AppRoutes.download,
      name: 'download',
      builder: (context, state) => const _PlaceholderScreen(title: 'Download'),
    ),

    // -- Auth --
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const _PlaceholderScreen(title: 'Login'),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const _PlaceholderScreen(title: 'Register'),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: 'otpVerification',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'OTP Verification'),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Forgot Password'),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      name: 'changePassword',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Change Password'),
    ),

    // -- Dashboard (redirects based on role) --
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Dashboard'),
    ),

    // -- Patient --
    GoRoute(
      path: AppRoutes.patientHome,
      name: 'patientHome',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Patient Home'),
    ),

    // -- Doctor --
    GoRoute(
      path: AppRoutes.doctorHome,
      name: 'doctorHome',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Doctor Home'),
    ),

    // -- Employee --
    GoRoute(
      path: AppRoutes.employeeHome,
      name: 'employeeHome',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Employee Home'),
    ),

    // -- Admin --
    GoRoute(
      path: AppRoutes.adminHome,
      name: 'adminHome',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Admin Home'),
    ),
    GoRoute(
      path: AppRoutes.superAdminHome,
      name: 'superAdminHome',
      builder: (context, state) =>
          const _PlaceholderScreen(title: 'Super Admin'),
    ),
  ];
}

// ── Temporary Placeholder (replaced in later phases) ───────
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — coming soon')),
    );
  }
}

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
