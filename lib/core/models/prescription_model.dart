/// Prescription model for doctor-prescribed medications.
library;

import 'package:equatable/equatable.dart';

class MedicationItem extends Equatable {
  const MedicationItem({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
  });

  /// Create from JSON.
  factory MedicationItem.fromJson(Map<String, dynamic> json) => MedicationItem(
        name: json['name'] as String,
        dosage: json['dosage'] as String,
        frequency: json['frequency'] as String,
        duration: json['duration'] as String,
        instructions: json['instructions'] as String?,
      );
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String? instructions;

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'name': name,
        'dosage': dosage,
        'frequency': frequency,
        'duration': duration,
        'instructions': instructions,
      };

  @override
  List<Object?> get props => [name, dosage, frequency, duration, instructions];
}

class PrescriptionModel extends Equatable {
  const PrescriptionModel({
    required this.id,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.medications,
    required this.createdAt,
    this.notes,
  });

  /// Create from JSON.
  factory PrescriptionModel.fromJson(Map<String, dynamic> json) =>
      PrescriptionModel(
        id: json['id'] as String,
        appointmentId: json['appointmentId'] as String,
        doctorId: json['doctorId'] as String,
        patientId: json['patientId'] as String,
        medications: (json['medications'] as List<dynamic>)
            .map((m) => MedicationItem.fromJson(m as Map<String, dynamic>))
            .toList(),
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
  final String id;
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final List<MedicationItem> medications;
  final String? notes;
  final DateTime createdAt;

  /// Create a copy with optional field overrides.
  PrescriptionModel copyWith({
    String? id,
    String? appointmentId,
    String? doctorId,
    String? patientId,
    List<MedicationItem>? medications,
    String? notes,
    DateTime? createdAt,
  }) =>
      PrescriptionModel(
        id: id ?? this.id,
        appointmentId: appointmentId ?? this.appointmentId,
        doctorId: doctorId ?? this.doctorId,
        patientId: patientId ?? this.patientId,
        medications: medications ?? this.medications,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
      );

  /// Get total number of medications in the prescription.
  int get medicationCount => medications.length;

  /// Get medications as formatted list of strings.
  List<String> getMedicationsList() =>
      medications.map((m) => '${m.name} - ${m.dosage}').toList();

  /// Check if prescription has any refills available (based on duration).
  bool get hasRefills =>
      medications.any((m) => m.frequency.toLowerCase().contains('daily'));

  /// Check if prescription is recent (created within last 30 days).
  bool get isRecent {
    final diff = DateTime.now().difference(createdAt);
    return diff.inDays <= 30;
  }

  /// Format medications for display.
  String getFormattedMedications() => medications
      .map((m) => '${m.name} ${m.dosage} - ${m.frequency}')
      .join('\n');

  /// Alias for createdAt for backward compatibility
  DateTime get prescriptionDate => createdAt;

  /// Get doctor name (to be loaded from doctor model)
  String? get doctorName => null;

  /// Get diagnosis (from notes)
  String? get diagnosis => notes;

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'appointmentId': appointmentId,
        'doctorId': doctorId,
        'patientId': patientId,
        'medications': medications.map((m) => m.toJson()).toList(),
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        appointmentId,
        doctorId,
        patientId,
        medications,
        notes,
        createdAt,
      ];
}
