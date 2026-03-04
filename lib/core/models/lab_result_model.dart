/// Lab result model for patient test results and diagnostics.
library;

import 'package:equatable/equatable.dart';

enum LabResultType { bloodTest, xray, mri, ctScan, ultrasound, other }

class LabResultModel extends Equatable {
  const LabResultModel({
    required this.id,
    required this.patientId,
    required this.uploadedBy,
    required this.type,
    required this.title,
    required this.fileUrl,
    required this.createdAt,
    this.notes,
  });

  /// Create from JSON.
  factory LabResultModel.fromJson(Map<String, dynamic> json) => LabResultModel(
        id: json['id'] as String,
        patientId: json['patientId'] as String,
        uploadedBy: json['uploadedBy'] as String,
        type: LabResultType.values.byName(json['type'] as String),
        title: json['title'] as String,
        fileUrl: json['fileUrl'] as String,
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
  final String id;
  final String patientId;
  final String uploadedBy; // Doctor/Technician ID
  final LabResultType type;
  final String title;
  final String fileUrl;
  final String? notes;
  final DateTime createdAt;

  /// Create a copy with optional field overrides.
  LabResultModel copyWith({
    String? id,
    String? patientId,
    String? uploadedBy,
    LabResultType? type,
    String? title,
    String? fileUrl,
    String? notes,
    DateTime? createdAt,
  }) =>
      LabResultModel(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        uploadedBy: uploadedBy ?? this.uploadedBy,
        type: type ?? this.type,
        title: title ?? this.title,
        fileUrl: fileUrl ?? this.fileUrl,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
      );

  /// Get readable lab result type name.
  String getTypeName() {
    switch (type) {
      case LabResultType.bloodTest:
        return 'Blood Test';
      case LabResultType.xray:
        return 'X-Ray';
      case LabResultType.mri:
        return 'MRI';
      case LabResultType.ctScan:
        return 'CT Scan';
      case LabResultType.ultrasound:
        return 'Ultrasound';
      case LabResultType.other:
        return 'Other';
    }
  }

  /// Get file extension from URL.
  String? getFileExtension() {
    try {
      final uri = Uri.parse(fileUrl);
      final path = uri.path;
      final lastDot = path.lastIndexOf('.');
      if (lastDot == -1) return null;
      return path.substring(lastDot + 1).toLowerCase();
    } catch (_) {
      return null;
    }
  }

  /// Check if the file is an image.
  bool get isImage {
    final ext = getFileExtension();
    if (ext == null) return false;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }

  /// Check if the file is a PDF.
  bool get isPDF {
    final ext = getFileExtension();
    return ext == 'pdf';
  }

  /// Check if result is recent (created within last 7 days).
  bool get isRecent {
    final diff = DateTime.now().difference(createdAt);
    return diff.inDays <= 7;
  }

  /// Days since result creation.
  int get daysSinceCreation => DateTime.now().difference(createdAt).inDays;

  /// Get file name from URL.
  String? getFileName() {
    try {
      final uri = Uri.parse(fileUrl);
      final pathSegments = uri.pathSegments;
      return pathSegments.isNotEmpty ? pathSegments.last : null;
    } catch (_) {
      return null;
    }
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'uploadedBy': uploadedBy,
        'type': type.toString().split('.').last,
        'title': title,
        'fileUrl': fileUrl,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        patientId,
        uploadedBy,
        type,
        title,
        fileUrl,
        notes,
        createdAt,
      ];
}
