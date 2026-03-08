/// Doctor data model mapped to the `doctors` Supabase table.
library;

import 'package:equatable/equatable.dart';

class DoctorModel extends Equatable {
  const DoctorModel({
    required this.id,
    required this.userId,
    required this.clinicId,
    required this.specialtyId,
    this.fullName,
    this.name,
    this.licenseNumber,
    this.bioAr,
    this.bioEn,
    this.experienceYears = 0,
    this.consultationFee = 0,
    this.currency = 'USD',
    this.acceptsRemote = false,
    this.isAvailable = true,
    this.workingHours = const {},
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      clinicId: json['clinic_id'] as String,
      specialtyId: json['specialty_id'] as String,
      fullName: json['full_name'] as String? ?? json['fullName'] as String?,
      name: json['name'] as String?,
      licenseNumber: json['license_number'] as String?,
      bioAr: json['bio_ar'] as String?,
      bioEn: json['bio_en'] as String?,
      experienceYears: (json['experience_years'] as int?) ?? 0,
      consultationFee: (json['consultation_fee'] as num?)?.toDouble() ?? 0,
      currency: (json['currency'] as String?) ?? 'USD',
      acceptsRemote: (json['accepts_remote'] as bool?) ?? false,
      isAvailable: (json['is_available'] as bool?) ?? true,
      workingHours: json['working_hours'] != null
          ? Map<String, dynamic>.from(json['working_hours'] as Map)
          : const {},
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String userId;
  final String clinicId;
  final String specialtyId;
  final String? fullName;
  final String? name;
  final String? licenseNumber;
  final String? bioAr;
  final String? bioEn;
  final int experienceYears;
  final double consultationFee;
  final String currency;
  final bool acceptsRemote;
  final bool isAvailable;

  /// Working hours stored as JSON
  final Map<String, dynamic> workingHours;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'clinic_id': clinicId,
      'specialty_id': specialtyId,
      'full_name': fullName,
      'name': name,
      'license_number': licenseNumber,
      'bio_ar': bioAr,
      'bio_en': bioEn,
      'experience_years': experienceYears,
      'consultation_fee': consultationFee,
      'currency': currency,
      'accepts_remote': acceptsRemote,
      'is_available': isAvailable,
      'working_hours': workingHours,
    };
  }

  // ── Copy With ──────────────────────────────────────────
  DoctorModel copyWith({
    String? id,
    String? userId,
    String? clinicId,
    String? specialtyId,
    String? fullName,
    String? name,
    String? licenseNumber,
    String? bioAr,
    String? bioEn,
    int? experienceYears,
    double? consultationFee,
    String? currency,
    bool? acceptsRemote,
    bool? isAvailable,
    Map<String, dynamic>? workingHours,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clinicId: clinicId ?? this.clinicId,
      specialtyId: specialtyId ?? this.specialtyId,
      fullName: fullName ?? this.fullName,
      name: name ?? this.name,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      bioAr: bioAr ?? this.bioAr,
      bioEn: bioEn ?? this.bioEn,
      experienceYears: experienceYears ?? this.experienceYears,
      consultationFee: consultationFee ?? this.consultationFee,
      currency: currency ?? this.currency,
      acceptsRemote: acceptsRemote ?? this.acceptsRemote,
      isAvailable: isAvailable ?? this.isAvailable,
      workingHours: workingHours ?? this.workingHours,
    );
  }

  // ── Helpers ────────────────────────────────────────────

  /// Returns localized bio
  String bio(String locale) => locale == 'ar' ? (bioAr ?? '') : (bioEn ?? '');

  /// Check if doctor works on specific day
  bool worksOn(String day) => workingHours.containsKey(day.toLowerCase());

  /// Formatted consultation fee
  String get formattedFee => '${consultationFee.toStringAsFixed(2)} $currency';

  // ── Equatable ──────────────────────────────────────────
  @override
  List<Object?> get props => [
        id,
        userId,
        clinicId,
        specialtyId,
        fullName,
        name,
        licenseNumber,
        bioAr,
        bioEn,
        experienceYears,
        consultationFee,
        currency,
        acceptsRemote,
        isAvailable,
        workingHours,
      ];
}
