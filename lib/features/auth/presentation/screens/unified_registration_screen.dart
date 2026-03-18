/// Unified Registration Screen with Role Selection
/// شاشة التسجيل الموحدة مع اختيار الدور
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_state.dart';

class UnifiedRegistrationScreen extends StatefulWidget {
  const UnifiedRegistrationScreen({super.key});

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

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  void _loadRoles() {
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
        _showError(_isArabic ? 'يرجى اختيار دور' : 'Please select a role');
        return;
      }

      if (!_agreeToTerms) {
        _showError(
          _isArabic
              ? 'يرجى الموافقة على الشروط والأحكام'
              : 'Please agree to terms and conditions',
        );
        return;
      }

      context.read<AdvancedAuthBloc>().add(
            RoleBasedRegistrationSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              fullName: _fullNameController.text.trim(),
              roleId: _selectedRole!.id,
              phone: _phoneController.text.trim().isEmpty
                  ? null
                  : _phoneController.text.trim(),
            ),
          );
    }
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

  void _handleRegistrationSuccess(
    BuildContext context,
    RoleBasedRegistrationSuccess state,
  ) {
    if (_selectedRole != null && _selectedRole!.requiresApproval) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.orange,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    } else if (_selectedRole != null &&
        _selectedRole!.requiresEmailVerification) {
      Navigator.pushNamed(
        context,
        '/email-verification',
        arguments: state.userProfile.id,
      );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isArabic ? 'تسجيل جديد' : 'Sign Up'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<AdvancedAuthBloc, AdvancedAuthState>(
        listener: (context, state) {
          if (state is RoleBasedRegistrationSuccess) {
            _handleRegistrationSuccess(context, state);
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
                        _isArabic ? 'اختر الدور' : 'Select Role',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<RoleModel>(
                        value: _selectedRole,
                        items: state.roles
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(
                                  _isArabic
                                      ? role.displayNameAr
                                      : role.displayNameEn,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (role) {
                          setState(() => _selectedRole = role);
                          if (role != null) {
                            context
                                .read<AdvancedAuthBloc>()
                                .add(RoleSelected(role));
                          }
                        },
                        decoration: InputDecoration(
                          labelText: _isArabic ? 'الدور' : 'Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.work),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return _isArabic
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
                          labelText: _isArabic ? 'الاسم الكامل' : 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _isArabic
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
                          labelText: _isArabic ? 'البريد الإلكتروني' : 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _isArabic
                                ? 'يرجى إدخال البريد الإلكتروني'
                                : 'Please enter email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return _isArabic
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
                          labelText: _isArabic
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
                          labelText: _isArabic ? 'كلمة المرور' : 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _isArabic
                                ? 'يرجى إدخال كلمة المرور'
                                : 'Please enter password';
                          }
                          if (value.length < 8) {
                            return _isArabic
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
                                _isArabic
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
                              : Text(_isArabic ? 'تسجيل' : 'Sign Up'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Login Link
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            text: TextSpan(
                              text: _isArabic
                                  ? 'لديك حساب بالفعل؟ '
                                  : 'Already have account? ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: _isArabic ? 'تسجيل الدخول' : 'Sign In',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
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
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadRoles,
                      child: Text(_isArabic ? 'إعادة محاولة' : 'Retry'),
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
