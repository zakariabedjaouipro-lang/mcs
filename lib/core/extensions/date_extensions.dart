/// Safe DateTime Extensions
library;

extension SafeDateTime on DateTime? {
  int get safeHour => this?.hour ?? 0;
  int get safeMinute => this?.minute ?? 0;
  int get safeDay => this?.day ?? 1;
  int get safeMonth => this?.month ?? 1;
  int get safeYear => this?.year ?? 2024;

  bool safeIsAfter(DateTime other) {
    if (this == null) return false;
    return this!.isAfter(other);
  }

  bool safeIsBefore(DateTime other) {
    if (this == null) return false;
    return this!.isBefore(other);
  }

  Duration? safeDifference(DateTime other) {
    if (this == null) return null;
    return this!.difference(other);
  }

  String formatTimeSafe({String defaultValue = '--:--'}) {
    if (this == null) return defaultValue;
    return '${this!.hour.toString().padLeft(2, '0')}:${this!.minute.toString().padLeft(2, '0')}';
  }

  String formatDateSafe({String defaultValue = '--/--/----', String separator = '/'}) {
    if (this == null) return defaultValue;
    return '${this!.day}$separator${this!.month}$separator${this!.year}';
  }
}