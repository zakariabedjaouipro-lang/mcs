/// Platform buttons widget - displays download buttons for all supported platforms.
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';

/// Platform button data model.
class PlatformData {
  final String name;
  final String shortName;
  final IconData icon;
  final Color color;
  final String primaryStore;
  final String? secondaryStore;
  final String downloadUrl;

  const PlatformData({
    required this.name,
    required this.shortName,
    required this.icon,
    required this.color,
    required this.primaryStore,
    this.secondaryStore,
    required this.downloadUrl,
  });
}

class PlatformButtons extends StatelessWidget {
  /// Whether to show all platforms or just primary ones.
  final bool showAll;

  const PlatformButtons({
    super.key,
    this.showAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final platforms = _getPlatforms();
    final displayPlatforms = showAll ? platforms : platforms.take(4).toList();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: displayPlatforms
          .map((platform) => _buildPlatformButton(context, platform))
          .toList(),
    );
  }

  /// Build individual platform button.
  Widget _buildPlatformButton(BuildContext context, PlatformData platform) {
    return ElevatedButton.icon(
      onPressed: () => _handleDownload(context, platform),
      icon: Icon(
        platform.icon,
        color: Colors.white,
      ),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            platform.name,
            style: TextStyles.labelLarge.copyWith(color: Colors.white),
          ),
          if (platform.primaryStore.isNotEmpty)
            Text(
              platform.primaryStore,
              style: TextStyles.labelSmall.copyWith(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: platform.color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Get supported platforms list.
  List<PlatformData> _getPlatforms() {
    return [
      PlatformData(
        name: 'iPhone',
        shortName: 'iOS',
        icon: Icons.apple,
        color: Colors.black,
        primaryStore: 'App Store',
        downloadUrl: 'https://apps.apple.com/app/mcs/id123456789',
      ),
      PlatformData(
        name: 'iPad',
        shortName: 'iPadOS',
        icon: Icons.tablet,
        color: Colors.grey[700]!,
        primaryStore: 'App Store',
        downloadUrl: 'https://apps.apple.com/app/mcs/id123456789',
      ),
      PlatformData(
        name: 'Android',
        shortName: 'Android',
        icon: Icons.android,
        color: Colors.green[700]!,
        primaryStore: 'Google Play',
        secondaryStore: 'Galaxy Store',
        downloadUrl:
            'https://play.google.com/store/apps/details?id=com.mcs.clinic',
      ),
      PlatformData(
        name: 'Windows',
        shortName: 'Windows',
        icon: Icons.computer,
        color: const Color(0xFF0078D4),
        primaryStore: 'Microsoft Store',
        downloadUrl: 'https://www.microsoft.com/store/apps/...',
      ),
      PlatformData(
        name: 'Mac',
        shortName: 'macOS',
        icon: Icons.laptop_mac,
        color: Colors.black87,
        primaryStore: 'App Store',
        downloadUrl: 'https://apps.apple.com/app/mcs/id123456789?mt=12',
      ),
      PlatformData(
        name: 'Linux',
        shortName: 'Linux',
        icon: Icons.computer,
        color: Colors.orange[700]!,
        primaryStore: 'Download',
        downloadUrl: 'https://mcs-clinic.com/download/linux',
      ),
      PlatformData(
        name: 'Web',
        shortName: 'Web',
        icon: Icons.language,
        color: Colors.deepPurple,
        primaryStore: 'Browser',
        downloadUrl: 'https://app.mcs-clinic.com',
      ),
    ];
  }

  /// Handle download button press.
  void _handleDownload(BuildContext context, PlatformData platform) {
    // In real implementation, this would:
    // 1. Open the app store link using url_launcher
    // 2. Or open a download page with more information
    // 3. Track analytics for download button clicks

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening ${platform.name} ${platform.primaryStore}...\n'
          'Link: ${platform.downloadUrl}',
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      ),
    );

    // Actual implementation would use:
    // if (await canLaunchUrl(Uri.parse(platform.downloadUrl))) {
    //   await launchUrl(Uri.parse(platform.downloadUrl));
    // }
  }
}
