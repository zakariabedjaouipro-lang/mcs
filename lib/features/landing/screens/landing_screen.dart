/// Landing screen - main page for the landing website.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/landing/widgets/device_detector.dart';
import 'package:mcs/features/landing/widgets/platform_buttons.dart';

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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _showElevation = _scrollController.offset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // 1. App Bar / Header
            _buildHeader(context),

            // 2. Hero Section
            _buildHeroSection(context),

            // 3. Features Section
            _buildFeaturesSection(context),

            // 4. Download Section
            _buildDownloadSection(context),

            // 5. Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// Build responsive app bar/header with logo, language switcher, and login button.
  Widget _buildHeader(BuildContext context) {
    final isSmall = context.isSmall;
    final padding = isSmall ? 16.0 : 24.0;

    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey[900] : Colors.white,
        boxShadow: _showElevation
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
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
              // Logo
              Row(
                children: [
                  Icon(
                    Icons.local_hospital,
                    size: isSmall ? 28 : 32,
                    color: AppColors.primary,
                  ),
                  if (!isSmall) ...[
                    const SizedBox(width: 12),
                    Text(
                      'MCS',
                      style: TextStyles.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                ],
              ),

              // Navigation items (hidden on small screens)
              if (!isSmall)
                Row(
                  children: [
                    _headerLink('Features', context),
                    const SizedBox(width: 24),
                    _headerLink('Download', context),
                    const SizedBox(width: 24),
                    _headerLink('About', context),
                  ],
                ),

              // Right side: Language, Theme, Login
              Row(
                children: [
                  // Language switcher
                  _languageButton(context),
                  const SizedBox(width: 8),

                  // Theme switcher
                  _themeButton(context),
                  const SizedBox(width: 8),

                  // Login button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to login
                    },
                    child: Text(
                      isSmall ? 'Login' : 'Sign In',
                      style: TextStyles.labelLarge,
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

  /// Build header navigation link.
  Widget _headerLink(String label, BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Handle navigation
        },
        child: Text(
          label,
          style: TextStyles.bodyLarge.copyWith(
            color: context.isDarkMode ? Colors.white70 : Colors.grey[800],
          ),
        ),
      ),
    );
  }

  /// Language switcher button.
  Widget _languageButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Toggle language (en <-> ar)
      },
      icon: const Icon(Icons.language),
      tooltip: 'Toggle Language',
    );
  }

  /// Theme switcher button.
  Widget _themeButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Toggle theme
      },
      icon: Icon(
        context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      ),
      tooltip: 'Toggle Theme',
    );
  }

  /// Build hero section with main headline and CTA button.
  Widget _buildHeroSection(BuildContext context) {
    final isSmall = context.isSmall;
    final isMedium = context.isMedium;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 16 : 48,
          vertical: isSmall ? 48 : 80,
        ),
        child: Column(
          children: [
            // Main headline
            Text(
              'MCS',
              style: TextStyles.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmall
                    ? 32
                    : isMedium
                        ? 40
                        : 56,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Subheading
            Text(
              'Medical Clinic System\nManage Your Healthcare Efficiently',
              style: TextStyles.titleMedium.copyWith(
                color: Colors.white70,
                fontSize: isSmall
                    ? 14
                    : isMedium
                        ? 16
                        : 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // CTA Buttons
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Scroll to download section
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Now'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Learn more
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    'Learn More',
                    style: TextStyles.labelLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build features section showcasing key features.
  Widget _buildFeaturesSection(BuildContext context) {
    const features = [
      (
        icon: Icons.calendar_today,
        title: 'Appointments',
        description: 'Easy scheduling and management'
      ),
      (
        icon: Icons.prescription,
        title: 'Prescriptions',
        description: 'Digital prescription management'
      ),
      (
        icon: Icons.video_call,
        title: 'Video Consultations',
        description: 'Connect with doctors online'
      ),
      (
        icon: Icons.assignment,
        title: 'Medical Records',
        description: 'Secure health documentation'
      ),
    ];

    final isSmall = context.isSmall;
    final crossAxisCount = isSmall ? 1 : 2;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 48,
        vertical: isSmall ? 48 : 80,
      ),
      child: Column(
        children: [
          // Section title
          Text(
            'Key Features',
            style: TextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Features grid
          GridView.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: features
                .map(
                  (feature) => _buildFeatureCard(
                    icon: feature.icon,
                    title: feature.title,
                    description: feature.description,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  /// Build feature card widget.
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build download section with platform-specific buttons.
  Widget _buildDownloadSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.isDarkMode ? Colors.grey[850] : Colors.grey[50],
      padding: EdgeInsets.symmetric(
        horizontal: context.isSmall ? 16 : 48,
        vertical: context.isSmall ? 48 : 80,
      ),
      child: Column(
        children: [
          // Section title
          Text(
            'Download MCS',
            style: TextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            'Available on all major platforms',
            style: TextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Device detection and platform buttons
          const DeviceDetector(),
        ],
      ),
    );
  }

  /// Build footer section.
  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.isDarkMode ? Colors.grey[900] : Colors.grey[100],
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _footerLink('Privacy', context),
              _footerLink('Terms', context),
              _footerLink('Support', context),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2026 MCS - Medical Clinic System. All rights reserved.',
            style: TextStyles.bodySmall.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build footer link.
  Widget _footerLink(String label, BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Handle footer link navigation
        },
        child: Text(
          label,
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
