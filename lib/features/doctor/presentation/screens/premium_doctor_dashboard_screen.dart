/// Premium Doctor Dashboard Screen
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/app_button.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

class PremiumDoctorDashboardScreen extends StatefulWidget {
  const PremiumDoctorDashboardScreen({super.key});

  @override
  State<PremiumDoctorDashboardScreen> createState() =>
      _PremiumDoctorDashboardScreenState();
}

class _PremiumDoctorDashboardScreenState
    extends State<PremiumDoctorDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return AppScaffold(
      title: isArabic ? 'لوحة التحكم' : 'Dashboard',
      showBackButton: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic
                      ? 'شاشة الإشعارات قريباً'
                      : 'Notifications screen coming soon',
                ),
              ),
            );
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'logout') {
              _showLogoutConfirmation(context, isArabic);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Text(isArabic ? 'الملف الشخصي' : 'Profile'),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Text(isArabic ? 'الإعدادات' : 'Settings'),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Text(
                isArabic ? 'تسجيل الخروج' : 'Logout',
                style: const TextStyle(color: PremiumColors.errorRed),
              ),
            ),
          ],
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(context, isArabic),
              const SizedBox(height: 24),
              _buildStatsGrid(context, isArabic),
              const SizedBox(height: 24),
              _buildTodayAppointments(context, isArabic),
              const SizedBox(height: 24),
              _buildQuickActions(context, isArabic),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, bool isArabic) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: PremiumColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'مرحباً،' : 'Welcome,',
                    style: PremiumTextStyles.headingMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic ? 'د. أحمد المنصوري' : 'Dr. Ahmed Al-Mansouri',
                    style: PremiumTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isArabic) {
    final stats = [
      {
        'title': isArabic ? 'إجمالي المرضى' : 'Total Patients',
        'value': '124',
        'icon': Icons.people,
        'color': PremiumColors.primaryBlue,
      },
      {
        'title': isArabic ? 'مواعيد اليوم' : "Today's Appointments",
        'value': '8',
        'icon': Icons.calendar_today,
        'color': PremiumColors.successGreen,
      },
      {
        'title': isArabic ? 'القادمة' : 'Upcoming',
        'value': '15',
        'icon': Icons.schedule,
        'color': PremiumColors.warningOrange,
      },
      {
        'title': isArabic ? 'في الانتظار' : 'Pending',
        'value': '3',
        'icon': Icons.pending_actions,
        'color': PremiumColors.errorRed,
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: stats.map((stat) {
        return AppCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (stat['color']! as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    stat['icon']! as IconData,
                    color: stat['color']! as Color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stat['value']! as String,
                  style: PremiumTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['title']! as String,
                  style: PremiumTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTodayAppointments(BuildContext context, bool isArabic) {
    final appointments = [
      {
        'patient': isArabic ? 'فاطمة المازروي' : 'Fatima Al-Mazrouei',
        'time': '09:00 AM',
        'type': isArabic ? 'فحص عام' : 'General Checkup',
      },
      {
        'patient': isArabic ? 'محمد القاسمي' : 'Mohammed Al-Qasimi',
        'time': '10:30 AM',
        'type': isArabic ? 'متابعة السكري' : 'Diabetes Follow-up',
      },
      {
        'patient': isArabic ? 'أميرة الداهري' : 'Amira Al-Dhaheri',
        'time': '02:00 PM',
        'type': isArabic ? 'ما بعد الجراحة' : 'Post-Operative',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'مواعيد اليوم' : "Today's Appointments",
          style: PremiumTextStyles.headingMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...appointments.map((appointment) {
          return AppCard(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(appointment['patient']!),
              subtitle: Text(
                '${appointment['time']} • ${appointment['type']}',
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isArabic) {
    final actions = [
      {
        'icon': Icons.calendar_today,
        'label': isArabic ? 'جدولة موعد' : 'Schedule Appointment',
      },
      {
        'icon': Icons.medical_services,
        'label': isArabic ? 'إضافة وصفة' : 'Add Prescription',
      },
      {
        'icon': Icons.science,
        'label': isArabic ? 'نتائج المختبر' : 'Lab Results',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'إجراءات سريعة' : 'Quick Actions',
          style: PremiumTextStyles.headingMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: actions.map((action) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AppButton(
                  label: action['label']! as String,
                  icon: action['icon']! as IconData,
                  size: AppButtonSize.small,
                  variant: AppButtonVariant.secondary,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(action['label']! as String)),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
        content: Text(
          isArabic
              ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟'
              : 'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              isArabic ? 'تسجيل الخروج' : 'Logout',
              style: const TextStyle(color: PremiumColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }
}
