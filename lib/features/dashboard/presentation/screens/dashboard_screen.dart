/// Dashboard Screen
/// Main dashboard displaying key statistics and recent activities
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/components/dashboard_stat_card.dart';
import 'package:mcs/core/components/empty_error_state.dart';
import 'package:mcs/core/components/medical_info_card.dart';
import 'package:mcs/core/components/skeleton_loaders.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/utils/extensions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate API call - Replace with actual BLoC or repository call
      await Future<void>.delayed(const Duration(milliseconds: 1500));

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: isDark ? Colors.grey[900] : Colors.white,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                centerTitle: false,
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _hasError
                    ? ErrorStateWidget(
                        message: 'Unable to fetch dashboard data',
                        onRetry: _loadDashboardData,
                      )
                    : _isLoading
                        ? _buildLoadingState()
                        : _buildDashboardContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats skeleton
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          children: List.generate(
            6,
            (index) => const StatCardSkeletonLoader(),
          ),
        ),
        const SizedBox(height: 24),

        // Recent activity skeleton
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const ListSkeletonLoader(itemCount: 3),
      ],
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            children: [
              DashboardStatCard(
                icon: Icons.calendar_today,
                label: "Today's Appointments",
                value: '12',
                color: MedicalColors.primary,
                onTap: () {},
              ),
              DashboardStatCard(
                icon: Icons.people,
                label: 'Total Patients',
                value: '248',
                color: MedicalColors.secondary,
                onTap: () {},
              ),
              DashboardStatCard(
                icon: Icons.description,
                label: 'Lab Results',
                value: '34',
                color: MedicalColors.accent,
                onTap: () {},
              ),
              DashboardStatCard(
                icon: Icons.description,
                label: 'Prescriptions',
                value: '56',
                color: MedicalColors.success,
                onTap: () {},
              ),
              DashboardStatCard(
                icon: Icons.receipt,
                label: 'Pending Bills',
                value: '8',
                color: const Color(0xFFFF9800),
                onTap: () {},
              ),
              DashboardStatCard(
                icon: Icons.security,
                label: 'Security',
                value: '✓',
                color: const Color(0xFF4CAF50),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent Activity Section
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),

          // Recent items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final activities = [
                {
                  'icon': Icons.calendar_month,
                  'title': 'New Appointment',
                  'subtitle': 'Dr. Ahmed scheduled with Patient John',
                  'time': '2 hours ago',
                },
                {
                  'icon': Icons.assignment,
                  'title': 'Lab Result Available',
                  'subtitle': 'Blood test results ready for review',
                  'time': '4 hours ago',
                },
                {
                  'icon': Icons.receipt_long,
                  'title': 'Invoice Generated',
                  'subtitle': 'Patient Sarah - Amount: 250 AED',
                  'time': '6 hours ago',
                },
                {
                  'icon': Icons.person_add,
                  'title': 'New Patient Registration',
                  'subtitle': 'Fatima Al-Mazrouei - Female, 28 years',
                  'time': '1 day ago',
                },
                {
                  'icon': Icons.medication,
                  'title': 'Prescription Created',
                  'subtitle': 'Diabetes maintenance - Patient: Mohammed',
                  'time': '1 day ago',
                },
              ];

              final activity = activities[index];

              return MedicalInfoCard(
                icon: activity['icon']! as IconData,
                title: activity['title']! as String,
                subtitle: activity['subtitle']! as String,
                iconColor: MedicalColors.primary,
                trailing: Text(
                  activity['time']! as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
                onTap: () {},
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Mock data model - Replace with actual data when BLoC is integrated
class DashboardData {
  DashboardData({
    required this.appointmentsToday,
    required this.totalPatients,
    required this.labResults,
    required this.prescriptions,
    required this.pendingBills,
  });
  final int appointmentsToday;
  final int totalPatients;
  final int labResults;
  final int prescriptions;
  final int pendingBills;
}
