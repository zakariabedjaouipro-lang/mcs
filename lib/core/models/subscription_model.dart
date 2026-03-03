/// Subscription data model mapped to the `subscriptions` Supabase table.
library;

import 'package:equatable/equatable.dart';

import 'package:mcs/core/constants/app_constants.dart';
import 'package:mcs/core/enums/subscription_type.dart';

class SubscriptionModel extends Equatable {
  const SubscriptionModel({
    required this.id,
    required this.clinicId,
    required this.planType,
    required this.status,
    required this.startsAt,
    required this.endsAt,
    this.codeUsed,
    this.amountPaid = 0,
    this.currency = 'USD',
    this.createdAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      clinicId: json['clinic_id'] as String,
      planType:
          SubscriptionPlanType.fromDbValue(json['plan_type'] as String),
      status:
          SubscriptionStatus.fromDbValue(json['status'] as String),
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      codeUsed: json['code_used'] as String?,
      amountPaid: (json['amount_paid'] as num?)?.toDouble() ?? 0,
      currency: (json['currency'] as String?) ?? 'USD',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String clinicId;
  final SubscriptionPlanType planType;
  final SubscriptionStatus status;
  final DateTime startsAt;
  final DateTime endsAt;
  final String? codeUsed;
  final double amountPaid;
  final String currency;
  final DateTime? createdAt;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinic_id': clinicId,
      'plan_type': planType.dbValue,
      'status': status.dbValue,
      'starts_at': startsAt.toIso8601String(),
      'ends_at': endsAt.toIso8601String(),
      'code_used': codeUsed,
      'amount_paid': amountPaid,
      'currency': currency,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // ── Copy With ──────────────────────────────────────────
  SubscriptionModel copyWith({
    String? id,
    String? clinicId,
    SubscriptionPlanType? planType,
    SubscriptionStatus? status,
    DateTime? startsAt,
    DateTime? endsAt,
    String? codeUsed,
    double? amountPaid,
    String? currency,
    DateTime? createdAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      clinicId: clinicId ?? this.clinicId,
      planType: planType ?? this.planType,
      status: status ?? this.status,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      codeUsed: codeUsed ?? this.codeUsed,
      amountPaid: amountPaid ?? this.amountPaid,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ── Helpers ────────────────────────────────────────────

  /// Whether the subscription is currently valid (active & not expired).
  bool get isValid =>
      status == SubscriptionStatus.active && DateTime.now().isBefore(endsAt);

  /// Number of remaining days. Returns 0 if expired.
  int get remainingDays {
    final diff = endsAt.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  /// Whether a renewal warning should be shown.
  bool get shouldWarn =>
      remainingDays <= AppConstants.warningBeforeExpiryDays && isValid;

  /// Whether the critical (3-day) warning threshold is reached.
  bool get isCriticalWarning =>
      remainingDays <= AppConstants.criticalWarningDays && isValid;

  /// Whether it's the final (1-day) warning.
  bool get isFinalWarning =>
      remainingDays <= AppConstants.finalWarningDays && isValid;

  bool get isTrial => planType == SubscriptionPlanType.trial;
  bool get isExpired => status == SubscriptionStatus.expired;
  bool get isSuspended => status == SubscriptionStatus.suspended;

  // ── Equatable ──────────────────────────────────────────
  @override
  List<Object?> get props => [
        id,
        clinicId,
        planType,
        status,
        startsAt,
        endsAt,
        codeUsed,
        amountPaid,
        currency,
        createdAt,
      ];
}
