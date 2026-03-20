/// Doctor Dashboard Example - مثال لوحة تحكم الطبيب
/// Demonstrates UnifiedAppScaffold usage with real doctor workflow
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

/// لوحة تحكم الطبيب
class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  bool _isDarkMode = false;
  String _currentLanguage = 'ar';
  int _notificationCount = 3;

  @override
  Widget build(BuildContext context) {
    final isArabic = _currentLanguage == 'ar';

    return UnifiedAppScaffold(
      title: isArabic ? 'لوحة تحكم الطبيب' : 'Doctor Dashboard',
      body: _buildDashboardContent(context, isArabic),
      userRole: 'Doctor',
      userData: AppScaffoldUserData(
        name: 'د. أحمد محمد',
        email: 'ahmed.doctor@clinic.com',
        role: 'Doctor',
        avatarUrl: null,
      ),
      notificationCount: _notificationCount,
      isDarkMode: _isDarkMode,
      currentLanguage: _currentLanguage,
      drawerItems: _buildDoctorDrawerItems(isArabic),
      onLanguageChange: (lang) => setState(() => _currentLanguage = lang),
      onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
      onNotificationTap: () => _showNotifications(context, isArabic),
      onLogout: () => _handleLogout(context),
      accentColor: Colors.blue,
    );
  }

  /// بناء محتوى لوحة التحكم
  Widget _buildDashboardContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Statistics Cards
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: _StatCard(
                  title: isArabic ? 'المرضى' : 'Patients',
                  value: '125',
                  icon: Icons.people,
                  color: Colors.blue,
                  isArabic: isArabic,
                ),
              ),
              Expanded(
                child: _StatCard(
                  title: isArabic ? 'المواعيد' : 'Appointments',
                  value: '12',
                  icon: Icons.calendar_today,
                  color: Colors.green,
                  isArabic: isArabic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Today's Schedule
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
                    isArabic ? 'مواعيد اليوم' : "Today's Appointments",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _AppointmentItem(
                    time: '09:00 AM',
                    patientName: 'محمد علي',
                    type: isArabic ? 'فحص عام' : 'General Checkup',
                    isArabic: isArabic,
                  ),
                  const Divider(height: 12),
                  _AppointmentItem(
                    time: '10:30 AM',
                    patientName: 'فاطمة أحمد',
                    type: isArabic ? 'متابعة' : 'Follow-up',
                    isArabic: isArabic,
                  ),
                  const Divider(height: 12),
                  _AppointmentItem(
                    time: '02:00 PM',
                    patientName: 'علي حسن',
                    type: isArabic ? 'فحص متقدم' : 'Advanced Check',
                    isArabic: isArabic,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Quick Actions
          Text(
            isArabic ? 'الإجراءات السريعة' : 'Quick Actions',
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
              _QuickActionCard(
                icon: Icons.add_circle_outline,
                label: isArabic ? 'تشخيص جديد' : 'New Diagnosis',
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.edit_note,
                label: isArabic ? 'وصفة طبية' : 'Prescription',
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.assignment,
                label: isArabic ? 'طلب فحص' : 'Lab Request',
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.videocam,
                label: isArabic ? 'استشارة فيديو' : 'Video Call',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// بناء عناصر دراج الطبيب
  List<DrawerItem> _buildDoctorDrawerItems(bool isArabic) {
    return [
      DrawerItemBuilder.dashboard(
        isArabic ? 'لوحة التحكم' : 'Dashboard',
        () {},
      ),
      DrawerItemBuilder.appointments(
        isArabic ? 'المواعيد' : 'Appointments',
        () {},
        badge: '12',
      ),
      DrawerItemBuilder.patients(
        isArabic ? 'المرضى' : 'Patients',
        () {},
      ),
      DrawerItemBuilder.prescriptions(
        isArabic ? 'الوصفات الطبية' : 'Prescriptions',
        () {},
      ),
      DrawerItemBuilder.reports(
        isArabic ? 'التقارير' : 'Reports',
        () {},
      ),
      DrawerItem(
        label: isArabic ? 'التشخيصات' : 'Diagnoses',
        icon: Icons.medical_services,
        onTap: () {},
      ),
      DrawerItemBuilder.settings(
        isArabic ? 'الإعدادات' : 'Settings',
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
          isArabic ? 'لديك 3 إشعارات جديدة' : 'You have 3 new notifications',
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

// Helper widgets for Doctor Dashboard

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isArabic;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentItem extends StatelessWidget {
  final String time;
  final String patientName;
  final String type;
  final bool isArabic;

  const _AppointmentItem({
    required this.time,
    required this.patientName,
    required this.type,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                patientName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
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
              color: Colors.blue,
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
