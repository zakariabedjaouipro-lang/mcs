/// Professional medical features section
/// Displays feature cards in a responsive grid layout
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/landing/widgets/medical_feature_card.dart';

class MedicalFeaturesSection extends StatelessWidget {
  const MedicalFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = context.isSmall;
    final isDark = context.isDarkMode;

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 12 : 48,
          vertical: isSmall ? 24 : 80,
        ),
        child: Column(
          children: [
            // Section header
            Text(
              'Why Choose MCS?',
              style: TextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmall ? 20 : 40,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Comprehensive features designed for modern healthcare management',
              style: TextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: isSmall ? 12 : 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            SizedBox(height: isSmall ? 16 : 56),

            // Features grid
            _buildFeaturesGrid(context, isSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context, bool isSmall) {
    final features = [
      _Feature(
        icon: Icons.event_note,
        title: 'Smart Scheduling',
        description:
            'Automated appointment management with intelligent conflict resolution',
        color: MedicalColors.primary,
      ),
      _Feature(
        icon: Icons.person_4,
        title: 'Patient Central',
        description:
            'Complete patient profiles with medical history and secure records',
        color: MedicalColors.secondary,
      ),
      _Feature(
        icon: Icons.assignment,
        title: 'Prescription Mgmt',
        description:
            'Digital prescription management with pharmacy integration',
        color: const Color(0xFF66BB6A),
      ),
      _Feature(
        icon: Icons.assessment,
        title: 'Lab Results',
        description: 'Integrated lab result tracking and analysis capabilities',
        color: const Color(0xFFFFA726),
      ),
      _Feature(
        icon: Icons.payment,
        title: 'Billing System',
        description: 'Automated invoicing, payment processing, and reporting',
        color: const Color(0xFFAB47BC),
      ),
      _Feature(
        icon: Icons.security,
        title: 'Data Security',
        description:
            'HIPAA-compliant encryption and secure patient data handling',
        color: const Color(0xFFEF5350),
      ),
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSmall
            ? 1
            : context.isMedium
                ? 2
                : 3,
        crossAxisSpacing: isSmall ? 12 : 24,
        mainAxisSpacing: isSmall ? 12 : 24,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return MedicalFeatureCard(
          icon: feature.icon,
          title: feature.title,
          description: feature.description,
          iconColor: feature.color,
        );
      },
    );
  }
}

class _Feature {
  _Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String description;
  final Color color;
}
