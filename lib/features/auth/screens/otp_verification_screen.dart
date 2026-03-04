import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/features/auth/presentation/bloc/index.dart';

/// شاشة التحقق بـ OTP - 6 حقول أرقام مع تنقل تلقائي وعداد زمني
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    this.contactInfo = '***@mail.com',
    this.contactMethod = 'email',
    this.onVerificationComplete,
  });

  final String contactInfo;
  final String contactMethod;
  final VoidCallback? onVerificationComplete;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with TickerProviderStateMixin {
  late List<TextEditingController> _otpControllers;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _setupShakeAnimation();
  }

  void _setupShakeAnimation() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void _handleOtpSubmit(BuildContext context) {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال الرمز كاملاً'),
          backgroundColor: Colors.red,
        ),
      );
      _shakeController.forward(from: 0);
      return;
    }

    context
        .read<AuthBloc>()
        .add(OtpSubmitted(otp: otp, email: widget.contactInfo));
  }

  void _handleResendOtp(BuildContext context) {
    context.read<AuthBloc>().add(
          ResendOtpRequested(
            email: widget.contactInfo,
            method: widget.contactMethod,
          ),
        );
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم التحقق بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onVerificationComplete?.call();
          // Navigate to reset password or home
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/reset-password',
            (route) => false,
          );
        } else if (state is OtpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          _shakeController.forward(from: 0);
        } else if (state is OtpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إعادة إرسال الرمز'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          const remainingSeconds = 0;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'التحقق من الهوية',
                style:
                    TextStyles.subtitle1.copyWith(fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Illustration
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Header
                    Text(
                      'تحقق من بيانات حسابك',
                      style: TextStyles.heading2.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'أدخل رمز التحقق المكون من 6 أرقام\nالذي تم إرساله إلى:',
                      style: TextStyles.body1.copyWith(color: AppColors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.contactInfo,
                        style: TextStyles.subtitle2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // OTP Input Fields
                    _buildOtpInput(),
                    const SizedBox(height: 24),

                    // Error Message
                    if (state is OtpFailure)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              state.message,
                              style:
                                  TextStyles.body2.copyWith(color: Colors.red),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox(height: 24),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            isLoading ? null : () => _handleOtpSubmit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor:
                              AppColors.primary.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'تحقق',
                                style: TextStyles.subtitle1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Resend Code Section
                    Column(
                      children: [
                        Text(
                          'لم تستقبل الرمز؟',
                          style:
                              TextStyles.body2.copyWith(color: AppColors.grey),
                        ),
                        const SizedBox(height: 8),
                        if (remainingSeconds > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'أعد الإرسال خلال ',
                                style: TextStyles.body2.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                              Text(
                                '${remainingSeconds}s',
                                style: TextStyles.body2.copyWith(
                                  color: const Color(0xFFF59E0B),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        else
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () => _handleResendOtp(context),
                            child: Text(
                              'أعد الإرسال',
                              style: TextStyles.body2.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpInput() {
    return ShakeTransition(
      animation: _shakeController,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _buildOtpField(index),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: _otpControllers[index].text.isEmpty
              ? AppColors.grey
              : AppColors.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: _otpControllers[index].text.isEmpty
            ? Colors.white
            : AppColors.primary.withValues(alpha: 0.05),
      ),
      child: Center(
        child: TextField(
          controller: _otpControllers[index],
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '',
            hintText: '-',
            hintStyle: TextStyles.heading2.copyWith(color: AppColors.grey),
          ),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyles.heading3.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          onChanged: (value) {
            setState(() {});
            context
                .read<AuthBloc>()
                .add(OtpDigitChanged(digit: value, index: index));
            if (value.isNotEmpty && index < 5) {
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).previousFocus();
            }
          },
          enabled: true,
        ),
      ),
    );
  }
}

/// Widget لتأثير الاهتزاز
class ShakeTransition extends StatelessWidget {
  const ShakeTransition({
    required this.animation,
    required this.child,
    super.key,
  });
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final offset = sin(animation.value * 6.28) * 10;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}
