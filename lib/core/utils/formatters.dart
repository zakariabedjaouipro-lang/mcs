/// Data formatting utilities.
library;

import 'package:intl/intl.dart';

abstract class Formatters {
  // ── Date / Time ──────────────────────────────────────────

  /// e.g. "2026-03-02"
  static String date(DateTime dt) => DateFormat('yyyy-MM-dd').format(dt);

  /// e.g. "02/03/2026"
  static String dateShort(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  /// e.g. "2 مارس 2026" or "March 2, 2026"
  static String dateLong(DateTime dt, {String locale = 'en'}) =>
      DateFormat.yMMMMd(locale).format(dt);

  /// e.g. "14:30" (24h)
  static String time24(DateTime dt) => DateFormat('HH:mm').format(dt);

  /// e.g. "2:30 PM"
  static String time12(DateTime dt) => DateFormat('h:mm a').format(dt);

  /// e.g. "02/03/2026 14:30"
  static String dateTime(DateTime dt) =>
      DateFormat('dd/MM/yyyy HH:mm').format(dt);

  /// e.g. "Monday" or "الاثنين"
  static String dayName(DateTime dt, {String locale = 'en'}) =>
      DateFormat('EEEE', locale).format(dt);

  /// e.g. "Mar 2" or "2 مارس"
  static String monthDay(DateTime dt, {String locale = 'en'}) =>
      DateFormat.MMMd(locale).format(dt);

  // ── Relative Time ────────────────────────────────────────

  /// Returns a human-readable relative time string.
  ///
  /// e.g. "just now", "5 minutes ago", "2 hours ago", "yesterday"
  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  // ── Currency ─────────────────────────────────────────────

  /// Formats [amount] with the given [currency] symbol.
  ///
  /// e.g. `formatCurrency(50, 'USD')` → "50.00 USD"
  static String currency(
    double amount, {
    String currency = 'USD',
    int decimals = 2,
  }) {
    final formatted = amount.toStringAsFixed(decimals);
    return '$formatted $currency';
  }

  /// Formats with a locale-aware number format.
  static String currencyLocale(
    double amount, {
    String locale = 'en',
    String symbol = r'$',
  }) {
    return NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    ).format(amount);
  }

  // ── Phone ────────────────────────────────────────────────

  /// Formats a phone number for display.
  ///
  /// e.g. "+213555123456" → "+213 555 123 456"
  static String phoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.length <= 4) return cleaned;

    // Simple grouping: country code + groups of 3
    final buffer = StringBuffer();
    var i = 0;

    // Keep '+' and country code (up to 3 digits after +)
    if (cleaned.startsWith('+')) {
      final ccEnd = cleaned.length > 4 ? 4 : cleaned.length;
      buffer.write(cleaned.substring(0, ccEnd));
      i = ccEnd;
    }

    while (i < cleaned.length) {
      if (buffer.isNotEmpty) buffer.write(' ');
      final end = (i + 3 > cleaned.length) ? cleaned.length : i + 3;
      buffer.write(cleaned.substring(i, end));
      i = end;
    }
    return buffer.toString();
  }

  // ── File Size ────────────────────────────────────────────

  /// Formats bytes into a human-readable string.
  ///
  /// e.g. 1536 → "1.5 KB"
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  // ── Numbers ──────────────────────────────────────────────

  /// Compact number: 1200 → "1.2K", 1500000 → "1.5M"
  static String compactNumber(num value, {String locale = 'en'}) =>
      NumberFormat.compact(locale: locale).format(value);

  /// Percentage with [decimals] precision.
  static String percentage(double value, {int decimals = 1}) =>
      '${(value * 100).toStringAsFixed(decimals)}%';
}
