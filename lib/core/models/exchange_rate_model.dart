/// Exchange rate model for currency conversion.
library;

import 'package:equatable/equatable.dart';

class ExchangeRateModel extends Equatable {
  // User/System ID who updated the rate

  const ExchangeRateModel({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.updatedAt,
    required this.updatedBy,
  });

  /// Create from JSON.
  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      ExchangeRateModel(
        id: json['id'] as String,
        fromCurrency: json['fromCurrency'] as String,
        toCurrency: json['toCurrency'] as String,
        rate: (json['rate'] as num).toDouble(),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        updatedBy: json['updatedBy'] as String,
      );
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime updatedAt;
  final String updatedBy;

  /// Create a copy with optional field overrides.
  ExchangeRateModel copyWith({
    String? id,
    String? fromCurrency,
    String? toCurrency,
    double? rate,
    DateTime? updatedAt,
    String? updatedBy,
  }) =>
      ExchangeRateModel(
        id: id ?? this.id,
        fromCurrency: fromCurrency ?? this.fromCurrency,
        toCurrency: toCurrency ?? this.toCurrency,
        rate: rate ?? this.rate,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
      );

  /// Convert an amount from source currency to target currency.
  /// Example: ExchangeRate(from: 'USD', to: 'SAR', rate: 3.75)
  ///   .convert(100) returns 375
  double convert(double amount) => amount * rate;

  /// Check if exchange rate is recent (updated within last 24 hours).
  bool get isRecent {
    final diff = DateTime.now().difference(updatedAt);
    return diff.inHours < 24;
  }

  /// Hours since last update.
  int get hoursSinceUpdate => DateTime.now().difference(updatedAt).inHours;

  /// Days since last update.
  int get daysSinceUpdate => DateTime.now().difference(updatedAt).inDays;

  /// Get currency pair as string (e.g., 'USD/SAR').
  String getCurrencyPair() => '$fromCurrency/$toCurrency';

  /// Get reverse exchange rate (inverse of current rate).
  double get reverseRate => 1 / rate;

  /// Convert in reverse direction.
  double convertReverse(double amount) => amount * reverseRate;

  /// Get formatted rate string (e.g., '1 USD = 3.75 SAR').
  String getFormattedRate() =>
      '1 $fromCurrency = ${rate.toStringAsFixed(4)} $toCurrency';

  /// Get stale status string.
  String getUpdateStatus() {
    if (isRecent) return 'Updated today';
    if (daysSinceUpdate == 1) return 'Updated yesterday';
    return 'Updated ${daysSinceUpdate}d ago';
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'fromCurrency': fromCurrency,
        'toCurrency': toCurrency,
        'rate': rate,
        'updatedAt': updatedAt.toIso8601String(),
        'updatedBy': updatedBy,
      };

  @override
  List<Object?> get props => [
        id,
        fromCurrency,
        toCurrency,
        rate,
        updatedAt,
        updatedBy,
      ];
}
