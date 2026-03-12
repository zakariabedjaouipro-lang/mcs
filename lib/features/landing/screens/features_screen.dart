/// Features screen - comprehensive display of system features.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/landing/widgets/feature_card.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

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
          'Features',
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
            // Introduction
            _buildIntroduction(context),
            const SizedBox(height: 60),

            // Patient Features
            _buildFeatureSection(
              context,
              title: 'For Patients',
              icon: Icons.person,
              color: Colors.blue,
              features: _getPatientFeatures(),
            ),
            const SizedBox(height: 60),

            // Doctor Features
            _buildFeatureSection(
              context,
              title: 'For Doctors',
              icon: Icons.local_hospital,
              color: Colors.green,
              features: _getDoctorFeatures(),
            ),
            const SizedBox(height: 60),

            // Staff Features
            _buildFeatureSection(
              context,
              title: 'For Staff',
              icon: Icons.group,
              color: Colors.orange,
              features: _getStaffFeatures(),
            ),
            const SizedBox(height: 60),

            // Admin Features
            _buildFeatureSection(
              context,
              title: 'For Administrators',
              icon: Icons.admin_panel_settings,
              color: Colors.purple,
              features: _getAdminFeatures(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build introduction section.
  Widget _buildIntroduction(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Powerful Features for Modern Healthcare',
          style: TextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: context.isSmall ? 28 : 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'MCS provides comprehensive tools for managing patient care, appointments, medical records, and clinic operations.',
          style: TextStyles.bodyLarge.copyWith(
            color: Colors.grey[600],
            fontSize: context.isSmall ? 14 : 16,
          ),
        ),
      ],
    );
  }

  /// Build feature section with title and grid.
  Widget _buildFeatureSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<FeatureItem> features,
  }) {
    final crossAxisCount = context.isSmall
        ? 1
        : context.isMedium
            ? 2
            : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Features grid
        GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: features
              .map(
                (feature) => FeatureCard(
                  icon: feature.icon,
                  title: feature.title,
                  description: feature.description,
                  color: color,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  /// Get patient features.
  List<FeatureItem> _getPatientFeatures() {
    return [
      FeatureItem(
        icon: Icons.calendar_today,
        title: 'Schedule Appointments',
        description: 'Book appointments with doctors at convenient times',
      ),
      FeatureItem(
        icon: Icons.description,
        title: 'Medical Records',
        description: 'Access your complete medical history and documents',
      ),
      FeatureItem(
        icon: Icons.medical_services,
        title: 'Prescriptions',
        description: 'View and manage your prescriptions digitally',
      ),
      FeatureItem(
        icon: Icons.video_call,
        title: 'Telemedicine',
        description: 'Consult with doctors via video calls from home',
      ),
      FeatureItem(
        icon: Icons.assignment,
        title: 'Lab Results',
        description: 'Get and download your lab test results instantly',
      ),
      FeatureItem(
        icon: Icons.notifications,
        title: 'Smart Reminders',
        description: 'Receive appointment and medication reminders',
      ),
    ];
  }

  /// Get doctor features.
  List<FeatureItem> _getDoctorFeatures() {
    return [
      FeatureItem(
        icon: Icons.person_add,
        title: 'Patient Management',
        description: 'Manage patient profiles and medical histories',
      ),
      FeatureItem(
        icon: Icons.edit_note,
        title: 'Clinical Notes',
        description: 'Create and organize detailed clinical notes',
      ),
      FeatureItem(
        icon: Icons.local_pharmacy,
        title: 'Prescribe Medications',
        description: 'Write and send digital prescriptions to patients',
      ),
      FeatureItem(
        icon: Icons.event_note,
        title: 'Schedule Management',
        description: 'Manage your clinic schedule and availability',
      ),
      FeatureItem(
        icon: Icons.assessment,
        title: 'Lab Orders',
        description: 'Order lab tests and receive results efficiently',
      ),
      FeatureItem(
        icon: Icons.videocam,
        title: 'Video Consultations',
        description: 'Conduct virtual consultations with patients',
      ),
    ];
  }

  /// Get staff features.
  List<FeatureItem> _getStaffFeatures() {
    return [
      FeatureItem(
        icon: Icons.phone,
        title: 'Call Management',
        description: 'Handle patient calls and inquiries efficiently',
      ),
      FeatureItem(
        icon: Icons.calendar_today,
        title: 'Appointment Scheduling',
        description: 'Manage clinic appointment bookings and confirmations',
      ),
      FeatureItem(
        icon: Icons.assignment_turned_in,
        title: 'Task Management',
        description: 'Track and complete assigned tasks',
      ),
      FeatureItem(
        icon: Icons.inventory_2,
        title: 'Inventory Management',
        description: 'Monitor medical supplies and equipment stock',
      ),
      FeatureItem(
        icon: Icons.report_gmailerrorred,
        title: 'Patient Triage',
        description: 'Record and prioritize patient information',
      ),
      FeatureItem(
        icon: Icons.file_download,
        title: 'Document Generation',
        description: 'Generate medical forms and documents',
      ),
    ];
  }

  /// Get admin features.
  List<FeatureItem> _getAdminFeatures() {
    return [
      FeatureItem(
        icon: Icons.assessment,
        title: 'Analytics & Reports',
        description: 'View detailed clinic analytics and performance reports',
      ),
      FeatureItem(
        icon: Icons.people,
        title: 'Staff Management',
        description: 'Manage doctors, nurses, and staff members',
      ),
      FeatureItem(
        icon: Icons.attach_money,
        title: 'Financial Reports',
        description: 'Track revenue, invoices, and payment records',
      ),
      FeatureItem(
        icon: Icons.settings,
        title: 'System Settings',
        description: 'Configure clinic settings and preferences',
      ),
      FeatureItem(
        icon: Icons.security,
        title: 'User Permissions',
        description: 'Control user roles and access permissions',
      ),
      FeatureItem(
        icon: Icons.backup,
        title: 'Data Backup',
        description: 'Automatic data backup and disaster recovery',
      ),
    ];
  }
}

/// Feature item data model.
class FeatureItem {
  FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;
}
