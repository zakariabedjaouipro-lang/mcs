import 'package:flutter/material.dart';
import 'package:mcs/core/widgets/custom_button.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? 'المخزون الحالي' : 'Current Inventory',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...List.generate(5, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AppCard(
                    child: ListTile(
                      leading: const Icon(Icons.medical_services,
                          color: Colors.blue),
                      title: Text(
                        isArabic
                            ? 'منتج طبي ${i + 1}'
                            : 'Medical Item ${i + 1}',
                      ),
                      subtitle: Text(isArabic ? 'الكمية: 50' : 'Quantity: 50'),
                      trailing: CustomButton(
                        label: isArabic ? 'تعديل' : 'Edit',
                        onPressed: () {},
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 32),
          CustomButton(
            label: isArabic ? 'إضافة منتج جديد' : 'Add New Item',
            icon: Icons.add,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
