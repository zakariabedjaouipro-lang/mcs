import 'package:flutter/material.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/widgets/responsive_layout.dart';
import 'package:mcs/features/landing/widgets/contact_form.dart';
import 'package:mcs/features/landing/widgets/social_links.dart';

/// صفحة الاتصال بنا - تحتوي على نموذج الاتصال ومعلومات التواصل
class ContactScreenLanding extends StatelessWidget {
  const ContactScreenLanding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section
          _buildHeaderSection(context),
          SizedBox(height: 60),

          // Contact Content
          ResponsiveLayout(
            mobile: _buildMobileLayout(context),
            tablet: _buildTabletLayout(context),
            desktop: _buildDesktopLayout(context),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'اتصل بنا',
            style: TextStyles.heading1.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'نحن هنا للإجابة على جميع استفساراتك',
            style: TextStyles.body1.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.phone,
            label: 'الهاتف',
            value: '+966123456789',
            onTap: () {},
          ),
          SizedBox(height: 16),
          _buildInfoCard(
            icon: Icons.email,
            label: 'البريد الإلكتروني',
            value: 'info@mcs.com',
            onTap: () {},
          ),
          SizedBox(height: 16),
          _buildInfoCard(
            icon: Icons.location_on,
            label: 'العنوان',
            value: 'الرياض، المملكة العربية السعودية',
            onTap: () {},
          ),
          SizedBox(height: 32),
          _buildMapPlaceholder(),
          SizedBox(height: 32),
          ContactFormWidget(),
          SizedBox(height: 32),
          _buildSocialSection(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.phone,
                  label: 'الهاتف',
                  value: '+966123456789',
                  onTap: () {},
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.email,
                  label: 'البريد الإلكتروني',
                  value: 'info@mcs.com',
                  onTap: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildInfoCard(
            icon: Icons.location_on,
            label: 'العنوان',
            value: 'الرياض، المملكة العربية السعودية',
            onTap: () {},
          ),
          SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMapPlaceholder(),
              ),
              SizedBox(width: 40),
              Expanded(
                child: ContactFormWidget(),
              ),
            ],
          ),
          SizedBox(height: 40),
          _buildSocialSection(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.phone,
                  label: 'الهاتف',
                  value: '+966123456789',
                  onTap: () {},
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.email,
                  label: 'البريد الإلكتروني',
                  value: 'info@mcs.com',
                  onTap: () {},
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.location_on,
                  label: 'العنوان',
                  value: 'الرياض، السعودية',
                  onTap: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 60),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _buildMapPlaceholder(),
              ),
              SizedBox(width: 60),
              Expanded(
                flex: 1,
                child: ContactFormWidget(),
              ),
            ],
          ),
          SizedBox(height: 60),
          _buildSocialSection(),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              SizedBox(height: 12),
              Text(
                label,
                style: TextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyles.body2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 350,
        color: AppColors.grey.withOpacity(0.1),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 80,
              color: AppColors.primary.withOpacity(0.3),
            ),
            Positioned(
              bottom: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'الرياض',
                  style: TextStyles.subtitle2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        Text(
          'تابعنا على وسائل التواصل الاجتماعي',
          style: TextStyles.heading3.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        SocialLinksWidget(),
      ],
    );
  }
}
