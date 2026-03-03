/// Web-specific utilities and helpers for the web platform.
library;

import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/foundation.dart';

abstract class WebUtils {
  // ── Browser Detection ────────────────────────────────────

  /// Detect current browser type.
  static BrowserType getBrowserType() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();

    if (userAgent.contains('edg')) return BrowserType.edge;
    if (userAgent.contains('chrome')) return BrowserType.chrome;
    if (userAgent.contains('safari') && !userAgent.contains('chrome')) {
      return BrowserType.safari;
    }
    if (userAgent.contains('firefox')) return BrowserType.firefox;

    return BrowserType.unknown;
  }

  /// Get browser version.
  static String? getBrowserVersion() {
    final userAgent = html.window.navigator.userAgent;
    final regex = RegExp(
      r'(?:Version\/|Chrome\/|Firefox\/|Edg\/)(\d+(\.\d+)*)',
    );
    final match = regex.firstMatch(userAgent);
    return match?.group(1);
  }

  /// Check if browser supports certain features.
  static bool browserSupports(String feature) {
    try {
      switch (feature.toLowerCase()) {
        case 'geolocation':
          return html.window.navigator.geolocation != null;
        case 'notifications':
          return html.Notification.supported;
        case 'service-worker':
          return html.window.navigator.serviceWorker != null;
        case 'storage':
          return html.window.localStorage != null;
        default:
          return false;
      }
    } catch (_) {
      return false;
    }
  }

  // ── PWA Features ─────────────────────────────────────────

  /// Register service worker for PWA.
  static Future<void> registerServiceWorker(String swPath) async {
    try {
      if (!kIsWeb || !browserSupports('service-worker')) {
        debugPrint('Service workers not supported');
        return;
      }

      // This would normally be handled by Flutter's web build system
      // Placeholder for service worker registration
      js.context.callMethod('navigator.serviceWorker.register', [swPath]);
    } catch (e) {
      debugPrint('Error registering service worker: $e');
    }
  }

  /// Check if app is installed as PWA.
  static bool get isPWAInstalled {
    try {
      final displayMode = js.context.callMethod('matchMedia',
          ['(display-mode: standalone)']).callMethod('matches') as bool;
      return displayMode ||
          html.window.navigator.userAgent.toLowerCase().contains('webapk');
    } catch (_) {
      return false;
    }
  }

  /// Request PWA installation (Web Share API).
  static Future<bool> requestPWAInstall() async {
    try {
      if (!js.context.hasProperty('beforeinstallprompt')) {
        return false;
      }

      final prompt = js.context['beforeinstallprompt'];
      prompt.callMethod('prompt', []);

      final result = await prompt.callMethod('userChoice');
      return result?['outcome'] == 'accepted';
    } catch (e) {
      debugPrint('Error requesting PWA install: $e');
      return false;
    }
  }

  // ── Deep Linking ─────────────────────────────────────────

  /// Get current URL from browser.
  static String getCurrentUrl() => html.window.location.href;

  /// Navigate to URL.
  static void navigateToUrl(String url) {
    html.window.location.href = url;
  }

  /// Push state to browser history.
  static void pushState(String title, String url) {
    html.window.history.pushState(null, title, url);
  }

  /// Replace state in browser history.
  static void replaceState(String title, String url) {
    html.window.history.replaceState(null, title, url);
  }

  /// Get query parameters from URL.
  static Map<String, String> getQueryParameters() {
    return Uri.parse(html.window.location.href).queryParameters;
  }

  /// Get URL fragments.
  static String? getUrlFragment() {
    final url = html.window.location.href;
    final hashIndex = url.indexOf('#');
    if (hashIndex == -1) return null;
    return url.substring(hashIndex + 1);
  }

  // ── Notifications ────────────────────────────────────────

  /// Request notification permission.
  static Future<NotificationPermission> requestNotificationPermission() async {
    try {
      if (!browserSupports('notifications')) {
        return NotificationPermission.denied;
      }

      final permission = html.Notification.permission;
      if (permission == 'default') {
        return (await html.Notification.requestPermission()) == 'granted'
            ? NotificationPermission.granted
            : NotificationPermission.denied;
      }

      return permission == 'granted'
          ? NotificationPermission.granted
          : NotificationPermission.denied;
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return NotificationPermission.denied;
    }
  }

  /// Show browser notification.
  static void showNotification(String title, {String? body, String? icon}) {
    try {
      if (!browserSupports('notifications')) return;

      html.Notification(title, body: body, icon: icon);
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  // ── Local Storage ────────────────────────────────────────

  /// Store value in local storage.
  static void setLocalStorage(String key, String value) {
    try {
      html.window.localStorage[key] = value;
    } catch (e) {
      debugPrint('Error setting local storage: $e');
    }
  }

  /// Get value from local storage.
  static String? getLocalStorage(String key) {
    try {
      return html.window.localStorage[key];
    } catch (e) {
      debugPrint('Error getting local storage: $e');
      return null;
    }
  }

  /// Remove value from local storage.
  static void removeLocalStorage(String key) {
    try {
      html.window.localStorage.remove(key);
    } catch (e) {
      debugPrint('Error removing from local storage: $e');
    }
  }

  /// Clear all local storage.
  static void clearLocalStorage() {
    try {
      html.window.localStorage.clear();
    } catch (e) {
      debugPrint('Error clearing local storage: $e');
    }
  }

  // ── Geolocation ──────────────────────────────────────────

  /// Get user's current position.
  static Future<GeolocationCoordinates?> getCurrentPosition() async {
    try {
      if (!browserSupports('geolocation')) {
        return null;
      }

      final position =
          await html.window.navigator.geolocation.getCurrentPosition();

      return GeolocationCoordinates(
        latitude: position.coords!.latitude!.toDouble(),
        longitude: position.coords!.longitude!.toDouble(),
        accuracy: position.coords!.accuracy?.toDouble(),
      );
    } catch (e) {
      debugPrint('Error getting current position: $e');
      return null;
    }
  }

  /// Watch user's position (continuous updates).
  static Stream<GeolocationCoordinates> watchPosition() {
    return html.window.navigator.geolocation.watchPosition().map((position) {
      return GeolocationCoordinates(
        latitude: (position.coords!.latitude! as num).toDouble(),
        longitude: (position.coords!.longitude! as num).toDouble(),
        accuracy: position.coords!.accuracy?.toDouble(),
      );
    });
  }

  // ── Clipboard ────────────────────────────────────────────

  /// Copy text to clipboard.
  static Future<bool> copyToClipboard(String text) async {
    try {
      await js.context.callMethod('eval', [
        '''navigator.clipboard.writeText("$text")''',
      ]);
      return true;
    } catch (e) {
      debugPrint('Error copying to clipboard: $e');
      return false;
    }
  }

  /// Read text from clipboard.
  static Future<String?> readFromClipboard() async {
    try {
      final result = await js.context.callMethod('eval', [
        '''navigator.clipboard.readText()''',
      ]);
      return result as String?;
    } catch (e) {
      debugPrint('Error reading from clipboard: $e');
      return null;
    }
  }

  // ── Display & Screen ─────────────────────────────────────

  /// Get current window dimensions.
  static Size getWindowSize() {
    return Size(
      html.window.innerWidth?.toDouble() ?? 0,
      html.window.innerHeight?.toDouble() ?? 0,
    );
  }

  /// Check if device is mobile.
  static bool get isMobileWeb {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('mobile') ||
        userAgent.contains('android') ||
        userAgent.contains('iphone') ||
        userAgent.contains('ipad');
  }

  /// Get device pixel ratio.
  static double get devicePixelRatio => html.window.devicePixelRatio.toDouble();

  /// Listen to window resize events.
  static Stream<Size> onWindowResize() {
    return html.window.onResize.map((_) => getWindowSize());
  }

  // ── Development Helpers ──────────────────────────────────

  /// Log to browser console.
  static void consoleLog(Object? object) {
    if (kDebugMode) {
      html.window.console.log(object);
    }
  }

  /// Check if DevTools is open.
  static bool get isDevToolsOpen {
    final start = DateTime.now().millisecondsSinceEpoch;
    html.Element? element;
    try {
      element = html.document.createElement('div');
      html.document.body?.append(element);
      bool checkTime() => DateTime.now().millisecondsSinceEpoch - start > 100;
      element.addEventListener('DOMNodeInserted', (_) {
        if (checkTime()) return;
      });
      element.addEventListener('DOMNodeRemoved', (_) {
        if (checkTime()) return;
      });
    } catch (_) {}
    return false;
  }
}

// ── Enums & Models ──────────────────────────────────────────

enum BrowserType { chrome, firefox, safari, edge, unknown }

enum NotificationPermission { granted, denied, default_ }

class GeolocationCoordinates {
  GeolocationCoordinates({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });
  final double latitude;
  final double longitude;
  final double? accuracy;

  @override
  String toString() =>
      'GeolocationCoordinates(lat: $latitude, lng: $longitude, accuracy: $accuracy)';
}

/// Size helper for web (similar to Flutter Size).
class Size {
  Size(this.width, this.height);
  final double width;
  final double height;

  @override
  String toString() => 'Size($width, $height)';
}
