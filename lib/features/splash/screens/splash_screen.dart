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
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Initialization Flow
  Future<void> _initialize() async {
    try {
      /// small delay to ensure Supabase session ready
      await Future<void>.delayed(const Duration(milliseconds: 500));

      /// check auth
      final isAuthenticated = SupabaseConfig.isAuthenticated;

      if (!mounted) return;

      if (!isAuthenticated) {
        context.go(AppRoutes.login);
        return;
      }

      /// get role
      final userRole = await RoleManagementService.getCurrentUserRole();

      /// approval status
      final approvalStatus =
          await RoleManagementService.getUserApprovalStatus();

      if (!mounted) return;

      final isPending = approvalStatus == 'pending';
      final isRejected = approvalStatus == 'rejected';

      /// rejected
      if (isRejected) {
        await SupabaseConfig.auth.signOut();

        if (!mounted) return;

        context.go(AppRoutes.login);
        return;
      }

      /// pending
      if (isPending) {
        context.go(AppRoutes.pendingApproval);
        return;
      }

      /// approved
      context.go(userRole.homeRoute);
    } catch (e) {
      debugPrint('Splash error: $e');

      if (!mounted) return;

      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: PremiumColors.primaryBlue,
      body: Center(
        child: Column(
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
        ),
      ),
    );
  }
}
