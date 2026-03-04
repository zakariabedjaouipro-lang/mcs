/// Currency selector widget - allows user to select currency for pricing display.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';

/// Currency controller for managing currency selection.
class CurrencyController extends ChangeNotifier {
  static const String _prefKey = 'selected_currency';
  static const String _defaultCurrency = 'USD';

  String _selectedCurrency = _defaultCurrency;

  String get selectedCurrency => _selectedCurrency;

  /// Initialize currency from storage (placeholder).
  Future<void> initialize() async {
    // In real implementation:
    // _selectedCurrency = await _getFromPrefs();
    _selectedCurrency = _defaultCurrency;
    notifyListeners();
  }

  /// Set selected currency.
  void setCurrency(String currency) {
    if (_selectedCurrency != currency) {
      _selectedCurrency = currency;
      _saveToPrefs(currency);
      notifyListeners();
    }
  }

  /// Save to preferences (placeholder).
  Future<void> _saveToPrefs(String currency) async {
    // In real implementation:
    // await SharedPreferences.getInstance().then((prefs) {
    //   prefs.setString(_prefKey, currency);
    // });
  }

  /// Get from preferences (placeholder).
  Future<String> _getFromPrefs() async {
    // In real implementation:
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString(_prefKey) ?? _defaultCurrency;
    return _defaultCurrency;
  }
}

class CurrencySelector extends StatefulWidget {
  final CurrencyController controller;

  const CurrencySelector({
    super.key,
    required this.controller,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  late String _selectedCurrency;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.controller.selectedCurrency;
    widget.controller.addListener(_onCurrencyChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onCurrencyChanged);
    super.dispose();
  }

  void _onCurrencyChanged() {
    setState(() {
      _selectedCurrency = widget.controller.selectedCurrency;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Currency button
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isExpanded ? AppColors.primary : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
              color: _isExpanded
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedCurrency,
                  style: TextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),

        // Dropdown options
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: _buildCurrencyOptions(),
            ),
          ),
      ],
    );
  }

  /// Build currency option buttons.
  List<Widget> _buildCurrencyOptions() {
    final currencies = [
      ('USD', '\$', 'United States Dollar'),
      ('EUR', '€', 'Euro'),
      ('DZD', 'دج', 'Algerian Dinar'),
    ];

    return currencies.asMap().entries.map((entry) {
      final isLast = entry.key == currencies.length - 1;
      final currency = entry.value;

      return Column(
        children: [
          GestureDetector(
            onTap: () {
              widget.controller.setCurrency(currency.$1);
              setState(() {
                _isExpanded = false;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              color: _selectedCurrency == currency.$1
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              child: Row(
                children: [
                  if (_selectedCurrency == currency.$1)
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  if (_selectedCurrency != currency.$1)
                    const Icon(
                      Icons.radio_button_unchecked,
                      size: 20,
                      color: Colors.grey,
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${currency.$1} (${currency.$2})',
                          style: TextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currency.$3,
                          style: TextStyles.labelSmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              color: Colors.grey[200],
            ),
        ],
      );
    }).toList();
  }
}

/// Currency exchange rates model.
class CurrencyRates {
  static const Map<String, double> baseRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'DZD': 134.5,
  };

  static double convert(double amount, String from, String to) {
    final fromRate = baseRates[from] ?? 1.0;
    final toRate = baseRates[to] ?? 1.0;
    return amount * (toRate / fromRate);
  }

  static String formatPrice(double price, String currency) {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${price.toStringAsFixed(2)}';
  }

  static String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'DZD':
        return 'دج';
      default:
        return '';
    }
  }
}
