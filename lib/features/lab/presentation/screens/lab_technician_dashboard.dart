/// Lab Technician Dashboard - لوحة تحكم فني المختبر
library;

import 'package:flutter/material.dart';

class LabTechnicianDashboard extends StatelessWidget {
  const LabTechnicianDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'لوحة تحكم المختبر' : 'Lab Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: isArabic ? 'الطلبات' : 'Requests'),
                Tab(text: isArabic ? 'النتائج' : 'Results'),
                Tab(text: isArabic ? 'التقارير' : 'Reports'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRequestsTab(context, isArabic),
                  _buildResultsTab(context, isArabic),
                  _buildReportsTab(context, isArabic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.description),
            title: Text(isArabic ? 'طلب تحليل' : 'Lab Request #001'),
            subtitle: Text(isArabic ? 'صورة دم كاملة' : 'Complete Blood Count'),
            trailing: const Chip(label: Text('Pending')),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.check_circle),
            title: Text(isArabic ? 'النتائج المكتملة' : 'Completed Results'),
            trailing: const Text('12',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildReportsTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.assessment),
            title: Text(isArabic ? 'التقارير الشهرية' : 'Monthly Reports'),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }
}
