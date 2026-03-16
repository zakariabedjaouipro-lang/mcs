/// Premium Landing Screen
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/app_button.dart';

class PremiumLandingScreen extends StatelessWidget {
  const PremiumLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 700;
    final horizontalPadding = isMobile ? 24.0 : 80.0;
    final heroSpacing = isMobile ? 40.0 : 80.0;
    final buttonSpacing = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: PremiumColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, isArabic, horizontalPadding),
            _buildHero(
              context,
              isArabic,
              horizontalPadding,
              heroSpacing,
              buttonSpacing,
            ),
            _buildFeatures(context, isArabic, horizontalPadding),
            _buildFooter(context, isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isArabic,
    double horizontalPadding,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: PremiumColors.mediumGrey,
          ),
        ),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: PremiumColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'MCS',
                style: PremiumTextStyles.headingMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              context.go(AppRoutes.login);
            },
            child: Text(isArabic ? 'تسجيل الدخول' : 'Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(
    BuildContext context,
    bool isArabic,
    double horizontalPadding,
    double heroSpacing,
    double buttonSpacing,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: heroSpacing,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PremiumColors.primaryBlue.withValues(alpha: 0.05),
            PremiumColors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Text(
            isArabic
                ? 'منصة متكاملة لإدارة العيادات الطبية'
                : 'Complete Platform for Medical Clinic Management',
            style: PremiumTextStyles.headingLarge.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            isArabic
                ? 'إدارة المرضى والمواعيد والفواتير بسهولة واحترافية'
                : 'Manage patients, appointments and billing with ease',
            style: PremiumTextStyles.headingMedium.copyWith(
              color: PremiumColors.lightText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: buttonSpacing),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              AppButton(
                label: isArabic ? 'ابدأ الآن' : 'Get Started',
                icon: Icons.arrow_forward,
                onPressed: () {
                  context.go(AppRoutes.register);
                },
              ),
              AppButton(
                label: isArabic ? 'عرض المزايا' : 'View Features',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  context.go(AppRoutes.features);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures(
    BuildContext context,
    bool isArabic,
    double horizontalPadding,
  ) {
    final features = [
      {
        'icon': Icons.people,
        'title': isArabic ? 'إدارة المرضى' : 'Patient Management',
        'desc': isArabic
            ? 'إدارة ملفات المرضى بسهولة'
            : 'Manage patient records easily',
      },
      {
        'icon': Icons.calendar_today,
        'title': isArabic ? 'إدارة المواعيد' : 'Appointments',
        'desc':
            isArabic ? 'جدولة المواعيد بسرعة' : 'Schedule appointments quickly',
      },
      {
        'icon': Icons.receipt_long,
        'title': isArabic ? 'الفواتير' : 'Billing',
        'desc': isArabic ? 'نظام فواتير متكامل' : 'Complete billing system',
      },
      {
        'icon': Icons.analytics,
        'title': isArabic ? 'التقارير' : 'Analytics',
        'desc': isArabic
            ? 'تقارير وإحصائيات متقدمة'
            : 'Advanced reports and analytics',
      },
    ];

    final width = MediaQuery.of(context).size.width;
    final crossAxis = width < 700 ? 1 : 2;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            isArabic ? 'المميزات الرئيسية' : 'Key Features',
            style: PremiumTextStyles.headingLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 2.4,
            ),
            itemBuilder: (context, index) {
              final feature = features[index];

              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: PremiumColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: PremiumColors.softShadow,
                  border: Border.all(
                    color: PremiumColors.mediumGrey,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            PremiumColors.primaryBlue.withValues(alpha: 0.13),
                            PremiumColors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        feature['icon']! as IconData,
                        color: PremiumColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            feature['title']! as String,
                            style: PremiumTextStyles.headingSmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            feature['desc']! as String,
                            style: PremiumTextStyles.bodySmall.copyWith(
                              color: PremiumColors.lightText,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(40),
      color: PremiumColors.lightGrey,
      child: Center(
        child: Text(
          isArabic
              ? '© 2026 نظام إدارة العيادات الطبية'
              : '© 2026 Medical Clinic System',
          style: PremiumTextStyles.bodySmall.copyWith(
            color: PremiumColors.darkGrey,
          ),
        ),
      ),
    );
  }
}
