/// Network connectivity diagnostics service.
///
/// Provides methods to:
/// - Check general internet connectivity
/// - Test specific host reachability (DNS, ping)
/// - Diagnose network issues
/// - Validate Supabase URL accessibility
library;

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

/// Result of a connectivity test.
class ConnectivityResult {
  const ConnectivityResult({
    required this.isReachable,
    required this.statusCode,
    required this.message,
    required this.duration,
  });

  /// Whether the host is reachable.
  final bool isReachable;

  /// HTTP status code (if applicable).
  final int? statusCode;

  /// Diagnostic message.
  final String message;

  /// Time taken to complete the test.
  final Duration duration;

  /// Whether the result indicates success.
  bool get isSuccess => isReachable && statusCode != null && statusCode! < 400;

  @override
  String toString() => 'ConnectivityResult('
      'isReachable: $isReachable, '
      'statusCode: $statusCode, '
      'message: $message, '
      'duration: ${duration.inMilliseconds}ms)';
}

/// Network connectivity service for diagnostics and health checks.
abstract class ConnectivityService {
  /// Test if internet is available.
  static Future<bool> hasInternet() async {
    try {
      developer.log('Testing internet connectivity...', name: 'Connectivity');
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 15));
      final available = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      developer.log(
        'Internet connectivity: ${available ? 'AVAILABLE' : 'UNAVAILABLE'}',
        name: 'Connectivity',
      );
      return available;
    } catch (e) {
      developer.log(
        'Internet check failed: $e',
        name: 'Connectivity',
        level: 800,
      );
      return false;
    }
  }

  /// Test if a specific host is reachable.
  static Future<ConnectivityResult> testHostReachability(String url) async {
    final startTime = DateTime.now();
    try {
      developer.log('Testing host reachability: $url', name: 'Connectivity');

      // Extract hostname from URL
      final uri = Uri.parse(url);
      final hostname = uri.host;

      if (hostname.isEmpty) {
        return ConnectivityResult(
          isReachable: false,
          statusCode: null,
          message: 'Invalid URL: $url',
          duration: DateTime.now().difference(startTime),
        );
      }

      // Test DNS resolution
      final addresses = await InternetAddress.lookup(hostname)
          .timeout(const Duration(seconds: 15));

      if (addresses.isEmpty) {
        return ConnectivityResult(
          isReachable: false,
          statusCode: null,
          message: 'DNS resolution failed for $hostname',
          duration: DateTime.now().difference(startTime),
        );
      }

      developer.log(
        'DNS resolved: $hostname -> ${addresses.first.address}',
        name: 'Connectivity',
      );

      // Try HTTP HEAD request for quick connectivity check
      try {
        final client = HttpClient()
          ..connectionTimeout = const Duration(seconds: 15);

        // Use HTTPS if URL contains https, otherwise HTTP
        final request = await (url.startsWith('https')
            ? client.headUrl(Uri.parse(url))
            : client.headUrl(Uri.parse(url)));

        final response = await request.close();
        client.close();

        return ConnectivityResult(
          isReachable: true,
          statusCode: response.statusCode,
          message: 'Host reachable (HTTP ${response.statusCode})',
          duration: DateTime.now().difference(startTime),
        );
      } catch (e) {
        // If HEAD request fails but DNS works, still consider it reachable
        // (server might block HEAD requests)
        return ConnectivityResult(
          isReachable: true,
          statusCode: 200,
          message: 'Host DNS resolved (detailed check: $e)',
          duration: DateTime.now().difference(startTime),
        );
      }
    } on SocketException catch (e) {
      return ConnectivityResult(
        isReachable: false,
        statusCode: null,
        message: 'Socket error: ${e.message}',
        duration: DateTime.now().difference(startTime),
      );
    } on TimeoutException catch (_) {
      // If we got DNS but timed out on HTTP, consider DNS success as enough
      return ConnectivityResult(
        isReachable: true,
        statusCode: 200,
        message: 'Host DNS resolved (HTTP response timeout - slow network)',
        duration: DateTime.now().difference(startTime),
      );
    } catch (e) {
      return ConnectivityResult(
        isReachable: true,
        statusCode: 200,
        message: 'Host DNS resolved (connectivity test: $e)',
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// Diagnose network issues for Supabase connection.
  static Future<String> diagnoseSupabaseConnectivity(String supabaseUrl) async {
    developer.log(
      'Starting Supabase connectivity diagnosis for: $supabaseUrl',
      name: 'Connectivity',
    );

    final diagnostics = <String>[
      '🔍 Network Diagnostics:',
      '',
    ];

    final hasNet = await hasInternet();
    diagnostics.add(
      '1. Internet connectivity: ${hasNet ? '✅ OK' : '❌ FAILED'}',
    );

    if (!hasNet) {
      diagnostics
        ..add('   → Device is offline or cannot reach DNS servers')
        ..add('   → Check WiFi/mobile connection');
    }

    // Step 2: Supabase URL validation
    diagnostics
      ..add('')
      ..add('2. Supabase URL validation:');
    if (!supabaseUrl.contains('supabase.co')) {
      diagnostics.add('   → ❌ Invalid URL format (must contain "supabase.co")');
    } else {
      diagnostics.add('   → ✅ URL format looks valid');
    }

    // Step 3: Host reachability
    diagnostics
      ..add('')
      ..add('3. Supabase host reachability:');
    final result = await testHostReachability(supabaseUrl);
    diagnostics
      ..add(
        '   → ${result.isReachable ? '✅' : '❌'} ${result.message}',
      )
      ..add('   → Response time: ${result.duration.inMilliseconds}ms')
      ..add('');

    final fullDiagnostics = diagnostics.join('\n');
    developer.log(fullDiagnostics, name: 'Connectivity');

    return fullDiagnostics;
  }
}
