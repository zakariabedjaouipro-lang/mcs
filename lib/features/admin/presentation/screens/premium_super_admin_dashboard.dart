/// Premium Super Admin Dashboard
/// لوحة تحكم Admin حديثة مع تصميم طبي عصري
library;

import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/supabase_config.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/services/role_management_service.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/features/admin/presentation/bloc/approval_bloc.dart';
import 'package:mcs/features/admin/presentation/screens/approvals_management_screen.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_event.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_event.dart';

/// Premium Super Admin Dashboard
class PremiumSuperAdminDashboard extends StatefulWidget {
  const PremiumSuperAdminDashboard({super.key});

  @override
  State<PremiumSuperAdminDashboard> createState() =>
      _PremiumSuperAdminDashboardState();
}

class _PremiumSuperAdminDashboardState extends State<PremiumSuperAdminDashboard>
    with TickerProviderStateMixin {
  late AnimationController _drawerAnimationController;
  bool _isDrawerOpen = true;
  String _selectedMenuItem = 'dashboard';

  final List<MenuItem> _menuItems = [
    const MenuItem(
      id: 'dashboard',
      label: 'لوحة التحكم',
      labelEn: 'Dashboard',
      icon: Icons.dashboard,
      color: Colors.blue,
    ),
    const MenuItem(
      id: 'clinics',
      label: 'إدارة العيادات',
      labelEn: 'Clinics',
      icon: Icons.local_hospital,
      color: Colors.teal,
    ),
    const MenuItem(
      id: 'doctors',
      label: 'إدارة الأطباء',
      labelEn: 'Doctors',
      icon: Icons.medical_services,
      color: Colors.cyan,
    ),
    const MenuItem(
      id: 'patients',
      label: 'إدارة المرضى',
      labelEn: 'Patients',
      icon: Icons.people,
      color: Colors.green,
    ),
    const MenuItem(
      id: 'appointments',
      label: 'المواعيد',
      labelEn: 'Appointments',
      icon: Icons.calendar_today,
      color: Colors.purple,
    ),
    const MenuItem(
      id: 'payments',
      label: 'المدفوعات',
      labelEn: 'Payments',
      icon: Icons.payment,
      color: Colors.orange,
    ),
    const MenuItem(
      id: 'approvals',
      label: 'الموافقات',
      labelEn: 'Approvals',
      icon: Icons.check_circle,
      color: Colors.amber,
    ),
    const MenuItem(
      id: 'subscriptions',
      label: 'الاشتراكات',
      labelEn: 'Subscriptions',
      icon: Icons.card_membership,
      color: Colors.indigo,
    ),
    const MenuItem(
      id: 'analytics',
      label: 'التحليلات والتقارير',
      labelEn: 'Analytics',
      icon: Icons.analytics,
      color: Colors.red,
    ),
    const MenuItem(
      id: 'permissions',
      label: 'الصلاحيات',
      labelEn: 'Permissions',
      icon: Icons.security,
      color: Colors.deepOrange,
    ),
    const MenuItem(
      id: 'settings',
      label: 'الإعدادات',
      labelEn: 'Settings',
      icon: Icons.settings,
      color: Colors.grey,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _drawerAnimationController.forward();
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    super.dispose();
  }

  /// Handle logout - clear cache and sign out
  Future<void> _handleLogout() async {
    // Clear role cache
    RoleManagementService.clearCache();

    // Show loading
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
      // Sign out from Supabase
      await SupabaseConfig.auth.signOut();

      // Wait for state to update
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Close loading dialog
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Navigate to login
      if (mounted) {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe right to go back (RTL)
        if (isArabic && details.primaryVelocity! < -500) {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
        // Swipe left to go back (LTR)
        else if (!isArabic && details.primaryVelocity! > 500) {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        drawer: _buildDrawerOnMobile(context, isArabic),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showFullSidebar = constraints.maxWidth > 800;

              return Row(
                children: [
                  // Sidebar - Show on large screens
                  if (showFullSidebar) _buildSidebar(context, isArabic),

                  // Main Content
                  Expanded(
                    child: Column(
                      children: [
                        // Top App Bar
                        _buildTopAppBar(
                          context,
                          isArabic,
                          isDark,
                          showFullSidebar,
                        ),

                        // Content Area
                        Expanded(
                          child: _buildMainContent(context, isArabic),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SIDEBAR
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDrawerOnMobile(BuildContext context, bool isArabic) {
    return Drawer(
      child: SafeArea(
        child: _buildSidebarContent(context, isArabic),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, bool isArabic) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(_drawerAnimationController),
      child: SafeArea(
        // ← هذا يحل مشكلة التداخل مع status bar
        child: _buildSidebarContent(context, isArabic),
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context, bool isArabic) {
    return Container(
      width: _isDrawerOpen ? 280 : 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
          ],
        ),
        border: Border(
          right: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        PremiumColors.successGreen,
                        PremiumColors.primaryBlue,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: PremiumColors.primaryBlue.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.healing,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                if (_isDrawerOpen) ...[
                  const SizedBox(height: 12),
                  Text(
                    'MCS',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: PremiumColors.primaryBlue,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic ? 'لوحة التحكم' : 'Admin Panel',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _selectedMenuItem == item.id;

                return _buildMenuItemAnimation(
                  child: _buildMenuItem(
                    context,
                    item,
                    isSelected,
                    isArabic,
                  ),
                );
              },
            ),
          ),

          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Column(
              children: [
                // Collapse Button
                InkWell(
                  onTap: () {
                    setState(() {
                      _isDrawerOpen = !_isDrawerOpen;
                      if (_isDrawerOpen) {
                        _drawerAnimationController.forward();
                      } else {
                        _drawerAnimationController.reverse();
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      _isDrawerOpen ? Icons.chevron_left : Icons.chevron_right,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Logout Button
                _buildMenuItemAnimation(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _handleLogout,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout,
                              size: 20,
                              color: Colors.red,
                            ),
                            if (_isDrawerOpen) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  isArabic ? 'تسجيل الخروج' : 'Logout',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    MenuItem item,
    bool isSelected,
    bool isArabic,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color:
            isSelected ? item.color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(
                color: item.color.withValues(alpha: 0.3),
                width: 1.5,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => _selectedMenuItem = item.id);
            if (item.id == 'approvals') {
              _showApprovalsModal(context);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: item.color,
                  ),
                ),
                if (_isDrawerOpen) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? item.label : item.labelEn,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? item.color
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemAnimation({required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(-20 * (1 - value), 0),
            child: child,
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TOP APP BAR
  // ═══════════════════════════════════════════════════════════════

  Widget _buildTopAppBar(
    BuildContext context,
    bool isArabic,
    bool isDark,
    bool showFullSidebar,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showSearch = screenWidth > 768; // Hide search on small screens
    final padding = screenWidth < 600 ? 12.0 : 16.0;
    final horPadding = screenWidth < 600 ? 12.0 : 24.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horPadding,
        vertical: padding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Menu Button (only on mobile)
            if (!showFullSidebar)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: const Icon(Icons.menu, size: 20),
                ),
              ),

            // Back Button with Swipe Hint
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Tooltip(
                message: Localizations.localeOf(context).languageCode == 'ar'
                    ? 'اسحب للعودة'
                    : 'Swipe to go back',
                child: InkWell(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.arrow_back, size: 20),
                ),
              ),
            ),

            // Search Bar (hidden on small screens)
            if (showSearch)
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (_) {},
                  decoration: InputDecoration(
                    hintText: isArabic ? 'ابحث...' : 'Search...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                ),
              ),

            // Notifications
            _buildIconButton(
              icon: Icons.notifications_outlined,
              badge: '3',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic
                          ? 'لا توجد إخطارات جديدة'
                          : 'No new notifications',
                    ),
                  ),
                );
              },
            ),

            // Theme Toggle
            _buildIconButton(
              icon: isDark ? Icons.light_mode : Icons.dark_mode,
              onTap: () {
                context.read<ThemeBloc>().add(const ToggleThemeEvent());
              },
            ),

            // Language Toggle
            _buildIconButton(
              icon: Icons.language,
              onTap: () {
                context
                    .read<LocalizationBloc>()
                    .add(const ToggleLanguageEvent());
              },
            ),

            // User Profile
            _buildUserProfile(context, isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Icon(icon, size: 24),
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, bool isArabic) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onSelected: (value) {
        if (value == 'logout') {
          _handleLogout();
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              const Icon(Icons.person, size: 18),
              const SizedBox(width: 12),
              Text(isArabic ? 'الملف الشخصي' : 'Profile'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              const Icon(Icons.settings, size: 18),
              const SizedBox(width: 12),
              Text(isArabic ? 'الإعدادات' : 'Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout, size: 18, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                isArabic ? 'تسجيل الخروج' : 'Logout',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        PremiumColors.primaryBlue,
                        PremiumColors.successGreen,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'المسؤول' : 'Admin',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // MAIN CONTENT
  // ═══════════════════════════════════════════════════════════════

  Widget _buildMainContent(BuildContext context, bool isArabic) {
    switch (_selectedMenuItem) {
      case 'dashboard':
        return _buildDashboardContent(context, isArabic);
      case 'clinics':
        return _buildClinicsContent(context, isArabic);
      case 'doctors':
        return _buildDoctorsContent(context, isArabic);
      case 'patients':
        return _buildPatientsContent(context, isArabic);
      case 'appointments':
        return _buildAppointmentsContent(context, isArabic);
      case 'payments':
        return _buildPaymentsContent(context, isArabic);
      case 'approvals':
        return _buildApprovalsContent(context);
      case 'subscriptions':
        return _buildSubscriptionsContent(context, isArabic);
      case 'analytics':
        return _buildAnalyticsContent(context, isArabic);
      case 'permissions':
        return _buildPermissionsContent(context, isArabic);
      case 'settings':
        return _buildSettingsContent(context, isArabic);
      default:
        return _buildUnderConstructionScreen(context, isArabic);
    }
  }

  Widget _buildDashboardContent(BuildContext context, bool isArabic) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 600 ? 16.0 : 20.0;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Text(
              isArabic ? 'مرحباً بعودتك!' : 'Welcome Back!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              isArabic
                  ? 'إليك ملخص نشاط النظام اليوم'
                  : "Here's a summary of today's activities",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),

            const SizedBox(height: 24),

            // Statistics Cards
            _buildStatisticsGrid(context, isArabic),

            const SizedBox(height: 32),

            // Recent Activity
            Text(
              isArabic ? 'النشاط الأخير' : 'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildActivityPanel(context, isArabic),

            const SizedBox(height: 32),

            // Quick Actions
            Text(
              isArabic ? 'الإجراءات السريعة' : 'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildQuickActionsGrid(context, isArabic),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, bool isArabic) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;

    // Responsive grid columns based on screen width
    if (screenWidth < 600) {
      crossAxisCount = 1;
    } else if (screenWidth < 1200) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 4;
    }

    final stats = [
      StatisticCard(
        title: isArabic ? 'العيادات' : 'Clinics',
        value: '24',
        icon: Icons.local_hospital,
        color: Colors.blue,
        change: '+2.5%',
      ),
      StatisticCard(
        title: isArabic ? 'الأطباء' : 'Doctors',
        value: '156',
        icon: Icons.medical_services,
        color: Colors.teal,
        change: '+5.2%',
      ),
      StatisticCard(
        title: isArabic ? 'المرضى' : 'Patients',
        value: '2,341',
        icon: Icons.people,
        color: Colors.green,
        change: '+12.3%',
      ),
      StatisticCard(
        title: isArabic ? 'الإيرادات' : 'Revenue',
        value: '45.8K',
        icon: Icons.attach_money,
        color: Colors.orange,
        change: '+8.1%',
      ),
    ];

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children:
          stats.map((stat) => _buildStatisticCard(context, stat)).toList(),
    );
  }

  Widget _buildStatisticCard(
    BuildContext context,
    StatisticCard stat,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            stat.color.withValues(alpha: 0.1),
            stat.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: stat.color.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: stat.color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: stat.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        stat.icon,
                        color: stat.color,
                        size: 24,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        stat.change,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.value,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: stat.color,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat.title,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityPanel(BuildContext context, bool isArabic) {
    final activities = [
      {
        'icon': Icons.person_add,
        'title': isArabic ? 'مريض جديد مسجل' : 'New patient registered',
        'time': '5 min ago',
      },
      {
        'icon': Icons.check_circle,
        'title': isArabic ? 'موعد تم إكماله' : 'Appointment completed',
        'time': '15 min ago',
      },
      {
        'icon': Icons.payment,
        'title': isArabic ? 'دفعة تم استلامها' : 'Payment received',
        'time': '1 hour ago',
      },
      {
        'icon': Icons.note_alt,
        'title': isArabic ? 'تقرير طبي جديد' : 'New medical report',
        'time': '2 hours ago',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: Colors.grey.withValues(alpha: 0.1),
        ),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PremiumColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    activity['icon']! as IconData,
                    color: PremiumColors.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title']! as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity['time']! as String,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, bool isArabic) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    // Responsive grid columns based on screen width
    if (screenWidth < 600) {
      crossAxisCount = 1;
      childAspectRatio = 1.5;
    } else if (screenWidth < 1000) {
      crossAxisCount = 2;
      childAspectRatio = 1.3;
    } else {
      crossAxisCount = 4;
      childAspectRatio = 1.0;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: childAspectRatio,
      children: [
        _buildQuickActionButton(
          context: context,
          icon: Icons.person_add,
          label: isArabic ? 'مريض جديد' : 'New Patient',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic ? 'إضافة مريض جديد' : 'Adding new patient',
                ),
                backgroundColor: Colors.blue,
              ),
            );
          },
        ),
        _buildQuickActionButton(
          context: context,
          icon: Icons.calendar_today,
          label: isArabic ? 'موعد جديد' : 'New Appointment',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic ? 'حجز موعد جديد' : 'Booking new appointment',
                ),
                backgroundColor: Colors.purple,
              ),
            );
          },
        ),
        _buildQuickActionButton(
          context: context,
          icon: Icons.note_add,
          label: isArabic ? 'تقرير جديد' : 'New Report',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic ? 'إنشاء تقرير جديد' : 'Creating new report',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          },
        ),
        _buildQuickActionButton(
          context: context,
          icon: Icons.local_hospital,
          label: isArabic ? 'عيادة جديدة' : 'New Clinic',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic ? 'تسجيل عيادة جديدة' : 'Registering new clinic',
                ),
                backgroundColor: Colors.teal,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PremiumColors.primaryBlue.withValues(alpha: 0.08),
            PremiumColors.primaryBlue.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: PremiumColors.primaryBlue.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: PremiumColors.primaryBlue.withValues(alpha: 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PremiumColors.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: PremiumColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: PremiumColors.primaryBlue,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalsContent(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ApprovalBloc>(),
      child: const ApprovalsManagementScreen(),
    );
  }

  Widget _buildClinicsContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'إدارة العيادات' : 'Clinics Management',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildContentCard(
            context: context,
            title: isArabic ? 'العيادات النشطة' : 'Active Clinics',
            icon: Icons.local_hospital,
            color: Colors.teal,
            content: '24 عيادة',
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'إدارة الأطباء' : 'Doctors Management',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildContentCard(
            context: context,
            title: isArabic ? 'الأطباء المسجلين' : 'Registered Doctors',
            icon: Icons.medical_services,
            color: Colors.cyan,
            content: '156 طبيب',
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'إدارة المرضى' : 'Patients Management',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildContentCard(
            context: context,
            title: isArabic ? 'إجمالي المرضى' : 'Total Patients',
            icon: Icons.people,
            color: Colors.green,
            content: '2,341 مريض',
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'المواعيد' : 'Appointments',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildContentCard(
            context: context,
            title: isArabic ? 'المواعيد اليومية' : 'Today Appointments',
            icon: Icons.calendar_today,
            color: Colors.purple,
            content: '12 موعد',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'المدفوعات' : 'Payments',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildContentCard(
            context: context,
            title: isArabic ? 'إجمالي الإيرادات' : 'Total Revenue',
            icon: Icons.payment,
            color: Colors.orange,
            content: '45.8K ريال',
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'الاشتراكات' : 'Subscriptions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildContentCard(
            context: context,
            title: isArabic ? 'الاشتراكات النشطة' : 'Active Subscriptions',
            icon: Icons.card_membership,
            color: Colors.indigo,
            content: '85 اشتراك',
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'التحليلات والتقارير' : 'Analytics & Reports',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildContentCard(
            context: context,
            title: isArabic ? 'الأداء الشهري' : 'Monthly Performance',
            icon: Icons.analytics,
            color: Colors.red,
            content: isArabic ? 'معدل النمو: +15%' : 'Growth Rate: +15%',
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'الصلاحيات' : 'Permissions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildContentCard(
            context: context,
            title: isArabic ? 'الأدوار المتاحة' : 'Available Roles',
            icon: Icons.security,
            color: Colors.deepOrange,
            content: '5 أدوار',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'الإعدادات' : 'Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildContentCard(
            context: context,
            title: isArabic ? 'إعدادات النظام' : 'System Settings',
            icon: Icons.settings,
            color: Colors.grey,
            content: isArabic ? 'محدثة' : 'Updated',
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderConstructionScreen(BuildContext context, bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: PremiumColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.construction,
              size: 50,
              color: PremiumColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isArabic ? 'قيد الإنشاء' : 'Under Construction',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'هذه الميزة قريباً جداً' : 'Coming soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  void _showApprovalsModal(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: BlocProvider(
          create: (_) => sl<ApprovalBloc>(),
          child: const ApprovalsManagementScreen(),
        ),
      ),
    );
  }
}

// Data Classes
class MenuItem {
  const MenuItem({
    required this.id,
    required this.label,
    required this.labelEn,
    required this.icon,
    required this.color,
  });

  final String id;
  final String label;
  final String labelEn;
  final IconData icon;
  final Color color;
}

class StatisticCard {
  const StatisticCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String change;
}
