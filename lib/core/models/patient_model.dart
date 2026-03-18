/// Patient data model mapped to the `patients` Supabase table.
///
/// نموذج بيانات المريض - يحتوي على جميع المعلومات الشخصية والصحية
library;

import 'package:equatable/equatable.dart';

class PatientModel extends Equatable {
  const PatientModel({
    required this.id,
    required this.userId,
    this.profilePhoto,
    this.dateOfBirth,
    this.gender,
    this.bloodType,
    this.height,
    this.weight,
    this.allergies = const [],
    this.medicalHistory = const {},
    this.chronicDiseases = const [],
    this.guardianId,
    this.guardianPhone,
    this.insuranceNumber,
    this.insuranceProvider,
    this.isRemote = false,
    this.tempPasswordChanged = false,
    this.emergencyContact,
    this.emergencyPhone,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      profilePhoto: json['profile_photo'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      bloodType: json['blood_type'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'] as List)
          : const [],
      medicalHistory: json['medical_history'] != null
          ? Map<String, dynamic>.from(json['medical_history'] as Map)
          : const {},
      chronicDiseases: json['chronic_diseases'] != null
          ? List<String>.from(json['chronic_diseases'] as List)
          : const [],
      guardianId: json['guardian_id'] as String?,
      guardianPhone: json['guardian_phone'] as String?,
      insuranceNumber: json['insurance_number'] as String?,
      insuranceProvider: json['insurance_provider'] as String?,
      isRemote: (json['is_remote'] as bool?) ?? false,
      tempPasswordChanged: (json['temp_password_changed'] as bool?) ?? false,
      emergencyContact: json['emergency_contact'] as String?,
      emergencyPhone: json['emergency_phone'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  // ── Fields ─────────────────────────────────────────────
  final String id;
  final String userId;
  final String? profilePhoto;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bloodType;
  final double? height; // بالسنتيمتر
  final double? weight; // بالكيلوجرام
  final List<String> allergies;
  final Map<String, dynamic> medicalHistory;
  final List<String> chronicDiseases;
  final String? guardianId;
  final String? guardianPhone;
  final String? insuranceNumber;
  final String? insuranceProvider;
  final bool isRemote;
  final bool tempPasswordChanged;
  final String? emergencyContact;
  final String? emergencyPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ── Serialization ──────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'profile_photo': profilePhoto,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'gender': gender,
      'blood_type': bloodType,
      'height': height,
      'weight': weight,
      'allergies': allergies,
      'medical_history': medicalHistory,
      'chronic_diseases': chronicDiseases,
      'guardian_id': guardianId,
      'guardian_phone': guardianPhone,
      'insurance_number': insuranceNumber,
      'insurance_provider': insuranceProvider,
      'is_remote': isRemote,
      'temp_password_changed': tempPasswordChanged,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // ── Copy With ──────────────────────────────────────────
  PatientModel copyWith({
    String? id,
    String? userId,
    String? profilePhoto,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    double? height,
    double? weight,
    List<String>? allergies,
    Map<String, dynamic>? medicalHistory,
    List<String>? chronicDiseases,
    String? guardianId,
    String? guardianPhone,
    String? insuranceNumber,
    String? insuranceProvider,
    bool? isRemote,
    bool? tempPasswordChanged,
    String? emergencyContact,
    String? emergencyPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      allergies: allergies ?? this.allergies,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      guardianId: guardianId ?? this.guardianId,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      isRemote: isRemote ?? this.isRemote,
      tempPasswordChanged: tempPasswordChanged ?? this.tempPasswordChanged,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ── Helpers ────────────────────────────────────────────

  /// حساب سن المريض بالسنوات من تاريخ الميلاد
  int? get age {
    if (dateOfBirth == null) return null;
    final today = DateTime.now();
    var calculatedAge = today.year - dateOfBirth!.year;
    if (today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month && today.day < dateOfBirth!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  /// حساب مؤشر كتلة الجسم (BMI)
  double? get bmi {
    if (height == null || weight == null) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// تقييم حالة الوزن بناءً على BMI
  String? get weightStatus {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    if (bmiValue < 18.5) return 'نقص الوزن';
    if (bmiValue < 25) return 'وزن صحي';
    if (bmiValue < 30) return 'زيادة الوزن';
    return 'السمنة';
  }

  /// التحقق من وجود حساسيات
  bool get hasAllergies => allergies.isNotEmpty;

  /// التحقق من وجود أمراض مزمنة
  bool get hasChronicDiseases => chronicDiseases.isNotEmpty;

  /// نسبة اكتمال الملف الشخصي (0.0 - 1.0)
  double get profileCompletionPercentage {
    int completedFields = 0;
    int totalFields = 10;

    if (profilePhoto != null) completedFields++;
    if (dateOfBirth != null) completedFields++;
    if (gender != null) completedFields++;
    if (bloodType != null) completedFields++;
    if (height != null) completedFields++;
    if (weight != null) completedFields++;
    if (allergies.isNotEmpty) completedFields++;
    if (insuranceNumber != null) completedFields++;
    if (emergencyContact != null) completedFields++;
    if (emergencyPhone != null) completedFields++;

    return completedFields / totalFields;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        profilePhoto,
        dateOfBirth,
        gender,
        bloodType,
        height,
        weight,
        allergies,
        medicalHistory,
        chronicDiseases,
        guardianId,
        guardianPhone,
        insuranceNumber,
        insuranceProvider,
        isRemote,
        tempPasswordChanged,
        emergencyContact,
        emergencyPhone,
        createdAt,
        updatedAt,
      ];
}
