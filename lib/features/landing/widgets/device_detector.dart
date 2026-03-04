/// Device detector widget - detects user device and shows relevant download buttons.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/features/landing/widgets/platform_buttons.dart';

/// Enum for detected device types.
enum DeviceTypeDetection {
  iphone,
  iPad,
  android,
  androidTablet,
  windows,
  macOS,
  web,
  unknown,
}

class DeviceDetector extends StatefulWidget {
  const DeviceDetector({
    super.key,
    this.showRecommended = true,
  });

  /// Whether to show all platforms or just detected ones.
  final bool showRecommended;

  @override
  State<DeviceDetector> createState() => _DeviceDetectorState();
}

class _DeviceDetectorState extends State<DeviceDetector> {
  late DeviceTypeDetection _detectedDevice;

  @override
  void initState() {
    super.initState();
    _detectedDevice = _detectDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Device detection message
        if (widget.showRecommended)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getDeviceMessage(),
                    style: TextStyles.bodyMedium.copyWith(
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 24),

        // Recommended buttons
        if (widget.showRecommended)
          Column(
            children: [
              Text(
                'Recommended for you',
                style: TextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildRecommendedButtons(),
              const SizedBox(height: 32),
            ],
          ),

        // All platforms
        Text(
          'or choose from all platforms',
          style: TextStyles.bodyMedium.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        const PlatformButtons(showAll: true),
      ],
    );
  }

  /// Build recommended buttons based on detected device.
  Widget _buildRecommendedButtons() {
    final buttons = <Widget>[];

    switch (_detectedDevice) {
      case DeviceTypeDetection.iphone:
      case DeviceTypeDetection.iPad:
        buttons.add(
          _buildStoreButton(
            icon: Icons.apple,
            text: 'App Store',
            platform: 'iOS',
            onPressed: () => _openAppStore('ios'),
            backgroundColor: Colors.black,
          ),
        );

      case DeviceTypeDetection.android:
      case DeviceTypeDetection.androidTablet:
        buttons.add(
          _buildStoreButton(
            icon: Icons.android,
            text: 'Google Play',
            platform: 'Android',
            onPressed: () => _openAppStore('android'),
            backgroundColor: Colors.green,
          ),
        );

      case DeviceTypeDetection.windows:
        buttons.add(
          _buildStoreButton(
            icon: Icons.computer,
            text: 'Microsoft Store',
            platform: 'Windows',
            onPressed: () => _openAppStore('windows'),
            backgroundColor: const Color(0xFF0078D4),
          ),
        );

      case DeviceTypeDetection.macOS:
        buttons.add(
          _buildStoreButton(
            icon: Icons.laptop_mac,
            text: 'App Store',
            platform: 'macOS',
            onPressed: () => _openAppStore('macos'),
            backgroundColor: Colors.black87,
          ),
        );

      case DeviceTypeDetection.web:
      case DeviceTypeDetection.unknown:
        // Show iOS and Android for web/unknown
        buttons.addAll([
          _buildStoreButton(
            icon: Icons.apple,
            text: 'App Store',
            platform: 'iOS',
            onPressed: () => _openAppStore('ios'),
            backgroundColor: Colors.black,
          ),
          const SizedBox(width: 16),
          _buildStoreButton(
            icon: Icons.android,
            text: 'Google Play',
            platform: 'Android',
            onPressed: () => _openAppStore('android'),
            backgroundColor: Colors.green,
          ),
        ]);
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: buttons,
    );
  }

  /// Build store button.
  Widget _buildStoreButton({
    required IconData icon,
    required String text,
    required String platform,
    required VoidCallback onPressed,
    required Color backgroundColor,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    );
  }

  /// Detect device type from user agent and context.
  DeviceTypeDetection _detectDevice() {
    // Get the platform from the current context
    final platform = Theme.of(context).platform;

    switch (platform) {
      case TargetPlatform.android:
        return DeviceTypeDetection.android;
      case TargetPlatform.iOS:
        return DeviceTypeDetection.iphone;
      case TargetPlatform.windows:
        return DeviceTypeDetection.windows;
      case TargetPlatform.macOS:
        return DeviceTypeDetection.macOS;
      case TargetPlatform.linux:
        return DeviceTypeDetection.web;
      case TargetPlatform.fuchsia:
        return DeviceTypeDetection.unknown;
    }
  }

  /// Get device detection message.
  String _getDeviceMessage() {
    switch (_detectedDevice) {
      case DeviceTypeDetection.iphone:
        return 'Detected: iPhone - Get MCS from App Store';
      case DeviceTypeDetection.iPad:
        return 'Detected: iPad - Get MCS from App Store';
      case DeviceTypeDetection.android:
        return 'Detected: Android Phone - Get MCS from Google Play';
      case DeviceTypeDetection.androidTablet:
        return 'Detected: Android Tablet - Get MCS from Google Play';
      case DeviceTypeDetection.windows:
        return 'Detected: Windows PC - Download MCS';
      case DeviceTypeDetection.macOS:
        return 'Detected: Mac - Get MCS from App Store';
      case DeviceTypeDetection.web:
        return 'Using web browser - Choose your device type below';
      case DeviceTypeDetection.unknown:
        return 'Device not detected - Choose your platform below';
    }
  }

  /// Open app store link (placeholder).
  void _openAppStore(String platform) {
    // In real implementation:
    // - iOS: https://apps.apple.com/...
    // - Android: https://play.google.com/store/apps/...
    // - Windows: Microsoft Store link
    // - macOS: Mac App Store link

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $platform store...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
