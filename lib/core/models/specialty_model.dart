/// Specialty model for medical specialties (e.g., Cardiology, Dentistry).
library;

import 'package:equatable/equatable.dart';

class SpecialtyModel extends Equatable {
  const SpecialtyModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.descriptionAr,
    required this.descriptionEn,
  });

  /// Create from JSON.
  factory SpecialtyModel.fromJson(Map<String, dynamic> json) => SpecialtyModel(
        id: json['id'] as String,
        nameAr: json['nameAr'] as String,
        nameEn: json['nameEn'] as String,
        icon: json['icon'] as String,
        descriptionAr: json['descriptionAr'] as String,
        descriptionEn: json['descriptionEn'] as String,
      );
  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String descriptionAr;
  final String descriptionEn;

  /// Create a copy with optional field overrides.
  SpecialtyModel copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? icon,
    String? descriptionAr,
    String? descriptionEn,
  }) =>
      SpecialtyModel(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        icon: icon ?? this.icon,
        descriptionAr: descriptionAr ?? this.descriptionAr,
        descriptionEn: descriptionEn ?? this.descriptionEn,
      );

  /// Get name based on locale ('ar' or 'en').
  String getName(String locale) {
    if (locale.toLowerCase() == 'ar') {
      return nameAr;
    }
    return nameEn;
  }

  /// Get description based on locale ('ar' or 'en').
  String getDescription(String locale) {
    if (locale.toLowerCase() == 'ar') {
      return descriptionAr;
    }
    return descriptionEn;
  }

  /// Get icon URL or path.
  String getIconUrl() => icon;

  /// Check if the icon is a valid URL or local path.
  bool get isIconValid => icon.isNotEmpty;

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'icon': icon,
        'descriptionAr': descriptionAr,
        'descriptionEn': descriptionEn,
      };

  @override
  List<Object?> get props => [
        id,
        nameAr,
        nameEn,
        icon,
        descriptionAr,
        descriptionEn,
      ];
}
