/// Region/State model for geographic locations within countries.
library;

import 'package:equatable/equatable.dart';

class RegionModel extends Equatable {
  const RegionModel({
    required this.id,
    required this.countryId,
    required this.name,
    required this.nameAr,
    required this.code,
    required this.isoCode,
    required this.regionType,
    this.capital,
    this.capitalAr,
  });

  /// Create from JSON.
  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
        id: json['id'] as String,
        countryId: json['country_id'] as String,
        name: json['name'] as String,
        nameAr: json['name_ar'] as String,
        code: json['code'] as String,
        isoCode: json['iso_code'] as String,
        regionType: json['region_type'] as String,
        capital: json['capital'] as String?,
        capitalAr: json['capital_ar'] as String?,
      );

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String countryId;
  final String name;
  final String nameAr;
  final String code; // Regional code (e.g., '01', '16' for Algerian wilayas)
  final String isoCode; // ISO 3166-2 subdivision code (e.g., 'DZ-01', 'DZ-16')
  final String regionType; // Type of region (e.g., 'wilaya', 'state', 'province', 'governorate')
  final String? capital;
  final String? capitalAr;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() => {
        'id': id,
        'country_id': countryId,
        'name': name,
        'name_ar': nameAr,
        'code': code,
        'iso_code': isoCode,
        'region_type': regionType,
        'capital': capital,
        'capital_ar': capitalAr,
      };

  // ── Copy With ──────────────────────────────────────────
  RegionModel copyWith({
    String? id,
    String? countryId,
    String? name,
    String? nameAr,
    String? code,
    String? isoCode,
    String? regionType,
    String? capital,
    String? capitalAr,
  }) =>
      RegionModel(
        id: id ?? this.id,
        countryId: countryId ?? this.countryId,
        name: name ?? this.name,
        nameAr: nameAr ?? this.nameAr,
        code: code ?? this.code,
        isoCode: isoCode ?? this.isoCode,
        regionType: regionType ?? this.regionType,
        capital: capital ?? this.capital,
        capitalAr: capitalAr ?? this.capitalAr,
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

  /// Get full name with country context.
  String getFullName(String locale, {String countryName = ''}) {
    final name = getName(locale);
    if (countryName.isEmpty) return name;
    return '$name, $countryName';
  }

  /// Get formatted name with code.
  String getFormattedName(String locale) {
    final name = getName(locale);
    return '$name ($code)';
  }

  /// Check if this is an Algerian wilaya (region).
  bool get isWilaya => regionType.toLowerCase() == 'wilaya';

  @override
  List<Object?> get props => [
        id,
        countryId,
        name,
        nameAr,
        code,
        isoCode,
        regionType,
        capital,
        capitalAr,
      ];
}