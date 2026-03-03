/// Vital signs model for patient health metrics.
library;

import 'package:equatable/equatable.dart';

enum BloodPressureStatus { normal, elevated, high, low }

enum TemperatureStatus { normal, fever, hypothermia }

class VitalSignsModel extends Equatable {
  const VitalSignsModel({
    required this.id,
    required this.patientId,
    required this.recordedBy,
    required this.systolicBP,
    required this.diastolicBP,
    required this.heartRate,
    required this.temperature,
    required this.weight,
    required this.height,
    required this.oxygenSaturation,
    this.notes,
    required this.recordedAt,
  });

  /// Create from JSON.
  factory VitalSignsModel.fromJson(Map<String, dynamic> json) =>
      VitalSignsModel(
        id: json['id'] as String,
        patientId: json['patientId'] as String,
        recordedBy: json['recordedBy'] as String,
        systolicBP: json['systolicBP'] as int,
        diastolicBP: json['diastolicBP'] as int,
        heartRate: json['heartRate'] as int,
        temperature: (json['temperature'] as num).toDouble(),
        weight: (json['weight'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        oxygenSaturation: json['oxygenSaturation'] as int,
        notes: json['notes'] as String?,
        recordedAt: DateTime.parse(json['recordedAt'] as String),
      );
  final String id;
  final String patientId;
  final String recordedBy; // Doctor/Nurse ID
  final int systolicBP;
  final int diastolicBP;
  final int heartRate;
  final double temperature;
  final double weight;
  final double height;
  final int oxygenSaturation;
  final String? notes;
  final DateTime recordedAt;

  /// Create a copy with optional field overrides.
  VitalSignsModel copyWith({
    String? id,
    String? patientId,
    String? recordedBy,
    int? systolicBP,
    int? diastolicBP,
    int? heartRate,
    double? temperature,
    double? weight,
    double? height,
    int? oxygenSaturation,
    String? notes,
    DateTime? recordedAt,
  }) =>
      VitalSignsModel(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        recordedBy: recordedBy ?? this.recordedBy,
        systolicBP: systolicBP ?? this.systolicBP,
        diastolicBP: diastolicBP ?? this.diastolicBP,
        heartRate: heartRate ?? this.heartRate,
        temperature: temperature ?? this.temperature,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        oxygenSaturation: oxygenSaturation ?? this.oxygenSaturation,
        notes: notes ?? this.notes,
        recordedAt: recordedAt ?? this.recordedAt,
      );

  /// Calculate BMI (Body Mass Index).
  /// BMI = weight(kg) / (height(m))^2
  double getBMI() {
    if (height == 0) return 0;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// Get BMI category.
  String getBMICategory() {
    final bmi = getBMI();
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// Get blood pressure status.
  BloodPressureStatus getBPStatus() {
    if (systolicBP < 90 || diastolicBP < 60) return BloodPressureStatus.low;
    if (systolicBP < 120 && diastolicBP < 80) return BloodPressureStatus.normal;
    if (systolicBP < 130 && diastolicBP < 80) {
      return BloodPressureStatus.elevated;
    }
    return BloodPressureStatus.high;
  }

  /// Get blood pressure status name.
  String getBPStatusName() {
    final status = getBPStatus();
    switch (status) {
      case BloodPressureStatus.normal:
        return 'Normal';
      case BloodPressureStatus.elevated:
        return 'Elevated';
      case BloodPressureStatus.high:
        return 'High';
      case BloodPressureStatus.low:
        return 'Low';
    }
  }

  /// Get blood pressure reading as string.
  String getBPReading() => '$systolicBP/$diastolicBP';

  /// Get temperature status.
  TemperatureStatus getTemperatureStatus() {
    if (temperature < 36.1) return TemperatureStatus.hypothermia;
    if (temperature <= 37.2) return TemperatureStatus.normal;
    return TemperatureStatus.fever;
  }

  /// Get temperature status name.
  String getTemperatureStatusName() {
    final status = getTemperatureStatus();
    switch (status) {
      case TemperatureStatus.normal:
        return 'Normal';
      case TemperatureStatus.fever:
        return 'Fever';
      case TemperatureStatus.hypothermia:
        return 'Hypothermia';
    }
  }

  /// Check if oxygen saturation is normal (typically 95-100%).
  bool get isOxygenLow => oxygenSaturation < 95;

  /// Check if heart rate is within normal range (60-100 bpm).
  bool get isHeartRateNormal => heartRate >= 60 && heartRate <= 100;

  /// Check if any vital sign is abnormal.
  bool get hasAbnormalVitals =>
      getBPStatus() != BloodPressureStatus.normal ||
      getTemperatureStatus() != TemperatureStatus.normal ||
      isOxygenLow ||
      !isHeartRateNormal;

  /// Get all vital signs as readable string.
  String getFormattedVitals() => '''
BP: $systolicBP/$diastolicBP mmHg (${getBPStatusName()})
HR: $heartRate bpm
Temperature: $temperature°C (${getTemperatureStatusName()})
O2 Saturation: $oxygenSaturation%
Weight: $weight kg
Height: $height cm
BMI: ${getBMI().toStringAsFixed(1)} (${getBMICategory()})
''';

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'recordedBy': recordedBy,
        'systolicBP': systolicBP,
        'diastolicBP': diastolicBP,
        'heartRate': heartRate,
        'temperature': temperature,
        'weight': weight,
        'height': height,
        'oxygenSaturation': oxygenSaturation,
        'notes': notes,
        'recordedAt': recordedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        patientId,
        recordedBy,
        systolicBP,
        diastolicBP,
        heartRate,
        temperature,
        weight,
        height,
        oxygenSaturation,
        notes,
        recordedAt,
      ];
}
