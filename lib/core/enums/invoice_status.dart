/// Invoice, lab result, and bug report status enums.
///
/// Values match the PostgreSQL enums in Supabase.
library;

// ── Invoice Status ─────────────────────────────────────────
enum InvoiceStatus {
  draft('draft', 'مسودة', 'Draft'),
  sent('sent', 'مُرسلة', 'Sent'),
  paid('paid', 'مدفوعة', 'Paid'),
  overdue('overdue', 'متأخرة', 'Overdue'),
  cancelled('cancelled', 'ملغاة', 'Cancelled');

  const InvoiceStatus(this.dbValue, this.labelAr, this.labelEn);

  final String dbValue;
  final String labelAr;
  final String labelEn;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  static InvoiceStatus fromDbValue(String value) {
    return InvoiceStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () => throw ArgumentError('Unknown InvoiceStatus: $value'),
    );
  }

  bool get isPending => this == draft || this == sent || this == overdue;
  bool get isTerminal => this == paid || this == cancelled;
}

// ── Lab Result Type ────────────────────────────────────────
enum LabResultType {
  bloodTest('blood_test', 'تحليل دم', 'Blood Test'),
  xray('xray', 'أشعة سينية', 'X-Ray'),
  mri('mri', 'رنين مغناطيسي', 'MRI'),
  ctScan('ct_scan', 'أشعة مقطعية', 'CT Scan'),
  ultrasound('ultrasound', 'موجات فوق صوتية', 'Ultrasound'),
  other('other', 'أخرى', 'Other');

  const LabResultType(this.dbValue, this.labelAr, this.labelEn);

  final String dbValue;
  final String labelAr;
  final String labelEn;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  static LabResultType fromDbValue(String value) {
    return LabResultType.values.firstWhere(
      (t) => t.dbValue == value,
      orElse: () => throw ArgumentError('Unknown LabResultType: $value'),
    );
  }
}

// ── Bug Report Status ──────────────────────────────────────
enum BugReportStatus {
  newReport('new', 'جديد', 'New'),
  inProgress('in_progress', 'قيد المعالجة', 'In Progress'),
  resolved('resolved', 'تم الحل', 'Resolved');

  const BugReportStatus(this.dbValue, this.labelAr, this.labelEn);

  final String dbValue;
  final String labelAr;
  final String labelEn;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  static BugReportStatus fromDbValue(String value) {
    return BugReportStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () => throw ArgumentError('Unknown BugReportStatus: $value'),
    );
  }
}
