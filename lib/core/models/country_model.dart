/// Country model for clinic locations and patient addresses.
library;

import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  // International dialing code (e.g., '+1', '+966')

  const CountryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.code,
    required this.phoneCode,
  });

  /// Create from JSON.
  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json['id'] as String,
        nameAr: json['nameAr'] as String,
        nameEn: json['nameEn'] as String,
        code: json['code'] as String,
        phoneCode: json['phoneCode'] as String,
      );
  final String id;
  final String nameAr;
  final String nameEn;
  final String code; // ISO 3166-1 (e.g., 'US', 'GB', 'KSA')
  final String phoneCode;

  /// Create a copy with optional field overrides.
  CountryModel copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? code,
    String? phoneCode,
  }) =>
      CountryModel(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        code: code ?? this.code,
        phoneCode: phoneCode ?? this.phoneCode,
      );

  /// Get name based on locale ('ar' or 'en').
  String getName(String locale) {
    if (locale.toLowerCase() == 'ar') {
      return nameAr;
    }
    return nameEn;
  }

  /// Get flag emoji based on country code.
  /// Converts ISO code (e.g., 'US') to flag emoji (e.g., 🇺🇸)
  String getFlagEmoji() {
    try {
      final codeUnits = code
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

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'code': code,
        'phoneCode': phoneCode,
      };

  @override
  List<Object?> get props => [id, nameAr, nameEn, code, phoneCode];
}
