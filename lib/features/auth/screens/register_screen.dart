import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mcs/core/theme/app_colors.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/validators.dart';
import 'package:mcs/features/auth/presentation/bloc/index.dart' as auth;
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'patient'; // patient, doctor, staff
  String? _selectedCountryId;
  String? _selectedRegionId;

  // ✅ تحميل الدول والمناطق مرة واحدة فقط
  List<Map<String, dynamic>> _countries = [];
  final Map<String, List<Map<String, dynamic>>> _regionsCache = {};
  bool _countriesLoaded = false;

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
  void initState() {
    super.initState();
    // ✅ تحميل الدول مرة واحدة عند فتح الشاشة
    _loadCountriesOnce();
  }

  Future<void> _loadCountriesOnce() async {
    if (_countriesLoaded) return;
    print('Loading countries from Supabase...');
    try {
      final supabase = Supabase.instance.client;
      final data = await supabase
          .from('countries')
          .select()
          .eq('is_supported', true)
          .order('name', ascending: true);

      print('Loaded ${data.length} countries from Supabase');

      if (mounted) {
        setState(() {
          _countries = data;
          _countriesLoaded = true;
          // تعيين أول دولة كقيمة افتراضية
          if (_countries.isNotEmpty && _selectedCountryId == null) {
            _selectedCountryId = _countries.first['id'] as String;
            print(
              'Default country set to: ${_countries.first['name_ar'] ?? _countries.first['name']}',
            );
          }
        });
      }
    } catch (e, stackTrace) {
      print('Error loading countries: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تحميل الدول: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // ✅ استخدام cascade operator لتبسيط الإغلاق
    _nameController
      ..dispose()
      ..text = '';
    _emailController
      ..dispose()
      ..text = '';
    _phoneController
      ..dispose()
      ..text = '';
    _addressController
      ..dispose()
      ..text = '';
    _passwordController
      ..dispose()
      ..text = '';
    _confirmPasswordController
      ..dispose()
      ..text = '';
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
          auth.RegisterSubmitted(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
            role: _selectedRole,
            countryId: _selectedCountryId,
            regionId: _selectedRegionId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<auth.AuthBloc, auth.AuthState>(
      listener: (context, state) {
        if (state is auth.RegisterSuccess) {
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
        } else if (state is auth.RegisterFailure) {
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
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: const Text('إنشاء حساب جديد'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    // Header
                    Text(
                      'إنشاء حساب جديد',
                      style: TextStyles.heading1.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'انضم إلينا الآن والاستمتع بالخدمات',
                      style: TextStyles.body1.copyWith(color: AppColors.grey),
                    ),
                    SizedBox(height: 30.h),

                    // Role Selection
                    Text(
                      'اختر دورك',
                      style: TextStyles.subtitle1.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
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
                                    auth.RegisterNameChanged(value),
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
                          SizedBox(height: 16.h),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            onChanged: (value) {
                              context.read<auth.AuthBloc>().add(
                                    auth.RegisterEmailChanged(value),
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
                          SizedBox(height: 16.h),

                          // Phone Field
                          TextFormField(
                            controller: _phoneController,
                            onChanged: (value) {
                              context.read<auth.AuthBloc>().add(
                                    auth.RegisterPhoneChanged(value),
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
                          SizedBox(height: 16.h),

                          // Country Selection
                          if (!_countriesLoaded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الدولة',
                                  style: TextStyles.body2.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                const Center(
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'جاري تحميل قائمة الدول...',
                                  style: TextStyles.caption.copyWith(
                                    color: AppColors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          else if (_countries.isEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الدولة',
                                  style: TextStyles.body2.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.all(16.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.greyLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                        255,
                                        134,
                                        65,
                                        65,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.orange,
                                        size: 20.h,
                                      ),
                                      SizedBox(width: 8.h),
                                      Expanded(
                                        child: Text(
                                          'لا توجد دول متاحة. تأكد من اتصال الإنترنت.',
                                          style: TextStyles.caption.copyWith(
                                            color: AppColors.greyDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else
                            DropdownButtonFormField<String>(
                              initialValue: _selectedCountryId,
                              decoration: _buildInputDecoration(
                                label: 'الدولة',
                                hint: 'اختر الدولة',
                                icon: Icons.location_on,
                              ),
                              items: _countries.map((country) {
                                final countryName =
                                    (country['name_ar'] as String?) ??
                                        (country['name'] as String?) ??
                                        'Unknown';
                                return DropdownMenuItem(
                                  value: country['id'] as String? ?? '',
                                  child: Text(countryName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null || value.isEmpty) {
                                  return;
                                }
                                if (!mounted) return;
                                setState(() {
                                  _selectedCountryId = value;
                                  _selectedRegionId = null;
                                  _regionsCache
                                      .clear(); // مسح ذاكرة التخزين المؤقت
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء اختيار الدولة';
                                }
                                return null;
                              },
                            ),
                          SizedBox(height: 16.h),

                          // ⭕ Region Selection
                          if (_selectedCountryId != null)
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: _loadRegions(_selectedCountryId!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Text(
                                    'فشل تحميل المناطق',
                                    style: TextStyles.body2
                                        .copyWith(color: Colors.red),
                                  );
                                }
                                final regions =
                                    snapshot.data ?? <Map<String, dynamic>>[];
                                return DropdownButtonFormField<String>(
                                  initialValue: _selectedRegionId,
                                  decoration: _buildInputDecoration(
                                    label: 'المنطقة',
                                    hint: 'اختر المنطقة',
                                    icon: Icons.map,
                                  ),
                                  items: regions.isEmpty
                                      ? []
                                      : regions.map((region) {
                                          final regionName =
                                              (region['name_ar'] as String?) ??
                                                  (region['name'] as String?) ??
                                                  'Unknown';
                                          return DropdownMenuItem<String>(
                                            value:
                                                region['id'] as String? ?? '',
                                            child: Text(regionName),
                                          );
                                        }).toList(),
                                  onChanged: (value) {
                                    if (value == null || value.isEmpty) {
                                      return;
                                    }
                                    if (!mounted) return;
                                    setState(
                                      () => _selectedRegionId = value,
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء اختيار المنطقة';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          if (_selectedCountryId != null)
                            SizedBox(height: 16.h),

                          // Address Field
                          TextFormField(
                            controller: _addressController,
                            decoration: _buildInputDecoration(
                              label: 'العنوان',
                              hint: 'شارع النيل، الدقي',
                              icon: Icons.location_city,
                            ),
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال العنوان';
                              }
                              if (value.length < 5) {
                                return 'العنوان قصير جداً';
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          SizedBox(height: 16.h),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            onChanged: (value) {
                              context.read<auth.AuthBloc>().add(
                                    auth.RegisterPasswordChanged(value),
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
                          SizedBox(height: 16.h),

                          // Confirm Password Field
                          TextFormField(
                            controller: _confirmPasswordController,
                            onChanged: (value) {
                              context.read<auth.AuthBloc>().add(
                                    auth.RegisterConfirmPasswordChanged(value),
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
                          SizedBox(height: 24.h),

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
                                disabledBackgroundColor: AppColors.primary
                                    .withValues(alpha: 0.5), // ✅ تم الإصلاح
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
                          SizedBox(height: 20.h),

                          // ✅ Login Link - تم الإصلاح
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
                                          : () {
                                              if (!mounted) return;
                                              context.go('/login');
                                            },
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
                          SizedBox(height: 40.h),
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
              context
                  .read<auth.AuthBloc>()
                  .add(auth.RegisterRoleChanged(role.value));
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
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05) // ✅ تم الإصلاح
              : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.1), // ✅ تم الإصلاح
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

  Future<List<Map<String, dynamic>>> _loadRegions(String countryId) async {
    // ✅ استخدام cache لتجنب استدعاءات متكررة
    if (_regionsCache.containsKey(countryId)) {
      return _regionsCache[countryId]!;
    }

    try {
      final supabase = Supabase.instance.client;
      final data = await supabase
          .from('regions')
          .select()
          .eq('country_id', countryId)
          .order('name', ascending: true);

      _regionsCache[countryId] = data;
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
