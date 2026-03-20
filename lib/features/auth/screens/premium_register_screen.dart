/// Premium Register Screen - High-end SaaS Design
/// Redesigned with modern UI patterns from Stripe, Notion, and Linear
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// الاستيرادات مرتبة أبجدياً
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/services/auth_service.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/utils/role_management_utils.dart';
import 'package:mcs/core/widgets/app_card.dart';
import 'package:mcs/core/widgets/custom_button.dart';
import 'package:mcs/core/widgets/custom_text_field.dart';

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
  String? _selectedClinicId; // ✅ جديد: معرّف العيادة للموظفين
  bool _isLoading = false;
  bool _isPublicRegistration = true; // ✅ جديد: نوع التسجيل

  List<Map<String, dynamic>> _countries = [];
  bool _countriesLoaded = false;

  // ✅ الحصول على الأدوار المتاحة بناءً على نوع التسجيل
  List<RoleOption> get _availableRoles {
    return RoleManagementUtils.getAvailableRoles(
      currentUserRole: '',
      isPublicRegistration: _isPublicRegistration,
    );
  }

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
      debugPrint('❌ Error loading countries: $e');

      if (mounted) {
        // Fallback data for testing
        final fallbackCountries = [
          {
            'id': '1',
            'name': 'Algeria',
            'name_ar': 'الجزائر',
            'iso2_code': 'DZ',
            'is_supported': true,
          },
          {
            'id': '2',
            'name': 'Morocco',
            'name_ar': 'المغرب',
            'iso2_code': 'MA',
            'is_supported': true,
          },
          {
            'id': '3',
            'name': 'Egypt',
            'name_ar': 'مصر',
            'iso2_code': 'EG',
            'is_supported': true,
          },
          {
            'id': '4',
            'name': 'Saudi Arabia',
            'name_ar': 'السعودية',
            'iso2_code': 'SA',
            'is_supported': true,
          },
          {
            'id': '5',
            'name': 'United Arab Emirates',
            'name_ar': 'الإمارات',
            'iso2_code': 'AE',
            'is_supported': true,
          },
          {
            'id': '6',
            'name': 'Tunisia',
            'name_ar': 'تونس',
            'iso2_code': 'TN',
            'is_supported': true,
          },
          {
            'id': '7',
            'name': 'Other Countries',
            'name_ar': 'دول أخرى',
            'iso2_code': 'OTH',
            'is_supported': true,
          },
        ];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تحديث: يتم استخدام بيانات مؤقتة. '
              'تحقق من اتصالك بـ Supabase.',
            ),
            backgroundColor: Colors.orange,
          ),
        );

        setState(() {
          _countries = fallbackCountries;
          _countriesLoaded = true;
          if (_selectedCountryId == null && _countries.isNotEmpty) {
            _selectedCountryId = _countries.first['id'] as String;
          }
        });
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

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
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

    // ✅ التحقق من أن الموظفين لديهم معرّف عيادة
    if (RoleManagementUtils.roleRequiresClinicId(_selectedRole) &&
        _selectedClinicId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب تحديد العيادة للموظفين'),
          backgroundColor: PremiumColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = sl<AuthService>();

      // ✅ تحديد حالة الموافقة بناءً على الدور
      final approvalStatus =
          RoleManagementUtils.getApprovalStatusForRole(_selectedRole);

      final response = await authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        clinicId: _selectedClinicId, // ✅ إضافة clinicId
        metadata: {
          'fullName': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'role': _selectedRole,
          'approvalStatus': approvalStatus,
          'registrationType': 'email',
        },
      );

      // Create approval request in database
      await Supabase.instance.client.from('user_approvals').insert({
        'user_id': response.user!.id,
        'email': _emailController.text.trim(),
        'full_name': _nameController.text.trim(),
        'role': _selectedRole,
        'clinic_id': _selectedClinicId, // ✅ حفظ clinicId
        'registration_type': 'email',
        'status': approvalStatus,
      }).then((_) {
        if (mounted) {
          final message = approvalStatus == 'approved'
              ? 'تم إنشاء الحساب بنجاح! يمكنك الدخول الآن.'
              : 'تم إنشاء الحساب بنجاح. في انتظار الموافقة...';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: PremiumColors.successGreen,
            ),
          );
          if (mounted) context.go(AppRoutes.login);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
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

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);

    try {
      final authService = sl<AuthService>();
      final authResponse = await authService.signInWithGoogle();

      if (authResponse != null && mounted) {
        // ✅ تحديد حالة الموافقة بناءً على الدور
        final approvalStatus =
            RoleManagementUtils.getApprovalStatusForRole(_selectedRole);

        // Update user metadata with role and approval status
        await authService.updateUserMetadata({
          'role': _selectedRole,
          'approvalStatus': approvalStatus,
          'registrationType': 'google',
          if (_selectedClinicId != null) 'clinicId': _selectedClinicId,
        });

        // Create approval request in database
        await Supabase.instance.client.from('user_approvals').insert({
          'user_id': authResponse.user!.id,
          'email': authResponse.user!.email ?? '',
          'full_name': authResponse.user!.userMetadata?['full_name'] ?? '',
          'role': _selectedRole,
          'clinic_id': _selectedClinicId, // ✅ حفظ clinicId
          'registration_type': 'google',
          'status': approvalStatus,
        }).then((_) {
          if (mounted) {
            final message = approvalStatus == 'approved'
                ? 'تم التسجيل عبر Google بنجاح!'
                : 'تم التسجيل عبر Google. في انتظار الموافقة...';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: PremiumColors.successGreen,
              ),
            );
            if (mounted) context.go(AppRoutes.login);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في التسجيل عبر Google: $e'),
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

  Future<void> _handleFacebookSignUp() async {
    setState(() => _isLoading = true);

    try {
      final authService = sl<AuthService>();
      final success = await authService.signInWithFacebook();

      if (success && mounted) {
        // Get current user to get their ID and details
        final user = authService.currentUser;
        if (user != null) {
          // ✅ تحديد حالة الموافقة بناءً على الدور
          final approvalStatus =
              RoleManagementUtils.getApprovalStatusForRole(_selectedRole);

          // Update user metadata with role and approval status
          await authService.updateUserMetadata({
            'role': _selectedRole,
            'approvalStatus': approvalStatus,
            'registrationType': 'facebook',
            if (_selectedClinicId != null) 'clinicId': _selectedClinicId,
          });

          // Create approval request in database
          final fullName = user.userMetadata?['full_name'] ??
              user.userMetadata?['name'] ??
              '';
          await Supabase.instance.client.from('user_approvals').insert({
            'user_id': user.id,
            'email': user.email ?? '',
            'full_name': fullName,
            'role': _selectedRole,
            'clinic_id': _selectedClinicId, // ✅ حفظ clinicId
            'registration_type': 'facebook',
            'status': approvalStatus,
          }).then((_) {
            if (mounted) {
              final message = approvalStatus == 'approved'
                  ? 'تم التسجيل عبر Facebook بنجاح!'
                  : 'تم التسجيل عبر Facebook. في انتظار الموافقة...';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: PremiumColors.successGreen,
                ),
              );
              if (mounted) context.go(AppRoutes.login);
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في التسجيل عبر Facebook: $e'),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.login);
            }
          },
          color: PremiumColors.darkText,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: PremiumColors.darkText,
      ),
      backgroundColor: PremiumColors.white,
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
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
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
            itemCount: _availableRoles.length,
            itemBuilder: (context, index) {
              final role = _availableRoles[index];
              return AppCard(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedRole = role.value);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            role.icon,
                            size: 40,
                            color: _selectedRole == role.value
                                ? PremiumColors.primaryBlue
                                : Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            role.label,
                            style: PremiumTextStyles.labelLarge.copyWith(
                              color: _selectedRole == role.value
                                  ? PremiumColors.primaryBlue
                                  : PremiumColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            role.description,
                            style: PremiumTextStyles.bodySmall.copyWith(
                              color: PremiumColors.lightText,
                            ),
                          ),
                          if (_selectedRole == role.value) ...[
                            const SizedBox(height: 12),
                            const Icon(
                              Icons.check_circle,
                              color: PremiumColors.primaryBlue,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
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
          CustomButton(
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
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
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
                CustomTextField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Email Address',
                  hint: 'john@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Phone Number',
                  hint: '+213 XXX XXX XXX',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
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
                child: CustomButton(
                  label: 'Back',
                  onPressed: _previousStep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
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
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a strong password to protect your account',
            style: PremiumTextStyles.bodyLarge.copyWith(
              color: PremiumColors.lightText,
            ),
          ),
          const SizedBox(height: 32),

          // Password Fields - تم إصلاح الأخطاء هنا
          CustomTextField(
            label: 'Password',
            hint: '••••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            prefixIcon: Icons.lock_outline,
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
          CustomTextField(
            label: 'Confirm Password',
            hint: '••••••••',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            prefixIcon: Icons.lock_outline,
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

          // Social Login Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Or sign up using',
                style: PremiumTextStyles.bodySmall.copyWith(
                  color: PremiumColors.lightText,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleGoogleSignUp,
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text('Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleFacebookSignUp,
                      icon: const Icon(
                        Icons.facebook,
                        color: Color(0xFF1877F2),
                      ),
                      label: const Text('Facebook'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
                child: CustomButton(
                  label: 'Back',
                  onPressed: _previousStep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
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

    return AppCard(
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
