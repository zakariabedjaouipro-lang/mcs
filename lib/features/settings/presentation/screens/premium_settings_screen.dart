/// Premium Settings Screen
/// Clean SaaS style inspired by Stripe / Notion

library;

import 'package:flutter/material.dart';

import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

class PremiumSettingsScreen extends StatefulWidget {
  const PremiumSettingsScreen({super.key});

  @override
  State<PremiumSettingsScreen> createState() => _PremiumSettingsScreenState();
}

class _PremiumSettingsScreenState extends State<PremiumSettingsScreen> {
  bool _darkMode = false;
  String _language = 'ar';

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return AppScaffold(
      title: isArabic ? 'الإعدادات' : 'Settings',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Profile Card
          _buildProfileCard(isArabic),

          const SizedBox(height: 20),

          /// Appearance
          _buildSectionTitle(isArabic ? 'المظهر' : 'Appearance'),
          const SizedBox(height: 12),
          _buildThemeToggle(isArabic),

          const SizedBox(height: 20),

          /// Language
          _buildSectionTitle(isArabic ? 'اللغة' : 'Language'),
          const SizedBox(height: 12),
          _buildLanguageToggle(isArabic),

          const SizedBox(height: 20),

          /// Account
          _buildSectionTitle(isArabic ? 'الحساب' : 'Account'),
          const SizedBox(height: 12),

          _buildListItem(
            icon: Icons.lock_outline,
            title: isArabic ? 'تغيير كلمة المرور' : 'Change Password',
            subtitle: isArabic
                ? 'تحديث كلمة المرور الخاصة بك'
                : 'Update your password',
          ),

          const SizedBox(height: 12),

          _buildListItem(
            icon: Icons.logout,
            title: isArabic ? 'تسجيل الخروج' : 'Logout',
            subtitle: isArabic
                ? 'الخروج من الحساب الحالي'
                : 'Sign out from your account',
          ),
        ],
      ),
    );
  }

  /// PROFILE
  Widget _buildProfileCard(bool isArabic) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            /// Avatar
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                gradient: PremiumColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 32,
              ),
            ),

            const SizedBox(width: 16),

            /// Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dr. Ahmed',
                    style: PremiumTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'admin@mcs.com',
                    style: PremiumTextStyles.bodySmall.copyWith(
                      color: PremiumColors.lightText,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.edit,
              color: PremiumColors.darkGrey,
            ),
          ],
        ),
      ),
    );
  }

  /// SECTION TITLE
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: PremiumTextStyles.headingSmall.copyWith(
        fontWeight: FontWeight.w600,
        color: PremiumColors.darkText,
      ),
    );
  }

  /// THEME TOGGLE
  Widget _buildThemeToggle(bool isArabic) {
    return _buildSwitchItem(
      icon: Icons.dark_mode,
      title: isArabic ? 'الوضع الداكن' : 'Dark Mode',
      subtitle: isArabic ? 'تفعيل المظهر الداكن' : 'Enable dark appearance',
      value: _darkMode,
      onChanged: (v) {
        setState(() {
          _darkMode = v;
        });
      },
    );
  }

  /// LANGUAGE
  Widget _buildLanguageToggle(bool isArabic) {
    return _buildListItem(
      icon: Icons.language,
      title: isArabic ? 'اللغة' : 'Language',
      subtitle: _language == 'ar' ? 'العربية' : 'English',
      onTap: () {
        setState(() {
          _language = _language == 'ar' ? 'en' : 'ar';
        });
      },
    );
  }

  /// LIST ITEM
  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon, color: PremiumColors.primaryBlue),
        title: Text(title, style: PremiumTextStyles.bodyLarge),
        subtitle: Text(
          subtitle,
          style: PremiumTextStyles.bodySmall.copyWith(
            color: PremiumColors.lightText,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  /// SWITCH ITEM
  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AppCard(
      child: ListTile(
        leading: Icon(icon, color: PremiumColors.primaryBlue),
        title: Text(title, style: PremiumTextStyles.bodyLarge),
        subtitle: Text(
          subtitle,
          style: PremiumTextStyles.bodySmall.copyWith(
            color: PremiumColors.lightText,
          ),
        ),
        trailing: Switch(
          value: value,
          activeThumbColor: PremiumColors.primaryBlue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
