/// Currency service for managing multi-currency support.
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supported currencies in the application.
enum Currency {
  usd('USD', r'$', 'US Dollar', 1),
  eur('EUR', '€', 'Euro', 0.92),
  dzd('DZD', 'د.ج', 'Algerian Dinar', 134.5);

  const Currency(
    this.code,
    this.symbol,
    this.name,
    this.exchangeRate,
  );

  final String code;
  final String symbol;
  final String name;
  final double exchangeRate;
}

/// Service for managing currency conversions and formatting.
class CurrencyService {
  Currency _selectedCurrency = Currency.dzd;
  final Map<Currency, double> _exchangeRates = {};

  /// Get the currently selected currency.
  Currency get selectedCurrency => _selectedCurrency;

  /// Get all supported currencies.
  List<Currency> get supportedCurrencies => Currency.values;

  /// Get the current exchange rates.
  Map<Currency, double> get exchangeRates => Map.unmodifiable(_exchangeRates);

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

  /// Fetch current exchange rates from the database or API.
  Future<void> fetchExchangeRates() async {
    try {
      // Try to fetch from database first
      final response = await Supabase.instance.client
          .from('exchange_rates')
          .select()
          .order('updated_at', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        final rates = response.first;
        _exchangeRates.clear();

        for (final currency in Currency.values) {
          final rate = rates['rate_${currency.code.toLowerCase()}'] as double?;
          if (rate != null && rate > 0) {
            _exchangeRates[currency] = rate;
          }
        }

        debugPrint('CurrencyService: Exchange rates loaded from database');
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

    // Convert to USD first (base currency)
    final inUsd = amount / (from.exchangeRate);

    // Then convert to target currency
    return inUsd * (to.exchangeRate);
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

  /// Get the exchange rate for a specific currency.
  double? getExchangeRate(Currency currency) {
    return _exchangeRates[currency] ?? currency.exchangeRate;
  }

  /// Update exchange rates (admin function).
  Future<void> updateExchangeRates(Map<Currency, double> newRates) async {
    try {
      // Update local cache
      _exchangeRates.addAll(newRates);

      // Save to database
      final ratesData = <String, dynamic>{};
      for (final entry in newRates.entries) {
        ratesData['rate_${entry.key.code.toLowerCase()}'] = entry.value;
      }

      await Supabase.instance.client.from('exchange_rates').insert({
        'rates': ratesData,
        'updated_at': DateTime.now().toIso8601String(),
      });

      debugPrint('CurrencyService: Exchange rates updated');
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
    for (final currency in Currency.values) {
      _exchangeRates[currency] = currency.exchangeRate;
    }
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
