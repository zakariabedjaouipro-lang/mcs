import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/features/admin/presentation/bloc/index.dart';

/// Admin Currency Management Screen
class AdminCurrenciesScreen extends StatelessWidget {
  const AdminCurrenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminBloc>(),
      child: const AdminCurrenciesView(),
    );
  }
}

class AdminCurrenciesView extends StatefulWidget {
  const AdminCurrenciesView({super.key});

  @override
  State<AdminCurrenciesView> createState() => _AdminCurrenciesViewState();
}

class _AdminCurrenciesViewState extends State<AdminCurrenciesView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const LoadExchangeRates());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة أسعار الصرف'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminBloc>().add(const LoadExchangeRates()),
            tooltip: 'تحديث',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExchangeRatesLoaded) {
            return _exchangeRatesTable(state.rates);
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
                    style: TextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('جاري تحميل البيانات...'));
        },
      ),
    );
  }

  Widget _exchangeRatesTable(Map<String, double> rates) {
    final currencies = [
      {'code': 'USD', 'name': 'دولار أمريكي', 'symbol': r'$'},
      {'code': 'EUR', 'name': 'يورو', 'symbol': '€'},
      {'code': 'DZD', 'name': 'دينار جزائري', 'symbol': 'دج'},
    ];

    final exchangeRates = [
      {'from': 'USD', 'to': 'EUR', 'rate': rates['usd_to_eur'] ?? 0.0},
      {'from': 'USD', 'to': 'DZD', 'rate': rates['usd_to_dzd'] ?? 0.0},
      {'from': 'EUR', 'to': 'USD', 'rate': rates['eur_to_usd'] ?? 0.0},
      {'from': 'EUR', 'to': 'DZD', 'rate': rates['eur_to_dzd'] ?? 0.0},
      {'from': 'DZD', 'to': 'USD', 'rate': rates['dzd_to_usd'] ?? 0.0},
      {'from': 'DZ', 'to': 'EUR', 'rate': rates['dzd_to_eur'] ?? 0.0},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أسعار الصرف الحالية',
            style: TextStyles.headline4,
          ),
          const SizedBox(height: 24),
          _ConversionCalculator(currencies, exchangeRates),

          const SizedBox(height: 32),
          Text(
            'جدول أسعار الصرف',
            style: TextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('من')),
                  DataColumn(label: Text('إلى')),
                  DataColumn(label: Text('سعر الصرف')),
                  DataColumn(label: Text('الإجراءات')),
                ],
                rows: exchangeRates.map((rate) {
                  return DataRow(
                    cells: [
                      DataCell(_buildCurrencyBadge(rate['from'] as String)),
                      DataCell(_buildCurrencyBadge(rate['to'] as String)),
                      DataCell(
                        Text((rate['rate'] as double).toStringAsFixed(4)),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditRateDialog(context, rate),
                          tooltip: 'تعديل السعر',
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyBadge(String currencyCode) {
    final currency = _getCurrencyInfo(currencyCode);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currency['code']!,
            style: TextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(
            currency['symbol']!,
            style: TextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Map<String, String> _getCurrencyInfo(String code) {
    const currencies = {
      'USD': {'code': 'USD', 'name': 'دولار أمريكي', 'symbol': r'$'},
      'EUR': {'code': 'EUR', 'name': 'يورو', 'symbol': '€'},
      'DZD': {'code': 'DZD', 'name': 'دينار جزائري', 'symbol': 'دج'},
    };
    return currencies[code] ?? {'code': code, 'name': code, 'symbol': ''};
  }

  Future<void> _showEditRateDialog(BuildContext context, Map<String, dynamic> rate) async {
    final rateController = TextEditingController(text: rate['rate'].toString());

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل سعر الصرف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_getCurrencyInfo(rate['from'] as String)['name']!} إلى ${_getCurrencyInfo(rate['to'] as String)['name']!}',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rateController,
              decoration: const InputDecoration(
                labelText: 'سعر الصرف *',
                border: OutlineInputBorder(),
                suffixText: 'X',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('حفظ التغييرات'),
          ),
        ],
      ),
    );

    if ((result ?? false) && context.mounted) {
      context.read<AdminBloc>().add(UpdateExchangeRate(
        fromCurrency: rate['from'] as String,
        toCurrency: rate['to'] as String,
        rate: double.parse(rateController.text),
      ));
    }
  }
}

class _ConversionCalculator extends StatefulWidget {
  final List<Map<String, String>> currencies;
  final List<Map<String, dynamic>> exchangeRates;

  const _ConversionCalculator(this.currencies, this.exchangeRates);

  @override
  State<_ConversionCalculator> createState() => _ConversionCalculatorState();
}

class _ConversionCalculatorState extends State<_ConversionCalculator> {
  final _amountController = TextEditingController(text: '100');
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        var rates = <String, double>{};
        if (state is ExchangeRatesLoaded) {
          rates = state.rates;
        }

        return Card(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calculate, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        'حاسبة العملات',
                        style: TextStyles.titleMedium.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'المبلغ',
                            border: OutlineInputBorder(),
                            prefixText: r'$ ',
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => _calculate(rates),
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _fromCurrency,
                        items: const ['USD', 'EUR', 'DZD']
                            .map((currency) => DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _fromCurrency = value ?? 'USD';
                            _calculate(rates);
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _toCurrency,
                        items: const ['USD', 'EUR', 'DZD']
                            .map((currency) => DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _toCurrency = value ?? 'EUR';
                            _calculate(rates);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'النتيجة',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _result,
                          style: TextStyles.headline3.copyWith(
                            color: AppColors.primary,
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
        },
      ),
    );
  }

  void _calculate(Map<String, double> rates) {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      setState(() => _result = '');
      return;
    }

    if (_fromCurrency == _toCurrency) {
      setState(() => _result = amount.toStringAsFixed(2));
      return;
    }

    final rateKey = '${_fromCurrency.toLowerCase()}_to_${_toCurrency.toLowerCase()}';
    final rate = rates[rateKey] ?? 1.0;
    final result = amount * rate;

    setState(() => _result = result.toStringAsFixed(2));
  }
}