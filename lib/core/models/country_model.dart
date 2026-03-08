/// Country model for clinic locations and patient addresses.
library;

import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  const CountryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.iso2Code,
    required this.iso3Code,
    required this.phoneCode,
    required this.currencyCode,
    required this.continent,
    required this.region,
    this.subregion,
    this.capital,
    this.capitalAr,
    this.isActive = true,
    this.isSupported = false,
  });

  /// Create from JSON.
  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        nameAr: json['name_ar'] as String,
        iso2Code: json['iso2_code'] as String,
        iso3Code: json['iso3_code'] as String,
        phoneCode: json['phone_code'] as String,
        currencyCode: json['currency_code'] as String,
        continent: json['continent'] as String,
        region: json['region'] as String,
        subregion: json['subregion'] as String?,
        capital: json['capital'] as String?,
        capitalAr: json['capital_ar'] as String?,
        isActive: (json['is_active'] as bool?) ?? true,
        isSupported: (json['is_supported'] as bool?) ?? false,
      );

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String name;
  final String nameAr;
  final String iso2Code; // ISO 3166-1 alpha-2 (e.g., 'US', 'DZ', 'GB')
  final String iso3Code; // ISO 3166-1 alpha-3 (e.g., 'USA', 'DZA', 'GBR')
  final String phoneCode; // International dialing code (e.g., '+1', '+213', '+44')
  final String currencyCode; // ISO 4217 currency code (e.g., 'USD', 'DZD', 'EUR')
  final String continent;
  final String region;
  final String? subregion;
  final String? capital;
  final String? capitalAr;
  final bool isActive;
  final bool isSupported;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_ar': nameAr,
        'iso2_code': iso2Code,
        'iso3_code': iso3Code,
        'phone_code': phoneCode,
        'currency_code': currencyCode,
        'continent': continent,
        'region': region,
        'subregion': subregion,
        'capital': capital,
        'capital_ar': capitalAr,
        'is_active': isActive,
        'is_supported': isSupported,
      };

  // ── Copy With ──────────────────────────────────────────
  CountryModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? iso2Code,
    String? iso3Code,
    String? phoneCode,
    String? currencyCode,
    String? continent,
    String? region,
    String? subregion,
    String? capital,
    String? capitalAr,
    bool? isActive,
    bool? isSupported,
  }) =>
      CountryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        nameAr: nameAr ?? this.nameAr,
        iso2Code: iso2Code ?? this.iso2Code,
        iso3Code: iso3Code ?? this.iso3Code,
        phoneCode: phoneCode ?? this.phoneCode,
        currencyCode: currencyCode ?? this.currencyCode,
        continent: continent ?? this.continent,
        region: region ?? this.region,
        subregion: subregion ?? this.subregion,
        capital: capital ?? this.capital,
        capitalAr: capitalAr ?? this.capitalAr,
        isActive: isActive ?? this.isActive,
        isSupported: isSupported ?? this.isSupported,
      );

  // ── Helpers ────────────────────────────────────────────

  /// Get name based on locale ('ar' or 'en').
  String getName(String locale) {
    if (locale.toLowerCase() == 'ar') {
      return nameAr;
    }
    return name;
  }

  /// Get capital based on locale ('ar' or 'en').
  String? getCapital(String locale) {
    if (locale.toLowerCase() == 'ar') {
      return capitalAr;
    }
    return capital;
  }

  /// Get flag emoji based on ISO2 code.
  /// Converts ISO code (e.g., 'US', 'DZ') to flag emoji (e.g., 🇺🇸, 🇩🇿)
  String getFlagEmoji() {
    try {
      final codeUnits = iso2Code
          .toUpperCase()
          .codeUnits
          .map((unit) => unit + 127397) // Convert to regional indicator symbols
          .toList();
      return String.fromCharCodes(codeUnits);
    } catch (_) {
      return '🏁'; // Fallback flag
    }
  }

  /// Get full country info for display.
  String getFullInfo({String locale = 'en'}) =>
      '${getName(locale)} (${getFlagEmoji()}) $phoneCode';

  /// Check if phone code is valid.
  bool get isPhoneCodeValid => phoneCode.startsWith('+');

  /// Check if country is Algeria (primary market).
  bool get isAlgeria => iso2Code.toUpperCase() == 'DZ';

  @override
  List<Object?> get props => [
        id,
        name,
        nameAr,
        iso2Code,
        iso3Code,
        phoneCode,
        currencyCode,
        continent,
        region,
        subregion,
        capital,
        capitalAr,
        isActive,
        isSupported,
      ];
}

