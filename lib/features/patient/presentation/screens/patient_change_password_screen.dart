import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/extensions/context_extensions.dart';
import 'package:mcs/core/widgets/custom_button.dart';
import 'package:mcs/core/widgets/custom_text_field.dart';
import 'package:mcs/features/patient/presentation/bloc/index.dart';

class PatientChangePasswordScreen extends StatefulWidget {
  const PatientChangePasswordScreen({super.key});

  @override
  State<PatientChangePasswordScreen> createState() =>
      _PatientChangePasswordScreenState();
}

class _PatientChangePasswordScreenState
    extends State<PatientChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translateSafe('change_password'),
          style: theme.textTheme.titleLarge,
        ),
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

            if (context.canPop()) {
              context.pop();
            }
          }

          if (state is PatientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// Header
                Icon(
                  Icons.lock_reset,
                  size: 70,
                  color: theme.colorScheme.primary,
                ),

                const SizedBox(height: 12),

                Text(
                  context.translateSafe('update_your_password'),
                  style: theme.textTheme.titleMedium,
                ),

                const SizedBox(height: 32),

                /// Current Password
                CustomTextField(
                  controller: _currentPasswordController,
                  label: context.translateSafe('current_password'),
                  hint: context.translateSafe('enter_current_password'),
                  prefixIcon: Icons.lock,
                  obscureText: _obscureCurrent,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrent = !_obscureCurrent;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.translateSafe(
                        'please_enter_current_password',
                      );
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                /// New Password
                CustomTextField(
                  controller: _newPasswordController,
                  label: context.translateSafe('new_password'),
                  hint: context.translateSafe('enter_new_password'),
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureNew,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.translateSafe(
                        'please_enter_new_password',
                      );
                    }

                    if (value.length < 8) {
                      return context.translateSafe('password_too_short');
                    }

                    return null;
                  },
                  onChanged: (_) {
                    setState(() {});
                  },
                ),

                const SizedBox(height: 10),

                _passwordStrengthIndicator(),

                const SizedBox(height: 20),

                /// Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: context.translateSafe('confirm_password'),
                  hint: context.translateSafe('confirm_new_password'),
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.translateSafe(
                        'please_confirm_password',
                      );
                    }

                    if (value != _newPasswordController.text) {
                      return context.translateSafe(
                        'passwords_do_not_match',
                      );
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                /// Button
                CustomButton(
                  label: context.translateSafe('change_password'),
                  onPressed: _changePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordStrengthIndicator() {
    final password = _newPasswordController.text;
    final strength = _calculateStrength(password);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strength.label,
            style: TextStyle(
              color: strength.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: strength.value,
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(strength.color),
          ),
        ],
      ),
    );
  }

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrength(0, '', Colors.grey);
    }

    var score = 0;

    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp('[A-Z]'))) score++;
    if (password.contains(RegExp('[a-z]'))) score++;
    if (password.contains(RegExp('[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) {
      return PasswordStrength(0.3, 'Weak', Colors.red);
    }

    if (score <= 4) {
      return PasswordStrength(0.6, 'Medium', Colors.orange);
    }

    return PasswordStrength(1, 'Strong', Colors.green);
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<PatientBloc>().add(
            ChangePassword(
              currentPassword: _currentPasswordController.text,
              newPassword: _newPasswordController.text,
            ),
          );
    }
  }
}

class PasswordStrength {
  PasswordStrength(this.value, this.label, this.color);

  final double value;
  final String label;
  final Color color;
}
