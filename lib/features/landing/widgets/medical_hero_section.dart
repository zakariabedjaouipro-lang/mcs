/// Professional medical hero section for landing page
/// Features animated crescent logo, headline, and CTA buttons
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/landing/widgets/medical_crescent_logo.dart';
import 'package:mcs/features/landing/widgets/medical_cta_button.dart';

class MedicalHeroSection extends StatefulWidget {
  const MedicalHeroSection({
    super.key,
    required this.onLoginPressed,
    required this.onRegisterPressed,
  });
  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;

  @override
  State<MedicalHeroSection> createState() => _MedicalHeroSectionState();
}

class _MedicalHeroSectionState extends State<MedicalHeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = context.isSmall;
    final isMedium = context.isMedium;
    final isDark = context.isDarkMode;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: MedicalColors.medicalGradient,
      ),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 48,
              vertical: isSmall ? 40 : 80,
            ),
            child: Column(
              children: [
                // Floating logo
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_floatingAnimation.value),
                      child: child,
                    );
                  },
                  child: MedicalCrescentLogo(
                    size: isSmall
                        ? 80
                        : isMedium
                            ? 100
                            : 120,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isSmall ? 24 : 32),

                // Main headline
                Text(
                  'Medical Clinic\nManagement System',
                  style: TextStyles.headlineLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmall
                        ? 32
                        : isMedium
                            ? 44
                            : 56,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmall ? 16 : 20),

                // Subtitle
                Text(
                  'Streamline clinic operations, enhance patient care, and manage appointments with a comprehensive, modern healthcare management platform.',
                  style: TextStyles.titleMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: isSmall
                        ? 14
                        : isMedium
                            ? 16
                            : 18,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                SizedBox(height: isSmall ? 32 : 48),

                // CTA Buttons
                _buildButtonRow(context),
                SizedBox(height: isSmall ? 20 : 40),

                // Decorative feature highlight
                _buildFeatureHighlight(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    final isSmall = context.isSmall;

    return Wrap(
      spacing: isSmall ? 12 : 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        MedicalCTAButton(
          label: 'Sign In',
          onPressed: widget.onLoginPressed,
          isSmall: isSmall,
          icon: Icons.login,
        ),
        MedicalCTAButton(
          label: 'Create Account',
          onPressed: widget.onRegisterPressed,
          isPrimary: false,
          isSmall: isSmall,
          icon: Icons.person_add,
        ),
      ],
    );
  }

  Widget _buildFeatureHighlight(BuildContext context) {
    final isSmall = context.isSmall;

    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user,
            color: Colors.white.withValues(alpha: 0.9),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'Trusted by healthcare professionals worldwide',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isSmall ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
