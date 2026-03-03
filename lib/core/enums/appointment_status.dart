/// Appointment status and type enums.
///
/// Values match the PostgreSQL enums in Supabase.
library;

// ── Appointment Status ─────────────────────────────────────
enum AppointmentStatus {
  pending('pending', 'قيد الانتظار', 'Pending'),
  confirmed('confirmed', 'مؤكد', 'Confirmed'),
  cancelled('cancelled', 'ملغى', 'Cancelled'),
  completed('completed', 'مكتمل', 'Completed'),
  noShow('no_show', 'لم يحضر', 'No Show');

  const AppointmentStatus(this.dbValue, this.labelAr, this.labelEn);

  final String dbValue;
  final String labelAr;
  final String labelEn;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  static AppointmentStatus fromDbValue(String value) {
    return AppointmentStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () =>
          throw ArgumentError('Unknown AppointmentStatus: $value'),
    );
  }

  /// Whether the appointment can still be modified.
  bool get isEditable => this == pending || this == confirmed;

  /// Whether the appointment is in a terminal state.
  bool get isTerminal =>
      this == cancelled || this == completed || this == noShow;
}

// ── Appointment Type ───────────────────────────────────────
enum AppointmentType {
  inPerson('in_person', 'حضوري', 'In Person'),
  remote('remote', 'عن بعد', 'Remote');

  const AppointmentType(this.dbValue, this.labelAr, this.labelEn);

  final String dbValue;
  final String labelAr;
  final String labelEn;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  static AppointmentType fromDbValue(String value) {
    return AppointmentType.values.firstWhere(
      (t) => t.dbValue == value,
      orElse: () => throw ArgumentError('Unknown AppointmentType: $value'),
    );
  }
}

// ── Remote Request Status ──────────────────────────────────
enum RemoteRequestStatus {
  none('none', 'لا يوجد', 'None'),
  pending('pending', 'قيد المراجعة', 'Pending'),
  accepted('accepted', 'مقبول', 'Accepted'),
  rejected('rejected', 'مرفوض', 'Rejected');

  const RemoteRequestStatus(this.dbValue, this.labelAr, this.labelEn);

  final String dbValue;
  final String labelAr;
  final String labelEn;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  static RemoteRequestStatus fromDbValue(String value) {
    return RemoteRequestStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () =>
          throw ArgumentError('Unknown RemoteRequestStatus: $value'),
    );
  }
}

// ── Video Session Status ───────────────────────────────────
enum VideoSessionStatus {
  scheduled('scheduled', 'مجدول', 'Scheduled'),
  active('active', 'نشط', 'Active'),
  completed('completed', 'مكتمل', 'Completed'),
  cancelled('cancelled', 'ملغى', 'Cancelled');

  const VideoSessionStatus(this.dbValue, this.labelAr, this.labelEn);

  final String dbValue;
  final String labelAr;
  final String labelEn;

  String label(String locale) => locale == 'ar' ? labelAr : labelEn;

  static VideoSessionStatus fromDbValue(String value) {
    return VideoSessionStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () =>
          throw ArgumentError('Unknown VideoSessionStatus: $value'),
    );
  }
}
