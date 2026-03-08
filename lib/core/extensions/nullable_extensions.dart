/// Safe Nullable Extensions
library;

extension NullableExtension<T> on T? {
  R? let<R>(R Function(T) block) {
    if (this == null) return null;
    return block(this as T);
  }

  R map<R>(R Function(T) block, {required R orElse}) {
    if (this == null) return orElse;
    return block(this as T);
  }

  bool exists(bool Function(T) predicate) {
    if (this == null) return false;
    return predicate(this as T);
  }

  void ifNotNull(void Function(T) action) {
    if (this != null) {
      action(this as T);
    }
  }

  T orDefault(T defaultValue) {
    return this ?? defaultValue;
  }
}

extension NullableListExtension<T> on List<T>? {
  T? safeElementAt(int index) {
    if (this == null) return null;
    if (index < 0 || index >= this!.length) return null;
    return this![index];
  }

  bool safeContains(T element) {
    if (this == null) return false;
    return this!.contains(element);
  }

  int get safeLength => this?.length ?? 0;
}

extension NullableStringExtension on String? {
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  String get safeTrim => this?.trim() ?? '';
  int get safeLength => this?.length ?? 0;
}