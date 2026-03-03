/// Patient data model mapped to the `patients` Supabase table.
library;

import 'package:equatable/equatable.dart';

class PatientModel extends Equatable {
  const PatientModel({
    required this.id,
    required this.userId,
    this.dateOfBirth,
    this.gender,
    this.bloodType,
    this.allergies = const [],
    this.medicalHistory = const {},
    this.guardianId,
    this.isRemote = false,
    this.tempPasswordChanged = false,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      bloodType: json['blood_type'] as String?,
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'] as List)
          : const [],
      medicalHistory: json['medical_history'] != null
          ? Map<String, dynamic>.from(json['medical_history'] as Map)
          : const {},
      guardianId: json['guardian_id'] as String?,
      isRemote: (json['is_remote'] as bool?) ?? false,
      tempPasswordChanged:
          (json['temp_password_changed'] as bool?) ?? false,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String userId;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bloodType;
  final List<String> allergies;
  final Map<String, dynamic> medicalHistory;
  final String? guardianId;
  final bool isRemote;
  final bool tempPasswordChanged;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'gender': gender,
      'blood_type': bloodType,
      'allergies': allergies,
      'medical_history': medicalHistory,
      'guardian_id': guardianId,
      'is_remote': isRemote,
      'temp_password_changed': tempPasswordChanged,
    };
  }

  // ── Copy With ──────────────────────────────────────────
  PatientModel copyWith({
    String? id,
    String? userId,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    List<String>? allergies,
    Map<String, dynamic>? medicalHistory,
    String? guardianId,
    bool? isRemote,
    bool? tempPasswordChanged,
  }) {
    return PatientModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      guardianId: guardianId ?? this.guardianId,
      isRemote: isRemote ?? this.isRemote,
      tempPasswordChanged:
          tempPasswordChanged ?? this.tempPasswordChanged,
    );
  }

  // ── Helpers ────────────────────────────────────────────

  /// Calculates the patient's age in years from [dateOfBirth].
  ///
  /// Returns `null` if [dateOfBirth] is not set.
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    var years = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      years--;
    }
    return years;
  }

  /// Whether this patient has a guardian assigned.
  bool get hasGuardian => guardianId != null && guardianId!.isNotEmpty;

  /// Whether the patient has any known allergies.
  bool get hasAllergies => allergies.isNotEmpty;

  /// Whether the remote patient still needs to change the temp password.
  bool get needsPasswordChange => isRemote && !tempPasswordChanged;

  // ── Equatable ──────────────────────────────────────────
  @override
  List<Object?> get props => [
        id,
        userId,
        dateOfBirth,
        gender,
        bloodType,
        allergies,
        medicalHistory,
        guardianId,
        isRemote,
        tempPasswordChanged,
      ];
}
