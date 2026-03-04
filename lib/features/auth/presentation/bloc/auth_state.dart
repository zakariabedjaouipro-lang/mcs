import 'package:equatable/equatable.dart';
import 'package:mcs/core/models/user_model.dart';

/// الحالة الأساسية للمصادقة
/// جميع حالات المصادقة ترث من هذه الفئة
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// ==============================
/// الحالات الأساسية
/// ==============================

/// الحالة الأولية (لم يتم بدء أي عملية)
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// حالة التحميل (جارية عملية ما)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// ==============================
/// حالات تسجيل الدخول
/// ==============================

/// نجاح تسجيل الدخول
class LoginSuccess extends AuthState {
  const LoginSuccess({
    required this.user,
    this.message = 'تم تسجيل الدخول بنجاح',
  });
  final UserModel user;
  final String message;

  @override
  List<Object?> get props => [user, message];
}

/// فشل تسجيل الدخول
class LoginFailure extends AuthState {
  const LoginFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// ==============================
/// حالات التسجيل
/// ==============================

/// نجاح التسجيل
class RegisterSuccess extends AuthState {
  const RegisterSuccess({
    required this.user,
    this.message = 'تم التسجيل بنجاح',
  });
  final UserModel user;
  final String message;

  @override
  List<Object?> get props => [user, message];
}

/// فشل التسجيل
class RegisterFailure extends AuthState {
  const RegisterFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// ==============================
/// حالات استعادة كلمة المرور
/// ==============================

/// تم إرسال طلب استعادة كلمة المرور
class ForgotPasswordSent extends AuthState {
  // 'email' or 'phone'

  const ForgotPasswordSent({
    required this.message,
    required this.method,
  });
  final String message;
  final String method;

  @override
  List<Object?> get props => [message, method];
}

/// فشل إرسال طلب استعادة كلمة المرور
class ForgotPasswordFailure extends AuthState {
  const ForgotPasswordFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// ==============================
/// حالات التحقق من OTP
/// ==============================

/// تم إرسال OTP
class OtpSent extends AuthState {
  const OtpSent({
    required this.email,
    required this.method,
    this.message = 'تم إرسال رمز التحقق',
  });
  final String email;
  final String method; // 'email' or 'phone'
  final String message;

  @override
  List<Object?> get props => [email, method, message];
}

/// تم التحقق من OTP بنجاح
class OtpVerified extends AuthState {
  const OtpVerified({
    this.message = 'تم التحقق من رمز OTP بنجاح',
  });
  final String message;

  @override
  List<Object?> get props => [message];
}

/// فشل التحقق من OTP
class OtpFailure extends AuthState {
  const OtpFailure(
    this.message, {
    this.attemptsRemaining,
  });
  final String message;
  final int? attemptsRemaining;

  @override
  List<Object?> get props => [message, attemptsRemaining];
}

/// OTP منتهي الصلاحية
class OtpExpired extends AuthState {
  const OtpExpired({
    this.message = 'انتهت صلاحية رمز التحقق',
  });
  final String message;

  @override
  List<Object?> get props => [message];
}

/// ==============================
/// حالات إعادة تعيين كلمة المرور
/// ==============================

/// نجاح إعادة تعيين كلمة المرور
class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess({
    this.message = 'تم إعادة تعيين كلمة المرور بنجاح',
  });
  final String message;

  @override
  List<Object?> get props => [message];
}

/// فشل إعادة تعيين كلمة المرور
class PasswordResetFailure extends AuthState {
  const PasswordResetFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// نجاح تغيير كلمة المرور
class PasswordChangeSuccess extends AuthState {
  const PasswordChangeSuccess({
    this.message = 'تم تغيير كلمة المرور بنجاح',
  });
  final String message;

  @override
  List<Object?> get props => [message];
}

/// فشل تغيير كلمة المرور
class PasswordChangeFailure extends AuthState {
  const PasswordChangeFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// ==============================
/// حالات التحقق من المستخدم
/// ==============================

/// المستخدم مسجل دخول
class Authenticated extends AuthState {
  const Authenticated(this.user);
  final UserModel user;

  @override
  List<Object?> get props => [user];
}

/// المستخدم غير مسجل دخول
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// ==============================
/// حالات التوجيه
/// ==============================

/// حالة توجيه المستخدم بناءً على دوره
class AuthRedirect extends AuthState {
  const AuthRedirect({
    required this.role,
    this.message = 'جاري التوجيه...',
  });
  final String role; // 'patient', 'doctor', 'staff', 'admin'
  final String message;

  @override
  List<Object?> get props => [role, message];
}

/// يجب تحديث الملف الشخصي قبل المتابعة
class ProfileCompletionRequired extends AuthState {
  const ProfileCompletionRequired({
    required this.user,
    this.message = 'يرجى إكمال ملفك الشخصي',
  });
  final UserModel user;
  final String message;

  @override
  List<Object?> get props => [user, message];
}

/// ==============================
/// حالات الخروج
/// ==============================

/// تم تسجيل الخروج بنجاح
class LogoutSuccess extends AuthState {
  const LogoutSuccess({
    this.message = 'تم تسجيل الخروج',
  });
  final String message;

  @override
  List<Object?> get props => [message];
}

/// فشل تسجيل الخروج
class LogoutFailure extends AuthState {
  const LogoutFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
