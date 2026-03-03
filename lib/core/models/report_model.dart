/// Medical report model for doctor-generated patient reports.
library;

import 'package:equatable/equatable.dart';

class ReportModel extends Equatable {
  const ReportModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.title,
    required this.content,
    this.fileUrl,
    required this.createdAt,
  });

  /// Create from JSON.
  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json['id'] as String,
        doctorId: json['doctorId'] as String,
        patientId: json['patientId'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        fileUrl: json['fileUrl'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
  final String id;
  final String doctorId;
  final String patientId;
  final String title;
  final String content;
  final String? fileUrl;
  final DateTime createdAt;

  /// Create a copy with optional field overrides.
  ReportModel copyWith({
    String? id,
    String? doctorId,
    String? patientId,
    String? title,
    String? content,
    String? fileUrl,
    DateTime? createdAt,
  }) =>
      ReportModel(
        id: id ?? this.id,
        doctorId: doctorId ?? this.doctorId,
        patientId: patientId ?? this.patientId,
        title: title ?? this.title,
        content: content ?? this.content,
        fileUrl: fileUrl ?? this.fileUrl,
        createdAt: createdAt ?? this.createdAt,
      );

  /// Get first 100 characters of content as summary.
  String getSummary({int maxChars = 100}) {
    if (content.length <= maxChars) return content;
    return '${content.substring(0, maxChars)}...';
  }

  /// Check if report has an attached file.
  bool get hasFile => fileUrl != null && fileUrl!.isNotEmpty;

  /// Get file extension if file exists.
  String? getFileExtension() {
    if (!hasFile) return null;
    try {
      final uri = Uri.parse(fileUrl!);
      final path = uri.path;
      final lastDot = path.lastIndexOf('.');
      if (lastDot == -1) return null;
      return path.substring(lastDot + 1).toLowerCase();
    } catch (_) {
      return null;
    }
  }

  /// Check if attached file is a PDF.
  bool get isPDF {
    final ext = getFileExtension();
    return ext == 'pdf';
  }

  /// Get file name from URL.
  String? getFileName() {
    if (!hasFile) return null;
    try {
      final uri = Uri.parse(fileUrl!);
      final pathSegments = uri.pathSegments;
      return pathSegments.isNotEmpty ? pathSegments.last : null;
    } catch (_) {
      return null;
    }
  }

  /// Check if report is recent (created within last 7 days).
  bool get isRecent {
    final diff = DateTime.now().difference(createdAt);
    return diff.inDays <= 7;
  }

  /// Days since report creation.
  int get daysSinceCreation => DateTime.now().difference(createdAt).inDays;

  /// Get content length in characters.
  int get contentLength => content.length;

  /// Get content length in words (approximate).
  int get wordCount => content.split(RegExp(r'\s+')).length;

  /// Check if report has meaningful content (not empty or whitespace).
  bool get hasContent => content.trim().isNotEmpty;

  /// Get formatted creation date string.
  String getFormattedDate({String locale = 'en'}) {
    if (locale.toLowerCase() == 'ar') {
      return _formatDateAr(createdAt);
    }
    return _formatDateEn(createdAt);
  }

  /// Format date in English.
  static String _formatDateEn(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Format date in Arabic.
  static String _formatDateAr(DateTime date) {
    final monthsAr = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${monthsAr[date.month - 1]} ${date.year}';
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'patientId': patientId,
        'title': title,
        'content': content,
        'fileUrl': fileUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        doctorId,
        patientId,
        title,
        content,
        fileUrl,
        createdAt,
      ];
}
