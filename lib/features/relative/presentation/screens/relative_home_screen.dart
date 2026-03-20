/// Relative Dashboard - لوحة تحكم قريب المريض
library;

import 'package:flutter/material.dart';

class RelativeDashboard extends StatelessWidget {
  const RelativeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'لوحة تحكم القريب' : 'Relative Dashboard'),
        backgroundColor: Colors.pink,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: isArabic ? 'المريض' : 'Patient'),
                Tab(text: isArabic ? 'السجلات' : 'Records'),
                Tab(text: isArabic ? 'الإشعارات' : 'Notifications'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPatientTab(context, isArabic),
                  _buildRecordsTab(context, isArabic),
                  _buildNotificationsTab(context, isArabic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientTab(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'معلومات المريض' : 'Patient Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(isArabic ? 'الاسم' : 'Name'),
                    subtitle: Text(isArabic ? 'محمد علي' : 'Mohammed Ali'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(isArabic ? 'رقم الهاتف' : 'Phone'),
                    subtitle: const Text('+213 123 456 7890'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.description),
            title: Text(isArabic ? 'السجلات الطبية' : 'Medical Records'),
            subtitle:
                Text(isArabic ? 'آخر تحديث: اليوم' : 'Last updated: Today'),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.receipt),
            title: Text(isArabic ? 'الفواتير' : 'Invoices'),
            subtitle:
                Text(isArabic ? '5 فواتير متاحة' : '5 invoices available'),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(isArabic ? 'موعد جديد' : 'New Appointment'),
            subtitle: Text(isArabic ? 'الغد في 2 مساءً' : 'Tomorrow at 2 PM'),
            trailing: const Icon(Icons.check),
          ),
        ),
      ],
    );
  }
}
