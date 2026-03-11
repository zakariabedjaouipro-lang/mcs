/// Premium Admin Currency Management Screen
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/app_button.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/app_scaffold.dart';

class PremiumAdminCurrenciesScreen extends StatelessWidget {
  const PremiumAdminCurrenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return AppScaffold(
      title: isArabic ? 'العملات وأسعار الصرف' : 'Currencies & Exchange Rates',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isArabic ? 'تحديث البيانات...' : 'Refreshing data...'),
              ),
            );
          },
          tooltip: isArabic ? 'تحديث' : 'Refresh',
        ),
      ],
      child: Column(
        children: [
          // Conversion Calculator Section
          _buildConversionCalculator(context, isArabic),
          const SizedBox(height: 24),

          // Exchange Rates Section
          _buildExchangeRatesSection(context, isArabic),
        ],
      ),
    );
  }

  Widget _buildConversionCalculator(BuildContext context, bool isArabic) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: PremiumColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calculate,
                    color: PremiumColors.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isArabic ? 'حاسبة العملات' : 'Currency Calculator',
                  style: PremiumTextStyles.headingSmall.copyWith(
                    color: PremiumColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: isArabic ? 'المبلغ' : 'Amount',
                      border: const OutlineInputBorder(),
                      prefixText: r' $ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: 'USD',
                  items: const [
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                    DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                    DropdownMenuItem(value: 'DZD', child: Text('DZD')),
                  ],
                  onChanged: (value) {},
                  isExpanded: true,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: 'EUR',
                  items: const [
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                    DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                    DropdownMenuItem(value: 'DZD', child: Text('DZD')),
                  ],
                  onChanged: (value) {},
                  isExpanded: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: PremiumColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PremiumColors.primaryBlue.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    isArabic ? 'النتيجة' : 'Result',
                    style: PremiumTextStyles.bodyMedium.copyWith(
                      color: PremiumColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '85.24',
                    style: PremiumTextStyles.headingLarge.copyWith(
                      color: PremiumColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeRatesSection(BuildContext context, bool isArabic) {
    final rates = [
      {'from': 'USD', 'to': 'EUR', 'rate': '0.92'},
      {'from': 'USD', 'to': 'DZD', 'rate': '138.50'},
      {'from': 'EUR', 'to': 'USD', 'rate': '1.09'},
      {'from': 'EUR', 'to': 'DZD', 'rate': '150.80'},
      {'from': 'DZD', 'to': 'USD', 'rate': '0.0072'},
      {'from': 'DZD', 'to': 'EUR', 'rate': '0.0066'},
    ];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'أسعار الصرف الحالية' : 'Current Exchange Rates',
            style: PremiumTextStyles.headingMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: PremiumColors.darkText,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: rates.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rate = rates[index];
                return AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: PremiumColors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.currency_exchange,
                                color: PremiumColors.orange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic ? 'من ${rate['from']} إلى ${rate['to']}' : 'From ${rate['from']} to ${rate['to']}',
                                  style: PremiumTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: PremiumColors.darkText,
                                  ),
                                ),
                                Text(
                                  isArabic ? 'سعر الصرف' : 'Exchange Rate',
                                  style: PremiumTextStyles.bodySmall.copyWith(
                                    color: PremiumColors.lightText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              rate['rate']!,
                              style: PremiumTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: PremiumColors.darkText,
                              ),
                            ),
                            AppButton(
                              label: isArabic ? 'تعديل' : 'Edit',
                              size: AppButtonSize.small,
                              variant: AppButtonVariant.secondary,
                              onPressed: () {
                                _showEditRateDialog(context, rate, isArabic);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: isArabic ? 'إضافة عملة' : 'Add Currency',
            icon: Icons.add,
            onPressed: () {
              _showAddCurrencyDialog(context, isArabic);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showEditRateDialog(BuildContext context, Map<String, dynamic> rate, bool isArabic) async {
    final rateController = TextEditingController(text: rate['rate'] as String);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'تعديل سعر الصرف' : 'Edit Exchange Rate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic
                  ? 'من ${rate['from']} إلى ${rate['to']}'
                  : 'From ${rate['from']} to ${rate['to']}',
              style: PremiumTextStyles.bodyMedium.copyWith(
                color: PremiumColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rateController,
              decoration: InputDecoration(
                labelText: isArabic ? 'سعر الصرف' : 'Exchange Rate',
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          AppButton(
            label: isArabic ? 'حفظ' : 'Save',
            size: AppButtonSize.small,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? 'تم حفظ السعر' : 'Rate saved successfully'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showAddCurrencyDialog(BuildContext context, bool isArabic) async {
    final codeController = TextEditingController();
    final nameController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'إضافة عملة جديدة' : 'Add New Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: isArabic ? 'رمز العملة' : 'Currency Code',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: isArabic ? 'اسم العملة' : 'Currency Name',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          AppButton(
            label: isArabic ? 'إضافة' : 'Add',
            size: AppButtonSize.small,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? 'تمت إضافة العملة' : 'Currency added successfully'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}