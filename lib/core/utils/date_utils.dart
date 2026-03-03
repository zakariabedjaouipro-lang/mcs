/// Date / time arithmetic and comparison helpers.
///
/// Named [AppDateUtils] to avoid collision with Flutter's DateUtils.
library;

abstract class AppDateUtils {
  // ── Difference ───────────────────────────────────────────

  /// Full-year difference between [from] and [to].
  static int yearsBetween(DateTime from, DateTime to) {
    var years = to.year - from.year;
    if (to.month < from.month ||
        (to.month == from.month && to.day < from.day)) {
      years--;
    }
    return years;
  }

  /// Number of calendar days between two dates (ignoring time).
  static int daysBetween(DateTime from, DateTime to) {
    final a = DateTime(from.year, from.month, from.day);
    final b = DateTime(to.year, to.month, to.day);
    return b.difference(a).inDays;
  }

  // ── Add / Subtract ───────────────────────────────────────

  static DateTime addDays(DateTime dt, int days) =>
      dt.add(Duration(days: days));

  static DateTime subtractDays(DateTime dt, int days) =>
      dt.subtract(Duration(days: days));

  static DateTime addMonths(DateTime dt, int months) {
    var m = dt.month + months;
    final y = dt.year + (m - 1) ~/ 12;
    m = ((m - 1) % 12) + 1;
    final maxDay = DateTime(y, m + 1, 0).day;
    final d = dt.day > maxDay ? maxDay : dt.day;
    return DateTime(y, m, d, dt.hour, dt.minute, dt.second);
  }

  static DateTime addYears(DateTime dt, int years) => addMonths(dt, years * 12);

  // ── Checks ───────────────────────────────────────────────

  static bool isPast(DateTime dt) => dt.isBefore(DateTime.now());
  static bool isFuture(DateTime dt) => dt.isAfter(DateTime.now());

  static bool isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  static bool isTomorrow(DateTime dt) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dt.year == tomorrow.year &&
        dt.month == tomorrow.month &&
        dt.day == tomorrow.day;
  }

  static bool isYesterday(DateTime dt) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dt.year == yesterday.year &&
        dt.month == yesterday.month &&
        dt.day == yesterday.day;
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ── Subscription Helpers ─────────────────────────────────

  /// Days remaining until [endDate]. Returns 0 if already past.
  static int remainingDays(DateTime endDate) {
    final days = daysBetween(DateTime.now(), endDate);
    return days > 0 ? days : 0;
  }

  /// Whether [endDate] is within [days] from now.
  static bool isWithinDays(DateTime endDate, int days) =>
      remainingDays(endDate) <= days && isFuture(endDate);

  // ── Start / End of Day ───────────────────────────────────

  static DateTime startOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static DateTime endOfDay(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day, 23, 59, 59);
}
