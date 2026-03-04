/// Form-field validation helpers.
///
/// Each function returns `null` on success or an error message string.
library;

import 'package:mcs/core/constants/app_constants.dart';

abstract class Validators {
  // ── Required ─────────────────────────────────────────────

  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // ── Email ────────────────────────────────────────────────

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(value.trim())) return 'Invalid email address';
    return null;
  }

  // ── Phone ────────────────────────────────────────────────

  static final _phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!_phoneRegex.hasMatch(cleaned)) return 'Invalid phone number';
    return null;
  }

  // ── Password ─────────────────────────────────────────────

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be at most ${AppConstants.maxPasswordLength} characters';
    }
    if (!value.contains(RegExp('[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp('[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp('[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Validates that [confirm] matches [password].
  static String? confirmPassword(String? confirm, String password) {
    if (confirm == null || confirm.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirm != password) return 'Passwords do not match';
    return null;
  }

  // ── Name ─────────────────────────────────────────────────

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    if (value.trim().length > 100) return 'Name is too long';
    return null;
  }

  // ── OTP ──────────────────────────────────────────────────

  static String? otp(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    return null;
  }

  // ── Numeric ──────────────────────────────────────────────

  static String? positiveNumber(String? value, [String fieldName = 'Value']) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    final number = num.tryParse(value);
    if (number == null) return '$fieldName must be a number';
    if (number <= 0) return '$fieldName must be greater than 0';
    return null;
  }

  // ── URL ──────────────────────────────────────────────────

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return 'Invalid URL';
    return null;
  }

  // ── Min / Max Length ─────────────────────────────────────

  static String? minLength(
    String? value,
    int min, [
    String fieldName = 'Field',
  ]) {
    if (value == null || value.length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  static String? maxLength(
    String? value,
    int max, [
    String fieldName = 'Field',
  ]) {
    if (value != null && value.length > max) {
      return '$fieldName must be at most $max characters';
    }
    return null;
  }

  // ── Convenience Methods ──────────────────────────────────

  /// Returns true if email is valid.
  static bool isValidEmail(String? value) => email(value) == null;

  /// Returns true if phone number is valid.
  static bool isValidPhoneNumber(String? value) => phone(value) == null;
}
