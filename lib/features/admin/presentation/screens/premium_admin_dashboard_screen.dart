/// Premium Admin Dashboard Screen
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

class PremiumAdminDashboardScreen extends StatelessWidget {
  const PremiumAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return AppScaffold(
      title: isArabic ? 'لوحة تحكم المدير' : 'Admin Dashboard',
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
            if (value == 'profile') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? 'شاشة الملف الشخصي قريباً'
                        : 'Profile screen coming soon',
                  ),
                ),
              );
            } else if (value == 'settings') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? 'شاشة الإعدادات قريباً'
                        : 'Settings screen coming soon',
                  ),
                ),
              );
            } else if (value == 'logout') {
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
              _buildQuickActions(context, isArabic),
              const SizedBox(height: 24),
              _buildRecentActivity(context, isArabic),
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
                Icons.admin_panel_settings,
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
                    isArabic ? 'مرحباً، المدير' : 'Welcome, Admin',
                    style: PremiumTextStyles.headingMedium.copyWith(
                      color: PremiumColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic
                        ? 'إدارة العيادات بسهولة'
                        : 'Manage clinics with ease',
                    style: PremiumTextStyles.bodyMedium.copyWith(
                      color: PremiumColors.lightText,
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
        'title': isArabic ? 'إجمالي العيادات' : 'Total Clinics',
        'value': '18',
        'icon': Icons.local_hospital,
        'color': PremiumColors.primaryBlue,
      },
      {
        'title': isArabic ? 'إجمالي الأطباء' : 'Total Doctors',
        'value': '42',
        'icon': Icons.medical_services,
        'color': PremiumColors.successGreen,
      },
      {
        'title': isArabic ? 'إجمالي المرضى' : 'Total Patients',
        'value': '1240',
        'icon': Icons.people,
        'color': PremiumColors.warningOrange,
      },
      {
        'title': isArabic ? 'الاشتراكات النشطة' : 'Active Subscriptions',
        'value': '15',
        'icon': Icons.card_membership,
        'color': PremiumColors.accentCyan,
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
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stat['value']! as String,
                  style: PremiumTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: PremiumColors.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['title']! as String,
                  style: PremiumTextStyles.bodySmall.copyWith(
                    color: PremiumColors.lightText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isArabic) {
    final actions = [
      {
        'icon': Icons.local_hospital,
        'label': isArabic ? 'إدارة العيادات' : 'Manage Clinics',
        'color': PremiumColors.primaryBlue,
      },
      {
        'icon': Icons.people,
        'label': isArabic ? 'إدارة الأطباء' : 'Manage Doctors',
        'color': PremiumColors.successGreen,
      },
      {
        'icon': Icons.card_membership,
        'label': isArabic ? 'إدارة الاشتراكات' : 'Manage Subscriptions',
        'color': PremiumColors.warningOrange,
      },
      {
        'icon': Icons.monetization_on,
        'label': isArabic ? 'العملات' : 'Currencies',
        'color': PremiumColors.accentCyan,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الإجراءات السريعة' : 'Quick Actions',
          style: PremiumTextStyles.headingMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: PremiumColors.darkText,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: actions.map((action) {
            return AppCard(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(action['label']! as String),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            (action['color']! as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        action['icon']! as IconData,
                        color: action['color']! as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      action['label']! as String,
                      textAlign: TextAlign.center,
                      style: PremiumTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: PremiumColors.darkText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الأنشطة الأخيرة' : 'Recent Activity',
          style: PremiumTextStyles.headingMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: PremiumColors.darkText,
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              _buildActivityItem(
                icon: Icons.local_hospital,
                title: isArabic ? 'تم إنشاء عيادة جديدة' : 'New clinic created',
                subtitle: isArabic
                    ? 'عيادة الرعاية - الرياض'
                    : 'Care Clinic - Riyadh',
                time: '2 min ago',
              ),
              _buildActivityItem(
                icon: Icons.medical_services,
                title: isArabic ? 'تمت إضافة طبيب' : 'Doctor added',
                subtitle:
                    isArabic ? 'د. أحمد المانصوري' : 'Dr. Ahmed Al-Mansouri',
                time: '15 min ago',
              ),
              _buildActivityItem(
                icon: Icons.card_membership,
                title: isArabic ? 'تم تجديد اشتراك' : 'Subscription renewed',
                subtitle: isArabic ? 'عيادة المستقبل' : 'Future Clinic',
                time: '1 hour ago',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: PremiumColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: PremiumColors.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: PremiumTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: PremiumColors.darkText,
                  ),
                ),
                Text(
                  subtitle,
                  style: PremiumTextStyles.bodySmall.copyWith(
                    color: PremiumColors.lightText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: PremiumTextStyles.bodySmall.copyWith(
              color: PremiumColors.lightText,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, bool isArabic) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
        content: Text(
          isArabic
              ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟'
              : 'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? 'تم تسجيل الخروج بنجاح'
                        : 'Logged out successfully',
                  ),
                ),
              );
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
