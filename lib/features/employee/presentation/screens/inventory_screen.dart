import 'package:flutter/material.dart';
import 'package:mcs/core/widgets/premium_button.dart';
import 'package:mcs/core/widgets/premium_card.dart';
import 'package:mcs/core/widgets/premium_section.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'إدارة المخزون' : 'Inventory Management',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PremiumSection(
            title: isArabic ? 'المخزون الحالي' : 'Current Inventory',
            child: Column(
              children: List.generate(5, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: PremiumCard(
                    child: ListTile(
                      leading: const Icon(Icons.medical_services, color: Colors.blue),
                      title: Text(isArabic
                          ? 'منتج طبي ${i + 1}'
                          : 'Medical Item ${i + 1}',),
                      subtitle: Text(isArabic ? 'الكمية: 50' : 'Quantity: 50'),
                      trailing: PremiumButton(
                        label: isArabic ? 'تعديل' : 'Edit',
                        size: PremiumButtonSize.small,
                        onPressed: () {},
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 32),
          PremiumButton(
            label: isArabic ? 'إضافة منتج جديد' : 'Add New Item',
            icon: Icons.add,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
