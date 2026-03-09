/// Device and platform detection service.
///
/// Detects the current platform, gathers device information
/// for analytics / bug reports, and provides platform-specific
/// download links for the landing page.
library;

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

// ── Platform Enum ──────────────────────────────────────────
enum AppPlatform {
  web,
  android,
  ios,
  windows,
  macos,
  linux,
  unknown,
}

class DeviceDetectionService {
  const DeviceDetectionService._();

  // ── Current Platform ─────────────────────────────────────

  /// Returns the current [AppPlatform].
  static AppPlatform get currentPlatform {
    if (kIsWeb) return AppPlatform.web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AppPlatform.android;
      case TargetPlatform.iOS:
        return AppPlatform.ios;
      case TargetPlatform.windows:
        return AppPlatform.windows;
      case TargetPlatform.macOS:
        return AppPlatform.macos;
      case TargetPlatform.linux:
        return AppPlatform.linux;
      case TargetPlatform.fuchsia:
        return AppPlatform.unknown;
    }
  }

  // ── Boolean Helpers ──────────────────────────────────────

  static bool get isWeb => kIsWeb;
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  static bool get isMacOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isLinux =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => isWindows || isMacOS || isLinux;

  // ── Download Links ───────────────────────────────────────

  /// Returns the appropriate app store / download URL for the
  /// current platform. Used by the landing page.
  static String? get downloadUrl {
    switch (currentPlatform) {
      case AppPlatform.android:
      case AppPlatform.web: // Default suggestion on web → Play Store
        return _playStoreUrl;
      case AppPlatform.ios:
        return _appStoreUrl;
      case AppPlatform.windows:
        return _windowsDownloadUrl;
      case AppPlatform.macos:
        return _macDownloadUrl;
      case AppPlatform.linux:
      case AppPlatform.unknown:
        return null;
    }
  }

  // TODO(phase-1): Replace with actual store URLs once application is published.
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.mcs.medical';
  static const _appStoreUrl =
      'https://apps.apple.com/app/medical-clinic-system/id1234567890';
  static const _windowsDownloadUrl = 'https://mcs.app/download/windows';
  static const _macDownloadUrl = 'https://mcs.app/download/macos';

  // ── Device Info Map (for bug reports) ────────────────────

  /// Returns a JSON-serialisable map of basic device info.
  static Map<String, dynamic> get deviceInfoMap {
    return {
      'platform': currentPlatform.name,
      'is_web': isWeb,
      'is_mobile': isMobile,
      'is_desktop': isDesktop,
    };
  }
}
