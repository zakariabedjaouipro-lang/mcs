/// Premium Dashboard Screen
/// High-end dashboard for displaying metrics and navigation
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/premium_dashboard_widgets.dart';

class PremiumDashboardScreen extends StatelessWidget {
  const PremiumDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: PremiumTextStyles.headingLarge),
        backgroundColor: PremiumColors.primaryBlue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PremiumDashboardCard(
              title: 'Appointments',
              value: '120',
              icon: Icons.calendar_today,
              backgroundColor: PremiumColors.cardGradient,
            ),
            SizedBox(height: 16),
            PremiumDashboardCard(
              title: 'Revenue',
              value: '2,000',
              icon: Icons.attach_money,
              backgroundColor: PremiumColors.accentGradient,
            ),
          ],
        ),
      ),
    );
  }
}
