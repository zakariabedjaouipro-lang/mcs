/// Unified Registration Screen with Role Selection
/// شاشة التسجيل الموحدة مع اختيار الدور
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/extensions/context_extension.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/core/theme/app_theme.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_state.dart';

class UnifiedRegistrationScreen extends StatefulWidget {
  const UnifiedRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<UnifiedRegistrationScreen> createState() =>
      _UnifiedRegistrationScreenState();
}

class _UnifiedRegistrationScreenState extends State<UnifiedRegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RoleModel? _selectedRole;
  bool _showPassword = false;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    // Load available roles
    context
        .read<AdvancedAuthBloc>()
        .add(const LoadAvailableRolesRequested(publicOnly: true));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        _showError('يرجى اختيار دور');
        return;
      }

      if (!_agreeToTerms) {
        _showError('يرجى الموافقة على الشروط والأحكام');
        return;
      }

      context.read<AdvancedAuthBloc>().add(
            RoleBasedRegistrationSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              fullName: _fullNameController.text.trim(),
              roleId: _selectedRole!.id,
              phone: _phoneController.text.trim(),
            ),
          );
    }
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
        title: Text(context.isArabic ? 'تسجيل جديد' : 'Sign Up'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<AdvancedAuthBloc, AdvancedAuthState>(
        listener: (context, state) {
          if (state is RoleBasedRegistrationSuccess) {
            if (_selectedRole!.requiresApproval) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.orange,
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) Navigator.pop(context);
              });
            } else if (_selectedRole!.requiresEmailVerification) {
              Navigator.pushNamed(context, '/email-verification',
                  arguments: state.userProfile.id);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) Navigator.pop(context);
              });
            }
          } else if (state is RoleBasedRegistrationFailure) {
            _showError(state.message);
          }
        },
        child: BlocBuilder<AdvancedAuthBloc, AdvancedAuthState>(
          builder: (context, state) {
            if (state is AdvancedAuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RolesLoadedSuccess) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role Selection
                      Text(
                        context.isArabic ? 'اختر الدور' : 'Select Role',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<RoleModel>(
                        value: _selectedRole,
                        items: state.roles
                            .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(context.isArabic
                                      ? role.displayNameAr
                                      : role.displayNameEn),
                                ))
                            .toList(),
                        onChanged: (role) {
                          setState(() => _selectedRole = role);
                          context
                              .read<AdvancedAuthBloc>()
                              .add(RoleSelected(role!));
                        },
                        decoration: InputDecoration(
                          labelText: context.isArabic ? 'الدور' : 'Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.work),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return context.isArabic
                                ? 'يرجى اختيار دور'
                                : 'Please select a role';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Full Name
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText:
                              context.isArabic ? 'الاسم الكامل' : 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.isArabic
                                ? 'يرجى إدخال الاسم الكامل'
                                : 'Please enter full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText:
                              context.isArabic ? 'البريد الإلكتروني' : 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.isArabic
                                ? 'يرجى إدخال البريد الإلكتروني'
                                : 'Please enter email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return context.isArabic
                                ? 'البريد الإلكتروني غير صحيح'
                                : 'Invalid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone (Optional)
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: context.isArabic
                              ? 'رقم الهاتف (اختياري)'
                              : 'Phone (Optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          labelText:
                              context.isArabic ? 'كلمة المرور' : 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.isArabic
                                ? 'يرجى إدخال كلمة المرور'
                                : 'Please enter password';
                          }
                          if (value.length < 8) {
                            return context.isArabic
                                ? 'كلمة المرور يجب أن تكون 8 أحرف على الأقل'
                                : 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Terms and Conditions
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) =>
                                setState(() => _agreeToTerms = value ?? false),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _agreeToTerms = !_agreeToTerms),
                              child: Text(
                                context.isArabic
                                    ? 'أوافق على الشروط والأحكام'
                                    : 'I agree to Terms and Conditions',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: state is AdvancedAuthLoading
                              ? null
                              : _submitRegistration,
                          child: state is AdvancedAuthLoading
                              ? const CircularProgressIndicator()
                              : Text(context.isArabic ? 'تسجيل' : 'Sign Up'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Login Link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: context.isArabic
                                ? 'لديك حساب بالفعل؟ '
                                : 'Already have account? ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: context.isArabic
                                    ? 'تسجيل الدخول'
                                    : 'Sign In',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is RolesLoadedFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AdvancedAuthBloc>().add(
                              const LoadAvailableRolesRequested(
                                  publicOnly: true),
                            );
                      },
                      child: Text(context.isArabic ? 'إعادة محاولة' : 'Retry'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class TapGestureRecognizer extends GestureRecognizer {
  TapGestureRecognizer({
    VoidCallback? onTap,
  }) : _onTap = onTap;

  final VoidCallback? _onTap;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent) {
      stopTrackingPointer(event.pointer);
      _onTap?.call();
    }
  }

  @override
  String get debugDescription => 'tap';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
