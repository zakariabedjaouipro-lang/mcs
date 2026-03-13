import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/services/auth_service.dart';
import 'package:mcs/core/services/supabase_service.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/app_theme.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/features/admin/presentation/bloc/index.dart';
import 'package:mcs/features/admin/presentation/bloc/approval_bloc.dart';
import 'package:mcs/features/admin/presentation/screens/admin_clinics_screen.dart';
import 'package:mcs/features/admin/presentation/screens/admin_currencies_screen.dart';
import 'package:mcs/features/admin/presentation/screens/admin_stats_screen.dart';
import 'package:mcs/features/admin/presentation/screens/admin_subscriptions_screen.dart';
import 'package:mcs/features/admin/presentation/screens/approvals_management_screen.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_event.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_event.dart';

/// Super Admin Dashboard Screen
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc(sl<SupabaseService>()),
      child: const AdminDashboardView(),
    );
  }
}

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _selectedIndex = 0;
  bool _isInitialized = false;

  late final List<_DashboardTab> _tabs = [
    _DashboardTab(
      title: 'الإحصائيات',
      icon: Icons.dashboard,
      builder: _buildStatsScreen,
    ),
    _DashboardTab(
      title: 'الموافقات',
      icon: Icons.check_circle,
      builder: _buildApprovalsScreen,
    ),
    _DashboardTab(
      title: 'العيادات',
      icon: Icons.local_hospital,
      builder: _buildClinicsScreen,
    ),
    _DashboardTab(
      title: 'الاشتراكات',
      icon: Icons.card_membership,
      builder: _buildSubscriptionsScreen,
    ),
    _DashboardTab(
      title: 'العملات',
      icon: Icons.currency_exchange,
      builder: _buildCurrenciesScreen,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // ✅ لا نستخدم context هنا - نستخدمه في didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ آمن تماماً هنا - الـ widget مُدرج بالكامل في الـ widget tree
    if (!_isInitialized) {
      context.read<AdminBloc>().add(const LoadDashboardStats());
      _isInitialized = true;
    }
  }

  // ── Screen Builders ──────────────────────────────────────

  static Widget _buildStatsScreen(BuildContext context) {
    return const AdminStatsScreen();
  }

  static Widget _buildApprovalsScreen(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ApprovalBloc>(),
      child: const ApprovalsManagementScreen(),
    );
  }

  static Widget _buildClinicsScreen(BuildContext context) {
    return const AdminClinicsScreen();
  }

  static Widget _buildSubscriptionsScreen(BuildContext context) {
    return const AdminSubscriptionsScreen();
  }

  static Widget _buildCurrenciesScreen(BuildContext context) {
    return const AdminCurrenciesScreen();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          // Mobile layout with BottomNavigationBar
          return Scaffold(
            appBar: AppBar(
              title: const Text('MCS Admin'),
              elevation: 0,
              actions: [
                // زر تبديل اللغة
                IconButton(
                  icon: const Icon(Icons.language),
                  tooltip: 'اللغة',
                  onPressed: () {
                    context
                        .read<LocalizationBloc>()
                        .add(const ToggleLanguageEvent());
                  },
                ),
                // زر تبديل الثيم
                IconButton(
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  tooltip: 'الثيم',
                  onPressed: () {
                    context.read<ThemeBloc>().add(const ToggleThemeEvent());
                  },
                ),
              ],
            ),
            body: _tabs[_selectedIndex].builder(context),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              type: BottomNavigationBarType.fixed,
              items: _tabs
                  .map(
                    (tab) => BottomNavigationBarItem(
                      icon: Icon(tab.icon),
                      label: tab.title,
                    ),
                  )
                  .toList(),
            ),
          );
        } else {
          // Desktop layout with sidebar
          return Scaffold(
            body: Row(
              children: [
                // Sidebar
                _buildSidebar(context),
                // Main content
                Expanded(
                  child: _tabs[_selectedIndex].builder(context),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppTheme.light.scaffoldBackgroundColor,
        border: Border(
          right: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          // Logo section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'MCS Admin',
                  style: TextStyles.headline4.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'لوحة المبرمج',
                  style: TextStyles.bodySmall.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Navigation items
          ...List.generate(_tabs.length, (index) {
            final tab = _tabs[index];
            final isSelected = _selectedIndex == index;
            return _buildSidebarItem(
              context,
              tab.icon,
              tab.title,
              isSelected,
              () => setState(() => _selectedIndex = index),
            );
          }),
          const Spacer(),
          // Logout
          _buildSidebarItem(
            context,
            Icons.logout,
            'تسجيل الخروج',
            false,
            () => _handleLogout(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    IconData icon,
    String title,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
          border: Border(
            right: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          Expanded(
            child: TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('إلغاء'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
                AuthService().signOut();
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardTab {
  _DashboardTab({
    required this.title,
    required this.icon,
    required this.builder,
  });
  final String title;
  final IconData icon;
  final Widget Function(BuildContext) builder;
}
