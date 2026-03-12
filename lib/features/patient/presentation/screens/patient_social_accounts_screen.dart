import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    extends State<PatientChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _currentHidden = true;
  bool _newHidden = true;
  bool _confirmHidden = true;

  late AnimationController _animationController;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.translateSafe('change_password')),
      ),
      body: BlocListener<PatientBloc, PatientState>(
        listener: (context, state) {
          if (state is PasswordChanged) {
            _showSuccessDialog(state.message);
          }

          if (state is PatientError) {
            _showError(state.message);
          }
        },
        child: FadeTransition(
          opacity: _fade,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(
                    Icons.lock_reset,
                    size: 70,
                    color: theme.colorScheme.primary,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    context.translateSafe('change_password'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Current Password
                  CustomTextField(
                    controller: _currentController,
                    label: context.translateSafe('current_password'),
                    hint: context.translateSafe('enter_current_password'),
                    prefixIcon: Icons.lock,
                    obscureText: _currentHidden,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _currentHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentHidden = !_currentHidden;
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

                  const SizedBox(height: 18),

                  /// New Password
                  CustomTextField(
                    controller: _newController,
                    label: context.translateSafe('new_password'),
                    hint: context.translateSafe('enter_new_password'),
                    prefixIcon: Icons.lock_outline,
                    obscureText: _newHidden,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _newHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _newHidden = !_newHidden;
                        });
                      },
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.translateSafe(
                          'please_enter_new_password',
                        );
                      }

                      if (value.length < 8) {
                        return context.translateSafe(
                          'password_too_short',
                        );
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  _buildStrengthMeter(),

                  const SizedBox(height: 18),

                  /// Confirm Password
                  CustomTextField(
                    controller: _confirmController,
                    label: context.translateSafe('confirm_password'),
                    hint: context.translateSafe('confirm_new_password'),
                    prefixIcon: Icons.lock_outline,
                    obscureText: _confirmHidden,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmHidden = !_confirmHidden;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.translateSafe(
                          'please_confirm_password',
                        );
                      }

                      if (value != _newController.text) {
                        return context.translateSafe(
                          'passwords_do_not_match',
                        );
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  BlocBuilder<PatientBloc, PatientState>(
                    builder: (context, state) {
                      final loading = state is PatientLoading;

                      return CustomButton(
                        label: loading
                            ? context.translateSafe('loading')
                            : context.translateSafe('change_password'),
                        onPressed: loading ? null : _changePassword,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthMeter() {
    final password = _newController.text;
    final strength = _calculateStrength(password);

    return Column(
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
              currentPassword: _currentController.text,
              newPassword: _newController.text,
            ),
          );
    }
  }

  void _showSuccessDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
        ],
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
}

class PasswordStrength {
  PasswordStrength(this.value, this.label, this.color);

  final double value;
  final String label;
  final Color color;
}
