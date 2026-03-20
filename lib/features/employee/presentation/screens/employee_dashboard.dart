/// Employee Dashboard Example - مثال لوحة تحكم الموظف
/// Demonstrates UnifiedAppScaffold usage with real employee workflow
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

/// لوحة تحكم الموظف
class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  bool _isDarkMode = false;
  String _currentLanguage = 'ar';
  int _notificationCount = 5;

  @override
  Widget build(BuildContext context) {
    final isArabic = _currentLanguage == 'ar';

    return UnifiedAppScaffold(
      title: isArabic ? 'لوحة تحكم الموظف' : 'Employee Dashboard',
      body: _buildDashboardContent(context, isArabic),
      userRole: 'Employee',
      userData: AppScaffoldUserData(
        name: 'علي محمد',
        email: 'ali.employee@clinic.com',
        role: 'Employee',
        avatarUrl: null,
      ),
      notificationCount: _notificationCount,
      isDarkMode: _isDarkMode,
      currentLanguage: _currentLanguage,
      drawerItems: _buildEmployeeDrawerItems(isArabic),
      onLanguageChange: (lang) => setState(() => _currentLanguage = lang),
      onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
      onNotificationTap: () => _showNotifications(context, isArabic),
      onLogout: () => _handleLogout(context),
      accentColor: Colors.teal,
    );
  }

  /// بناء محتوى لوحة التحكم
  Widget _buildDashboardContent(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // إحصائيات اليوم
          _buildStatsSection(context, isArabic),
          SizedBox(height: 24),

          // المهام الحالية
          _buildTasksSection(context, isArabic),
          SizedBox(height: 24),

          // المرضى المعينين
          _buildPatientsSection(context, isArabic),
          SizedBox(height: 24),

          // الإجراءات السريعة
          _buildQuickActionsSection(context, isArabic),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  /// قسم الإحصائيات
  Widget _buildStatsSection(BuildContext context, bool isArabic) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'إحصائيات اليوم' : 'Today\'s Statistics',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: isArabic ? 'المهام المنجزة' : 'Tasks Completed',
                  value: '8',
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: isArabic ? 'المرضى المعالجين' : 'Patients Treated',
                  value: '15',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// بطاقة الإحصائية
  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  /// قسم المهام
  Widget _buildTasksSection(BuildContext context, bool isArabic) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'المهام الحالية' : 'Current Tasks',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 12),
          _buildTaskItem(
            context: context,
            title: isArabic ? 'تسجيل المرضى الجدد' : 'Register New Patients',
            time: '9:00 AM - 12:00 PM',
            isArabic: isArabic,
          ),
          SizedBox(height: 8),
          _buildTaskItem(
            context: context,
            title:
                isArabic ? 'تنظيم البيانات الطبية' : 'Organize Medical Records',
            time: '1:00 PM - 3:00 PM',
            isArabic: isArabic,
          ),
          SizedBox(height: 8),
          _buildTaskItem(
            context: context,
            title: isArabic ? 'تنسيق المواعيد' : 'Coordinate Appointments',
            time: '3:00 PM - 5:00 PM',
            isArabic: isArabic,
          ),
        ],
      ),
    );
  }

  /// عنصر المهمة
  Widget _buildTaskItem({
    required BuildContext context,
    required String title,
    required String time,
    required bool isArabic,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment, color: Colors.teal),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// قسم المرضى المعينين
  Widget _buildPatientsSection(BuildContext context, bool isArabic) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'المرضى المعينين لك' : 'Your Assigned Patients',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 12),
          _buildPatientItem(
            context: context,
            name: 'محمد علي',
            age: '45',
            room: '102',
            isArabic: isArabic,
          ),
          SizedBox(height: 8),
          _buildPatientItem(
            context: context,
            name: 'فاطمة محمد',
            age: '32',
            room: '103',
            isArabic: isArabic,
          ),
        ],
      ),
    );
  }

  /// عنصر المريض
  Widget _buildPatientItem({
    required BuildContext context,
    required String name,
    required String age,
    required String room,
    required bool isArabic,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(name[0], style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  '${isArabic ? 'العمر' : 'Age'}: $age - ${isArabic ? 'الغرفة' : 'Room'}: $room',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// قسم الإجراءات السريعة
  Widget _buildQuickActionsSection(BuildContext context, bool isArabic) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'إجراءات سريعة' : 'Quick Actions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
            children: [
              _buildActionCard(
                context: context,
                icon: Icons.person_add,
                title: isArabic ? 'مريض جديد' : 'New Patient',
                color: Colors.blue,
                onTap: () {},
              ),
              _buildActionCard(
                context: context,
                icon: Icons.event,
                title: isArabic ? 'موعد جديد' : 'New Appointment',
                color: Colors.green,
                onTap: () {},
              ),
              _buildActionCard(
                context: context,
                icon: Icons.assessment,
                title: isArabic ? 'تقرير' : 'Report',
                color: Colors.orange,
                onTap: () {},
              ),
              _buildActionCard(
                context: context,
                icon: Icons.settings,
                title: isArabic ? 'إعدادات' : 'Settings',
                color: Colors.purple,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// بطاقة الإجراء
  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء عناصر الدرج
  List<DrawerItem> _buildEmployeeDrawerItems(bool isArabic) {
    return [
      DrawerItem(
        label: isArabic ? 'لوحة التحكم' : 'Dashboard',
        icon: Icons.dashboard,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'المرضى' : 'Patients',
        icon: Icons.people,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'المواعيد' : 'Appointments',
        icon: Icons.event,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'البيانات الطبية' : 'Medical Records',
        icon: Icons.description,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'التقارير' : 'Reports',
        icon: Icons.assessment,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'المخزون' : 'Inventory',
        icon: Icons.inventory_2,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'الإعدادات' : 'Settings',
        icon: Icons.settings,
        onTap: () {},
      ),
      DrawerItem(
        label: isArabic ? 'تسجيل الخروج' : 'Logout',
        icon: Icons.logout,
        onTap: () => _handleLogout(context),
      ),
    ];
  }

  /// عرض الإشعارات
  void _showNotifications(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'الإشعارات' : 'Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text(isArabic
                  ? 'موعد جديد في الساعة 3 مساءً'
                  : 'New appointment at 3 PM'),
            ),
            ListTile(
              leading: Icon(Icons.assignment, color: Colors.green),
              title: Text(isArabic ? 'مهمة جديدة انتظرت' : 'New task assigned'),
            ),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.orange),
              title:
                  Text(isArabic ? 'تنبيه اختبار مستحق' : 'Lab test due alert'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }

  /// معالج تسجيل الخروج
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentLanguage == 'ar' ? 'تسجيل الخروج' : 'Logout'),
        content: Text(_currentLanguage == 'ar'
            ? 'هل تريد تسجيل الخروج؟'
            : 'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_currentLanguage == 'ar' ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add actual logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_currentLanguage == 'ar'
                      ? 'تم تسجيل الخروج'
                      : 'You have been logged out'),
                ),
              );
            },
            child: Text(_currentLanguage == 'ar' ? 'تسجيل الخروج' : 'Logout'),
          ),
        ],
      ),
    );
  }
}
