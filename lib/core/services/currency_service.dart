/// Currency service for managing multi-currency support.
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supported currencies in the application.
enum Currency {
  usd('USD', r'$', 'US Dollar'),
  eur('EUR', '€', 'Euro'),
  dzd('DZD', 'د.ج', 'Algerian Dinar');

  const Currency(
    this.code,
    this.symbol,
    this.name,
  );

  final String code;
  final String symbol;
  final String name;
}

/// Exchange rate model for storing exchange rate information.
class ExchangeRateModel {
  const ExchangeRateModel({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.effectiveDate,
    this.isActive = true,
    this.source,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) => ExchangeRateModel(
        id: json['id'] as String,
        fromCurrency: json['from_currency'] as String,
        toCurrency: json['to_currency'] as String,
        rate: (json['rate'] as num).toDouble(),
        effectiveDate: DateTime.parse(json['effective_date'] as String),
        isActive: (json['is_active'] as bool?) ?? true,
        source: json['source'] as String?,
      );

  final String id; // UUID
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime effectiveDate;
  final bool isActive;
  final String? source;

  Map<String, dynamic> toJson() => {
        'id': id,
        'from_currency': fromCurrency,
        'to_currency': toCurrency,
        'rate': rate,
        'effective_date': effectiveDate.toIso8601String(),
        'is_active': isActive,
        'source': source,
      };
}

/// Service for managing currency conversions and formatting.
class CurrencyService {
  Currency _selectedCurrency = Currency.dzd;
  final Map<String, double> _exchangeRates = {}; // Key: "FROM_TO", Value: rate

  /// Get the currently selected currency.
  Currency get selectedCurrency => _selectedCurrency;

  /// Get all supported currencies.
  List<Currency> get supportedCurrencies => Currency.values;

  /// Get the current exchange rates.
  Map<String, double> get exchangeRates => Map.unmodifiable(_exchangeRates);

  /// Initialize the currency service and fetch exchange rates.
  Future<void> initialize() async {
    try {
      // Load saved currency preference
      final prefs = await Supabase.instance.client.storage
          .from('app-settings')
          .download('currency-preference.json');

      if (prefs.isNotEmpty) {
        // Parse and set saved currency
        // This is a simplified example
        const savedCode = 'DZD'; // Would parse from prefs
        _selectedCurrency = Currency.values.firstWhere(
          (c) => c.code == savedCode,
          orElse: () => Currency.dzd,
        );
      }

      // Fetch current exchange rates
      await fetchExchangeRates();

      debugPrint('CurrencyService: Initialized with ${_selectedCurrency.code}');
    } catch (e) {
      debugPrint('CurrencyService: Initialization error - $e');
      // Set default exchange rates
      _setDefaultExchangeRates();
    }
  }

  /// Set the selected currency.
  void setSelectedCurrency(Currency currency) {
    _selectedCurrency = currency;
    debugPrint(
      'CurrencyService: Selected currency changed to ${currency.code}',
    );

    // Save preference (in a real app, this would persist to storage)
    _saveCurrencyPreference(currency);
  }

  /// Fetch current exchange rates from the database.
  Future<void> fetchExchangeRates() async {
    try {
      // Fetch from exchange_rates table
      final response = await Supabase.instance.client
          .from('exchange_rates')
          .select()
          .eq('is_active', true)
          .lte('effective_date', DateTime.now().toIso8601String())
          .order('effective_date', ascending: false);

      if (response.isNotEmpty) {
        _exchangeRates.clear();

        // Group by from_currency and get the most recent rate for each pair
        final latestRates = <String, ExchangeRateModel>{};
        for (final item in response) {
          final rate = ExchangeRateModel.fromJson(item);
          final key = '${rate.fromCurrency}_${rate.toCurrency}';
          
          // Keep only the most recent rate for each pair
          if (!latestRates.containsKey(key) || 
              rate.effectiveDate.isAfter(latestRates[key]!.effectiveDate)) {
            latestRates[key] = rate;
          }
        }

        // Build exchange rate map
        for (final rate in latestRates.values) {
          _exchangeRates['${rate.fromCurrency}_${rate.toCurrency}'] = rate.rate;
        }

        debugPrint('CurrencyService: Exchange rates loaded from database (${_exchangeRates.length} pairs)');
        return;
      }
    } catch (e) {
      debugPrint('CurrencyService: Failed to fetch from database - $e');
    }

    // Fallback to default rates
    _setDefaultExchangeRates();
  }

  /// Convert an amount from one currency to another.
  double convert(double amount, {Currency? from, Currency? to}) {
    from ??= _selectedCurrency;
    to ??= _selectedCurrency;

    if (from == to) return amount;

    // Get direct exchange rate
    final key = '${from.code}_${to.code}';
    final rate = _exchangeRates[key];

    if (rate != null) {
      return amount * rate;
    }

    // Try to convert via USD as base currency
    if (from.code != 'USD' && to.code != 'USD') {
      final toUsd = _exchangeRates['${from.code}_USD'];
      final fromUsd = _exchangeRates['USD_${to.code}'];
      
      if (toUsd != null && fromUsd != null) {
        return (amount / toUsd) * fromUsd;
      }
    }

    // Fallback to default conversion
    debugPrint('CurrencyService: No exchange rate found for $key, using default');
    return amount; // Return original amount if no rate found
  }

  /// Format an amount with the selected currency symbol.
  String format(double amount, {Currency? currency}) {
    currency ??= _selectedCurrency;

    // Convert amount to selected currency if needed
    final convertedAmount =
        convert(amount, from: currency, to: _selectedCurrency);

    // Format with appropriate decimal places
    final formattedAmount = _formatNumber(convertedAmount);

    return '${currency.symbol}$formattedAmount';
  }

  /// Format an amount without the currency symbol.
  String formatWithoutSymbol(double amount, {Currency? currency}) {
    currency ??= _selectedCurrency;
    final convertedAmount =
        convert(amount, from: currency, to: _selectedCurrency);
    return _formatNumber(convertedAmount);
  }

  /// Parse a formatted amount string back to a double.
  double? parse(String formattedAmount) {
    try {
      // Remove currency symbol and any non-numeric characters except decimal point
      final cleaned = formattedAmount.replaceAll(RegExp(r'[^\d.-]'), '');
      return double.tryParse(cleaned);
    } catch (e) {
      debugPrint('CurrencyService: Parse error - $e');
      return null;
    }
  }

  /// Get the exchange rate for a specific currency pair.
  double? getExchangeRate(Currency from, Currency to) {
    final key = '${from.code}_${to.code}';
    return _exchangeRates[key];
  }

  /// Update exchange rates (admin function).
  Future<void> updateExchangeRates(Map<String, double> newRates) async {
    try {
      final effectiveDate = DateTime.now();
      final records = <Map<String, dynamic>>[];

      // Parse keys in format "FROM_TO" and create records
      for (final entry in newRates.entries) {
        final parts = entry.key.split('_');
        if (parts.length == 2) {
          records.add({
            'from_currency': parts[0],
            'to_currency': parts[1],
            'rate': entry.value,
            'effective_date': effectiveDate.toIso8601String(),
            'is_active': true,
          });
        }
      }

      // Insert new exchange rates
      if (records.isNotEmpty) {
        await Supabase.instance.client.from('exchange_rates').insert(records);
        
        // Refresh local cache
        await fetchExchangeRates();
        
        debugPrint('CurrencyService: ${records.length} exchange rates updated');
      }
    } catch (e) {
      debugPrint('CurrencyService: Update exchange rates error - $e');
      rethrow;
    }
  }

  /// Format a number with appropriate decimal places.
  String _formatNumber(double number) {
    // Use 2 decimal places for most currencies
    // Use 3 decimal places for currencies with small values
    final decimalPlaces = _selectedCurrency == Currency.dzd ? 3 : 2;

    return number.toStringAsFixed(decimalPlaces);
  }

  /// Set default exchange rates.
  void _setDefaultExchangeRates() {
    _exchangeRates.clear();
    // Default rates (USD as base)
    _exchangeRates['USD_USD'] = 1.0;
    _exchangeRates['USD_EUR'] = 0.92;
    _exchangeRates['USD_DZD'] = 134.5;
    _exchangeRates['EUR_USD'] = 1.09;
    _exchangeRates['EUR_EUR'] = 1.0;
    _exchangeRates['EUR_DZD'] = 146.2;
    _exchangeRates['DZD_USD'] = 0.0074;
    _exchangeRates['DZD_EUR'] = 0.0068;
    _exchangeRates['DZD_DZD'] = 1.0;
    
    debugPrint('CurrencyService: Default exchange rates set');
  }

  /// Save currency preference to storage.
  Future<void> _saveCurrencyPreference(Currency currency) async {
    try {
      // In a real app, this would save to SharedPreferences or similar
      // For now, just log it
      debugPrint(
        'CurrencyService: Saving currency preference: ${currency.code}',
      );
    } catch (e) {
      debugPrint('CurrencyService: Save preference error - $e');
    }
  }

  /// Dispose of the service.
  void dispose() {
    _exchangeRates.clear();
  }
}

