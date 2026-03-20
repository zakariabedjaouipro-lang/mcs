/// Admin Dashboard Example - مثال لوحة تحكم الإدارة
/// Demonstrates UnifiedAppScaffold usage with real admin workflow
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

/// لوحة تحكم الإدارة
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isDarkMode = false;
  String _currentLanguage = 'ar';
  int _notificationCount = 5;

  @override
  Widget build(BuildContext context) {
    final isArabic = _currentLanguage == 'ar';

    return UnifiedAppScaffold(
      title: isArabic ? 'لوحة تحكم الإدارة' : 'Admin Dashboard',
      body: _buildDashboardContent(context, isArabic),
      userRole: 'Clinic Admin',
      userData: AppScaffoldUserData(
        name: 'محمد الإداري',
        email: 'admin@clinic.com',
        role: 'Clinic Admin',
        avatarUrl: null,
      ),
      notificationCount: _notificationCount,
      isDarkMode: _isDarkMode,
      currentLanguage: _currentLanguage,
      drawerItems: _buildAdminDrawerItems(isArabic),
      onLanguageChange: (lang) => setState(() => _currentLanguage = lang),
      onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
      onNotificationTap: () => _showNotifications(context, isArabic),
      onLogout: () => _handleLogout(context),
      accentColor: Colors.indigo,
    );
  }

  /// بناء محتوى لوحة التحكم
  Widget _buildDashboardContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      child: Column(
        spacing: 20,
        children: [
          // Key Metrics - 4 column layout
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: _MetricCard(
                  title: isArabic ? 'المرضى' : 'Patients',
                  value: '1,250',
                  icon: Icons.people,
                  color: Colors.blue,
                  change: '+12',
                  isArabic: isArabic,
                ),
              ),
              Expanded(
                child: _MetricCard(
                  title: isArabic ? 'الأطباء' : 'Doctors',
                  value: '45',
                  icon: Icons.medical_services,
                  color: Colors.blue,
                  change: '+2',
                  isArabic: isArabic,
                ),
              ),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: _MetricCard(
                  title: isArabic ? 'المواعيد' : 'Appointments',
                  value: '328',
                  icon: Icons.calendar_today,
                  color: Colors.green,
                  change: '+45',
                  isArabic: isArabic,
                ),
              ),
              Expanded(
                child: _MetricCard(
                  title: isArabic ? 'الإيرادات' : 'Revenue',
                  value: '\$12.5K',
                  icon: Icons.attach_money,
                  color: Colors.green,
                  change: '+8%',
                  isArabic: isArabic,
                ),
              ),
            ],
          ),
          // Daily Activity
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    isArabic ? 'الأنشطة اليومية' : 'Daily Activities',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _ActivityItem(
                    icon: Icons.person_add,
                    title: isArabic ? 'مريض جديد' : 'New Patient',
                    subtitle: 'أحمد محمد' + (isArabic ? '' : ' - Ahmed'),
                    time: '09:30 AM',
                    isArabic: isArabic,
                  ),
                  _ActivityItem(
                    icon: Icons.assignment,
                    title: isArabic ? 'موعد جديد' : 'New Appointment',
                    subtitle: isArabic ? 'د. فاطمة' : 'Dr. Fatima',
                    time: '10:15 AM',
                    isArabic: isArabic,
                  ),
                  _ActivityItem(
                    icon: Icons.check_circle,
                    title: isArabic ? 'موعد مكتمل' : 'Appointment Done',
                    subtitle: 'علي حسن',
                    time: '11:45 AM',
                    isArabic: isArabic,
                  ),
                ],
              ),
            ),
          ),
          // System Status
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    isArabic ? 'حالة النظام' : 'System Status',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _StatusItem(
                    label: isArabic ? 'قاعدة البيانات' : 'Database',
                    status: 'Healthy',
                    isHealthy: true,
                    isArabic: isArabic,
                  ),
                  _StatusItem(
                    label: isArabic ? 'الخادم' : 'Server',
                    status: 'Online',
                    isHealthy: true,
                    isArabic: isArabic,
                  ),
                  _StatusItem(
                    label: isArabic ? 'النسخ الاحتياطي' : 'Backup',
                    status: '2 hours ago',
                    isHealthy: true,
                    isArabic: isArabic,
                  ),
                ],
              ),
            ),
          ),
          // Quick Actions
          Text(
            isArabic ? 'المهام السريعة' : 'Quick Tasks',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _AdminActionCard(
                icon: Icons.person_add,
                label: isArabic ? 'مستخدم جديد' : 'Add User',
                onTap: () {},
              ),
              _AdminActionCard(
                icon: Icons.assessment,
                label: isArabic ? 'تقرير شامل' : 'Generate Report',
                onTap: () {},
              ),
              _AdminActionCard(
                icon: Icons.backup,
                label: isArabic ? 'نسخة احتياطية' : 'Backup',
                onTap: () {},
              ),
              _AdminActionCard(
                icon: Icons.tune,
                label: isArabic ? 'الإعدادات' : 'Settings',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// بناء عناصر دراج الإدارة
  List<DrawerItem> _buildAdminDrawerItems(bool isArabic) {
    return [
      DrawerItemBuilder.dashboard(
        isArabic ? 'لوحة التحكم' : 'Dashboard',
        () {},
      ),
      DrawerItemBuilder.patients(
        isArabic ? 'إدارة المرضى' : 'Manage Patients',
        () {},
      ),
      DrawerItem(
        label: isArabic ? 'إدارة الأطباء' : 'Manage Doctors',
        icon: Icons.medical_services,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'إدارة الموظفين' : 'Manage Staff',
        icon: Icons.people,
        onTap: () {},
      ),
      DrawerItemBuilder.appointments(
        isArabic ? 'المواعيد' : 'Appointments',
        () {},
        badge: '5',
      ),
      DrawerItemBuilder.analytics(
        isArabic ? 'التقارير والإحصائيات' : 'Reports & Analytics',
        () {},
      ),
      DrawerItem(
        label: isArabic ? 'الفواتير' : 'Invoices',
        icon: Icons.receipt,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'المخزون' : 'Inventory',
        icon: Icons.inventory,
        onTap: () {},
      ),
      DrawerItemBuilder.settings(
        isArabic ? 'إعدادات النظام' : 'System Settings',
        () {},
      ),
      DrawerItemBuilder.logout(
        isArabic ? 'تسجيل الخروج' : 'Logout',
        () => _handleLogout(context),
      ),
    ];
  }

  void _showNotifications(BuildContext context, bool isArabic) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? 'لديك 5 إشعارات جديدة' : 'You have 5 new notifications',
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out')),
    );
  }
}

// Helper widgets for Admin Dashboard

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String change;
  final bool isArabic;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 8,
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              change,
              style: TextStyle(
                fontSize: 11,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isArabic;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.indigo),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String status;
  final bool isHealthy;
  final bool isArabic;

  const _StatusItem({
    required this.label,
    required this.status,
    required this.isHealthy,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          spacing: 8,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isHealthy ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: isHealthy ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.indigo,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
