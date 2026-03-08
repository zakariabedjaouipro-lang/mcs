/// Autism Assessment Model for ASD evaluation results.
library;

import 'package:equatable/equatable.dart';

enum AssessmentType { ados1, ados2, cars, mChat, aapep, other }

class AutismAssessmentModel extends Equatable {
  const AutismAssessmentModel({
    required this.id,
    required this.patientId,
    required this.therapistId,
    required this.assessmentType,
    required this.score,
    required this.assessedAt,
    this.notes,
  });

  /// Create from JSON.
  factory AutismAssessmentModel.fromJson(Map<String, dynamic> json) =>
      AutismAssessmentModel(
        id: json['id'] as String,
        patientId: json['patientId'] as String,
        therapistId: json['therapistId'] as String,
        assessmentType: AssessmentType.values.byName(
          json['assessmentType'] as String,
        ),
        score: json['score'] as Map<String, dynamic>? ?? {},
        notes: json['notes'] as String?,
        assessedAt: DateTime.parse(json['assessedAt'] as String),
      );
  final String id;
  final String patientId;
  final String therapistId;
  final AssessmentType assessmentType;
  final Map<String, dynamic> score; // Contains individual domain scores
  final String? notes;
  final DateTime assessedAt;

  /// Create a copy with optional field overrides.
  AutismAssessmentModel copyWith({
    String? id,
    String? patientId,
    String? therapistId,
    AssessmentType? assessmentType,
    Map<String, dynamic>? score,
    String? notes,
    DateTime? assessedAt,
  }) =>
      AutismAssessmentModel(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        therapistId: therapistId ?? this.therapistId,
        assessmentType: assessmentType ?? this.assessmentType,
        score: score ?? this.score,
        notes: notes ?? this.notes,
        assessedAt: assessedAt ?? this.assessedAt,
      );

  /// Get assessment type name.
  String getAssessmentTypeName() {
    switch (assessmentType) {
      case AssessmentType.ados1:
        return 'ADOS-1';
      case AssessmentType.ados2:
        return 'ADOS-2';
      case AssessmentType.cars:
        return 'CARS';
      case AssessmentType.mChat:
        return 'M-CHAT';
      case AssessmentType.aapep:
        return 'AAPEP';
      case AssessmentType.other:
        return 'Other';
    }
  }

  /// Calculate total score from all domains.
  double getTotalScore() {
    double total = 0;
    score.forEach((key, value) {
      if (value is num) {
        total += value.toDouble();
      }
    });
    return total;
  }

  /// Get severity level based on total score.
  /// Returns: 'Minimal', 'Mild', 'Moderate', 'Severe'
  String getSeverityLevel() {
    final total = getTotalScore();

    // ADOS-2 severity ranges (example thresholds)
    if (total <= 6) return 'Minimal';
    if (total <= 12) return 'Mild';
    if (total <= 18) return 'Moderate';
    return 'Severe';
  }

  /// Get individual domain score.
  dynamic getScoreForDomain(String domain) => score[domain];

  /// Get all domain names.
  List<String> getDomainNames() => score.keys.toList();

  /// Get score breakdown as formatted string.
  String getScoreBreakdown() {
    final buffer = StringBuffer();
    score.forEach((domain, value) {
      buffer.writeln('$domain: $value');
    });
    return buffer.toString();
  }

  /// Check if assessment is recent (within last 3 months).
  bool get isRecent {
    final diff = DateTime.now().difference(assessedAt);
    return diff.inDays <= 90;
  }

  /// Days since assessment.
  int get daysSinceAssessment => DateTime.now().difference(assessedAt).inDays;

  /// Check if assessment needs follow-up (older than 6 months).
  bool get needsFollowUp {
    final diff = DateTime.now().difference(assessedAt);
    return diff.inDays > 180;
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'therapistId': therapistId,
        'assessmentType': assessmentType.toString().split('.').last,
        'score': score,
        'notes': notes,
        'assessedAt': assessedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        patientId,
        therapistId,
        assessmentType,
        score,
        notes,
        assessedAt,
      ];
}

