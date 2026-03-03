/// SMS / OTP service.
///
/// Delegates OTP delivery to a Supabase Edge Function
/// (`send-otp`) and verification to Supabase Auth.
library;

import 'dart:developer';

import 'package:mcs/core/constants/app_constants.dart';
import 'package:mcs/core/constants/db_constants.dart';
import 'package:mcs/core/errors/exceptions.dart';
import 'package:mcs/core/services/supabase_service.dart';

class SmsService {
  SmsService({required SupabaseService supabaseService})
      : _supabase = supabaseService;

  final SupabaseService _supabase;

  // ── Send OTP ─────────────────────────────────────────────

  /// Requests the backend to send an OTP to [phone].
  ///
  /// Returns `true` on success.
  Future<bool> sendOtp({required String phone}) async {
    try {
      await _supabase.rpc(
        DbFunctions.sendOtp,
        params: {'phone_number': phone},
      );
      log('OTP sent to $phone', name: 'SmsService');
      return true;
    } catch (e, st) {
      log(
        'Failed to send OTP: $e',
        name: 'SmsService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  // ── Verify OTP ───────────────────────────────────────────

  /// Verifies the [code] entered by the user for the given [phone].
  ///
  /// Returns `true` when verification succeeds.
  Future<bool> verifyOtp({
    required String phone,
    required String code,
  }) async {
    if (code.length != AppConstants.otpLength) {
      throw const ValidationException(
        message: 'OTP must be ${AppConstants.otpLength} digits',
      );
    }

    try {
      final result = await _supabase.rpc(
        DbFunctions.verifyOtp,
        params: {
          'phone_number': phone,
          'otp_code': code,
        },
      );
      final success = result == true || result == 'true';
      log(
        'OTP verification for $phone: ${success ? 'success' : 'failed'}',
        name: 'SmsService',
      );
      return success;
    } catch (e, st) {
      log(
        'OTP verification error: $e',
        name: 'SmsService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  // ── Resend OTP ───────────────────────────────────────────

  /// Resends the OTP to [phone]. Wrapper around [sendOtp].
  Future<bool> resendOtp({required String phone}) => sendOtp(phone: phone);
}
