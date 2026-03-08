/// Safe Extensions للتعامل الآمن مع البيانات في مشروع MCS
///
/// هذا الملف يحتوي على extension methods للتعامل الآمن مع:
/// - النصوص (String)
/// - التواريخ (DateTime)
/// - القوائم (List)
/// - الألوان (Color)
library;

import 'package:flutter/material.dart';

// ═════════════════════════════════════════════════════════════════════════════
// SafeString Extension
// ═════════════════════════════════════════════════════════════════════════════

extension SafeString on String? {
  /// الحصول على الحرف الأول بأمان
  /// إذا كان النص null أو فارغ، يعيد 'U'
  String get firstCharSafe {
    if (this == null || this!.isEmpty) return 'U';
    return this![0].toUpperCase();
  }

  /// الحصول على أول حرفين بأمان
  /// إذا كان النص null أو فارغ، يعيد 'UN'
  String get initialsSafe {
    if (this == null || this!.isEmpty) return 'UN';
    final parts = this!.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// التحقق من أن النص ليس null أو فارغ
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// إرجاع النص أو قيمة افتراضية
  String orDefault(String defaultValue) {
    return isNotNullOrEmpty ? this! : defaultValue;
  }

  /// تقليم النص بأمان
  String get trimSafe => this?.trim() ?? '';

  /// تحويل النص إلى int بأمان
  int? toIntSafe() {
    if (this == null || this!.isEmpty) return null;
    return int.tryParse(this!);
  }

  /// تحويل النص إلى double بأمان
  double? toDoubleSafe() {
    if (this == null || this!.isEmpty) return null;
    return double.tryParse(this!);
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SafeDateTime Extension
// ═════════════════════════════════════════════════════════════════════════════

extension SafeDateTime on DateTime? {
  /// التحقق من أن التاريخ ليس null
  bool get isNotNull => this != null;

  /// التحقق من أن التاريخ في الماضي
  bool get isPast {
    if (this == null) return false;
    return this!.isBefore(DateTime.now());
  }

  /// التحقق من أن التاريخ في المستقبل
  bool get isFuture {
    if (this == null) return false;
    return this!.isAfter(DateTime.now());
  }

  /// التحقق من أن التاريخ هو اليوم
  bool get isToday {
    if (this == null) return false;
    final now = DateTime.now();
    return this!.year == now.year &&
        this!.month == now.month &&
        this!.day == now.day;
  }

  /// الحصول على الساعة بأمان
  int get hourSafe => this?.hour ?? 0;

  /// الحصول على الدقيقة بأمان
  int get minuteSafe => this?.minute ?? 0;

  /// تنسيق التاريخ كـ DD/MM/YYYY
  String get formatDMY {
    if (this == null) return 'N/A';
    return '${this!.day}/${this!.month}/${this!.year}';
  }

  /// تنسيق التاريخ كـ HH:MM
  String get formatHM {
    if (this == null) return 'N/A';
    return '${this!.hour.toString().padLeft(2, '0')}:${this!.minute.toString().padLeft(2, '0')}';
  }

  /// تنسيق التاريخ كـ DD/MM/YYYY HH:MM
  String get formatFull {
    if (this == null) return 'N/A';
    return '$formatDMY $formatHM';
  }

  /// حساب الفرق بالأيام من الآن
  int get daysFromNow {
    if (this == null) return 0;
    return this!.difference(DateTime.now()).inDays;
  }

  /// حساب الفرق بالساعات من الآن
  int get hoursFromNow {
    if (this == null) return 0;
    return this!.difference(DateTime.now()).inHours;
  }

  /// حساب الفرق بالدقائق من الآن
  int get minutesFromNow {
    if (this == null) return 0;
    return this!.difference(DateTime.now()).inMinutes;
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SafeList Extension
// ═════════════════════════════════════════════════════════════════════════════

extension SafeList<T> on List<T>? {
  /// التحقق من أن القائمة ليست null أو فارغة
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// إرجاع القائمة أو قائمة فارغة
  List<T> orEmpty() => this ?? [];

  /// الحصول على العنصر الأول بأمان
  T? get firstSafe {
    if (this == null || this!.isEmpty) return null;
    return this!.first;
  }

  /// الحصول على العنصر الأخير بأمان
  T? get lastSafe {
    if (this == null || this!.isEmpty) return null;
    return this!.last;
  }

  /// الحصول على عنصر في فهرس معين بأمان
  T? atSafe(int index) {
    if (this == null || index < 0 || index >= this!.length) return null;
    return this![index];
  }

  /// الحصول على عدد العناصر بأمان
  int get lengthSafe => this?.length ?? 0;
}

// ═════════════════════════════════════════════════════════════════════════════
// SafeColor Extension
// ═════════════════════════════════════════════════════════════════════════════

extension SafeColor on Color {
  /// إنشاء لون بشفافية باستخدام withValues (بديل withOpacity)
  Color withAlphaSafe(double alpha) {
    return withValues(alpha: alpha.clamp(0.0, 1.0));
  }

  /// إنشاء لون بشفافية 10%
  Color withAlpha10() => withAlphaSafe(0.1);

  /// إنشاء لون بشفافية 20%
  Color withAlpha20() => withAlphaSafe(0.2);

  /// إنشاء لون بشفافية 30%
  Color withAlpha30() => withAlphaSafe(0.3);

  /// إنشاء لون بشفافية 50%
  Color withAlpha50() => withAlphaSafe(0.5);

  /// إنشاء لون بشفافية 70%
  Color withAlpha70() => withAlphaSafe(0.7);
}

// ═════════════════════════════════════════════════════════════════════════════
// SafeNum Extension
// ═════════════════════════════════════════════════════════════════════════════

extension SafeNum on num? {
  /// التحقق من أن الرقم ليس null
  bool get isNotNull => this != null;

  /// إرجاع الرقم أو قيمة افتراضية
  num orDefault(num defaultValue) => this ?? defaultValue;

  /// تحويل إلى int بأمان
  int toIntSafe() => this?.toInt() ?? 0;

  /// تحويل إلى double بأمان
  double toDoubleSafe() => this?.toDouble() ?? 0.0;

  /// تنسيق الرقم
  String toStringSafe() => this?.toString() ?? '0';
}

// ═════════════════════════════════════════════════════════════════════════════
// SafeBool Extension
// ═════════════════════════════════════════════════════════════════════════════

extension SafeBool on bool? {
  /// التحقق من أن القيمة true
  bool get isTrue => this ?? false;

  /// التحقق من أن القيمة false
  bool get isFalse => this == false;

  /// إرجاع القيمة أو false
  bool orDefault(bool defaultValue) => this ?? defaultValue;
}
