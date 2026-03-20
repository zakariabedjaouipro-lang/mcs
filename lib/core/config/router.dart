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
import 'package:mcs/features/admin/presentation/screens/premium_admin_clinics_screen.dart';
import 'package:mcs/features/admin/presentation/screens/admin_employees_screen.dart';
import 'package:mcs/features/admin/presentation/screens/admin_patients_screen.dart';
import 'package:mcs/features/admin/presentation/screens/admin_dashboard.dart';
import 'package:mcs/features/admin/presentation/screens/super_admin_dashboard_v2.dart';

// App shell
import 'package:mcs/features/app/shells/app_shell.dart';

// Appointment
import 'package:mcs/features/appointment/presentation/screens/appointments_screen.dart';

// Clinic Admin
import 'package:mcs/features/clinic/presentation/screens/clinic_dashboard.dart';

// Nurse
import 'package:mcs/features/nurse/presentation/screens/nurse_dashboard.dart';

// Receptionist
import 'package:mcs/features/receptionist/presentation/screens/receptionist_dashboard.dart';

// Pharmacist
import 'package:mcs/features/pharmacist/presentation/screens/pharmacist_dashboard.dart';

// Lab Technician
import 'package:mcs/features/lab/presentation/screens/lab_technician_dashboard.dart';

// Radiographer
import 'package:mcs/features/radiology/presentation/screens/radiographer_dashboard.dart';

// Relative
import 'package:mcs/features/relative/presentation/screens/relative_home_screen.dart';

// Auth
import 'package:mcs/features/auth/screens/change_password_screen.dart';
import 'package:mcs/features/auth/screens/forgot_password_screen.dart';
import 'package:mcs/features/auth/screens/otp_verification_screen.dart';
import 'package:mcs/features/auth/screens/pending_approval_screen.dart';
import 'package:mcs/features/auth/screens/premium_login_screen.dart';
import 'package:mcs/features/auth/screens/premium_register_screen.dart';

// Doctor
import 'package:mcs/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:mcs/features/doctor/presentation/screens/doctor_lab_results_screen.dart';
import 'package:mcs/features/doctor/presentation/screens/doctor_patients_screen.dart';
import 'package:mcs/features/doctor/presentation/screens/doctor_prescriptions_screen.dart';
import 'package:mcs/features/doctor/presentation/screens/doctor_profile_screen.dart';
import 'package:mcs/features/doctor/presentation/screens/doctor_dashboard.dart';

// Employee
import 'package:mcs/features/employee/presentation/screens/employee_lab_results_screen.dart';
import 'package:mcs/features/employee/presentation/screens/employee_patients_screen.dart';
import 'package:mcs/features/employee/presentation/screens/employee_prescriptions_screen.dart';
import 'package:mcs/features/employee/presentation/screens/employee_profile_screen.dart';
import 'package:mcs/features/employee/presentation/screens/inventory_screen.dart';
import 'package:mcs/features/employee/presentation/screens/invoices_screen.dart';
import 'package:mcs/features/employee/presentation/screens/employee_dashboard.dart';

// Landing
import 'package:mcs/features/landing/screens/contact_screen.dart' as contact;
import 'package:mcs/features/landing/screens/download_screen.dart';
import 'package:mcs/features/landing/screens/features_screen.dart';
import 'package:mcs/features/landing/screens/premium_landing_screen.dart'
    as premium_landing;
import 'package:mcs/features/landing/screens/pricing_screen.dart';

// Patient
import 'package:mcs/features/patient/presentation/screens/patient_book_appointment_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patient_change_password_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patient_home_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patient_lab_results_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patient_medical_history_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patient_prescriptions_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patient_profile_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patient_remote_sessions_screen.dart';
import 'package:mcs/features/patient/presentation/screens/patient_social_accounts_screen.dart';
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
  /// ADVANCED ROUTE GUARD
  /// ═══════════════════════════════════════════════════════════════════════════
  static String? _guard(BuildContext context, GoRouterState state) {
    final isAuthenticated = SupabaseConfig.isAuthenticated;
    final currentPath = state.matchedLocation;

    debugPrint(
        '🛡️ GUARD CHECK: isAuthenticated=$isAuthenticated, path=$currentPath');

    // ✅ ALLOW public routes without any checks
    const publicRoutes = [
      AppRoutes.landing,
      AppRoutes.features,
      AppRoutes.pricing,
      AppRoutes.contact,
      AppRoutes.download,
    ];

    if (publicRoutes.contains(currentPath)) {
      debugPrint('🛡️ Public route allowed: $currentPath');
      return null;
    }

    // ✅ ALLOW splash screen without any checks
    if (currentPath == '/splash') {
      debugPrint('🛡️ Splash screen allowed');
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
      if (authRoutes.contains(currentPath)) {
        debugPrint(
            '🛡️ Auth route allowed for unauthenticated user: $currentPath');
        return null;
      }
      debugPrint(
          '🛡️ Unauthenticated user trying to access protected route, redirecting to login');
      return AppRoutes.login;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // AUTHENTICATED USERS
    // ═══════════════════════════════════════════════════════════════════════

    if ((currentPath == AppRoutes.register ||
            currentPath == AppRoutes.otpVerification ||
            currentPath == AppRoutes.forgotPassword ||
            currentPath == AppRoutes.changePassword) &&
        isAuthenticated) {
      debugPrint(
          '🛡️ Auth route allowed for authenticated user (completing flow): $currentPath');
      return null;
    }

    if (currentPath == AppRoutes.pendingApproval) {
      debugPrint('🛡️ Pending approval screen allowed');
      return null;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // APPROVAL STATUS CHECK
    // ═══════════════════════════════════════════════════════════════════════

    try {
      final authUser = SupabaseConfig.currentUser;

      if (authUser != null) {
        final approvalStatus =
            (authUser.userMetadata?['approvalStatus'] as String?) ?? '';

        debugPrint('🛡️ Approval status: $approvalStatus');

        if (approvalStatus == 'pending') {
          if (currentPath != AppRoutes.pendingApproval) {
            debugPrint(
                '🛡️ User pending approval, redirecting to pending screen');
            return AppRoutes.pendingApproval;
          }
        } else if (approvalStatus == 'rejected') {
          if (currentPath != AppRoutes.login) {
            debugPrint('🛡️ User rejected, redirecting to login');
            return AppRoutes.login;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking approval status: $e');
    }

    // ═══════════════════════════════════════════════════════════════════════
    // ROLE-BASED ROUTING
    // ═══════════════════════════════════════════════════════════════════════

    if (currentPath == AppRoutes.dashboard) {
      final homePath = _getRoleBasedHomePath();
      debugPrint('🛡️ Redirecting from dashboard to: $homePath');
      return homePath;
    }

    if (currentPath == AppRoutes.login) {
      final homePath = _getRoleBasedHomePath();
      debugPrint(
          '🛡️ User already authenticated on login page, redirecting to: $homePath');
      return homePath;
    }

    debugPrint('🛡️ No redirect needed');
    return null;
  }

  /// ═════════════════════════════════════════════════════════════════════════
  /// GET ROLE-BASED HOME PATH
  /// ═════════════════════════════════════════════════════════════════════════
  static String _getRoleBasedHomePath() {
    try {
      final authUser = SupabaseConfig.currentUser;

      debugPrint('🛡️ Getting role-based home for user: ${authUser?.email}');

      if (authUser == null) {
        debugPrint('🛡️ User is null, returning to splash');
        return '/splash';
      }

      // ═════════════════════════════════════════════════════════════════════
      // PRIORITY 1: Try appMetadata['role']
      // ═════════════════════════════════════════════════════════════════════
      final appMetadata = authUser.appMetadata;
      debugPrint('🛡️ appMetadata: $appMetadata');

      try {
        final appRole = appMetadata['role'];
        if (appRole != null && appRole.toString().isNotEmpty) {
          debugPrint('🛡️ Found role in appMetadata: $appRole');
          final path = _mapRoleToPath(appRole.toString());
          debugPrint('🛡️ Mapping role "$appRole" to path: $path');
          return path;
        }
      } catch (e) {
        debugPrint('🛡️ Error reading appMetadata: $e');
      }

      // ═════════════════════════════════════════════════════════════════════
      // PRIORITY 2: Try userMetadata['role']
      // ═════════════════════════════════════════════════════════════════════
      final userMetadata = authUser.userMetadata;
      debugPrint('🛡️ userMetadata: $userMetadata');

      if (userMetadata != null) {
        try {
          final userRole = userMetadata['role'];
          if (userRole != null && userRole.toString().isNotEmpty) {
            debugPrint('🛡️ Found role in userMetadata: $userRole');
            final path = _mapRoleToPath(userRole.toString());
            debugPrint('🛡️ Mapping role "$userRole" to path: $path');
            return path;
          }
        } catch (e) {
          debugPrint('🛡️ Error reading userMetadata: $e');
        }
      }

      debugPrint(
        '🛡️ WARNING: User ${authUser.id} has no role in metadata. '
        'Returning to splash for role resolution.',
      );

      return '/splash';
    } catch (e) {
      debugPrint('❌ ERROR in _getRoleBasedHomePath: $e');
      return '/splash';
    }
  }

  /// ✅ **محدث: تعيين مسار فريد لكل دور**
  static String _mapRoleToPath(String role) {
    return switch (role.toLowerCase()) {
      'super_admin' => AppRoutes.superAdminHome,
      'clinic_admin' || 'admin' => AppRoutes.adminHome,
      'doctor' => AppRoutes.doctorHome,
      'nurse' => '/nurse/dashboard',
      'receptionist' => '/receptionist/dashboard',
      'pharmacist' => '/pharmacist/dashboard',
      'lab_technician' => '/lab/dashboard',
      'radiographer' => '/radiology/dashboard',
      'patient' => AppRoutes.patientHome,
      'relative' => '/relative/home',
      _ => '/splash',
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
    GoRoute(
      path: AppRoutes.pendingApproval,
      builder: (context, state) => const PendingApprovalScreen(),
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
          path: 'lab-results',
          builder: (context, state) =>
              const AppShellScreen(child: PatientLabResultsScreen()),
        ),
        GoRoute(
          path: 'prescriptions',
          builder: (context, state) =>
              const AppShellScreen(child: PatientPrescriptionsScreen()),
        ),
        GoRoute(
          path: 'remote-sessions',
          builder: (context, state) =>
              const AppShellScreen(child: PatientRemoteSessionsScreen()),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const AppShellScreen(child: SettingsScreen(isPremium: true)),
        ),
        GoRoute(
          path: 'social-accounts',
          builder: (context, state) =>
              const AppShellScreen(child: PatientSocialAccountsScreen()),
        ),
        GoRoute(
          path: 'book-appointment',
          builder: (context, state) =>
              const AppShellScreen(child: PatientBookAppointmentScreen()),
        ),
        GoRoute(
          path: 'medical-history',
          builder: (context, state) =>
              const AppShellScreen(child: PatientMedicalHistoryScreen()),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) =>
              const AppShellScreen(child: PatientProfileScreen()),
        ),
        GoRoute(
          path: 'change-password',
          builder: (context, state) =>
              const AppShellScreen(child: PatientChangePasswordScreen()),
        ),
      ],
    ),

    /// Doctor
    GoRoute(
      path: AppRoutes.doctorHome,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<DoctorBloc>(),
        child: const DoctorDashboard(),
      ),
      routes: [
        GoRoute(
          path: 'appointments',
          builder: (context, state) =>
              const AppShellScreen(child: AppointmentsScreen(isPremium: true)),
        ),
        GoRoute(
          path: 'patients',
          builder: (context, state) => const DoctorPatientsScreen(),
        ),
        GoRoute(
          path: 'prescriptions',
          builder: (context, state) => const DoctorPrescriptionsScreen(),
        ),
        GoRoute(
          path: 'lab-results',
          builder: (context, state) => const DoctorLabResultsScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const DoctorProfileScreen(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const AppShellScreen(child: SettingsScreen(isPremium: true)),
        ),
      ],
    ),

    /// Employee
    GoRoute(
      path: AppRoutes.employeeHome,
      builder: (context, state) => const EmployeeDashboard(),
      routes: [
        GoRoute(
          path: 'appointments',
          builder: (context, state) =>
              const AppShellScreen(child: AppointmentsScreen(isPremium: true)),
        ),
        GoRoute(
          path: 'patients',
          builder: (context, state) => const EmployeePatientsScreen(),
        ),
        GoRoute(
          path: 'prescriptions',
          builder: (context, state) => const EmployeePrescriptionsScreen(),
        ),
        GoRoute(
          path: 'lab-results',
          builder: (context, state) => const EmployeeLabResultsScreen(),
        ),
        GoRoute(
          path: 'inventory',
          builder: (context, state) => const InventoryScreen(),
        ),
        GoRoute(
          path: 'invoices',
          builder: (context, state) => const InvoicesScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const EmployeeProfileScreen(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const AppShellScreen(child: SettingsScreen(isPremium: true)),
        ),
      ],
    ),

    /// Admin
    GoRoute(
      path: AppRoutes.adminHome,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AdminBloc>(),
        child: const AdminDashboard(),
      ),
      routes: [
        GoRoute(
          path: 'appointments',
          builder: (context, state) =>
              const AppShellScreen(child: AppointmentsScreen(isPremium: true)),
        ),
        GoRoute(
          path: 'doctors',
          builder: (context, state) => const PremiumAdminClinicsScreen(),
        ),
        GoRoute(
          path: 'employees',
          builder: (context, state) => const AdminEmployeesScreen(),
        ),
        GoRoute(
          path: 'patients',
          builder: (context, state) => const AdminPatientsScreen(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const AppShellScreen(child: SettingsScreen(isPremium: true)),
        ),
      ],
    ),

    /// Super Admin
    GoRoute(
      path: AppRoutes.superAdminHome,
      builder: (context, state) => const SuperAdminDashboardV2(),
    ),

    /// Premium Super Admin
    GoRoute(
      path: AppRoutes.premiumSuperAdminHome,
      builder: (context, state) => const SuperAdminDashboardV2(),
    ),

    /// Clinic Admin
    GoRoute(
      path: '/clinic/dashboard',
      builder: (context, state) => const ClinicDashboard(),
    ),

    /// Nurse
    GoRoute(
      path: '/nurse/dashboard',
      builder: (context, state) => const NurseDashboard(),
    ),

    /// Receptionist
    GoRoute(
      path: '/receptionist/dashboard',
      builder: (context, state) => const ReceptionistDashboard(),
    ),

    /// Pharmacist
    GoRoute(
      path: '/pharmacist/dashboard',
      builder: (context, state) => const PharmacistDashboard(),
    ),

    /// Lab Technician
    GoRoute(
      path: '/lab/dashboard',
      builder: (context, state) => const LabTechnicianDashboard(),
    ),

    /// Radiographer
    GoRoute(
      path: '/radiology/dashboard',
      builder: (context, state) => const RadiographerDashboard(),
    ),

    /// Relative
    GoRoute(
      path: '/relative/home',
      builder: (context, state) => const RelativeDashboard(),
    ),

    /// Splash
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    /// ═══════════════════════════════════════════════════════════
    /// TEST ROUTES
    /// ═══════════════════════════════════════════════════════════
    GoRoute(
      path: '/test-super-admin',
      builder: (context, state) => const SuperAdminDashboardV2(),
    ),
    GoRoute(
      path: '/test-admin',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AdminBloc>(),
        child: const SuperAdminDashboardV2(),
      ),
    ),
    GoRoute(
      path: '/test-doctor',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<DoctorBloc>(),
        child: const DoctorDashboard(),
      ),
    ),
    GoRoute(
      path: '/test-employee',
      builder: (context, state) => const EmployeeDashboard(),
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
