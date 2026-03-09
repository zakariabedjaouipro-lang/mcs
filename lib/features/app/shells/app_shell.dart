/// App Shell with Bottom Navigation
/// Main app structure with navigation between screens
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/utils/extensions.dart';

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
        route: '/dashboard',
      ),
      NavigationItem(
        label: 'Patients',
        icon: Icons.people,
        route: '/patients',
      ),
      NavigationItem(
        label: 'Appointments',
        icon: Icons.calendar_today,
        route: '/appointments',
      ),
      NavigationItem(
        label: 'Records',
        icon: Icons.description,
        route: '/records',
      ),
      NavigationItem(
        label: 'Settings',
        icon: Icons.settings,
        route: '/settings',
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
  void _navigateToInventory() => context.go('/inventory');
  void _navigateToInvoices() => context.go('/invoices');
  void _logout() => context.go('/login');

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final items = _buildNavigationItems();

    return Scaffold(
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
              Navigator.pop(context);
              _navigateToInventory();
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('الفواتير'),
            onTap: () {
              Navigator.pop(context);
              _navigateToInvoices();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
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
        color: isDark ? Colors.grey[900] : Colors.white,
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
