/// Subscription code data model mapped to the `subscription_codes` table.
library;

import 'package:equatable/equatable.dart';

import 'package:mcs/core/enums/subscription_type.dart';

class SubscriptionCodeModel extends Equatable {
  const SubscriptionCodeModel({
    required this.id,
    required this.code,
    required this.planType,
    this.priceUsd = 0,
    this.priceEur = 0,
    this.priceDzd = 0,
    this.maxUses = 1,
    this.usedCount = 0,
    this.isActive = true,
    this.createdBy,
    this.expiresAt,
    this.createdAt,
  });

  factory SubscriptionCodeModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionCodeModel(
      id: json['id'] as String,
      code: json['code'] as String,
      planType:
          SubscriptionPlanType.fromDbValue(json['plan_type'] as String),
      priceUsd: (json['price_usd'] as num?)?.toDouble() ?? 0,
      priceEur: (json['price_eur'] as num?)?.toDouble() ?? 0,
      priceDzd: (json['price_dzd'] as num?)?.toDouble() ?? 0,
      maxUses: (json['max_uses'] as int?) ?? 1,
      usedCount: (json['used_count'] as int?) ?? 0,
      isActive: (json['is_active'] as bool?) ?? true,
      createdBy: json['created_by'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String code;
  final SubscriptionPlanType planType;
  final double priceUsd;
  final double priceEur;
  final double priceDzd;
  final int maxUses;
  final int usedCount;
  final bool isActive;
  final String? createdBy;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'plan_type': planType.dbValue,
      'price_usd': priceUsd,
      'price_eur': priceEur,
      'price_dzd': priceDzd,
      'max_uses': maxUses,
      'used_count': usedCount,
      'is_active': isActive,
      'created_by': createdBy,
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // ── Copy With ──────────────────────────────────────────
  SubscriptionCodeModel copyWith({
    String? id,
    String? code,
    SubscriptionPlanType? planType,
    double? priceUsd,
    double? priceEur,
    double? priceDzd,
    int? maxUses,
    int? usedCount,
    bool? isActive,
    String? createdBy,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return SubscriptionCodeModel(
      id: id ?? this.id,
      code: code ?? this.code,
      planType: planType ?? this.planType,
      priceUsd: priceUsd ?? this.priceUsd,
      priceEur: priceEur ?? this.priceEur,
      priceDzd: priceDzd ?? this.priceDzd,
      maxUses: maxUses ?? this.maxUses,
      usedCount: usedCount ?? this.usedCount,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ── Helpers ────────────────────────────────────────────

  /// Whether this code can still be redeemed.
  bool get canBeUsed {
    if (!isActive) return false;
    if (usedCount >= maxUses) return false;
    if (expiresAt != null && DateTime.now().isAfter(expiresAt!)) return false;
    return true;
  }

  /// Number of remaining uses.
  int get remainingUses => maxUses - usedCount;

  /// Whether the code has expired by date.
  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  /// Whether all uses have been consumed.
  bool get isFullyUsed => usedCount >= maxUses;

  /// Returns the price in the given [currency] code.
  double priceFor(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return priceUsd;
      case 'EUR':
        return priceEur;
      case 'DZD':
        return priceDzd;
      default:
        return priceUsd;
    }
  }

  // ── Equatable ──────────────────────────────────────────
  @override
  List<Object?> get props => [
        id,
        code,
        planType,
        priceUsd,
        priceEur,
        priceDzd,
        maxUses,
        usedCount,
        isActive,
        createdBy,
        expiresAt,
        createdAt,
      ];
}
