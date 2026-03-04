/// Subscription model representing a clinic's subscription plan.
library;

import 'package:equatable/equatable.dart';
import 'package:mcs/core/enums/subscription_type.dart';

class SubscriptionModel extends Equatable {
  const SubscriptionModel({
    required this.id,
    required this.code,
    required this.type,
    required this.priceUsd,
    required this.priceEur,
    required this.priceDzd,
    this.isUsed = false,
    this.clinicId,
    this.usedAt,
    this.createdAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      code: json['code'] as String,
      type: SubscriptionType.fromDbValue(json['type'] as String),
      priceUsd: (json['price_usd'] as num).toDouble(),
      priceEur: (json['price_eur'] as num).toDouble(),
      priceDzd: (json['price_dzd'] as num).toDouble(),
      isUsed: json['is_used'] as bool? ?? false,
      clinicId: json['clinic_id'] as String?,
      usedAt: json['used_at'] != null
          ? DateTime.parse(json['used_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  final String id;
  final String code; // Unique code for activation
  final SubscriptionType type;
  final double priceUsd;
  final double priceEur;
  final double priceDzd;
  final bool isUsed;
  final String? clinicId;
  final DateTime? usedAt;
  final DateTime? createdAt;

  /// Get price in specified currency
  double getPrice(String currency) {
    final lowerCurrency = currency.toLowerCase();
    if (lowerCurrency == 'usd' || lowerCurrency == r'$') {
      return priceUsd;
    } else if (lowerCurrency == 'eur' || lowerCurrency == '€') {
      return priceEur;
    } else if (lowerCurrency == 'dzd' || lowerCurrency == 'دج') {
      return priceDzd;
    }
    return priceUsd;
  }

  /// Get price formatted as string
  String getPriceFormatted(String currency) {
    final price = getPrice(currency);
    switch (currency.toLowerCase()) {
      case 'usd':
        return '\$${price.toStringAsFixed(2)}';
      case 'eur':
        return '€${price.toStringAsFixed(2)}';
      case 'dzd':
        return '${price.toStringAsFixed(2)} دج';
      default:
        return '\$${price.toStringAsFixed(2)}';
    }
  }

  /// Get duration in months
  int get durationInMonths {
    switch (type) {
      case SubscriptionType.trial:
        return 1; // 30 days trial
      case SubscriptionType.monthly:
        return 1;
      case SubscriptionType.quarterly:
        return 3;
      case SubscriptionType.halfYearly:
        return 6;
      case SubscriptionType.yearly:
        return 12;
    }
  }

  /// Get end date based on start date
  DateTime getEndDate(DateTime startDate) {
    switch (type) {
      case SubscriptionType.trial:
        return startDate.add(const Duration(days: 30));
      case SubscriptionType.monthly:
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
      case SubscriptionType.quarterly:
        return DateTime(startDate.year, startDate.month + 3, startDate.day);
      case SubscriptionType.halfYearly:
        return DateTime(startDate.year, startDate.month + 6, startDate.day);
      case SubscriptionType.yearly:
        return DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'type': type.toDbValue(),
      'price_usd': priceUsd,
      'price_eur': priceEur,
      'price_dzd': priceDzd,
      'is_used': isUsed,
      'clinic_id': clinicId,
      'used_at': usedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  SubscriptionModel copyWith({
    String? id,
    String? code,
    SubscriptionType? type,
    double? priceUsd,
    double? priceEur,
    double? priceDzd,
    bool? isUsed,
    String? clinicId,
    DateTime? usedAt,
    DateTime? createdAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      priceUsd: priceUsd ?? this.priceUsd,
      priceEur: priceEur ?? this.priceEur,
      priceDzd: priceDzd ?? this.priceDzd,
      isUsed: isUsed ?? this.isUsed,
      clinicId: clinicId ?? this.clinicId,
      usedAt: usedAt ?? this.usedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        code,
        type,
        priceUsd,
        priceEur,
        priceDzd,
        isUsed,
        clinicId,
        usedAt,
        createdAt,
      ];
}
