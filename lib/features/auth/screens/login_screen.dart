import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/constants/app_routes.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/utils/responsive_utils.dart';
import 'package:mcs/core/utils/validators.dart';
import 'package:mcs/features/auth/presentation/bloc/index.dart';

/// شاشة تسجيل الدخول - البريد الإلكتروني وكلمة المرور
///
/// ✨ تحسينات المميزات:
/// - تصميم عصري مع تأثيرات انتقالية سلسة
/// - اختيار دور/نوع المستخدم (مريض، طبيب، موظف، إدارة)
/// - أيقونات ديناميكية جميلة
/// - معالجة أخطاء محسنة مع تنبيهات مرئية
/// - دعم RTL/LTR محسن
/// - Responsive design على جميع الأجهزة
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String _selectedRole = 'patient'; // Default role
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // تهيئة التأثيرات الانتقالية
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          LoginSubmitted(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            // أضفنا الدور المحدد
            role: _selectedRole,
          ),
        );
  }

  // دالة مساعدة للحصول على أيقونة الدور
  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'doctor':
        return Icons.medical_information;
      case 'employee':
        return Icons.badge;
      case 'admin':
        return Icons.admin_panel_settings;
      case 'patient':
      default:
        return Icons.person;
    }
  }

  // دالة مساعدة للحصول على اسم الدور مترجم
  String _getRoleLabel(String role) {
    switch (role) {
      case 'doctor':
        return 'طبيب';
      case 'employee':
        return 'موظف';
      case 'admin':
        return 'إدارة';
      case 'patient':
      default:
        return 'مريض';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go(AppRoutes.dashboard);
        } else if (state is LoginFailure) {
          // تنبيه محسن مع أيقونة وألوان أفضل
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              elevation: 8,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: Colors.grey[50],
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
              ),
              title: const Text('تسجيل الدخول'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: AppColors.primary,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.horizontalPadding,
                    vertical: context.verticalPadding,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              // Spacer
                              SizedBox(height: context.verticalPadding / 2),

                              // أيقونة العنوان الموضوعية
                              Container(
                                padding: EdgeInsets.all(context.cardPadding),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.lock_outline,
                                  size: 48,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: context.formFieldSpacing),

                              // Header
                              Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontSize: context.heading2Size,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: context.formFieldSpacing / 2),
                              Text(
                                'أهلاً بعودتك! تسجيل دخول للمتابعة',
                                style: TextStyle(
                                  fontSize: context.bodyMediumSize,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: context.verticalPadding * 2),

                              // اختيار نوع المستخدم (الدور)
                              Text(
                                'اختر نوع حسابك',
                                style: TextStyle(
                                  fontSize: context.bodyMediumSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: context.formFieldSpacing),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.cardPadding / 2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildRoleCard(
                                          'patient', context, isLoading),
                                      SizedBox(width: context.formFieldSpacing),
                                      _buildRoleCard(
                                          'doctor', context, isLoading),
                                      SizedBox(width: context.formFieldSpacing),
                                      _buildRoleCard(
                                          'employee', context, isLoading),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: context.verticalPadding * 2),

                              // Form
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Email Field - محسن مع أيقونة وظل
                                    _buildEmailField(context, isLoading),
                                    SizedBox(height: context.formFieldSpacing),

                                    // Password Field - محسن
                                    _buildPasswordField(context, isLoading),
                                    SizedBox(height: context.formFieldSpacing),

                                    // Forgot Password Link
                                    Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: TextButton(
                                        onPressed: isLoading
                                            ? null
                                            : () => context
                                                .push(AppRoutes.forgotPassword),
                                        child: Text(
                                          'نسيت كلمة المرور؟',
                                          style: TextStyle(
                                            fontSize: context.bodySmallSize,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: context.verticalPadding),

                                    // Login Button - محسن مع ظل وتأثير
                                    _buildLoginButton(context, isLoading),
                                  ],
                                ),
                              ),

                              SizedBox(height: context.verticalPadding * 2),

                              // Sign Up Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ليس لديك حساب؟',
                                    style: TextStyle(
                                      fontSize: context.bodySmallSize,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: isLoading
                                        ? null
                                        : () =>
                                            context.push(AppRoutes.register),
                                    child: Text(
                                      'سجل الآن',
                                      style: TextStyle(
                                        fontSize: context.bodySmallSize,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: context.verticalPadding),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // بناء بطاقة اختيار الدور
  Widget _buildRoleCard(String role, BuildContext context, bool isLoading) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: isLoading ? null : () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: context.cardPadding,
          vertical: context.cardPadding / 1.5,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(context.borderRadius),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getRoleIcon(role),
              color: isSelected ? Colors.white : AppColors.primary,
              size: 28,
            ),
            SizedBox(height: context.formFieldSpacing / 2),
            Text(
              _getRoleLabel(role),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: context.bodySmallSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // بناء حقل البريد الإلكتروني
  Widget _buildEmailField(BuildContext context, bool isLoading) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        hintText: 'example@mail.com',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.cardPadding,
          vertical: context.cardPadding / 1.5,
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.emailAddress,
      enabled: !isLoading,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال البريد الإلكتروني';
        }
        if (!Validators.isValidEmail(value)) {
          return 'البريد الإلكتروني غير صحيح';
        }
        return null;
      },
    );
  }

  // بناء حقل كلمة المرور
  Widget _buildPasswordField(BuildContext context, bool isLoading) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        hintText: '••••••••',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.primary,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.borderRadius),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.cardPadding,
          vertical: context.cardPadding / 1.5,
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      obscureText: _obscurePassword,
      enabled: !isLoading,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال كلمة المرور';
        }
        if (value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
    );
  }

  // بناء زر الدخول
  Widget _buildLoginButton(BuildContext context, bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: context.buttonHeight,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => _handleLogin(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.borderRadius),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.login, color: Colors.white),
                    SizedBox(width: context.formFieldSpacing),
                    Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: context.buttonTextSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
