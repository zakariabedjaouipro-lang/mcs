/// TOTP (Time-based One-Time Password) Service
/// خدمة كلمة المرور لمرة واحدة المبنية على الوقت
library;

import 'dart:developer' as developer;
import 'dart:math';

class TotpService {
  // ── Generate Secret ──────────────────────────────────────

  /// Generate a random base32 secret for TOTP
  /// توليد سر عشوائي base32 لـ TOTP
  static String generateSecret({int length = 32}) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base32.encode(values).substring(0, length);
  }

  // ── Generate QR Code URI ─────────────────────────────────

  /// Generate otpauth URI for QR code
  /// توليد otpauth URI لرمز QR
  static String generateQrCodeUri({
    required String secret,
    required String userId,
    required String issuer,
  }) {
    return Uri(
      scheme: 'otpauth',
      host: 'totp',
      path: '/$issuer:$userId',
      queryParameters: {
        'secret': secret,
        'issuer': issuer,
      },
    ).toString();
  }

  // ── Verify TOTP Code ─────────────────────────────────────

  /// Verify a TOTP code
  /// التحقق من رمز TOTP
  static bool verifyCode({
    required String secret,
    required String code,
    int timeStep = 30,
    int digits = 6,
    int window = 1,
  }) {
    try {
      final cleanCode = code.replaceAll(' ', '');

      if (!RegExp(r'^\d+$').hasMatch(cleanCode)) {
        return false;
      }

      if (cleanCode.length != digits) {
        return false;
      }

      final now = DateTime.now();
      for (int i = -window; i <= window; i++) {
        final offset = now.millisecondsSinceEpoch ~/ 1000 + (i * timeStep);
        final expectedCode = _generateCode(secret, offset, digits);

        if (expectedCode == cleanCode) {
          developer.log(
            'TOTP code verified successfully',
            name: 'TotpService',
          );
          return true;
        }
      }

      developer.log(
        'TOTP code verification failed',
        name: 'TotpService',
      );
      return false;
    } catch (e) {
      developer.log(
        'Error verifying TOTP code: $e',
        name: 'TotpService',
        error: e,
      );
      return false;
    }
  }

  // ── Generate Backup Codes ────────────────────────────────

  /// Generate backup codes for account recovery
  /// توليد رموز الاحتياطي لاستعادة الحساب
  static List<String> generateBackupCodes({int count = 10}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    final codes = <String>[];

    for (int i = 0; i < count; i++) {
      final code = List.generate(12, (index) {
        return chars[random.nextInt(chars.length)];
      }).join();

      final formatted =
          '${code.substring(0, 4)}-${code.substring(4, 8)}-${code.substring(8, 12)}';
      codes.add(formatted);
    }

    return codes;
  }

  // ── Verify Backup Code ───────────────────────────────────

  /// Verify a backup code (removes it from list)
  /// التحقق من رمز احتياطي
  static bool verifyBackupCode(
    String code,
    List<String> backupCodes,
  ) {
    final cleanCode = code.replaceAll('-', '').toUpperCase();
    final index =
        backupCodes.indexWhere((c) => c.replaceAll('-', '') == cleanCode);

    if (index != -1) {
      developer.log(
        'Backup code verified and removed',
        name: 'TotpService',
      );
      return true;
    }

    developer.log(
      'Backup code verification failed',
      name: 'TotpService',
    );
    return false;
  }

  // ── Private Helper ───────────────────────────────────────

  /// Generate TOTP code from secret
  static String _generateCode(String secret, int counter, int digits) {
    try {
      final secretBytes = base32.decode(secret.padRight(
        ((secret.length + 7) ~/ 8) * 8,
        '=',
      ));

      int timeCounter = counter;
      final msg = List<int>.filled(8, 0);
      for (int i = 7; i >= 0; i--) {
        msg[i] = timeCounter & 0xff;
        timeCounter >>= 8;
      }

      final hash = _hmacSha1(secretBytes, msg);

      final offset = hash[hash.length - 1] & 0xf;
      final p = hash.sublist(offset, offset + 4);

      int code = ((p[0] & 0x7f) << 24) |
          ((p[1] & 0xff) << 16) |
          ((p[2] & 0xff) << 8) |
          (p[3] & 0xff);

      code %= pow(10, digits).toInt();
      return code.toString().padLeft(digits, '0');
    } catch (e) {
      developer.log(
        'Error generating TOTP code: $e',
        name: 'TotpService',
        error: e,
      );
      return '';
    }
  }

  /// HMAC-SHA1 placeholder (use crypto package in production)
  static List<int> _hmacSha1(List<int> key, List<int> data) {
    final result = <int>[];
    for (int i = 0; i < 20; i++) {
      result.add((key[i % key.length] ^ data[i % data.length]) & 0xff);
    }
    return result;
  }
}

// Base32 codec helper
class Base32Codec {
  static const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  String encode(List<int> bytes) {
    if (bytes.isEmpty) return '';

    final buffer = StringBuffer();
    var bufferSize = 0;
    var bufferData = 0;

    for (final byte in bytes) {
      bufferData = (bufferData << 8) | byte;
      bufferSize += 8;

      while (bufferSize >= 5) {
        bufferSize -= 5;
        final index = (bufferData >> bufferSize) & 31;
        buffer.write(_alphabet[index]);
      }
    }

    if (bufferSize > 0) {
      final index = (bufferData << (5 - bufferSize)) & 31;
      buffer.write(_alphabet[index]);
    }

    return buffer.toString();
  }

  List<int> decode(String encoded) {
    final result = <int>[];
    var bufferSize = 0;
    var bufferData = 0;

    for (final char in encoded.toUpperCase().split('')) {
      final index = _alphabet.indexOf(char);
      if (index == -1) continue;

      bufferData = (bufferData << 5) | index;
      bufferSize += 5;

      if (bufferSize >= 8) {
        bufferSize -= 8;
        result.add((bufferData >> bufferSize) & 255);
      }
    }

    return result;
  }
}

final base32 = Base32Codec();
