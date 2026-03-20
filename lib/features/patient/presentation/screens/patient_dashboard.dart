/// Patient Dashboard Example - مثال لوحة تحكم المريض
/// Demonstrates UnifiedAppScaffold usage with real patient workflow
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

/// لوحة تحكم المريض
class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  bool _isDarkMode = false;
  String _currentLanguage = 'ar';
  int _notificationCount = 2;

  @override
  Widget build(BuildContext context) {
    final isArabic = _currentLanguage == 'ar';

    return UnifiedAppScaffold(
      title: isArabic ? 'صحتي' : 'My Health',
      body: _buildDashboardContent(context, isArabic),
      userRole: 'Patient',
      userData: AppScaffoldUserData(
        name: 'فاطمة محمد',
        email: 'fatima.patient@clinic.com',
        role: 'Patient',
        avatarUrl: null,
      ),
      notificationCount: _notificationCount,
      isDarkMode: _isDarkMode,
      currentLanguage: _currentLanguage,
      drawerItems: _buildPatientDrawerItems(isArabic),
      onLanguageChange: (lang) => setState(() => _currentLanguage = lang),
      onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
      onNotificationTap: () => _showNotifications(context, isArabic),
      onLogout: () => _handleLogout(context),
      accentColor: Colors.green,
    );
  }

  /// بناء محتوى لوحة التحكم
  Widget _buildDashboardContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Health Status Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    isArabic ? 'حالتك الصحية' : 'Your Health Status',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _HealthMetric(
                        label: isArabic ? 'ضغط الدم' : 'Blood Pressure',
                        value: '120/80',
                        unit: 'mmHg',
                        status: 'Normal',
                      ),
                      _HealthMetric(
                        label: isArabic ? 'النبض' : 'Heart Rate',
                        value: '72',
                        unit: 'bpm',
                        status: 'Normal',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Next Appointment
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
                    isArabic ? 'الموعد القادم' : 'Next Appointment',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _AppointmentDetailCard(
                    doctor: 'Dr. Ahmed Mohamed',
                    type: isArabic ? 'فحص عام' : 'General Checkup',
                    date: '2024-04-15',
                    time: '10:00 AM',
                    location: isArabic ? 'عيادة الداخلية' : 'Main Clinic',
                    isArabic: isArabic,
                  ),
                ],
              ),
            ),
          ),
          // Recent Prescriptions
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
                    isArabic ? 'الوصفات الطبية' : 'Prescriptions',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _PrescriptionItem(
                    medication: 'Paracetamol',
                    dosage: '500mg',
                    frequency: isArabic ? '3 مرات يومياً' : '3 times daily',
                    duration: '7 days',
                    isArabic: isArabic,
                  ),
                  const Divider(height: 12),
                  _PrescriptionItem(
                    medication: 'Vitamin C',
                    dosage: '1000mg',
                    frequency: isArabic ? 'مرة واحدة يومياً' : 'Once daily',
                    duration: '30 days',
                    isArabic: isArabic,
                  ),
                ],
              ),
            ),
          ),
          // Quick Actions
          Text(
            isArabic ? 'الخدمات السريعة' : 'Quick Services',
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
              _ServiceCard(
                icon: Icons.calendar_today,
                label: isArabic ? 'حجز موعد' : 'Book Appointment',
                onTap: () {},
              ),
              _ServiceCard(
                icon: Icons.videocam,
                label: isArabic ? 'استشارة فيديو' : 'Video Consultation',
                onTap: () {},
              ),
              _ServiceCard(
                icon: Icons.assignment,
                label: isArabic ? 'نتائج الفحوصات' : 'Test Results',
                onTap: () {},
              ),
              _ServiceCard(
                icon: Icons.file_download,
                label: isArabic ? 'تحميل التقارير' : 'Download Reports',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// بناء عناصر دراج المريض
  List<DrawerItem> _buildPatientDrawerItems(bool isArabic) {
    return [
      DrawerItemBuilder.dashboard(
        isArabic ? 'لوحة التحكم' : 'Dashboard',
        () {},
      ),
      DrawerItemBuilder.appointments(
        isArabic ? 'المواعيد' : 'Appointments',
        () {},
        badge: '1',
      ),
      DrawerItemBuilder.prescriptions(
        isArabic ? 'الوصفات الطبية' : 'Prescriptions',
        () {},
      ),
      DrawerItemBuilder.reports(
        isArabic ? 'التقارير الطبية' : 'Medical Reports',
        () {},
      ),
      DrawerItem(
        label: isArabic ? 'نتائج الفحوصات' : 'Lab Results',
        icon: Icons.science,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'ملفي الصحي' : 'Health Records',
        icon: Icons.health_and_safety,
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
          isArabic ? 'لديك إشعاران جديدان' : 'You have 2 new notifications',
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

// Helper widgets for Patient Dashboard

class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String status;

  const _HealthMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _AppointmentDetailCard extends StatelessWidget {
  final String doctor;
  final String type;
  final String date;
  final String time;
  final String location;
  final bool isArabic;

  const _AppointmentDetailCard({
    required this.doctor,
    required this.type,
    required this.date,
    required this.time,
    required this.location,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            doctor,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            type,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Row(
            spacing: 16,
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.green),
              Text(date, style: const TextStyle(fontSize: 12)),
              Icon(Icons.access_time, size: 16, color: Colors.green),
              Text(time, style: const TextStyle(fontSize: 12)),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.green),
              Text(location, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrescriptionItem extends StatelessWidget {
  final String medication;
  final String dosage;
  final String frequency;
  final String duration;
  final bool isArabic;

  const _PrescriptionItem({
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          medication,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: Text(
                '$dosage • $frequency',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            Text(
              duration,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceCard({
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
              color: Colors.green,
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
