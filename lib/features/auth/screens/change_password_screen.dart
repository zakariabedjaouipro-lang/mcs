import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/features/auth/presentation/bloc/index.dart';

/// شاشة تغيير كلمة المرور - مع شروط قوة كلمة المرور
class ChangePasswordScreen extends StatefulWidget {
  // اختياري إذا أراد المستخدم تغيير كلمته الحالية

  const ChangePasswordScreen({
    super.key,
    this.isForcedChange = false,
    this.currentPassword,
  });
  final bool isForcedChange; // هل هو تغيير إجباري بعد تسجيل دخول أول مرة؟
  final String? currentPassword;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Password strength indicators
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp('[A-Z]'));
      _hasLowercase = password.contains(RegExp('[a-z]'));
      _hasNumber = password.contains(RegExp(r'\d'));
      _hasSpecialChar =
          password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}:";,.<>?]'));
    });
  }

  bool _isPasswordStrong(String password) {
    return _hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasNumber &&
        _hasSpecialChar;
  }

  void _handleChangePassword(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمات المرور غير متطابقة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isPasswordStrong(_newPasswordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمة المرور لا تلبي متطلبات الأمان'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // If forced change (after password reset via email), use ChangePasswordSubmitted
    // because the user needs to provide new password only
    context.read<AuthBloc>().add(
          ChangePasswordSubmitted(
            currentPassword:
                widget.isForcedChange ? '' : _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تغيير كلمة المرور بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          if (widget.isForcedChange) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          } else {
            Navigator.pop(context);
          }
        } else if (state is PasswordResetFailure) {
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
            appBar: widget.isForcedChange
                ? null
                : AppBar(
                    title: Text(
                      'تغيير كلمة المرور',
                      style: TextStyles.subtitle1
                          .copyWith(fontWeight: FontWeight.w700),
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
                    SizedBox(height: widget.isForcedChange ? 60 : 40),

                    // Header
                    if (widget.isForcedChange)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.security,
                              size: 40,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),

                    Text(
                      widget.isForcedChange
                          ? 'تغيير كلمة المرور الإجبارية'
                          : 'تغيير كلمة المرور',
                      style: TextStyles.heading1.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isForcedChange
                          ? 'لحماية حسابك، يجب عليك تغيير كلمة المرور عند تسجيل الدخول للمرة الأولى'
                          : 'اختر كلمة مرور قوية وآمنة',
                      style: TextStyles.body1.copyWith(color: AppColors.grey),
                    ),
                    const SizedBox(height: 40),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Current Password Field (إذا لم تكن تغيير إجباري)
                          if (!widget.isForcedChange) ...[
                            TextFormField(
                              controller: _currentPasswordController,
                              decoration: _buildInputDecoration(
                                label: 'كلمة المرور الحالية',
                                icon: Icons.lock,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureCurrentPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.grey,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () => _obscureCurrentPassword =
                                          !_obscureCurrentPassword,
                                    );
                                  },
                                ),
                              ),
                              obscureText: _obscureCurrentPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال كلمة المرور الحالية';
                                }
                                return null;
                              },
                              enabled: !isLoading,
                            ),
                            const SizedBox(height: 20),
                          ],

                          // New Password Field
                          TextFormField(
                            controller: _newPasswordController,
                            decoration: _buildInputDecoration(
                              label: 'كلمة المرور الجديدة',
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscureNewPassword =
                                        !_obscureNewPassword,
                                  );
                                },
                              ),
                            ),
                            obscureText: _obscureNewPassword,
                            onChanged: _updatePasswordStrength,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال كلمة مرور جديدة';
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // Password Strength Indicators
                          _buildPasswordStrengthIndicators(),
                          const SizedBox(height: 20),

                          // Confirm Password Field
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: _buildInputDecoration(
                              label: 'تأكيد كلمة المرور',
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  );
                                },
                              ),
                            ),
                            obscureText: _obscureConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء تأكيد كلمة المرور';
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 32),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _handleChangePassword(context),
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
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'تغيير كلمة المرور',
                                      style: TextStyles.subtitle1.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 40),
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

  Widget _buildPasswordStrengthIndicators() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'متطلبات كلمة المرور القوية:',
          style: TextStyles.subtitle2.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildStrengthItem('8 أحرف على الأقل', _hasMinLength),
        _buildStrengthItem('أحرف كبيرة وصغيرة', _hasUppercase && _hasLowercase),
        _buildStrengthItem('رقم واحد على الأقل', _hasNumber),
        _buildStrengthItem(r'رمز خاص (مثل !@#$%)', _hasSpecialChar),
      ],
    );
  }

  Widget _buildStrengthItem(String label, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isValid
                  ? Colors.green
                  : AppColors.grey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: isValid
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyles.body2.copyWith(
              color: isValid ? Colors.black : AppColors.grey,
              fontWeight: isValid ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      suffixIcon: suffixIcon,
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
