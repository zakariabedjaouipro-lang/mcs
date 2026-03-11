import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/validators.dart';
import 'package:mcs/features/auth/presentation/bloc/index.dart';

/// شاشة استعادة كلمة المرور - إدخال البريد أو الهاتف وإرسال رمز التحقق
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();

  String _contactMethod = 'email'; // email or phone

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleSendVerification(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          ForgotPasswordSubmitted(
            contactInfo: _inputController.text.trim(),
            method: _contactMethod,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // توجيه إلى شاشة التحقق من OTP
          Navigator.of(context).pushNamed(
            '/otp-verification',
            arguments: _inputController.text.trim(),
          );
        } else if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'استعادة كلمة المرور',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Illustration
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_reset,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Header
                    Text(
                      'أنسيت كلمة المرور؟',
                      style: TextStyles.heading2.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لا تقلق! أدخل بريدك الإلكتروني أو رقم هاتفك وسنرسل لك رمز التحقق',
                      style: TextStyles.body1.copyWith(color: AppColors.grey),
                    ),
                    const SizedBox(height: 40),

                    // Contact Method Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildMethodButton(
                              label: 'البريد الإلكتروني',
                              method: 'email',
                              isSelected: _contactMethod == 'email',
                              isLoading: isLoading,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMethodButton(
                              label: 'رقم الهاتف',
                              method: 'phone',
                              isSelected: _contactMethod == 'phone',
                              isLoading: isLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _inputController,
                            decoration: _buildInputDecoration(),
                            keyboardType: _contactMethod == 'email'
                                ? TextInputType.emailAddress
                                : TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال ${_contactMethod == 'email' ? 'البريد الإلكتروني' : 'رقم الهاتف'}';
                              }

                              if (_contactMethod == 'email') {
                                if (!Validators.isValidEmail(value)) {
                                  return 'البريد الإلكتروني غير صحيح';
                                }
                              } else {
                                if (!Validators.isValidPhoneNumber(value)) {
                                  return 'رقم الهاتف غير صحيح';
                                }
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () => _handleSendVerification(context),
                              icon: const Icon(Icons.send),
                              label: Text(
                                'إرسال رمز التحقق',
                                style: TextStyles.subtitle1.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor:
                                    AppColors.primary.withValues(alpha: 0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Back to Login
                          Center(
                            child: GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              child: Text(
                                'العودة إلى تسجيل الدخول',
                                style: TextStyles.subtitle2.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'سيتم إرسال رمز تحقق من 6 أرقام. سيكون الرمز صالحاً لمدة 10 دقائق',
                              style: TextStyles.body2.copyWith(
                                color: AppColors.greyDark,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMethodButton({
    required String label,
    required String method,
    required bool isSelected,
    required bool isLoading,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : () => setState(() => _contactMethod = method),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              label,
              style: TextStyles.subtitle2.copyWith(
                color: isSelected ? AppColors.primary : AppColors.grey,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      labelText: _contactMethod == 'email' ? 'البريد الإلكتروني' : 'رقم الهاتف',
      hintText: _contactMethod == 'email' ? 'example@mail.com' : '0501234567',
      prefixIcon: Icon(
        _contactMethod == 'email' ? Icons.email : Icons.phone,
        color: AppColors.primary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
