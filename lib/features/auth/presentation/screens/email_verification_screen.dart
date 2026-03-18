/// Email Verification Screen
/// شاشة التحقق من البريد الإلكتروني
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_state.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _codeController = TextEditingController();
  bool _codeVerified = false;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    // Send verification link
    context.read<AdvancedAuthBloc>().add(
          EmailVerificationRequested(widget.userId),
        );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyEmail() {
    if (_codeController.text.isEmpty) {
      _showError(
        _isArabic ? 'يرجى إدخال رمز التحقق' : 'Please enter verification code',
      );
      return;
    }

    context.read<AdvancedAuthBloc>().add(
          EmailVerificationTokenSubmitted(
            userId: widget.userId,
            token: _codeController.text.trim(),
          ),
        );
  }

  void _resendCode() {
    context.read<AdvancedAuthBloc>().add(
          EmailVerificationRequested(widget.userId),
        );
  }

  void _showError(String message) {
    if (!mounted) return;
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
        title: Text(_isArabic ? 'التحقق من البريد' : 'Email Verification'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<AdvancedAuthBloc, AdvancedAuthState>(
        listener: (context, state) {
          if (state is EmailVerificationLinkSent) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.blue,
              ),
            );
          } else if (state is EmailVerifiedSuccess) {
            setState(() => _codeVerified = true);
            if (!mounted) return;
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
          } else if (state is EmailVerificationFailure) {
            _showError(state.message);
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
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_unread,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Center(
                    child: Text(
                      _isArabic
                          ? 'تحقق من بريدك الإلكتروني'
                          : 'Verify Your Email',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Center(
                    child: Text(
                      _isArabic
                          ? 'لقد أرسلنا رمز التحقق إلى بريدك الإلكتروني'
                          : 'We sent a verification code to your email',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Verification Code Input
                  TextField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: _isArabic ? 'رمز التحقق' : 'Verification Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.security),
                      enabled: !_codeVerified,
                    ),
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),

                  // Verify Button
                  if (!_codeVerified)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                            state is AdvancedAuthLoading ? null : _verifyEmail,
                        child: state is AdvancedAuthLoading
                            ? const CircularProgressIndicator()
                            : Text(_isArabic ? 'تحقق' : 'Verify'),
                      ),
                    ),

                  if (_codeVerified)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.check_circle),
                        label: Text(
                          _isArabic ? 'تم التحقق' : 'Verified',
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Resend Code
                  if (!_codeVerified)
                    Center(
                      child: TextButton(
                        onPressed:
                            state is AdvancedAuthLoading ? null : _resendCode,
                        child: Text(
                          _isArabic ? 'إعادة إرسال رمز' : 'Resend Code',
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
