/// Subscription plan types and statuses.
///
/// Values match the PostgreSQL enums in Supabase.
library;

// ── Plan Type ──────────────────────────────────────────────
enum SubscriptionPlanType {
  trial('trial', 'تجريبي', 'Trial', 30),
  monthly('monthly', 'شهري', 'Monthly', 30),
  quarterly('quarterly', 'ربع سنوي', 'Quarterly', 90),
  semiAnnual('semi_annual', 'نصف سنوي', 'Semi-Annual', 180),
  annual('annual', 'سنوي', 'Annual', 365);

  const SubscriptionPlanType(
    this.dbValue,
    this.labelAr,
    this.labelEn,
    this.durationDays,
  );

  final String dbValue;
  final String labelAr;
  final String labelEn;
  final int durationDays;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  String toDbValue() => dbValue;

  static SubscriptionPlanType fromDbValue(String value) {
    return SubscriptionPlanType.values.firstWhere(
      (t) => t.dbValue == value,
      orElse: () => throw ArgumentError('Unknown SubscriptionPlanType: $value'),
    );
  }
}

// ── Subscription Type (for subscription codes) ─────────────
enum SubscriptionType {
  trial('trial', 'تجريبي', 'Trial', 0, 0, 0, 30),
  monthly('monthly', 'شهري', 'Monthly', 29.99, 27.99, 4000, 30),
  quarterly('quarterly', 'ربع سنوي', 'Quarterly', 79.99, 74.99, 11000, 90),
  halfYearly(
      'half_yearly', 'نصف سنوي', 'Half-Yearly', 149.99, 139.99, 20000, 180,
  ),
  yearly('yearly', 'سنوي', 'Yearly', 279.99, 259.99, 37000, 365);

  const SubscriptionType(
    this.dbValue,
    this.labelAr,
    this.labelEn,
    this.priceUsd,
    this.priceEur,
    this.priceDzd,
    this.durationDays,
  );

  final String dbValue;
  final String labelAr;
  final String labelEn;
  final double priceUsd;
  final double priceEur;
  final double priceDzd;
  final int durationDays;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  String toDbValue() => dbValue;

  DateTime getEndDate(DateTime startDate) {
    return startDate.add(Duration(days: durationDays));
  }

  static SubscriptionType fromDbValue(String value) {
    return SubscriptionType.values.firstWhere(
      (t) => t.dbValue == value,
      orElse: () => throw ArgumentError('Unknown SubscriptionType: $value'),
    );
  }
}

// ── Subscription Status ────────────────────────────────────
enum SubscriptionStatus {
  active('active', 'نشط', 'Active'),
  expired('expired', 'منتهي', 'Expired'),
  suspended('suspended', 'معلّق', 'Suspended'),
  cancelled('cancelled', 'ملغى', 'Cancelled');

  const SubscriptionStatus(this.dbValue, this.labelAr, this.labelEn);

  final String dbValue;
  final String labelAr;
  final String labelEn;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  static SubscriptionStatus fromDbValue(String value) {
    return SubscriptionStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () => throw ArgumentError('Unknown SubscriptionStatus: $value'),
    );
  }

  bool get isUsable => this == active;
}

