/// Employee Dashboard Screen
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/widgets/premium_button.dart';
import 'package:mcs/core/widgets/premium_card.dart';
import 'package:mcs/core/widgets/premium_section.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'لوحة الموظف' : 'Employee Dashboard',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PremiumSection(
            title: isArabic ? 'إحصائيات اليوم' : "Today's Stats",
            child: Row(
              children: [
                Expanded(
                  child: PremiumCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inventory, color: Colors.blue, size: 36),
                        const SizedBox(height: 8),
                        Text(isArabic ? 'المخزون' : 'Inventory'),
                        Text('120',
                            style: Theme.of(context).textTheme.headlineMedium,),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PremiumCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.receipt, color: Colors.green, size: 36),
                        const SizedBox(height: 8),
                        Text(isArabic ? 'الفواتير' : 'Invoices'),
                        Text('32',
                            style: Theme.of(context).textTheme.headlineMedium,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          PremiumSection(
            title: isArabic ? 'إجراءات سريعة' : 'Quick Actions',
            child: Row(
              children: [
                Expanded(
                  child: PremiumButton(
                    label: isArabic ? 'إضافة مخزون' : 'Add Inventory',
                    icon: Icons.add,
                    onPressed: () {
                      context.go(AppRoutes.inventory);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PremiumButton(
                    label: isArabic ? 'إصدار فاتورة' : 'Issue Invoice',
                    icon: Icons.receipt_long,
                    onPressed: () {
                      context.go(AppRoutes.invoices);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
