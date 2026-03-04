import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/validators.dart';
import 'package:mcs/features/auth/presentation/bloc/index.dart' as auth;

/// شاشة تسجيل مستخدم جديد مع اختيار الدور والتحقق
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'patient'; // patient, doctor, staff
  String? _selectedCountryId;
  String? _selectedRegionId;

  final List<RoleOption> _roles = [
    RoleOption(
      value: 'patient',
      label: 'مريض',
      description: 'للوصول لخدمات الرعاية الصحية',
      icon: Icons.person,
    ),
    RoleOption(
      value: 'doctor',
      label: 'طبيب',
      description: 'لإدارة عيادتك والمرضى',
      icon: Icons.medical_services,
    ),
    RoleOption(
      value: 'staff',
      label: 'موظف إداري',
      description: 'لإدارة العيادة والمواعيد',
      icon: Icons.admin_panel_settings,
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمات المرور غير متطابقة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<auth.AuthBloc>().add(
          RegisterSubmitted(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
            role: _selectedRole,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<auth.AuthBloc, auth.AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء الحساب بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          // توجيه إلى شاشة التحقق من OTP
          Navigator.of(context).pushNamed(
            '/otp-verification',
            arguments: _emailController.text,
          );
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<auth.AuthBloc, auth.AuthState>(
        builder: (context, state) {
          final isLoading = state is auth.AuthLoading;

          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),

                    // Header
                    Text(
                      'إنشاء حساب جديد',
                      style: TextStyles.heading1.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'انضم إلينا الآن والاستمتع بالخدمات',
                      style: TextStyles.body1.copyWith(color: AppColors.grey),
                    ),
                    const SizedBox(height: 40),

                    // Role Selection
                    Text(
                      'اختر دورك',
                      style: TextStyles.subtitle1.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: List.generate(
                        _roles.length,
                        (index) => _buildRoleOption(_roles[index], isLoading),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            onChanged: (value) {
                              context.read<auth.AuthBloc>().add(
                                    RegisterNameChanged(value),
                                  );
                            },
                            decoration: _buildInputDecoration(
                              label: 'الاسم الكامل',
                              hint: 'محمد أحمد',
                              icon: Icons.person,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال الاسم';
                              }
                              if (value.length < 3) {
                                return 'الاسم قصير جداً';
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            onChanged: (value) {
                              context.read<auth.AuthBloc>().add(
                                    RegisterEmailChanged(value),
                                  );
                            },
                            decoration: _buildInputDecoration(
                              label: 'البريد الإلكتروني',
                              hint: 'example@mail.com',
                              icon: Icons.email,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال البريد';
                              }
                              if (!Validators.isValidEmail(value)) {
                                return 'البريد غير صحيح';
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // Phone Field
                          TextFormField(
                            controller: _phoneController,
                            onChanged: (value) {
                              context.read<auth.AuthBloc>().add(
                                    RegisterPhoneChanged(value),
                                  );
                            },
                            decoration: _buildInputDecoration(
                              label: 'رقم الهاتف',
                              hint: '0501234567',
                              icon: Icons.phone,
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال رقم الهاتف';
                              }
                              if (!Validators.isValidPhoneNumber(value)) {
                                return 'رقم الهاتف غير صحيح';
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // Country Selection
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: _loadCountries(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              final countries = snapshot.data ?? [];
                              return DropdownButtonFormField<String>(
                                value: _selectedCountryId,
                                decoration: _buildInputDecoration(
                                  label: 'الدولة',
                                  hint: 'اختر الدولة',
                                  icon: Icons.location_on,
                                ),
                                items: countries.map((country) {
                                  return DropdownMenuItem(
                                    value: country['id'] as String,
                                    child: Text(country['name_ar'] as String),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCountryId = value;
                                    _selectedRegionId = null;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء اختيار الدولة';
                                  }
                                  return null;
                                },
                                enabled: !isLoading,
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Region Selection
                          if (_selectedCountryId != null)
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: _loadRegions(_selectedCountryId!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                final regions = snapshot.data ?? [];
                                return DropdownButtonFormField<String>(
                                  value: _selectedRegionId,
                                  decoration: _buildInputDecoration(
                                    label: 'المنطقة',
                                    hint: 'اختر المنطقة',
                                    icon: Icons.map,
                                  ),
                                  items: regions.map((region) {
                                    return DropdownMenuItem(
                                      value: region['id'] as String,
                                      child: Text(region['name_ar'] as String),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => _selectedRegionId = value);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء اختيار المنطقة';
                                    }
                                    return null;
                                  },
                                  enabled: !isLoading,
                                );
                              },
                            ),
                          if (_selectedCountryId != null) const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            onChanged: (value) {
                              context.read<auth.AuthBloc>().add(
                                    RegisterPasswordChanged(value),
                                  );
                            },
                            decoration: _buildInputDecoration(
                              label: 'كلمة المرور',
                              hint: '••••••••',
                              icon: Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال كلمة المرور';
                              }
                              if (value.length < 8) {
                                return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                              }
                              if (!_isStrongPassword(value)) {
                                return 'كلمة مرور ضعيفة - استخدم أحرفاً وأرقام ورموز';
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password Field
                          TextFormField(
                            controller: _confirmPasswordController,
                            onChanged: (value) {
                              context.read<auth.AuthBloc>().add(
                                    RegisterConfirmPasswordChanged(value),
                                  );
                            },
                            decoration: _buildInputDecoration(
                              label: 'تأكيد كلمة المرور',
                              hint: '••••••••',
                              icon: Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  );
                                },
                              ),
                            ),
                            obscureText: _obscureConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء تأكيد كلمة المرور';
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 24),

                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _handleRegister(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor:
                                    AppColors.primary.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'إنشاء الحساب',
                                      style: TextStyles.subtitle1.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Login Link
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'هل لديك حساب؟ ',
                                    style: TextStyles.body2.copyWith(
                                      color: AppColors.greyDark,
                                    ),
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: GestureDetector(
                                      onTap: isLoading
                                          ? null
                                          : () => Navigator.of(context)
                                              .pushNamed('/login'),
                                      child: Text(
                                        'تسجيل الدخول',
                                        style: TextStyles.body2.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoleOption(RoleOption role, bool isLoading) {
    final isSelected = _selectedRole == role.value;

    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              setState(() => _selectedRole = role.value);
              context.read<auth.AuthBloc>().add(RegisterRoleChanged(role.value));
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color:
              isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                role.icon,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.label,
                    style: TextStyles.subtitle1.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.primary : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.description,
                    style: TextStyles.caption.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        color: AppColors.primary,
                        size: 12,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  bool _isStrongPassword(String password) {
    // Check for at least one letter, one number, and one special character
    final hasLetter = password.contains(RegExp('[a-zA-Z]'));
    final hasNumber = password.contains(RegExp(r'\d'));
    final hasSpecialChar =
        password.contains(RegExp(r'''[!@#$%^&*()_+\-=\[\]{};:'".<>?]'''));

    return hasLetter && hasNumber && hasSpecialChar;
  }

  Future<List<Map<String, dynamic>>> _loadCountries() async {
    try {
      final supabase = Supabase.instance.client;
      final data = await supabase
          .from('countries')
          .select()
          .eq('is_supported', true)
          .order('name', ascending: true);
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _loadRegions(String countryId) async {
    try {
      final supabase = Supabase.instance.client;
      final data = await supabase
          .from('regions')
          .select()
          .eq('country_id', countryId)
          .order('name', ascending: true);
      return data;
    } catch (e) {
      return [];
    }
  }
}

/// فئة تمثل خيار دور
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
