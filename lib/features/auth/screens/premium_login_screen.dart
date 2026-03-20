/// Premium Login Screen
/// High-end authentication flow matching Stripe/Notion aesthetic
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show OAuthProvider;

import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/services/auth_service.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/custom_button.dart';
import 'package:mcs/core/widgets/custom_text_field.dart';

/// Demo accounts for all 10 roles
final _demoAccounts = [
  // Admin Roles (4)
  {
    'role': 'Super Admin',
    'email': 'super@example.com',
    'password': 'Password123!',
    'description': 'مدير النظام - صلاحيات كاملة',
    'icon': Icons.admin_panel_settings,
    'color': Colors.purple,
    'path': '/admin/dashboard',
  },
  {
    'role': 'Clinic Admin',
    'email': 'clinic@example.com',
    'password': 'Password123!',
    'description': 'مدير العيادة - إدارة العيادة',
    'icon': Icons.business_center,
    'color': Colors.indigo,
    'path': '/clinic/dashboard',
  },
  {
    'role': 'Doctor',
    'email': 'doctor@example.com',
    'password': 'Password123!',
    'description': 'طبيب - مواعيد ومرضى',
    'icon': Icons.medical_services,
    'color': Colors.blue,
    'path': '/doctor/dashboard',
  },
  {
    'role': 'Nurse',
    'email': 'nurse@example.com',
    'password': 'Password123!',
    'description': 'ممرض - متابعة المرضى',
    'icon': Icons.healing,
    'color': Colors.teal,
    'path': '/nurse/dashboard',
  },

  // Staff Roles (4) - استخدام أيقونات بديلة موجودة
  {
    'role': 'Receptionist',
    'email': 'reception@example.com',
    'password': 'Password123!',
    'description': 'موظف استقبال - حجوزات',
    'icon': Icons.door_front_door, // أيقونة موجودة
    'color': Colors.orange,
    'path': '/receptionist/dashboard',
  },
  {
    'role': 'Pharmacist',
    'email': 'pharmacy@example.com',
    'password': 'Password123!',
    'description': 'صيدلي - وصفات طبية',
    'icon': Icons.local_pharmacy,
    'color': Colors.green,
    'path': '/pharmacist/dashboard',
  },
  {
    'role': 'Lab Technician',
    'email': 'lab@example.com',
    'password': 'Password123!',
    'description': 'فني مختبر - تحاليل',
    'icon': Icons.science,
    'color': Colors.cyan,
    'path': '/lab/dashboard',
  },
  {
    'role': 'Radiographer',
    'email': 'radio@example.com',
    'password': 'Password123!',
    'description': 'أخصائي أشعة',
    'icon': Icons.radar, // أيقونة موجودة
    'color': Colors.amber,
    'path': '/radiology/dashboard',
  },

  // Patient Roles (2)
  {
    'role': 'Patient',
    'email': 'patient@example.com',
    'password': 'Password123!',
    'description': 'مريض - متابعة صحية',
    'icon': Icons.person,
    'color': Colors.green,
    'path': '/patient/home',
  },
  {
    'role': 'Relative',
    'email': 'relative@example.com',
    'password': 'Password123!',
    'description': 'قريب المريض',
    'icon': Icons.family_restroom,
    'color': Colors.brown,
    'path': '/relative/home',
  },
];

class PremiumLoginScreen extends StatefulWidget {
  const PremiumLoginScreen({super.key});

  @override
  State<PremiumLoginScreen> createState() => _PremiumLoginScreenState();
}

class _PremiumLoginScreenState extends State<PremiumLoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  // Search functionality
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.landing);
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
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 48,
              vertical: isMobile ? 32 : 48,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(context, isArabic),

                    const SizedBox(height: 32),

                    // Role Tags (Quick access to demo accounts)
                    _buildRoleTags(context),

                    const SizedBox(height: 32),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email field
                          CustomTextField(
                            label: isArabic
                                ? 'البريد الإلكتروني'
                                : 'Email Address',
                            hint: isArabic
                                ? 'you@example.com'
                                : 'you@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.mail_outlined,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return isArabic
                                    ? 'البريد الإلكتروني مطلوب'
                                    : 'Email is required';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+$',
                              ).hasMatch(value!)) {
                                return isArabic
                                    ? 'يرجى إدخال بريد صحيح'
                                    : 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Password field
                          CustomTextField(
                            label: isArabic ? 'كلمة المرور' : 'Password',
                            hint: isArabic ? '••••••••' : '••••••••',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return isArabic
                                    ? 'كلمة المرور مطلوبة'
                                    : 'Password is required';
                              }
                              if (value!.length < 8) {
                                return isArabic
                                    ? 'كلمة المرور يجب أن تكون 8 أحرف على الأقل'
                                    : 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Remember me & Forgot password row
                          _buildRememberRow(context, isArabic),

                          const SizedBox(height: 32),

                          // Sign in button
                          CustomButton(
                            label: isArabic ? 'تسجيل الدخول' : 'Sign In',
                            onPressed: _isLoading ? null : _handleSignIn,
                            isLoading: _isLoading,
                          ),

                          const SizedBox(height: 16),

                          // Divider
                          _buildDivider(isArabic),

                          const SizedBox(height: 16),

                          // Social login buttons
                          _buildSocialButtons(context, isArabic),

                          const SizedBox(height: 32),

                          // Sign up link
                          _buildSignUpLink(context, isArabic),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Terms & Privacy
                    _buildTermsText(context, isArabic),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build header with logo and title
  Widget _buildHeader(BuildContext context, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: PremiumColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.medical_services_outlined,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),

        // Title
        Text(
          isArabic ? 'مرحباً بعودتك' : 'Welcome Back',
          style: PremiumTextStyles.displayMedium,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Row(
          children: [
            Expanded(
              child: Text(
                isArabic
                    ? 'سجل الدخول إلى حسابك الطبي'
                    : 'Sign in to your medical clinic account',
                style: PremiumTextStyles.bodyRegular.copyWith(
                  color: PremiumColors.lightText,
                ),
              ),
            ),
            // Demo Button
            TextButton.icon(
              onPressed: _showDemoAccountsDialog,
              icon: const Icon(
                Icons.info_outline,
                size: 16,
              ),
              label: Text(isArabic ? 'حسابات تجريبية' : 'Demo'),
              style: TextButton.styleFrom(
                foregroundColor: PremiumColors.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build role tags for quick access
  Widget _buildRoleTags(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _demoAccounts.map((account) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(account['role']!.toString()),
              selected: false,
              onSelected: (selected) {
                _autofillDemoAccount(
                  account['email']!.toString(),
                  account['password']!.toString(),
                );
              },
              backgroundColor: Colors.grey[100],
              selectedColor:
                  (account['color']! as Color).withValues(alpha: 0.2),
              checkmarkColor: account['color']! as Color,
              avatar: Icon(
                account['icon']! as IconData,
                size: 16,
                color: account['color']! as Color,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build remember me row
  Widget _buildRememberRow(BuildContext context, bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me checkbox
        Flexible(
          child: GestureDetector(
            onTap: () {
              setState(() => _rememberMe = !_rememberMe);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _rememberMe
                          ? PremiumColors.primaryBlue
                          : PremiumColors.mediumGrey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _rememberMe
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: PremiumColors.primaryBlue,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    isArabic ? 'تذكرني' : 'Remember me',
                    style: PremiumTextStyles.bodySmall.copyWith(
                      color: PremiumColors.darkText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Forgot password link
        Flexible(
          child: GestureDetector(
            onTap: () {
              // Navigate to forgot password
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? 'ميزة استعادة كلمة المرور قريباً'
                        : 'Forgot password feature coming soon',
                  ),
                ),
              );
            },
            child: Text(
              isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?',
              style: PremiumTextStyles.bodySmall.copyWith(
                color: PremiumColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
    );
  }

  /// Build divider
  Widget _buildDivider(bool isArabic) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: PremiumColors.mediumGrey,
            height: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            isArabic ? 'أو' : 'or',
            style: PremiumTextStyles.bodyMedium.copyWith(
              color: PremiumColors.lightText,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: PremiumColors.mediumGrey,
            height: 24,
          ),
        ),
      ],
    );
  }

  /// Build social login buttons
  Widget _buildSocialButtons(BuildContext context, bool isArabic) {
    return Column(
      children: [
        // Google Sign In
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _handleGoogleSignIn,
            icon: const Icon(Icons.g_mobiledata, size: 24),
            label: Text(
              isArabic ? 'تسجيل الدخول عبر Google' : 'Sign in with Google',
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Facebook Sign In
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _handleFacebookSignIn,
            icon: const Icon(
              Icons.facebook,
              size: 24,
              color: Color(0xFF1877F2),
            ),
            label: Text(
              isArabic ? 'تسجيل الدخول عبر Facebook' : 'Sign in with Facebook',
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  /// Build sign up link
  Widget _buildSignUpLink(BuildContext context, bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isArabic ? 'ليس لديك حساب؟ ' : "Don't have an account? ",
          style: PremiumTextStyles.bodyRegular.copyWith(
            color: PremiumColors.lightText,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to signup
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isArabic
                      ? 'ميزة إنشاء حساب قريباً'
                      : 'Sign up feature coming soon',
                ),
              ),
            );
          },
          child: Text(
            isArabic ? 'إنشاء حساب' : 'Create account',
            style: PremiumTextStyles.bodyRegular.copyWith(
              color: PremiumColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Build terms and privacy text
  Widget _buildTermsText(BuildContext context, bool isArabic) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: PremiumColors.lightText,
            letterSpacing: 0.5,
            height: 1.2,
          ),
          children: [
            TextSpan(
              text: isArabic
                  ? 'باستمرارك، أنت توافق على '
                  : 'By signing in, you agree to our ',
            ),
            TextSpan(
              text: isArabic ? 'الشروط' : 'Terms',
              style: const TextStyle(
                color: PremiumColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: isArabic ? ' و ' : ' and '),
            TextSpan(
              text: isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
              style: const TextStyle(
                color: PremiumColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle Google Sign In
  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() => _isLoading = true);

      await sl<AuthService>().signInWithGoogle();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('جاري تحميل حسابك...'),
          ),
        );
      }
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

  /// Handle Facebook Sign In
  Future<void> _handleFacebookSignIn() async {
    try {
      setState(() => _isLoading = true);
      await sl<AuthService>().signInWithOAuth(
        OAuthProvider.facebook,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('جاري تحميل حسابك...'),
          ),
        );
      }
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

  /// Handle sign in with email/password
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = sl<AuthService>();
      await authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'تم تسجيل الدخول بنجاح'
                  : 'Login successful',
            ),
            backgroundColor: PremiumColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'خطأ في تسجيل الدخول: $e'
                  : 'Login error: $e',
            ),
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

  /// Show demo accounts dialog
  void _showDemoAccountsDialog() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final filteredAccounts = _searchQuery.isEmpty
              ? _demoAccounts
              : _demoAccounts.where((account) {
                  final role = account['role']!.toString().toLowerCase();
                  final email = account['email']!.toString().toLowerCase();
                  final query = _searchQuery.toLowerCase();
                  return role.contains(query) || email.contains(query);
                }).toList();

          return AlertDialog(
            backgroundColor: PremiumColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'حسابات تجريبية' : 'Demo Accounts',
                  style: PremiumTextStyles.headingMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  isArabic
                      ? 'اختر حساباً لتعبئة البيانات تلقائياً'
                      : 'Tap any account to auto-fill credentials',
                  style: PremiumTextStyles.bodySmall.copyWith(
                    color: PremiumColors.lightText,
                  ),
                ),
                const SizedBox(height: 16),
                // Search field
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: PremiumColors.mediumGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: isArabic ? 'بحث...' : 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            content: Container(
              width: double.maxFinite,
              constraints: const BoxConstraints(maxHeight: 400),
              child: filteredAccounts.isEmpty
                  ? Center(
                      child: Text(
                        isArabic ? 'لا توجد نتائج' : 'No results found',
                        style: PremiumTextStyles.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredAccounts.length,
                      itemBuilder: (context, index) {
                        final account = filteredAccounts[index];
                        return _buildDemoAccountTile(
                          role: account['role']!.toString(),
                          email: account['email']!.toString(),
                          password: account['password']!.toString(),
                          description: account['description']!.toString(),
                          icon: account['icon']! as IconData,
                          color: account['color']! as Color,
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  _searchQuery = '';
                  Navigator.pop(context);
                },
                child: Text(isArabic ? 'إغلاق' : 'Close'),
              ),
            ],
          );
        },
      ),
    ).then((_) {
      // Clear search when dialog closes
      _searchController.clear();
      setState(() {
        _searchQuery = '';
      });
    });
  }

  /// Build demo account tile
  Widget _buildDemoAccountTile({
    required String role,
    required String email,
    required String password,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: PremiumColors.mediumGrey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Row(
            children: [
              Text(
                role,
                style: PremiumTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  role == 'Super Admin'
                      ? '✨'
                      : role == 'Clinic Admin'
                          ? '👑'
                          : '👤',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                description,
                style: PremiumTextStyles.bodySmall.copyWith(
                  color: PremiumColors.lightText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: PremiumTextStyles.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'email') {
                await _copyToClipboard(email);
              } else if (value == 'password') {
                await _copyToClipboard(password);
              } else if (value == 'fill') {
                _autofillDemoAccount(email, password);
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'email',
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, size: 18, color: color),
                    const SizedBox(width: 8),
                    Text(isArabic ? 'نسخ البريد' : 'Copy Email'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'password',
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, size: 18, color: color),
                    const SizedBox(width: 8),
                    Text(isArabic ? 'نسخ كلمة المرور' : 'Copy Password'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'fill',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      isArabic ? 'تعبئة تلقائية' : 'Auto-fill',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
            child: const Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }

  /// Copy text to clipboard
  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'تم النسخ إلى الحافظة!'
                : 'Copied to clipboard!',
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: PremiumColors.successGreen,
        ),
      );
    }
  }

  /// Auto-fill demo account
  void _autofillDemoAccount(String email, String password) {
    _emailController.text = email;
    _passwordController.text = password;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'تم تعبئة بيانات الحساب!'
              : 'Account details filled in!',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: PremiumColors.successGreen,
      ),
    );
  }
}
