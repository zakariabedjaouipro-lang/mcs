/// ═══════════════════════════════════════════════════════════════════════════
/// SPLASH SCREEN
/// ═══════════════════════════════════════════════════════════════════════════

library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/services/role_management_service.dart';
import 'package:mcs/core/theme/premium_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Initialization Flow with Timeout Protection
  Future<void> _initialize() async {
    try {
      debugPrint('[SPLASH] Initialization started');

      /// small delay to ensure Supabase session ready
      await Future<void>.delayed(const Duration(milliseconds: 500));

      /// check auth
      final isAuthenticated = SupabaseConfig.isAuthenticated;
      debugPrint('[SPLASH] Is authenticated: $isAuthenticated');

      if (!mounted) return;

      if (!isAuthenticated) {
        debugPrint('[SPLASH] User not authenticated → going to login');
        context.go(AppRoutes.login);
        return;
      }

      /// get role WITH TIMEOUT (max 3 seconds)
      debugPrint('[SPLASH] Fetching user role...');
      UserRole userRole;
      String? approvalStatus;

      try {
        final roleAndStatus = await Future.wait<dynamic>([
          RoleManagementService.getCurrentUserRole(),
          RoleManagementService.getUserApprovalStatus(),
        ]).timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            debugPrint('[SPLASH] Role resolution timeout!');
            throw Exception('Role resolution took too long');
          },
        );

        userRole = roleAndStatus[0] as UserRole;
        approvalStatus = roleAndStatus[1] as String?;

        debugPrint('[SPLASH] Got user role: $userRole');
        debugPrint('[SPLASH] Got approval status: $approvalStatus');
      } catch (e) {
        debugPrint('[SPLASH] Error fetching role: $e');

        /// If timeout/error but authenticated → show retry
        if (!mounted) return;

        setState(() {
          _hasError = true;
          _errorMessage = 'Unable to load role info. Please retry.';
        });
        return;
      }

      if (!mounted) return;

      final isPending = approvalStatus == 'pending';
      final isRejected = approvalStatus == 'rejected';

      /// rejected
      if (isRejected) {
        debugPrint('[SPLASH] User rejected → signing out');
        await SupabaseConfig.auth.signOut();

        if (!mounted) return;

        context.go(AppRoutes.login);
        return;
      }

      /// pending
      if (isPending) {
        debugPrint('[SPLASH] User pending approval → pending screen');
        context.go(AppRoutes.pendingApproval);
        return;
      }

      /// approved - use role's home route
      if (userRole == UserRole.unknown) {
        /// User is authenticated but has NO ROLE
        /// This should NOT happen - show error instead of redirecting
        debugPrint('[SPLASH] ERROR: User authenticated but has no role!');
        setState(() {
          _hasError = true;
          _errorMessage = 'User role not found. Please contact support.';
        });
        return;
      }

      final homeRoute = userRole.homeRoute;
      debugPrint('[SPLASH] User approved → navigating to: $homeRoute');
      context.go(homeRoute);
    } catch (e) {
      debugPrint('[SPLASH] Unexpected error: $e');

      if (!mounted) return;

      setState(() {
        _hasError = true;
        _errorMessage = 'An error occurred. Please retry.';
      });
    }
  }

  /// Retry initialization
  void _retry() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumColors.primaryBlue,
      body: Center(
        child: _hasError ? _buildErrorScreen() : _buildLoadingScreen(),
      ),
    );
  }

  /// Loading Screen
  Widget _buildLoadingScreen() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
        SizedBox(height: 24),
        Text(
          'تحميل التطبيق',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Loading Application',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Error Screen with Retry
  Widget _buildErrorScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.white70,
          size: 48,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: PremiumColors.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade300,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Logout and go to login screen
  Future<void> _logout() async {
    try {
      await SupabaseConfig.auth.signOut();
      if (!mounted) return;
      context.go(AppRoutes.login);
    } catch (e) {
      debugPrint('[SPLASH] Logout error: $e');
    }
  }
}
