/// Premium Login Screen
/// High-end authentication flow matching Stripe/Notion aesthetic
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/config/injection_container.dart';
import 'package:mcs/core/services/auth_service.dart';
import 'package:mcs/core/theme/premium_colors.dart';
import 'package:mcs/core/theme/premium_text_styles.dart';
import 'package:mcs/core/widgets/premium_button.dart';
import 'package:mcs/core/widgets/premium_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show OAuthProvider;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo placeholder
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
                        const Text(
                          'Welcome Back',
                          style: PremiumTextStyles.displayMedium,
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'Sign in to your medical clinic account',
                          style: PremiumTextStyles.bodyRegular.copyWith(
                            color: PremiumColors.lightText,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email field
                          PremiumFormField(
                            label: 'Email Address',
                            hint: 'you@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.mail_outlined),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Email is required';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+$',
                              ).hasMatch(value!)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Password field
                          PremiumFormField(
                            label: 'Password',
                            hint: '••••••••',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            prefixIcon: const Icon(Icons.lock_outline),
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
                                return 'Password is required';
                              }
                              if (value!.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Remember me & Forgot password row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Remember me checkbox
                              GestureDetector(
                                onTap: () {
                                  setState(() => _rememberMe = !_rememberMe);
                                },
                                child: Row(
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
                                                color:
                                                    PremiumColors.primaryBlue,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Remember me',
                                      style:
                                          PremiumTextStyles.bodyMedium.copyWith(
                                        color: PremiumColors.darkText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Forgot password link
                              GestureDetector(
                                onTap: () {
                                  // Navigate to forgot password
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Forgot password feature coming soon',
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: PremiumTextStyles.bodyMedium.copyWith(
                                    color: PremiumColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Sign in button
                          PremiumButton(
                            label: 'Sign In',
                            onPressed: _isLoading ? null : _handleSignIn,
                            isLoading: _isLoading,
                          ),

                          const SizedBox(height: 16),

                          // Divider
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: PremiumColors.mediumGrey,
                                  height: 24,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'or',
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
                          ),

                          const SizedBox(height: 16),

                          // Social login buttons
                          Column(
                            children: [
                              // Google Sign In
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      setState(() => _isLoading = true);
                                      final success = await sl<AuthService>()
                                          .signInWithGoogle();
                                      if (success && mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('جاري تحميل حسابك...'),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('خطأ: $e'),
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  },
                                  icon:
                                      const Icon(Icons.g_mobiledata, size: 24),
                                  label: const Text(
                                    'تسجيل الدخول عبر Google',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    side: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Facebook Sign In
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      setState(() => _isLoading = true);
                                      final success = await sl<AuthService>()
                                          .signInWithOAuth(
                                        OAuthProvider.facebook,
                                      );
                                      if (success && mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('جاري تحميل حسابك...'),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('خطأ: $e'),
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.facebook,
                                    size: 24,
                                    color: Color(0xFF1877F2),
                                  ),
                                  label: const Text(
                                    'تسجيل الدخول عبر Facebook',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    side: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: PremiumTextStyles.bodyRegular.copyWith(
                                  color: PremiumColors.lightText,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to signup
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Navigate to signup',
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Create account',
                                  style: PremiumTextStyles.bodyRegular.copyWith(
                                    color: PremiumColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Terms & Privacy
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: PremiumColors.lightText,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                          children: [
                            TextSpan(text: 'By signing in, you agree to our '),
                            TextSpan(
                              text: 'Terms',
                              style: TextStyle(
                                color: PremiumColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: PremiumColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = sl<AuthService>();
      final user = await authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الدخول بنجاح'),
            backgroundColor: PremiumColors.successGreen,
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
}
