import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/features/admin/presentation/bloc/index.dart';

/// Admin Statistics Screen
class AdminStatsScreen extends StatelessWidget {
  const AdminStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardStatsLoaded) {
          return _StatsContent(stats: state);
        }

        if (state is AdminError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style:
                      TextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('جاري تحميل الإحصائيات...'));
      },
    );
  }
}

class _StatsContent extends StatelessWidget {
  const _StatsContent({required this.stats});
  final DashboardStatsLoaded stats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإحصائيات العامة',
              style: TextStyles.headline3,
            ),
            const SizedBox(height: 32),
            // Stats cards
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.5,
              children: [
                _StatCard(
                  title: 'إجمالي العيادات',
                  value: stats.totalClinics.toString(),
                  icon: Icons.local_hospital,
                  color: AppColors.primary,
                ),
                _StatCard(
                  title: 'اشتراكات نشطة',
                  value: stats.activeSubscriptions.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                _StatCard(
                  title: 'اشتراكات تجريبية',
                  value: stats.trialSubscriptions.toString(),
                  icon: Icons.science,
                  color: Colors.orange,
                ),
                _StatCard(
                  title: 'اشتراكات منتهية',
                  value: stats.expiredSubscriptions.toString(),
                  icon: Icons.warning,
                  color: Colors.red,
                ),
                _StatCard(
                  title: 'إجمالي المستخدمين',
                  value: stats.totalUsers.toString(),
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                _StatCard(
                  title: 'الإيرادات (USD)',
                  value: '\$${stats.totalRevenueUsd.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 48),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyles.headline4
                .copyWith(color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyles.bodySmall.copyWith(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

