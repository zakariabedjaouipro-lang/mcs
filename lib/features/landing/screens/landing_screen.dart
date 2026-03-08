/// Landing screen - Professional Medical Clinic Management System
/// Modern, clean interface with medical branding and crescent symbol
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:mcs/core/config/router.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/auth_state.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mcs/features/localization/presentation/bloc/localization_event.dart';
import 'package:mcs/features/landing/widgets/medical_hero_section.dart';
import 'package:mcs/features/landing/widgets/medical_features_section.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:mcs/features/theme/presentation/bloc/theme_event.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late ScrollController _scrollController;
  bool _showElevation = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _showElevation = _scrollController.offset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go(AppRoutes.dashboard);
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: MedicalColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _buildHeader(context),
              MedicalHeroSection(
                onLoginPressed: () => context.go(AppRoutes.login),
                onRegisterPressed: () => context.go(AppRoutes.register),
              ),
              const MedicalFeaturesSection(),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Professional medical header with branding
  Widget _buildHeader(BuildContext context) {
    final isSmall = context.isSmall;
    final isDark = context.isDarkMode;
    final padding = isSmall ? 16.0 : 24.0;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        boxShadow: _showElevation
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: isSmall ? 12.0 : 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Medical Logo Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: MedicalColors.medicalGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: isSmall ? 24 : 28,
                      color: Colors.white,
                    ),
                  ),
                  if (!isSmall) ...[
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MCS',
                          style: TextStyles.labelLarge.copyWith(
                            color: MedicalColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Medical Clinic',
                          style: TextStyles.bodySmall.copyWith(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),

              // Navigation links (desktop only)
              if (!isSmall)
                Row(
                  children: [
                    _headerLink(
                      'Features',
                      context,
                      () => context.go(AppRoutes.features),
                    ),
                    const SizedBox(width: 24),
                    _headerLink(
                      'Pricing',
                      context,
                      () => context.go(AppRoutes.pricing),
                    ),
                    const SizedBox(width: 24),
                    _headerLink(
                      'Contact',
                      context,
                      () => context.go(AppRoutes.contact),
                    ),
                  ],
                ),

              // Right section: theme, language, login
              Row(
                children: [
                  _languageButton(context),
                  const SizedBox(width: 8),
                  _themeButton(context),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.login),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MedicalColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmall ? 12 : 20,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isSmall ? 'Sign In' : 'Sign In',
                      style: TextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header navigation link
  Widget _headerLink(String label, BuildContext context, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyles.bodyLarge.copyWith(
            color: context.isDarkMode ? Colors.white70 : Colors.grey[800],
          ),
        ),
      ),
    );
  }

  /// Language switcher button
  Widget _languageButton(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final isArabic = currentLocale.languageCode == 'ar';

    return IconButton(
      onPressed: () {
        context.read<LocalizationBloc>().add(const ToggleLanguageEvent());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic ? 'Switched to English' : 'تم التبديل للعربية',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      icon: const Icon(Icons.language),
      tooltip: 'Toggle Language',
    );
  }

  /// Theme switcher button
  Widget _themeButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<ThemeBloc>().add(const ToggleThemeEvent());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.isDarkMode
                  ? 'Switched to light mode'
                  : 'تم التبديل للوضع الداكن',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      icon: Icon(
        context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      ),
      tooltip: 'Toggle Theme',
    );
  }

  /// Professional footer
  Widget _buildFooter(BuildContext context) {
    final isSmall = context.isSmall;
    final isDark = context.isDarkMode;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            if (isDark) Colors.grey[850]! else Colors.grey[50]!,
            if (isDark) Colors.grey[900]! else Colors.grey[100]!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[700]! : MedicalColors.mediumGrey,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 16 : 48,
          vertical: isSmall ? 32 : 48,
        ),
        child: Column(
          children: [
            // Footer content grid
            if (!isSmall)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _footerColumn('Product', ['Features', 'Pricing', 'Security']),
                  _footerColumn('Company', ['About', 'Blog', 'Careers']),
                  _footerColumn('Resources', ['Help', 'Contact', 'Privacy']),
                  _footerColumn('Legal', ['Terms', 'Privacy', 'Cookies']),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _footerColumn('Product', ['Features', 'Pricing', 'Security']),
                  const SizedBox(height: 24),
                  _footerColumn('Company', ['About', 'Blog', 'Careers']),
                ],
              ),
            SizedBox(height: isSmall ? 24 : 40),

            // Divider
            Divider(
              color: isDark ? Colors.grey[700] : MedicalColors.mediumGrey,
              height: 32,
            ),

            // Bottom section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2026 MCS. All rights reserved.',
                  style: TextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                if (!isSmall)
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 16,
                        color: MedicalColors.success,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'HIPAA Compliant',
                        style: TextStyles.bodySmall.copyWith(
                          color: MedicalColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Footer column with links
  Widget _footerColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                link,
                style: TextStyles.bodySmall.copyWith(
                  color:
                      context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
