/// Region/State model for geographic locations within countries.
library;

import 'package:equatable/equatable.dart';

class RegionModel extends Equatable {
  const RegionModel({
    required this.id,
    required this.countryId,
    required this.nameAr,
    required this.nameEn,
  });

  /// Create from JSON.
  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
        id: json['id'] as String,
        countryId: json['countryId'] as String,
        nameAr: json['nameAr'] as String,
        nameEn: json['nameEn'] as String,
      );
  final String id;
  final String countryId;
  final String nameAr;
  final String nameEn;

  /// Create a copy with optional field overrides.
  RegionModel copyWith({
    String? id,
    String? countryId,
    String? nameAr,
    String? nameEn,
  }) =>
      RegionModel(
        id: id ?? this.id,
        countryId: countryId ?? this.countryId,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
      );

  /// Get name based on locale ('ar' or 'en').
  String getName(String locale) {
    if (locale.toLowerCase() == 'ar') {
      return nameAr;
    }
    return nameEn;
  }

  /// Get full name with country context.
  /// This would typically be used with the country name for full address display.
  String getFullName(String locale, {String countryName = ''}) {
    final name = getName(locale);
    if (countryName.isEmpty) return name;
    return '$name, $countryName';
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'countryId': countryId,
        'nameAr': nameAr,
        'nameEn': nameEn,
      };

  @override
  List<Object?> get props => [id, countryId, nameAr, nameEn];
}
