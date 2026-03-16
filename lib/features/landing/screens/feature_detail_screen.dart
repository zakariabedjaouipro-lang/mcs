/// Feature detail screen - Detailed view of a single feature
/// Shows full feature information with back button
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';

class FeatureDetailScreen extends StatelessWidget {
  const FeatureDetailScreen({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.landing);
            }
          },
          tooltip: 'Go back',
        ),
        title: Text(
          title,
          style: TextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.isDarkMode ? Colors.grey[900] : Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.isSmall ? 16 : 48,
          vertical: context.isSmall ? 24 : 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon section with background
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: context.isSmall ? 32 : 48,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: context.isSmall ? 64 : 96,
                  color: color,
                ),
              ),
            ),
            SizedBox(height: context.isSmall ? 32 : 48),

            // Title
            Text(
              title,
              style: TextStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: context.isSmall ? 24 : 32,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              description,
              style: TextStyles.bodyLarge.copyWith(
                fontSize: context.isSmall ? 14 : 16,
                height: 1.6,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: context.isSmall ? 32 : 48),

            // Features list
            _buildFeaturesList(context),
            SizedBox(height: context.isSmall ? 32 : 48),

            // Call to action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: EdgeInsets.symmetric(
                    vertical: context.isSmall ? 12 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Get started with $title'),
                      backgroundColor: color,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  'Get Started',
                  style: TextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    final features = _getRelatedFeatures();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Benefits',
          style: TextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.isSmall ? 16 : 24),
        ...features.map((feature) => _buildFeatureItem(context, feature)),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.isSmall ? 12 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.2),
            ),
            child: Icon(
              Icons.check,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            child: Text(
              feature,
              style: TextStyles.bodyLarge.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getRelatedFeatures() {
    switch (title.toLowerCase()) {
      case 'schedule appointments':
        return [
          'Easy online booking system',
          'Real-time availability updates',
          'Automated appointment reminders',
          'Flexible rescheduling options',
        ];
      case 'medical records':
        return [
          'Secure cloud storage',
          'Easy access anytime, anywhere',
          'Complete medical history',
          'Document sharing with doctors',
        ];
      case 'patient management':
        return [
          'Comprehensive patient profiles',
          'Medical history tracking',
          'Communication tools',
          'Automated workflows',
        ];
      case 'prescriptions':
        return [
          'Digital prescription management',
          'Pharmacy integration',
          'Refill reminders',
          'Medication tracking',
        ];
      default:
        return [
          'Comprehensive feature set',
          'Easy to use interface',
          'Secure and reliable',
          'Always available support',
        ];
    }
  }
}
