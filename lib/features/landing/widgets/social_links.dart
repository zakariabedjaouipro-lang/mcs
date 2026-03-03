import 'package:flutter/material.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';

/// روابط التواصل الاجتماعي - يحتوي على أيقونات وروابط التواصل
class SocialLinksWidget extends StatelessWidget {
  final Color? primaryColor;
  final double iconSize;
  final EdgeInsets padding;
  final Axis direction;

  const SocialLinksWidget({
    Key? key,
    this.primaryColor,
    this.iconSize = 50,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.direction = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = this.primaryColor ?? AppColors.primary;

    final socialLinks = [
      SocialLink(
        platform: 'Facebook',
        icon: Icons.facebook,
        url: 'https://www.facebook.com/mcs',
        color: Color(0xFF1877F2),
      ),
      SocialLink(
        platform: 'Twitter',
        icon: Icons.twitter,
        url: 'https://www.twitter.com/mcs',
        color: Color(0xFF1DA1F2),
      ),
      SocialLink(
        platform: 'Instagram',
        icon: Icons.account_circle,
        url: 'https://www.instagram.com/mcs',
        color: Color(0xFFE4405F),
      ),
      SocialLink(
        platform: 'LinkedIn',
        icon: Icons.business,
        url: 'https://www.linkedin.com/company/mcs',
        color: Color(0xFF0A66C2),
      ),
      SocialLink(
        platform: 'YouTube',
        icon: Icons.play_circle,
        url: 'https://www.youtube.com/@mcs',
        color: Color(0xFFFF0000),
      ),
      SocialLink(
        platform: 'WhatsApp',
        icon: Icons.message,
        url: 'https://wa.me/966501234567',
        color: Color(0xFF25D366),
      ),
    ];

    if (direction == Axis.vertical) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: socialLinks
            .map((link) => _buildSocialItem(link, primaryColor))
            .toList(),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: socialLinks
          .map((link) => _buildSocialIcon(link, primaryColor))
          .toList(),
    );
  }

  Widget _buildSocialIcon(SocialLink link, Color primaryColor) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _openLink(link.url),
        child: Tooltip(
          message: link.platform,
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: link.color.withOpacity(0.1),
              border: Border.all(color: link.color, width: 2),
            ),
            child: Center(
              child: Icon(
                link.icon,
                color: link.color,
                size: iconSize * 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialItem(SocialLink link, Color primaryColor) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _openLink(link.url),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: link.color),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: link.color.withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(
                    link.icon,
                    color: link.color,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  link.platform,
                  style: TextStyles.subtitle1.copyWith(
                    color: link.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward, color: link.color, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _openLink(String url) {
    // In a real app, use url_launcher package
    // launchUrl(Uri.parse(url));
    print('Opening: $url');
  }
}

/// فئة تمثل وسيلة تواصل اجتماعي
class SocialLink {
  final String platform;
  final IconData icon;
  final String url;
  final Color color;

  SocialLink({
    required this.platform,
    required this.icon,
    required this.url,
    required this.color,
  });
}
