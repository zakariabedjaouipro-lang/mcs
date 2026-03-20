/// Pharmacist Dashboard - لوحة تحكم الصيدلي
library;

import 'package:flutter/material.dart';

class PharmacistDashboard extends StatelessWidget {
  const PharmacistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'لوحة تحكم الصيدلي' : 'Pharmacist Dashboard'),
        backgroundColor: Colors.purple,
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: isArabic ? 'الوصفات' : 'Prescriptions'),
                Tab(text: isArabic ? 'المخزون' : 'Inventory'),
                Tab(text: isArabic ? 'الأدوية الجني' : 'Medicines'),
                Tab(text: isArabic ? 'الإعدادات' : 'Settings'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPrescriptionsTab(context, isArabic),
                  _buildInventoryTab(context, isArabic),
                  _buildMedicinesTab(context, isArabic),
                  _buildSettingsTab(context, isArabic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionsTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.receipt),
            title: Text(isArabic ? 'وصفة #001' : 'Prescription #001'),
            subtitle: Text(isArabic ? 'أموكسيسيلين' : 'Amoxicillin'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.storage),
            title: Text(isArabic ? 'المخزون الكلي' : 'Total Stock'),
            trailing: const Text('250 items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicinesTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: Text(isArabic ? 'الأدوية المتوفرة' : 'Available Medicines'),
            trailing: const Text('125',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab(BuildContext context, bool isArabic) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(isArabic ? 'الإعدادات' : 'Settings'),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
