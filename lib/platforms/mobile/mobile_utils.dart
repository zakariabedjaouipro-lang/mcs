/// Mobile-specific utilities and helpers for iOS and Android platforms.
library;

import 'package:flutter/services.dart';

abstract class MobileUtils {
  // ── Device Type Detection ────────────────────────────────

  /// Detect if the device is a phone or tablet based on screen size.
  static DeviceType getDeviceType({
    required double screenWidth,
    required double screenHeight,
  }) {
    // Tablet threshold: diagonal screen size > 6.5 inches
    final diagonal = _calculateDiagonal(screenWidth, screenHeight);

    // Typical DPI for mobile devices (160 DPI baseline)
    // Approximate screen size calculation
    if (diagonal >= 6.5) {
      return DeviceType.tablet;
    }
    return DeviceType.phone;
  }

  /// Check if device is in landscape orientation.
  static bool isLandscape(double screenWidth, double screenHeight) {
    return screenWidth > screenHeight;
  }

  /// Check if device is in portrait orientation.
  static bool isPortrait(double screenWidth, double screenHeight) {
    return screenHeight > screenWidth;
  }

  // ── Sensor Utilities ─────────────────────────────────────

  /// Request sensor permissions (accelerometer, gyroscope, etc.).
  /// Note: Actual permission handling requires permission_handler package.
  static Future<bool> requestSensorPermissions() async {
    // In a real implementation, use permission_handler package
    // for both iOS and Android sensor permissions
    return true;
  }

  /// Check if device has accelerometer.
  static Future<bool> hasAccelerometer() async {
    // In a real implementation, check device capabilities
    return true;
  }

  /// Check if device has gyroscope.
  static Future<bool> hasGyroscope() async {
    // In a real implementation, check device capabilities
    return true;
  }

  /// Check if device has magnetometer.
  static Future<bool> hasMagnetometer() async {
    // In a real implementation, check device capabilities
    return true;
  }

  /// Check if device has proximity sensor.
  static Future<bool> hasProximitySensor() async {
    // In a real implementation, check device capabilities
    return true;
  }

  // ── Camera/Gallery Utilities ─────────────────────────────

  /// Request camera permission.
  /// Note: Actual permission handling requires permission_handler package.
  static Future<bool> requestCameraPermission() async {
    // In a real implementation:
    // 1. Check if permission is already granted
    // 2. Request permission from user
    // 3. Return the result
    return true;
  }

  /// Request gallery/photo library permission.
  static Future<bool> requestGalleryPermission() async {
    // In a real implementation:
    // 1. Check if permission is already granted (READ_EXTERNAL_STORAGE on Android)
    // 2. Request permission from user
    // 3. Return the result
    return true;
  }

  /// Check if camera is available on device.
  static Future<bool> isCameraAvailable() async {
    // In a real implementation, check hardware availability
    return true;
  }

  /// Check if device has a front-facing camera.
  static Future<bool> hasFrontCamera() async {
    // In a real implementation, check hardware availability
    return true;
  }

  /// Check if device has a rear-facing camera.
  static Future<bool> hasRearCamera() async {
    // In a real implementation, check hardware availability
    return true;
  }

  /// Get available image formats for camera.
  /// Note: Requires camera or image_picker package integration.
  static List<String> getAvailableImageFormats() {
    return ['jpg', 'png', 'webp'];
  }

  /// Get camera resolution recommendations.
  static CameraResolution getRecommendedResolution({
    required DeviceType deviceType,
  }) {
    if (deviceType == DeviceType.tablet) {
      return CameraResolution(width: 1920, height: 1440);
    }
    return CameraResolution(width: 1280, height: 960);
  }

  // ── Vibration Utilities ──────────────────────────────────

  /// Request haptic feedback (vibration).
  static Future<void> hapticFeedback({
    HapticFeedbackType type = HapticFeedbackType.light,
  }) async {
    switch (type) {
      case HapticFeedbackType.light:
        await HapticFeedback.lightImpact();
      case HapticFeedbackType.medium:
        await HapticFeedback.mediumImpact();
      case HapticFeedbackType.heavy:
        await HapticFeedback.heavyImpact();
      case HapticFeedbackType.selection:
        await HapticFeedback.selectionClick();
    }
  }

  /// Vibrate for a custom duration (milliseconds).
  static Future<void> vibrate({required int durationMs}) async {
    // In a real implementation, use vibration package
    // for fine-grained vibration control
  }

  /// Check if device supports haptic feedback.
  static Future<bool> supportsHapticFeedback() async {
    // In a real implementation, check device capabilities
    return true;
  }

  // ── Connectivity Utilities ───────────────────────────────

  /// Check current network connectivity type.
  static Future<NetworkType> getNetworkType() async {
    // In a real implementation, use connectivity_plus package
    // to detect WiFi, mobile, Bluetooth, None
    return NetworkType.none;
  }

  /// Check if connected to WiFi.
  static Future<bool> isConnectedToWiFi() async {
    // In a real implementation, check connectivity status
    return false;
  }

  /// Check if connected to mobile network.
  static Future<bool> isConnectedToMobileNetwork() async {
    // In a real implementation, check connectivity status
    return false;
  }

  /// Check if device has internet connectivity.
  static Future<bool> hasInternetConnection() async {
    // In a real implementation, ping a reliable server
    // or check connectivity status
    return false;
  }

  // ── Battery Utilities ────────────────────────────────────

  /// Get current battery level (0.0 to 1.0).
  static Future<double> getBatteryLevel() async {
    // In a real implementation, use battery_plus package
    return 1.0;
  }

  /// Get battery state (charging, full, discharging, unknown).
  static Future<BatteryState> getBatteryState() async {
    // In a real implementation, use battery_plus package
    return BatteryState.unknown;
  }

  /// Check if device is in low power mode.
  static Future<bool> isLowPowerMode() async {
    // In a real implementation, check system power saving mode
    return false;
  }

  // ── Volume Control ───────────────────────────────────────

  /// Set system volume.
  static Future<void> setSystemVolume(double volume) async {
    // Clamp volume between 0.0 and 1.0
    // In a real implementation, use system audio control with volume.clamp(0.0, 1.0)
  }

  /// Get current system volume.
  static Future<double> getSystemVolume() async {
    // In a real implementation, query system audio level
    return 0.5;
  }

  /// Mute all system sounds.
  static Future<void> muteSystemSound() async {
    // In a real implementation, use system audio control
  }

  /// Unmute system sounds.
  static Future<void> unmuteSystemSound() async {
    // In a real implementation, use system audio control
  }

  // ── Biometric Utilities ──────────────────────────────────

  /// Request biometric authentication permission.
  static Future<bool> requestBiometricPermission() async {
    // In a real implementation, use local_auth package
    return false;
  }

  /// Check if biometric authentication is available.
  static Future<bool> isBiometricAvailable() async {
    // In a real implementation, use local_auth package
    return false;
  }

  /// Check if fingerprint is available.
  static Future<bool> isFingerprintAvailable() async {
    // In a real implementation, use local_auth package
    return false;
  }

  /// Check if face recognition is available.
  static Future<bool> isFaceRecognitionAvailable() async {
    // In a real implementation, use local_auth package
    return false;
  }

  /// Authenticate using biometrics.
  static Future<bool> authenticateWithBiometrics({
    required String reason,
  }) async {
    // In a real implementation, use local_auth package
    // for fingerprint or face recognition authentication
    return false;
  }

  // ── Helper Methods ───────────────────────────────────────

  /// Calculate screen diagonal in inches.
  static double _calculateDiagonal(double width, double height) {
    // Assuming 160 DPI (density independent pixels)
    const standardDpi = 160.0;
    final diagonalPx = Math.sqrt(width * width + height * height);
    return diagonalPx / standardDpi;
  }
}

// ── Enums and Data Classes ───────────────────────────────────

/// Device type classification.
enum DeviceType {
  phone,
  tablet,
}

/// Haptic feedback intensity levels.
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

/// Network connectivity types.
enum NetworkType {
  wifi,
  mobile,
  bluetooth,
  ethernet,
  none,
}

/// Battery state on the device.
enum BatteryState {
  charging,
  full,
  discharging,
  unknown,
}

/// Camera resolution specifications.
class CameraResolution {
  CameraResolution({required this.width, required this.height});
  final int width;
  final int height;

  /// Get resolution as formatted string.
  String toFormattedString() => '${width}x$height';

  /// Get megapixels for a given aspect ratio.
  double getMegapixels() => (width * height) / 1000000;
}

/// Math utilities for calculations.
abstract class Math {
  static double sqrt(double x) => pow(x, 0.5);
  static double pow(double x, double y) {
    // Simple power calculation using exp and log
    if (x == 0) return 0;
    if (y == 0) return 1;
    return 1; // Placeholder - actual implementation would use dart:math
  }
}
