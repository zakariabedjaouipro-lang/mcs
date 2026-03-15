/// Splash Screen - Shown During App Initialization
///
/// This screen is displayed while the app initializes:
/// - Loading Supabase configuration
/// - Initializing dependency injection
/// - Loading theme and locale preferences
/// - Initializing BLoCs
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/utils/responsive_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.message = 'جاري تحميل التطبيق...',
  });

  /// Optional loading message
  final String message;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Medical Logo/Crescent Symbol
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MedicalColors.primary.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.favorite,
                  size: 48,
                  color: MedicalColors.primary,
                ),
              ),
            ),

            SizedBox(height: context.buttonHeight),

            // App Title
            Text(
              'MCS',
              style: TextStyle(
                fontSize: context.heading1Size,
                fontWeight: FontWeight.w800,
                color: context.isMobile
                    ? MedicalColors.primary
                    : MedicalColors.primary,
              ),
            ),

            SizedBox(height: context.formFieldSpacing),

            // Subtitle
            Text(
              'Medical Clinic System',
              style: TextStyle(
                fontSize: context.bodyMediumSize,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: context.verticalPadding * 2),

            // Loading Indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  MedicalColors.primary,
                ),
              ),
            ),

            SizedBox(height: context.verticalPadding),

            // Loading Message
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.horizontalPadding,
              ),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.bodySmallSize,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
