/// Two-Factor Authentication Verification Screen
/// شاشة التحقق من المصادقة الثنائية أثناء تسجيل الدخول
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/extensions/context_extension.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_state.dart';

class TwoFactorAuthVerifyScreen extends StatefulWidget {
  const TwoFactorAuthVerifyScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  State<TwoFactorAuthVerifyScreen> createState() =>
      _TwoFactorAuthVerifyScreenState();
}

class _TwoFactorAuthVerifyScreenState extends State<TwoFactorAuthVerifyScreen> {
  final _codeController = TextEditingController();
  bool _verified = false;
  int _attemptCount = 0;
  static const int _maxAttempts = 3;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify2FA() {
    if (_codeController.text.isEmpty) {
      _showError(
        context.isArabic
            ? 'يرجى إدخال الرمز'
            : 'Please enter the code',
      );
      return;
    }

    if (_attemptCount >= _maxAttempts) {
      _showError(
        context.isArabic
            ? 'تم عدد المحاولات القصوى'
            : 'Maximum attempts exceeded',
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
      return;
    }

    context.read<AdvancedAuthBloc>().add(
          TwoFactorAuthVerificationRequested(
            userId: widget.userId,
            code: _codeController.text.trim(),
          ),
        );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.isArabic
              ? 'التحقق من الهويتين'
              : '2FA Verification',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<AdvancedAuthBloc, AdvancedAuthState>(
        listener: (context, state) {
          if (state is TwoFactorAuthVerificationSuccess) {
            setState(() => _verified = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              }
            });
          } else if (state is TwoFactorAuthVerificationFailure) {
            setState(() => _attemptCount++);
            _showError(state.message);
            _codeController.clear();
          }
        },
        child: BlocBuilder<AdvancedAuthBloc, AdvancedAuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // Header
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Center(
                    child: Text(
                      context.isArabic
                          ? 'التحقق من الهويتين'
                          : '2FA Verification',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Center(
                    child: Text(
                      context.isArabic
                          ? 'أدخل رمز التحقق من تطبيق المصادقة'
                          : 'Enter the verification code from your authenticator app',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Code Input
                  if (!_verified)
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText:
                            context.isArabic ? 'الرمز' : 'Verification Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.security),
                      ),
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),

                  if (_verified)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.isArabic
                                  ? 'تم التحقق بنجاح'
                                  : 'Verified Successfully',
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Attempts Counter
                  if (!_verified)
                    Center(
                      child: Text(
                        context.isArabic
                            ? 'محاولات متبقية: ${_maxAttempts - _attemptCount}'
                            : 'Attempts remaining: ${_maxAttempts - _attemptCount}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange,
                            ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Verify Button
                  if (!_verified)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state is AdvancedAuthLoading
                            ? null
                            : _verify2FA,
                        child: state is AdvancedAuthLoading
                            ? const CircularProgressIndicator()
                            : Text(context.isArabic ? 'تحقق' : 'Verify'),
                      ),
                    ),

                  if (_verified)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.check_circle),
                        label: Text(
                          context.isArabic ? 'تم التحقق' : 'Verified',
                        ),
                      ),
                    ),
                ],
              );
            );
          },
        ),
      ),
    );
  }
}
