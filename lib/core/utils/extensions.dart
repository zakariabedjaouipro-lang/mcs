/// Dart/Flutter extension methods for common types.
library;

import 'package:flutter/material.dart';

// ── String Extensions ────────────────────────────────────────

extension StringExtensions on String {
  /// Remove all whitespace from the string.
  String removeWhitespace() => replaceAll(RegExp(r'\s+'), '');

  /// Capitalize the first letter only.
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Convert to title case (capitalize each word).
  String toTitleCase() => split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  /// Remove leading and trailing whitespace, and condense internal whitespace.
  String normalizeWhitespace() => trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Check if string is a valid email (simplified check).
  bool isValidEmail() => contains('@') && contains('.');

  /// Check if string is a valid phone number (basic check).
  bool isValidPhone() => replaceAll(RegExp(r'[\s\-()]'), '').length >= 8;

  /// Check if string contains only digits.
  bool isNumeric() => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Check if string contains only letters.
  bool isAlpha() => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string is alphanumeric.
  bool isAlphaNumeric() => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Truncate string to [maxLength] and add ellipsis if needed.
  String truncate(int maxLength, {String ellipsis = '...'}) =>
      length > maxLength
          ? '${substring(0, maxLength - ellipsis.length)}$ellipsis'
          : this;

  /// Reverse the string.
  String reverse() => split('').reversed.join();

  /// Check if string is palindrome.
  bool isPalindrome() =>
      normalizeWhitespace().toLowerCase() ==
      normalizeWhitespace().toLowerCase().reverse();

  /// Extract digits only from string.
  String onlyDigits() => replaceAll(RegExp('[^0-9]'), '');

  /// Extract letters only from string.
  String onlyLetters() => replaceAll(RegExp('[^a-zA-Z]'), '');
}

// ── Int Extensions ──────────────────────────────────────────

extension IntExtensions on int {
  /// Convert to duration in milliseconds.
  Duration get millis => Duration(milliseconds: this);

  /// Convert to duration in seconds.
  Duration get seconds => Duration(seconds: this);

  /// Convert to duration in minutes.
  Duration get minutes => Duration(minutes: this);

  /// Convert to duration in hours.
  Duration get hours => Duration(hours: this);

  /// Convert to duration in days.
  Duration get days => Duration(days: this);

  /// Check if number is even.
  bool get isEven => (this & 1) == 0;

  /// Check if number is odd.
  bool get isOdd => !isEven;

  /// Check if number is positive.
  bool get isPositive => this > 0;

  /// Check if number is negative.
  bool get isNegative => this < 0;

  /// Check if number is zero.
  bool get isZero => this == 0;

  /// Get absolute value.
  int get abs => this.abs();

  /// Get the divisors of this number.
  List<int> get divisors {
    final result = <int>[];
    for (var i = 1; i <= this; i++) {
      if (this % i == 0) result.add(i);
    }
    return result;
  }

  /// Check if number is prime.
  bool get isPrime {
    if (this < 2) return false;
    if (this == 2) return true;
    if (isEven) return false;
    for (var i = 3; i * i <= this; i += 2) {
      if (this % i == 0) return false;
    }
    return true;
  }
}

// ── Double Extensions ────────────────────────────────────────

extension DoubleExtensions on double {
  /// Round to [places] decimal places.
  double roundToPlaces(int places) {
    final mod = 10.0 * places;
    return (this * mod).round() / mod;
  }

  /// Check if value is positive.
  bool get isPositive => this > 0;

  /// Check if value is negative.
  bool get isNegative => this < 0;

  /// Check if value is zero.
  bool get isZero => this == 0;

  /// Get absolute value.
  double get abs => this.abs();

  /// Clamp value between [min] and [max].
  double clamp(double min, double max) =>
      this < min ? min : (this > max ? max : this);
}

// ── DateTime Extensions ──────────────────────────────────────

extension DateTimeExtensions on DateTime {
  /// Create a copy with modified components.
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
      );

  /// Get start of day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Get first day of month.
  DateTime get firstDayOfMonth => DateTime(year, month);

  /// Get last day of month.
  DateTime get lastDayOfMonth => DateTime(year, month + 1, 0);

  /// Check if date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future.
  bool get isFuture => isAfter(DateTime.now());

  /// Get age in years.
  int get age {
    final today = DateTime.now();
    var years = today.year - year;
    if (today.month < month || (today.month == month && today.day < day)) {
      years--;
    }
    return years;
  }

  /// Check if date is weekend.
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Check if date is weekday.
  bool get isWeekday => !isWeekend;

  /// Get week number of year.
  int get weekNumber {
    final jan4 = DateTime(year, 1, 4);
    final sunday = jan4.subtract(Duration(days: jan4.weekday - 1));
    final dayDiff = difference(sunday).inDays;
    return (dayDiff / 7).ceil();
  }
}

// ── Duration Extensions ──────────────────────────────────────

extension DurationExtensions on Duration {
  /// Convert to a human-readable string.
  /// e.g. "2h 30m 45s"
  String get humanReadable {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    final parts = <String>[];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0) parts.add('${seconds}s');

    return parts.isEmpty ? '0s' : parts.join(' ');
  }

  /// Get total days (including fractional).
  double get inDaysDouble => inHours / 24;

  /// Get total hours (including fractional).
  double get inHoursDouble => inMinutes / 60;

  /// Get total minutes (including fractional).
  double get inMinutesDouble => inSeconds / 60;
}

// ── List Extensions ─────────────────────────────────────────

extension ListExtensions<T> on List<T> {
  /// Get a random element from the list.
  T? get random => isEmpty ? null : this[(DateTime.now().microsecond) % length];

  /// Chunk list into sublists of [size].
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }

  /// Check if list contains any element that matches the [test].
  bool anyMatch(bool Function(T) test) => any(test);

  /// Check if all elements match the [test].
  bool allMatch(bool Function(T) test) => every(test);

  /// Get first element or null.
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null.
  T? get lastOrNull => isEmpty ? null : last;

  /// Flatten nested lists (one level).
  List<T> flatten() {
    final result = <T>[];
    for (final item in this) {
      if (item is List) {
        result.addAll(item.cast<T>());
      } else {
        result.add(item);
      }
    }
    return result;
  }

  /// Remove duplicates while preserving order.
  List<T> unique() {
    final seen = <T>{};
    return where(seen.add).toList();
  }

  /// Reverse the order of elements.
  List<T> reversed() => [...this].reversed.toList();
}

// ── Map Extensions ──────────────────────────────────────────

extension MapExtensions<K, V> on Map<K, V> {
  /// Check if map contains a given key.
  bool containsKeyIgnoreCase(String key) =>
      keys.any((k) => k.toString().toLowerCase() == key.toLowerCase());

  /// Get value by key or return [defaultValue].
  V? getOrDefault(K key, [V? defaultValue]) =>
      containsKey(key) ? this[key] : defaultValue;

  /// Invert keys and values (V must be comparable).
  Map<V, K> invert() => {for (final entry in entries) entry.value: entry.key};

  /// Filter map by a predicate.
  Map<K, V> filter(bool Function(K, V) test) {
    final result = <K, V>{};
    forEach((k, v) {
      if (test(k, v)) result[k] = v;
    });
    return result;
  }

  /// Transform all values.
  Map<K, V2> mapValues<V2>(V2 Function(V) transform) {
    final result = <K, V2>{};
    forEach((k, v) {
      result[k] = transform(v);
    });
    return result;
  }
}

// ── BuildContext Extensions (Flutter-specific) ──────────────

extension BuildContextExtensions on BuildContext {
  /// Get screen width.
  double get width => MediaQuery.of(this).size.width;

  /// Get screen height.
  double get height => MediaQuery.of(this).size.height;

  /// Get screen size.
  Size get screenSize => MediaQuery.of(this).size;

  /// Check if device is in landscape.
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if device is in portrait.
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Check if device is small (mobile).
  bool get isSmall => width < 600;

  /// Check if device is medium (tablet).
  bool get isMedium => width >= 600 && width < 900;

  /// Check if device is large (tablet/desktop).
  bool get isLarge => width >= 900;

  /// Get device padding (safe area).
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Get device view insets (keyboard, notches, etc).
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Get text scale factor.
  double get textScaleFactor => MediaQuery.of(this).textScaler.scale(1);

  /// Get brightness (dark/light).
  Brightness get brightness => MediaQuery.of(this).platformBrightness;

  /// Check if in dark mode.
  bool get isDarkMode => brightness == Brightness.dark;

  /// Push named route.
  Future<T?> toNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);

  /// Pop route.
  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);

  /// Show snackbar.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) =>
      ScaffoldMessenger.of(
        this,
      ).showSnackBar(SnackBar(content: Text(message), duration: duration));

  /// Show error snackbar.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: duration,
        ),
      );

  /// Show success snackbar.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: duration,
        ),
      );
}

// ── Widget Extensions (Flutter-specific) ─────────────────────

extension WidgetExtensions on Widget {
  /// Add padding around widget.
  Widget withPadding(EdgeInsets padding) =>
      Padding(padding: padding, child: this);

  /// Add symmetric padding.
  Widget withSymmetricPadding({double horizontal = 0, double vertical = 0}) =>
      withPadding(
        EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      );

  /// Add center wrapper.
  Widget centered() => Center(child: this);

  /// Add expanded wrapper.
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Add opacity wrapper.
  Widget withOpacity(double opacity) => Opacity(opacity: opacity, child: this);

  /// Add gesture detector for tap.
  Widget onTap(VoidCallback onTap) =>
      GestureDetector(onTap: onTap, child: this);

  /// Add gesture detector for long press.
  Widget onLongPress(VoidCallback onLongPress) =>
      GestureDetector(onLongPress: onLongPress, child: this);

  /// Add hero animation wrapper.
  Widget withHero(Object tag) => Hero(tag: tag, child: this);

  /// Add visibility wrapper.
  Widget withVisibility({
    required bool visible,
    Widget replacement = const SizedBox.shrink(),
  }) =>
      Visibility(visible: visible, replacement: replacement, child: this);

  /// Add layout builder wrapper.
  Widget withLayoutBuilder(
    Widget Function(BuildContext, BoxConstraints) builder,
  ) =>
      LayoutBuilder(builder: builder);
}
