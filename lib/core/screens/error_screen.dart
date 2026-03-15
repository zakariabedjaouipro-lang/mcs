/// Error Screen - Shown When Initialization Fails
///
/// Displays error information with a retry button to recover from
/// initialization failures (Supabase, dependencies, BLoCs, etc.)
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcs/core/theme/medical_colors.dart';
import 'package:mcs/core/utils/responsive_utils.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.error,
    required this.onRetry,
    super.key,
    this.title = 'Ø®Ø·Ø£ ÙÙŠ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚',
    this.subtitle = 'Ø­Ø¯Ø« Ø®Ø·Ø£ Ø£Ø«Ù†Ø§Ø¡ ØªØ­Ù…ÙŠÙ„ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚',
  });

  /// Error message to display
  final String error;

  /// Title of the error
  final String title;

  /// Subtitle/description of the error
  final String subtitle;

  /// Callback when retry button is pressed
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MedicalColors.error.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48.sp,
                  color: MedicalColors.error,
                ),
              ),

              SizedBox(height: context.buttonHeight),

              // Error Title
              Text(
                title,
                style: TextStyle(
                  fontSize: context.heading2Size,
                  fontWeight: FontWeight.w700,
                  color: MedicalColors.error,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: context.formFieldSpacing),

              // Error Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: context.bodyMediumSize,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: context.verticalPadding),

              // Error Details (scrollable for long errors)
              SizedBox(
                height: 120.h,
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(context.cardPadding),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(context.borderRadius),
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      error,
                      style: TextStyle(
                        fontSize: context.bodySmallSize,
                        color: Colors.grey[700],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: context.verticalPadding * 2),

              // Retry Button
              SizedBox(
                width: double.infinity,
                height: context.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    'Ø­Ø§ÙˆÙ„ Ù…Ø±Ø© Ø£Ø®Ø±Ù‰',
                    style: TextStyle(
                      fontSize: context.buttonTextSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MedicalColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.borderRadius),
                    ),
                  ),
                ),
              ),

              SizedBox(height: context.verticalPadding),

              // Close Button (fallback)
              SizedBox(
                width: double.infinity,
                height: context.buttonHeight,
                child: OutlinedButton(
                  onPressed: () {
                    // Gracefully exit the app (consider safer alternatives)
                    // In production, might show help text instead
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.borderRadius),
                    ),
                  ),
                  child: Text(
                    'Ø¥ØºÙ„Ø§Ù‚ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚',
                    style: TextStyle(
                      fontSize: context.buttonTextSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
