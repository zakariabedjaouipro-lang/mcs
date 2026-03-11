/// Premium Register Screen - High-end SaaS Design
/// Redesigned with modern UI patterns from Stripe, Notion, and Linear
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/config/router.dart';
import 'package:mcs/core/services/auth_service.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/premium_button.dart';
import 'package:mcs/core/widgets/premium_card.dart';
import 'package:mcs/core/widgets/premium_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PremiumRegisterScreen extends StatefulWidget {
  const PremiumRegisterScreen({super.key});

  @override
  State<PremiumRegisterScreen> createState() => _PremiumRegisterScreenState();
}

class _PremiumRegisterScreenState extends State<PremiumRegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late PageController _pageController;
  late AnimationController _fadeController;
  int _currentStep = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'patient';
  String? _selectedCountryId;
  bool _isLoading = false;

  List<Map<String, dynamic>> _countries = [];
  bool _countriesLoaded = false;

  final List<RoleOption> _roles = [
    RoleOption(
      value: 'patient',
      label: 'Patient',
      description: 'Access healthcare services',
      icon: Icons.person,
    ),
    RoleOption(
      value: 'doctor',
      label: 'Doctor',
      description: 'Manage clinic and patients',
      icon: Icons.medical_services,
    ),
    RoleOption(
      value: 'staff',
      label: 'Staff',
      description: 'Manage clinic operations',
      icon: Icons.admin_panel_settings,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _loadCountriesOnce();
    _fadeController.forward();
  }

  Future<void> _loadCountriesOnce() async {
    if (_countriesLoaded) return;
    try {
      final supabase = Supabase.instance.client;
      final data = await supabase
          .from('countries')
          .select()
          .eq('is_supported', true)
          .order('name', ascending: true);

      if (mounted) {
        setState(() {
          _countries = data;
          _countriesLoaded = true;
          if (_countries.isNotEmpty && _selectedCountryId == null) {
            _selectedCountryId = _countries.first['id'] as String;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load countries: $e'),
            backgroundColor: PremiumColors.errorRed,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _handleCreateAccount() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمات المرور غير متطابقة'),
          backgroundColor: PremiumColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = sl<AuthService>();
      final user = await authService.registerWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
      );

      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الحساب بنجاح'),
            backgroundColor: PremiumColors.successGreen,
          ),
        );
        // Navigate to dashboard or login
        if (mounted) context.go(AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: PremiumColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
              style: TextStyle(
                color: PremiumColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeController,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentStep = index);
          },
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildRoleSelectionStep(),
            _buildBasicInfoStep(),
            _buildPasswordStep(),
          ],
        ),
      ),
    );
  }

  /// Step 1: Role Selection
  Widget _buildRoleSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const SizedBox(height: 16),
          const Text(
            'Choose your role',
            style: TextStyle(),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the role that best describes you. You can change this later.',
            style: PremiumTextStyles.bodyLarge.copyWith(
              color: PremiumColors.lightText,
            ),
          ),
          const SizedBox(height: 48),

          // Role Cards
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _roles.length,
            itemBuilder: (context, index) {
              final role = _roles[index];
              return PremiumRoleCard(
                icon: role.icon,
                title: role.label,
                description: role.description,
                isSelected: _selectedRole == role.value,
                onTap: () {
                  setState(() => _selectedRole = role.value);
                },
              );
            },
          ),

          const SizedBox(height: 48),

          // Progress Indicator
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: index <= _currentStep
                        ? PremiumColors.primaryBlue
                        : PremiumColors.mediumGrey,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Next Button
          PremiumButton(
            label: 'Continue',
            onPressed: _nextStep,
            icon: Icons.arrow_forward,
          ),

          const SizedBox(height: 16),

          // Sign In Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: PremiumTextStyles.bodyMedium,
              ),
              GestureDetector(
                onTap: () => context.go(AppRoutes.login),
                child: Text(
                  'Sign In',
                  style: PremiumTextStyles.bodyMedium.copyWith(
                    color: PremiumColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Step 2: Basic Information
  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Basic information',
            style: TextStyle(),
          ),
          const SizedBox(height: 8),
          Text(
            'Help us get to know you better',
            style: PremiumTextStyles.bodyLarge.copyWith(
              color: PremiumColors.lightText,
            ),
          ),
          const SizedBox(height: 32),

          // Form Fields
          Form(
            key: _formKey,
            child: Column(
              children: [
                PremiumFormField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                const SizedBox(height: 24),
                PremiumFormField(
                  label: 'Email Address',
                  hint: 'john@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline),
                ),
                const SizedBox(height: 24),
                PremiumFormField(
                  label: 'Phone Number',
                  hint: '+213 XXX XXX XXX',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Progress Indicator
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: index <= _currentStep
                        ? PremiumColors.primaryBlue
                        : PremiumColors.mediumGrey,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              Expanded(
                child: PremiumButton(
                  label: 'Back',
                  variant: PremiumButtonVariant.secondary,
                  onPressed: _previousStep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PremiumButton(
                  label: 'Next',
                  onPressed: _nextStep,
                  icon: Icons.arrow_forward,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Step 3: Password Setup
  Widget _buildPasswordStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Secure your account',
            style: TextStyle(),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a strong password to protect your account',
            style: PremiumTextStyles.bodyLarge.copyWith(
              color: PremiumColors.lightText,
            ),
          ),
          const SizedBox(height: 32),

          // Password Fields
          PremiumFormField(
            label: 'Password',
            hint: '••••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              child: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          const SizedBox(height: 24),
          PremiumFormField(
            label: 'Confirm Password',
            hint: '••••••••',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
              child: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Password Requirements
          _buildPasswordRequirements(),

          const SizedBox(height: 32),

          // Progress Indicator
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: index <= _currentStep
                        ? PremiumColors.primaryBlue
                        : PremiumColors.mediumGrey,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              Expanded(
                child: PremiumButton(
                  label: 'Back',
                  variant: PremiumButtonVariant.secondary,
                  onPressed: _previousStep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PremiumButton(
                  label: 'Create Account',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _handleCreateAccount,
                  icon: Icons.check,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Terms
          Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'By signing up, you agree to our ',
                    style: PremiumTextStyles.bodySmall.copyWith(
                      color: PremiumColors.lightText,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms',
                    style: PremiumTextStyles.bodySmall.copyWith(
                      color: PremiumColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: PremiumTextStyles.bodySmall.copyWith(
                      color: PremiumColors.lightText,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: PremiumTextStyles.bodySmall.copyWith(
                      color: PremiumColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;
    final requirements = {
      'At least 8 characters': password.length >= 8,
      'Contains uppercase letter': password.contains(RegExp('[A-Z]')),
      'Contains lowercase letter': password.contains(RegExp('[a-z]')),
      'Contains number': password.contains(RegExp('[0-9]')),
      'Contains special character': password.contains(RegExp(r'[!@#$%^&*]')),
    };

    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password requirements',
            style: PremiumTextStyles.labelLarge,
          ),
          const SizedBox(height: 12),
          ...requirements.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(
                    entry.value ? Icons.check_circle : Icons.circle_outlined,
                    size: 18,
                    color: entry.value
                        ? PremiumColors.successGreen
                        : PremiumColors.lightText,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    entry.key,
                    style: PremiumTextStyles.bodySmall.copyWith(
                      color: entry.value
                          ? PremiumColors.successGreen
                          : PremiumColors.lightText,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class RoleOption {
  RoleOption({
    required this.value,
    required this.label,
    required this.description,
    required this.icon,
  });

  final String value;
  final String label;
  final String description;
  final IconData icon;
}
