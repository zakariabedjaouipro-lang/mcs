/// App Shell with Bottom Navigation
/// Main app structure with navigation between screens
library;

import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/services/role_management_service.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_event.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_event.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({
    required this.child,
    this.userRole = 'patient',
    super.key,
  });
  final Widget child;
  final String userRole; // 'patient', 'doctor', 'admin', 'superAdmin'

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  int _selectedIndex = 0;

  List<NavigationItem> _buildNavigationItems() {
    // بناء قائمة العناصر الأساسية
    final items = <NavigationItem>[
      NavigationItem(
        label: 'Dashboard',
        icon: Icons.dashboard,
        route: '/patient/dashboard',
      ),
      NavigationItem(
        label: 'Patients',
        icon: Icons.people,
        route: '/patient/patients',
      ),
      NavigationItem(
        label: 'Appointments',
        icon: Icons.calendar_today,
        route: '/patient/appointments',
      ),
      NavigationItem(
        label: 'Records',
        icon: Icons.description,
        route: '/patient/records',
      ),
      NavigationItem(
        label: 'Settings',
        icon: Icons.settings,
        route: '/patient/settings',
      ),
    ];

    // إضافة أزرار المسؤولين حسب الدور
    if (widget.userRole == 'admin' || widget.userRole == 'superAdmin') {
      items.add(
        NavigationItem(
          label: 'Admin',
          icon: Icons.admin_panel_settings,
          route: '/admin',
        ),
      );
    }
    if (widget.userRole == 'superAdmin') {
      items.add(
        NavigationItem(
          label: 'SuperAdmin',
          icon: Icons.supervised_user_circle,
          route: '/super-admin',
        ),
      );
    }

    return items;
  }

  void _onNavItemTapped(int index) {
    final items = _buildNavigationItems();
    setState(() => _selectedIndex = index);
    context.go(items[index].route);
  }

  // ✅ الوظائف المنفذة (بدلاً من TODOs)
  void _navigateToInventory() => context.go(AppRoutes.inventory);
  void _navigateToInvoices() => context.go(AppRoutes.invoices);

  Future<void> _logout() async {
    // Close any open navigation drawers first
    if (context.canPop()) {
      context.pop();
    }

    // Show loading dialog with proper synchronization
    if (!mounted) return;

    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    try {
      // Step 1: Clear role cache to prevent stale data
      RoleManagementService.clearCache();

      // Step 2: Sign out from Supabase
      // This will trigger auth state changes
      await SupabaseConfig.auth.signOut();

      // Step 3: Give the auth state stream time to update
      // The Supabase SDK updates currentUser asynchronously
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Step 4: Close loading dialog
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Step 5: Navigate to login
      // The router guard will redirect since isAuthenticated is now false
      if (mounted) {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      debugPrint('Logout error: $e');

      // Even on error, try to navigate to login
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تسجيل الخروج: $e'),
            backgroundColor: Colors.red,
          ),
        );

        // Still navigate to login in case of error
        unawaited(
          Future<void>.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.go(AppRoutes.login);
            }
          }),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final items = _buildNavigationItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Clinic System'),
        elevation: 0,
        backgroundColor: MedicalColors.primary,
        foregroundColor: Colors.white,
        actions: [
          // زر تبديل اللغة
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'اللغة / Language',
            onPressed: () {
              context.read<LocalizationBloc>().add(
                    const ToggleLanguageEvent(),
                  );
            },
          ),
          // زر تبديل الثيم
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'الثيم / Theme',
            onPressed: () {
              context.read<ThemeBloc>().add(
                    const ToggleThemeEvent(),
                  );
            },
          ),
          // زر تسجيل الخروج
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج / Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigation(context, isDark, items),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: MedicalColors.primary,
            ),
            child: Text(
              'القائمة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('المخزون'),
            onTap: () {
              context.pop();
              _navigateToInventory();
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('الفواتير'),
            onTap: () {
              context.pop();
              _navigateToInvoices();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title:
                const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context,
    bool isDark,
    List<NavigationItem> items,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : MedicalColors.mediumGrey,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: MedicalColors.primary,
        unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey[600],
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        items: items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class NavigationItem {
  NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
  });
  final String label;
  final IconData icon;
  final String route;
}
