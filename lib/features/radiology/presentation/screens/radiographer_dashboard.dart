/// Radiographer Dashboard - لوحة تحكم أخصائي الأشعة
library;

import 'package:flutter/material.dart';

class RadiographerDashboard extends StatelessWidget {
  const RadiographerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'لوحة تحكم الأشعة' : 'Radiology Dashboard'),
        backgroundColor: Colors.indigo,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: isArabic ? 'الطلبات' : 'Requests'),
                Tab(text: isArabic ? 'الصور' : 'Images'),
                Tab(text: isArabic ? 'التقارير' : 'Reports'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRequestsTab(context, isArabic),
                  _buildImagesTab(context, isArabic),
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
            leading: const Icon(Icons.medical_services),
            title: Text(isArabic ? 'طلب أشعة X' : 'X-Ray Request'),
            subtitle: Text(isArabic ? 'الصدر' : 'Chest'),
            trailing: const Chip(label: Text('New')),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.image),
            title: Text(isArabic ? 'الصور المحفوظة' : 'Saved Images'),
            trailing:
                const Text('45', style: TextStyle(fontWeight: FontWeight.bold)),
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
            leading: const Icon(Icons.receipt),
            title: Text(isArabic ? 'التقارير الطبية' : 'Medical Reports'),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }
}
