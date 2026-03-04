import 'package:flutter/material.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';

/// تذييل الموقع - يحتوي على الروابط والمعلومات والتواصل الاجتماعي
class FooterWidget extends StatelessWidget {
  const FooterWidget({
    super.key,
    this.primaryColor,
    this.onLogoTap,
  });
  final Color? primaryColor;
  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = this.primaryColor ?? AppColors.primary;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return ColoredBox(
      color: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          // Main Footer Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 60,
            ),
            child: isMobile
                ? _buildMobileFooter(primaryColor)
                : _buildDesktopFooter(primaryColor),
          ),

          // Divider
          Container(
            height: 1,
            color: Colors.white10,
          ),

          // Bottom Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: _buildBottomBar(primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(Color primaryColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Info
        Expanded(
          flex: 2,
          child: _buildCompanySection(primaryColor),
        ),
        const SizedBox(width: 60),

        // Quick Links
        Expanded(
          child: _buildLinksSection(
            title: 'روابط سريعة',
            links: [
              'الرئيسية',
              'المميزات',
              'الأسعار',
              'التحميل',
              'الدعم',
            ],
            primaryColor: primaryColor,
          ),
        ),

        // Resources
        Expanded(
          child: _buildLinksSection(
            title: 'الموارد',
            links: [
              'التوثيق',
              'المدونة',
              'الأسئلة الشائعة',
              'الدروس',
              'المجتمع',
            ],
            primaryColor: primaryColor,
          ),
        ),

        // Legal
        Expanded(
          child: _buildLinksSection(
            title: 'القوانين',
            links: [
              'سياسة الخصوصية',
              'شروط الاستخدام',
              'سياسة الكوكيز',
              'إعدادات الخصوصية',
            ],
            primaryColor: primaryColor,
          ),
        ),

        // Contact Info
        Expanded(
          child: _buildContactSection(primaryColor),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanySection(primaryColor),
        const SizedBox(height: 40),
        _buildLinksSection(
          title: 'روابط سريعة',
          links: [
            'الرئيسية',
            'المميزات',
            'الأسعار',
            'التحميل',
            'الدعم',
          ],
          primaryColor: primaryColor,
        ),
        const SizedBox(height: 40),
        _buildLinksSection(
          title: 'الموارد',
          links: [
            'التوثيق',
            'المدونة',
            'الأسئلة الشائعة',
            'الدروس',
          ],
          primaryColor: primaryColor,
        ),
        const SizedBox(height: 40),
        _buildContactSection(primaryColor),
      ],
    );
  }

  Widget _buildCompanySection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'MCS',
                  style: TextStyles.subtitle1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'MCS',
              style: TextStyles.heading3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Description
        Text(
          'نظام إدارة العيادات الطبية الشاملة - منصة موحدة لتحسين الرعاية الصحية',
          style: TextStyles.body2.copyWith(
            color: Colors.white70,
            height: 1.6,
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),

        // Social Links
        Row(
          children: [
            _buildSocialIcon(
                Icons.facebook,
                'Facebook',
                const Color(0xFF1877F2),
              ),
            const SizedBox(width: 12),
            _buildSocialIcon(
                Icons.close,
                'X (Twitter)',
                const Color(0xFF1DA1F2),
              ),
            const SizedBox(width: 12),
            _buildSocialIcon(
              Icons.account_circle,
              'Instagram',
              const Color(0xFFE4405F),
            ),
            const SizedBox(width: 12),
            _buildSocialIcon(
                Icons.business,
                'LinkedIn',
                const Color(0xFF0A66C2),
              ),
            const SizedBox(width: 12),
            _buildSocialIcon(
                Icons.play_circle, 'YouTube', const Color(0xFFFF0000)),
          ],
        ),
      ],
    );
  }

  Widget _buildLinksSection({
    required String title,
    required List<String> links,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.subtitle1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            links.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildFooterLink(links[index], primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تواصل معنا',
          style: TextStyles.subtitle1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        _buildContactItem(
          icon: Icons.phone,
          label: '+966 123 456 789',
          primaryColor: primaryColor,
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          icon: Icons.email,
          label: 'info@mcs.com',
          primaryColor: primaryColor,
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          icon: Icons.location_on,
          label: 'الرياض، السعودية',
          primaryColor: primaryColor,
        ),
      ],
    );
  }

  Widget _buildFooterLink(String label, Color primaryColor) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          label,
          style: TextStyles.body2.copyWith(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required Color primaryColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyles.body2.copyWith(color: Colors.white70),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(
    IconData icon,
    String label,
    Color color,
  ) {
    return Tooltip(
      message: label,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.2),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(Color primaryColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© 2024-2026 MCS. جميع الحقوق محفوظة.',
              style: TextStyles.caption.copyWith(color: Colors.white54),
            ),
            Row(
              children: [
                _buildBottomLink('سياسة الخصوصية', primaryColor),
                const SizedBox(width: 20),
                _buildBottomLink('شروط الاستخدام', primaryColor),
                const SizedBox(width: 20),
                _buildBottomLink('اتصل بنا', primaryColor),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomLink(String label, Color primaryColor) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Text(
          label,
          style: TextStyles.caption.copyWith(
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
