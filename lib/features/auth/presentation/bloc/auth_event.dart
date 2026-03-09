import 'package:equatable/equatable.dart';

/// الحدث الأساسي للمصادقة
/// جميع أحداث المصادقة ترث من هذه الفئة
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// ==============================
/// أحداث تسجيل الدخول
/// ==============================

/// تغيير قيمة البريد الإلكتروني في نموذج تسجيل الدخول
class LoginEmailChanged extends AuthEvent {
  const LoginEmailChanged(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

/// تغيير قيمة كلمة المرور في نموذج تسجيل الدخول
class LoginPasswordChanged extends AuthEvent {
  const LoginPasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

/// إرسال طلب تسجيل الدخول
class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// تسجيل الدخول عبر وسائل التواصل الاجتماعية
class LoginWithSocialSubmitted extends AuthEvent {
  const LoginWithSocialSubmitted({
    required this.provider,
    required this.token,
  });
  final String provider; // 'google', 'facebook', 'apple'
  final String token;

  @override
  List<Object?> get props => [provider, token];
}

/// ==============================
/// أحداث التسجيل
/// ==============================

/// تغيير قيمة الاسم في نموذج التسجيل
class RegisterNameChanged extends AuthEvent {
  const RegisterNameChanged(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}

/// تغيير قيمة البريد الإلكتروني في نموذج التسجيل
class RegisterEmailChanged extends AuthEvent {
  const RegisterEmailChanged(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

/// تغيير قيمة رقم الهاتف في نموذج التسجيل
class RegisterPhoneChanged extends AuthEvent {
  const RegisterPhoneChanged(this.phone);
  final String phone;

  @override
  List<Object?> get props => [phone];
}

/// تغيير قيمة كلمة المرور في نموذج التسجيل
class RegisterPasswordChanged extends AuthEvent {
  const RegisterPasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

/// تأكيد كلمة المرور
class RegisterConfirmPasswordChanged extends AuthEvent {
  const RegisterConfirmPasswordChanged(this.confirmPassword);
  final String confirmPassword;

  @override
  List<Object?> get props => [confirmPassword];
}

/// تغيير اختيار الدور (مريض/طبيب/موظف)
class RegisterRoleChanged extends AuthEvent {
  const RegisterRoleChanged(this.role);
  final String role;

  @override
  List<Object?> get props => [role];
}

/// إرسال طلب التسجيل
class RegisterSubmitted extends AuthEvent {
  const RegisterSubmitted({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;

  @override
  List<Object?> get props => [name, email, phone, password, role];
}

/// ==============================
/// أحداث استعادة كلمة المرور
/// ==============================

/// إرسال طلب استعادة كلمة المرور
class ForgotPasswordSubmitted extends AuthEvent {
  // 'email' or 'phone'

  const ForgotPasswordSubmitted({
    required this.contactInfo,
    required this.method,
  });
  final String contactInfo; // email or phone
  final String method;

  @override
  List<Object?> get props => [contactInfo, method];
}

/// ==============================
/// أحداث التحقق من OTP
/// ==============================

/// إرسال طلب التحقق من OTP
class OtpSubmitted extends AuthEvent {
  const OtpSubmitted({
    required this.email,
    required this.otp,
  });
  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}

/// تغيير رقم OTP في حقل معين
class OtpDigitChanged extends AuthEvent {
  const OtpDigitChanged({
    required this.digit,
    required this.index,
  });
  final String digit;
  final int index;

  @override
  List<Object?> get props => [digit, index];
}

/// إعادة محاولة إرسال OTP
class ResendOtpRequested extends AuthEvent {
  // 'email' or 'phone'

  const ResendOtpRequested({
    required this.email,
    required this.method,
  });
  final String email;
  final String method;

  @override
  List<Object?> get props => [email, method];
}

/// ==============================
/// أحداث تغيير كلمة المرور
/// ==============================

/// إرسال طلب إعادة تعيين كلمة المرور
class ResetPasswordSubmitted extends AuthEvent {
  const ResetPasswordSubmitted({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
  final String email;
  final String otp;
  final String newPassword;

  @override
  List<Object?> get props => [email, otp, newPassword];
}

/// إرسال طلب تغيير كلمة المرور الحالية
class ChangePasswordSubmitted extends AuthEvent {
  const ChangePasswordSubmitted({
    required this.currentPassword,
    required this.newPassword,
  });
  final String currentPassword;
  final String newPassword;

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// ==============================
/// أحداث عامة
/// ==============================

/// إظهار/إخفاء كلمة المرور
class TogglePasswordVisibility extends AuthEvent {
  const TogglePasswordVisibility({required this.isVisible});
  final bool isVisible;

  @override
  List<Object?> get props => [isVisible];
}

/// التحقق من المستخدم الحالي عند تشغيل التطبيق
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// تسجيل الخروج
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// إعادة تعيين حالة المصادقة (مثل التنقل بين الشاشات)
class ClearAuthState extends AuthEvent {
  const ClearAuthState();
}

/// طلب إدارة الحالة
class SetLoading extends AuthEvent {
  const SetLoading();
}


