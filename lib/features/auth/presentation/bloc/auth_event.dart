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
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

/// تغيير قيمة كلمة المرور في نموذج تسجيل الدخول
class LoginPasswordChanged extends AuthEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

/// إرسال طلب تسجيل الدخول
class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// تسجيل الدخول عبر وسائل التواصل الاجتماعية
class LoginWithSocialSubmitted extends AuthEvent {
  final String provider; // 'google', 'facebook', 'apple'
  final String token;

  const LoginWithSocialSubmitted({
    required this.provider,
    required this.token,
  });

  @override
  List<Object?> get props => [provider, token];
}

/// ==============================
/// أحداث التسجيل
/// ==============================

/// تغيير قيمة الاسم في نموذج التسجيل
class RegisterNameChanged extends AuthEvent {
  final String name;

  const RegisterNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

/// تغيير قيمة البريد الإلكتروني في نموذج التسجيل
class RegisterEmailChanged extends AuthEvent {
  final String email;

  const RegisterEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

/// تغيير قيمة رقم الهاتف في نموذج التسجيل
class RegisterPhoneChanged extends AuthEvent {
  final String phone;

  const RegisterPhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

/// تغيير قيمة كلمة المرور في نموذج التسجيل
class RegisterPasswordChanged extends AuthEvent {
  final String password;

  const RegisterPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

/// تأكيد كلمة المرور
class RegisterConfirmPasswordChanged extends AuthEvent {
  final String confirmPassword;

  const RegisterConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

/// تغيير اختيار الدور (مريض/طبيب/موظف)
class RegisterRoleChanged extends AuthEvent {
  final String role;

  const RegisterRoleChanged(this.role);

  @override
  List<Object?> get props => [role];
}

/// إرسال طلب التسجيل
class RegisterSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;

  const RegisterSubmitted({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, phone, password, role];
}

/// ==============================
/// أحداث استعادة كلمة المرور
/// ==============================

/// إرسال طلب استعادة كلمة المرور
class ForgotPasswordSubmitted extends AuthEvent {
  final String contactInfo; // email or phone
  final String method; // 'email' or 'phone'

  const ForgotPasswordSubmitted({
    required this.contactInfo,
    required this.method,
  });

  @override
  List<Object?> get props => [contactInfo, method];
}

/// ==============================
/// أحداث التحقق من OTP
/// ==============================

/// إرسال طلب التحقق من OTP
class OtpSubmitted extends AuthEvent {
  final String email;
  final String otp;

  const OtpSubmitted({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}

/// تغيير رقم OTP في حقل معين
class OtpDigitChanged extends AuthEvent {
  final String digit;
  final int index;

  const OtpDigitChanged({
    required this.digit,
    required this.index,
  });

  @override
  List<Object?> get props => [digit, index];
}

/// إعادة محاولة إرسال OTP
class ResendOtpRequested extends AuthEvent {
  final String email;
  final String method; // 'email' or 'phone'

  const ResendOtpRequested({
    required this.email,
    required this.method,
  });

  @override
  List<Object?> get props => [email, method];
}

/// ==============================
/// أحداث تغيير كلمة المرور
/// ==============================

/// إرسال طلب إعادة تعيين كلمة المرور
class ResetPasswordSubmitted extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordSubmitted({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}

/// إرسال طلب تغيير كلمة المرور الحالية
class ChangePasswordSubmitted extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordSubmitted({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// ==============================
/// أحداث عامة
/// ==============================

/// إظهار/إخفاء كلمة المرور
class TogglePasswordVisibility extends AuthEvent {
  final bool isVisible;

  const TogglePasswordVisibility(this.isVisible);

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
