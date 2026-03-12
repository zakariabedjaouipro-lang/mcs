/// Premium Patient Home Screen
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

class PremiumPatientHomeScreen extends StatelessWidget {
  const PremiumPatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return AppScaffold(
      title: isArabic ? 'الرئيسية' : 'Home',
      showBackButton: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(isArabic ? 'لا توجد إشعارات' : 'No notifications'),
              ),
            );
          },
          tooltip: isArabic ? 'الإشعارات' : 'Notifications',
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isArabic ? 'الإعدادات' : 'Settings'),
              ),
            );
          },
          tooltip: isArabic ? 'الإعدادات' : 'Settings',
        ),
      ],
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Welcome Card
              _welcomeCard(context, isArabic),
              const SizedBox(height: 24),

              /// Quick Actions Section
              _quickActionsSection(context, isArabic),
              const SizedBox(height: 24),

              /// Appointments Card
              _sectionCard(
                context,
                icon: Icons.calendar_month_outlined,
                title: isArabic ? 'المواعيد' : 'Appointments',
                subtitle: isArabic
                    ? 'لا توجد مواعيد قادمة'
                    : 'No upcoming appointments',
                isArabic: isArabic,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? 'الانتقال إلى المواعيد'
                            : 'Navigate to appointments',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              /// Prescriptions Card
              _sectionCard(
                context,
                icon: Icons.medication_outlined,
                title: isArabic ? 'الوصفات' : 'Prescriptions',
                subtitle:
                    isArabic ? 'لا توجد وصفات نشطة' : 'No active prescriptions',
                isArabic: isArabic,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? 'الانتقال إلى الوصفات'
                            : 'Navigate to prescriptions',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              /// Lab Results Card
              _sectionCard(
                context,
                icon: Icons.science_outlined,
                title: isArabic ? 'نتائج المختبر' : 'Lab Results',
                subtitle: isArabic ? 'لا توجد نتائج' : 'No lab results',
                isArabic: isArabic,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? 'الانتقال إلى نتائج المختبر'
                            : 'Navigate to lab results',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Welcome Card with user information
  Widget _welcomeCard(BuildContext context, bool isArabic) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: PremiumColors.primaryGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'مرحباً' : 'Welcome',
                    style: PremiumTextStyles.headingMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PremiumColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic ? 'لوحة المريض' : 'Patient Dashboard',
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

  /// Quick Actions Grid Section
  Widget _quickActionsSection(BuildContext context, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الإجراءات السريعة' : 'Quick Actions',
          style: PremiumTextStyles.headingLarge.copyWith(
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
          childAspectRatio: 1.1,
          children: [
            _actionCard(
              context,
              icon: Icons.calendar_today_outlined,
              label: isArabic ? 'حجز موعد' : 'Book Appointment',
              isArabic: isArabic,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic ? 'حجز موعد جديد' : 'Book new appointment',
                    ),
                  ),
                );
              },
            ),
            _actionCard(
              context,
              icon: Icons.video_call_outlined,
              label: isArabic ? 'جلسات عن بعد' : 'Remote Sessions',
              isArabic: isArabic,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(isArabic ? 'جلسات الفيديو' : 'Video sessions'),
                  ),
                );
              },
            ),
            _actionCard(
              context,
              icon: Icons.medication_outlined,
              label: isArabic ? 'الوصفات' : 'Prescriptions',
              isArabic: isArabic,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(isArabic ? 'عرض الوصفات' : 'View prescriptions'),
                  ),
                );
              },
            ),
            _actionCard(
              context,
              icon: Icons.science_outlined,
              label: isArabic ? 'نتائج المختبر' : 'Lab Results',
              isArabic: isArabic,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic ? 'عرض نتائج المختبر' : 'View lab results',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Action Card for quick access
  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isArabic,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: PremiumColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: PremiumColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: PremiumTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: PremiumColors.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Card with icon and navigation
  Widget _sectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isArabic,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                size: 20,
                color: PremiumColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PremiumTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: PremiumColors.darkText,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PremiumTextStyles.bodySmall.copyWith(
                      color: PremiumColors.lightText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: PremiumColors.lightText,
            ),
          ],
        ),
      ),
    );
  }
}
