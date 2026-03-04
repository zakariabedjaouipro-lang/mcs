/// Download screen - dedicated page for downloading the app.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/landing/widgets/device_detector.dart';
import 'package:mcs/features/landing/widgets/platform_buttons.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late ScrollController _scrollController;
  bool _showElevation = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _showElevation = _scrollController.offset > 0;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Download section
            _buildDownloadSection(context),

            // System requirements
            _buildRequirementsSection(context),

            // Installation guide
            _buildGuideSection(context),

            // FAQ section
            _buildFAQSection(context),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// Build header with back button and title.
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey[900] : Colors.white,
        boxShadow: _showElevation
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                ),
              ]
            : [],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Download MCS',
                  style: TextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build main download section with device detection and buttons.
  Widget _buildDownloadSection(BuildContext context) {
    final isSmall = context.isSmall;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 48,
        vertical: isSmall ? 40 : 60,
      ),
      child: Column(
        children: [
          // Title
          Text(
            'Get MCS Now',
            style: TextStyles.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isSmall ? 28 : 40,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            'Your healthcare management solution, available on all platforms',
            style: TextStyles.body1.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Device detection and platform buttons
          const DeviceDetector(),

          const SizedBox(height: 32),

          // All platforms section
          Text(
            'or choose from all available platforms:',
            style: TextStyles.body2.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),

          // All platform buttons
          const PlatformButtons(showAll: true),
        ],
      ),
    );
  }

  /// Build system requirements section.
  Widget _buildRequirementsSection(BuildContext context) {
    final isSmall = context.isSmall;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 48,
        vertical: isSmall ? 40 : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'System Requirements',
            style: TextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Requirements grid
          GridView.count(
            crossAxisCount: isSmall ? 1 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildRequirementCard(
                title: 'iOS',
                icon: Icons.apple,
                requirements: [
                  'iOS 12.0 or later',
                  '100 MB storage',
                  'Internet connection',
                ],
              ),
              _buildRequirementCard(
                title: 'Android',
                icon: Icons.android,
                requirements: [
                  'Android 6.0 or later',
                  '85 MB storage',
                  'Internet connection',
                ],
              ),
              _buildRequirementCard(
                title: 'Windows',
                icon: Icons.computer,
                requirements: [
                  'Windows 10 or later',
                  '150 MB storage',
                  'Internet connection',
                ],
              ),
              _buildRequirementCard(
                title: 'macOS',
                icon: Icons.laptop_mac,
                requirements: [
                  'macOS 10.15 or later',
                  '150 MB storage',
                  'Internet connection',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build requirement card.
  Widget _buildRequirementCard({
    required String title,
    required IconData icon,
    required List<String> requirements,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...requirements.map(
              (req) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        req,
                        style: TextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build installation guide section.
  Widget _buildGuideSection(BuildContext context) {
    final isSmall = context.isSmall;

    return Container(
      width: double.infinity,
      color: context.isDarkMode ? Colors.grey[850] : Colors.grey[50],
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 48,
        vertical: isSmall ? 40 : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Installation Guide',
            style: TextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Steps
          _buildGuideStep(
            step: 1,
            title: 'Download',
            description:
                'Choose your platform and download MCS from the app store or website.',
          ),
          const SizedBox(height: 16),
          _buildGuideStep(
            step: 2,
            title: 'Install',
            description:
                'Follow the on-screen instructions to install the application on your device.',
          ),
          const SizedBox(height: 16),
          _buildGuideStep(
            step: 3,
            title: 'Sign Up',
            description: 'Create an account or sign in with your credentials.',
          ),
          const SizedBox(height: 16),
          _buildGuideStep(
            step: 4,
            title: 'Start Using',
            description:
                'Access your medical records and schedule appointments.',
          ),
        ],
      ),
    );
  }

  /// Build guide step widget.
  Widget _buildGuideStep({
    required int step,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step number circle
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyles.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),

        // Step content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyles.body2.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build FAQ section.
  Widget _buildFAQSection(BuildContext context) {
    final isSmall = context.isSmall;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 48,
        vertical: isSmall ? 40 : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // FAQ items
          _buildFAQItem(
            question: 'Is MCS free to download?',
            answer:
                'Yes, MCS is free to download. Some features may require a subscription.',
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            question: 'Which platforms are supported?',
            answer:
                'MCS is available on iOS, Android, Windows, macOS, and Web.',
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            question: 'How do I reset my password?',
            answer:
                'Use the "Forgot Password" option on the login screen to reset your password via email.',
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            question: 'Is my medical data secure?',
            answer:
                'Yes, we use end-to-end encryption and comply with HIPAA standards.',
          ),
        ],
      ),
    );
  }

  /// Build FAQ item.
  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Card(
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyles.bodyMedium.copyWith(color: Colors.black),
            ),
          ),
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
              _footerLink('Contact', context),
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
          // Handle navigation
        },
        child: Text(
          label,
          style: TextStyles.bodyMedium.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
