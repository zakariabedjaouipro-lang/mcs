/// Platform detection and platform-specific utilities.
library;

import 'dart:io' as io;

import 'package:flutter/foundation.dart';

abstract class PlatformUtils {
  // ── Platform Detection ───────────────────────────────────

  static bool get isWeb => kIsWeb;
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => isWindows || isMacOS || isLinux;

  static bool get isAndroid => !kIsWeb && io.Platform.isAndroid;
  static bool get isIOS => !kIsWeb && io.Platform.isIOS;
  static bool get isWindows => !kIsWeb && io.Platform.isWindows;
  static bool get isMacOS => !kIsWeb && io.Platform.isMacOS;
  static bool get isLinux => !kIsWeb && io.Platform.isLinux;

  // ── Safe Getters (Web-aware) ─────────────────────────────

  static String? get osVersion {
    if (kIsWeb) return null;
    try {
      return io.Platform.operatingSystemVersion;
    } catch (_) {
      return null;
    }
  }

  static String? getEnvironmentVariable(String name) {
    if (kIsWeb) return null;
    try {
      return io.Platform.environment[name];
    } catch (_) {
      return null;
    }
  }

  // ── Device Features ─────────────────────────────────────

  /// Whether device might be a tablet (very rough heuristic).
  /// Use MediaQuery.of(context).size.diagonal for better detection.
  static bool get mightBeTablet {
    if (!isMobile) return false;
    // Basic heuristic: aspect ratio closer to 1.0 = tablet-like
    // This would need context to be accurate; this is just a placeholder.
    return false;
  }

  /// Whether device is in debug mode.
  static bool get isInDebugMode => kDebugMode;

  /// Whether device is running in release mode.
  static bool get isInReleaseMode => kReleaseMode;

  /// Whether device is running in profile mode (for testing performance).
  static bool get isInProfileMode => kProfileMode;

  // ── Platform-Specific Behaviors ──────────────────────────

  /// Get the native file separator for the platform.
  static String get pathSeparator {
    if (kIsWeb) return '/';
    return io.Platform.pathSeparator;
  }

  /// Get the system's line separator.
  static String get lineTerminator {
    if (kIsWeb) return '\n';
    return io.Platform.lineTerminator;
  }

  /// Get number of processors (threads) available.
  static int? get processorCount {
    if (kIsWeb) return null;
    try {
      return io.Platform.numberOfProcessors;
    } catch (_) {
      return null;
    }
  }

  /// Get system locale from environment.
  static String? get systemLocale {
    if (kIsWeb) return null;
    try {
      return io.Platform.environment['LANG']?.split('.').first;
    } catch (_) {
      return null;
    }
  }

  // ── Platform-Specific Defaults ───────────────────────────

  /// Get appropriate file extension for platform executables.
  static String get executableExtension {
    if (kIsWeb) return '';
    if (isWindows) return '.exe';
    return '';
  }

  /// Whether to use Material 3 by default on this platform.
  static bool get useMaterial3ByDefault => true;

  /// Whether native Back button should be handled (Android/web).
  static bool get hasNativeBackButton => isAndroid || isWeb;
}
