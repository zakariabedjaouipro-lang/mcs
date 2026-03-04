/// Patient Change Password Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/localization/app_localizations.dart';
import 'package:mcs/core/widgets/custom_button.dart';
import 'package:mcs/core/widgets/custom_text_field.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

/// Patient change password screen
class PatientChangePasswordScreen extends StatefulWidget {
  const PatientChangePasswordScreen({super.key});

  @override
  State<PatientChangePasswordScreen> createState() => _PatientChangePasswordScreenState();
}

class _PatientChangePasswordScreenState extends State<PatientChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('change_password')),
      ),
      body: BlocListener<PatientBloc, PatientState>(
        listener: (context, state) {
          if (state is PasswordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is PatientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context).translate('password_requirements'),
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Current Password
                CustomTextField(
                  controller: _currentPasswordController,
                  label: AppLocalizations.of(context).translate('current_password'),
                  hintText: AppLocalizations.of(context).translate('enter_current_password'),
                  prefixIcon: Icons.lock,
                  obscureText: _obscureCurrentPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context).translate('please_enter_current_password');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // New Password
                CustomTextField(
                  controller: _newPasswordController,
                  label: AppLocalizations.of(context).translate('new_password'),
                  hintText: AppLocalizations.of(context).translate('enter_new_password'),
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureNewPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context).translate('please_enter_new_password');
                    }
                    if (value.length < 8) {
                      return AppLocalizations.of(context).translate('password_too_short');
                    }
                    return null;
                  },
                  onChanged: (_) {
                    _formKey.currentState?.validate();
                  },
                ),
                const SizedBox(height: 8),
                
                // Password Strength Indicator
                _buildPasswordStrengthIndicator(),
                const SizedBox(height: 16),
                
                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: AppLocalizations.of(context).translate('confirm_password'),
                  hintText: AppLocalizations.of(context).translate('confirm_new_password'),
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context).translate('please_confirm_password');
                    }
                    if (value != _newPasswordController.text) {
                      return AppLocalizations.of(context).translate('passwords_do_not_match');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Change Password Button
                CustomButton(
                  text: AppLocalizations.of(context).translate('change_password'),
                  onPressed: _changePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = _newPasswordController.text;
    final strength = _calculatePasswordStrength(password);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context).translate('password_strength'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(width: 8),
            Text(
              strength.label,
              style: TextStyle(
                color: strength.color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: strength.value,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(strength.color),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).translate('password_requirements'),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrength(0, '', Colors.grey);
    }
    
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Complexity checks
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    
    if (score <= 2) {
      return PasswordStrength(0.33, AppLocalizations.of(context).translate('weak'), Colors.red);
    } else if (score <= 4) {
      return PasswordStrength(0.66, AppLocalizations.of(context).translate('medium'), Colors.orange);
    } else {
      return PasswordStrength(1.0, AppLocalizations.of(context).translate('strong'), Colors.green);
    }
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<PatientBloc>().add(ChangePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ));
    }
  }
}

class PasswordStrength {
  final double value;
  final String label;
  final Color color;
  
  PasswordStrength(this.value, this.label, this.color);
}