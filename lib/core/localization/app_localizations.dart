/// Application localization support.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// AppLocalizations class for managing app translations.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // ── Common ─────────────────────────────────────────────────
  String get appName => 'MCS';
  String get appFullName => 'Medical Clinic Management System';
  String get loading => locale.languageCode == 'ar' ? 'جاري التحميل...' : 'Loading...';
  String get error => locale.languageCode == 'ar' ? 'حدث خطأ' : 'An error occurred';
  String get success => locale.languageCode == 'ar' ? 'نجاح' : 'Success';
  String get warning => locale.languageCode == 'ar' ? 'تحذير' : 'Warning';
  String get info => locale.languageCode == 'ar' ? 'معلومات' : 'Info';
  String get retry => locale.languageCode == 'ar' ? 'إعادة المحاولة' : 'Retry';
  String get cancel => locale.languageCode == 'ar' ? 'إلغاء' : 'Cancel';
  String get confirm => locale.languageCode == 'ar' ? 'تأكيد' : 'Confirm';
  String get save => locale.languageCode == 'ar' ? 'حفظ' : 'Save';
  String get delete => locale.languageCode == 'ar' ? 'حذف' : 'Delete';
  String get edit => locale.languageCode == 'ar' ? 'تعديل' : 'Edit';
  String get add => locale.languageCode == 'ar' ? 'إضافة' : 'Add';
  String get search => locale.languageCode == 'ar' ? 'بحث' : 'Search';
  String get filter => locale.languageCode == 'ar' ? 'تصفية' : 'Filter';
  String get sort => locale.languageCode == 'ar' ? 'ترتيب' : 'Sort';
  String get view => locale.languageCode == 'ar' ? 'عرض' : 'View';
  String get download => locale.languageCode == 'ar' ? 'تحميل' : 'Download';
  String get upload => locale.languageCode == 'ar' ? 'رفع' : 'Upload';
  String get share => locale.languageCode == 'ar' ? 'مشاركة' : 'Share';
  String get close => locale.languageCode == 'ar' ? 'إغلاق' : 'Close';
  String get back => locale.languageCode == 'ar' ? 'رجوع' : 'Back';
  String get next => locale.languageCode == 'ar' ? 'التالي' : 'Next';
  String get previous => locale.languageCode == 'ar' ? 'السابق' : 'Previous';
  String get submit => locale.languageCode == 'ar' ? 'إرسال' : 'Submit';
  String get done => locale.languageCode == 'ar' ? 'تم' : 'Done';
  String get yes => locale.languageCode == 'ar' ? 'نعم' : 'Yes';
  String get no => locale.languageCode == 'ar' ? 'لا' : 'No';
  String get ok => locale.languageCode == 'ar' ? 'موافق' : 'OK';

  // ── Auth ──────────────────────────────────────────────────
  String get login => locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Login';
  String get register => locale.languageCode == 'ar' ? 'إنشاء حساب' : 'Register';
  String get logout => locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Logout';
  String get email => locale.languageCode == 'ar' ? 'البريد الإلكتروني' : 'Email';
  String get password => locale.languageCode == 'ar' ? 'كلمة المرور' : 'Password';
  String get confirmPassword => locale.languageCode == 'ar' ? 'تأكيد كلمة المرور' : 'Confirm Password';
  String get forgotPassword => locale.languageCode == 'ar' ? 'نسيت كلمة المرور؟' : 'Forgot Password?';
  String get resetPassword => locale.languageCode == 'ar' ? 'إعادة تعيين كلمة المرور' : 'Reset Password';
  String get changePassword => locale.languageCode == 'ar' ? 'تغيير كلمة المرور' : 'Change Password';
  String get name => locale.languageCode == 'ar' ? 'الاسم' : 'Name';
  String get phone => locale.languageCode == 'ar' ? 'رقم الهاتف' : 'Phone';
  String get otp => locale.languageCode == 'ar' ? 'رمز التحقق' : 'OTP';
  String get verifyOtp => locale.languageCode == 'ar' ? 'التحقق من الرمز' : 'Verify OTP';
  String get resendOtp => locale.languageCode == 'ar' ? 'إعادة إرسال الرمز' : 'Resend OTP';
  String get dontHaveAccount => locale.languageCode == 'ar' ? 'ليس لديك حساب؟' : "Don't have an account?";
  String get alreadyHaveAccount => locale.languageCode == 'ar' ? 'لديك حساب بالفعل؟' : 'Already have an account?';
  String get signUp => locale.languageCode == 'ar' ? 'إنشاء حساب' : 'Sign Up';
  String get signIn => locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Sign In';

  // ── Roles ────────────────────────────────────────────────
  String get patient => locale.languageCode == 'ar' ? 'مريض' : 'Patient';
  String get doctor => locale.languageCode == 'ar' ? 'طبيب' : 'Doctor';
  String get staff => locale.languageCode == 'ar' ? 'موظف' : 'Staff';
  String get admin => locale.languageCode == 'ar' ? 'مدير' : 'Admin';

  // ── Validation ────────────────────────────────────────────
  String get requiredField => locale.languageCode == 'ar' ? 'هذا الحقل مطلوب' : 'This field is required';
  String get invalidEmail => locale.languageCode == 'ar' ? 'البريد الإلكتروني غير صالح' : 'Invalid email address';
  String get invalidPhone => locale.languageCode == 'ar' ? 'رقم الهاتف غير صالح' : 'Invalid phone number';
  String get passwordTooShort => locale.languageCode == 'ar' ? 'كلمة المرور قصيرة جداً' : 'Password is too short';
  String get passwordMismatch => locale.languageCode == 'ar' ? 'كلمات المرور غير متطابقة' : 'Passwords do not match';
  String get invalidOtp => locale.languageCode == 'ar' ? 'رمز التحقق غير صالح' : 'Invalid OTP code';
  String get otpExpired => locale.languageCode == 'ar' ? 'رمز التحقق منتهي الصلاحية' : 'OTP has expired';

  // ── Navigation ───────────────────────────────────────────
  String get home => locale.languageCode == 'ar' ? 'الرئيسية' : 'Home';
  String get profile => locale.languageCode == 'ar' ? 'الملف الشخصي' : 'Profile';
  String get settings => locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings';
  String get notifications => locale.languageCode == 'ar' ? 'الإشعارات' : 'Notifications';
  String get appointments => locale.languageCode == 'ar' ? 'المواعيد' : 'Appointments';
  String get patients => locale.languageCode == 'ar' ? 'المرضى' : 'Patients';
  String get doctors => locale.languageCode == 'ar' ? 'الأطباء' : 'Doctors';
  String get reports => locale.languageCode == 'ar' ? 'التقارير' : 'Reports';
  String get prescriptions => locale.languageCode == 'ar' ? 'الوصفات' : 'Prescriptions';
  String get invoices => locale.languageCode == 'ar' ? 'الفواتير' : 'Invoices';
  String get inventory => locale.languageCode == 'ar' ? 'المخزون' : 'Inventory';
  String get labResults => locale.languageCode == 'ar' ? 'نتائج المختبر' : 'Lab Results';
  String get videoCalls => locale.languageCode == 'ar' ? 'المكالمات المرئية' : 'Video Calls';

  // ── Status ───────────────────────────────────────────────
  String get pending => locale.languageCode == 'ar' ? 'قيد الانتظار' : 'Pending';
  String get confirmed => locale.languageCode == 'ar' ? 'مؤكد' : 'Confirmed';
  String get completed => locale.languageCode == 'ar' ? 'مكتمل' : 'Completed';
  String get cancelled => locale.languageCode == 'ar' ? 'ملغي' : 'Cancelled';
  String get active => locale.languageCode == 'ar' ? 'نشط' : 'Active';
  String get inactive => locale.languageCode == 'ar' ? 'غير نشط' : 'Inactive';
  String get paid => locale.languageCode == 'ar' ? 'مدفوع' : 'Paid';
  String get unpaid => locale.languageCode == 'ar' ? 'غير مدفوع' : 'Unpaid';

  // ── Messages ─────────────────────────────────────────────
  String get loginSuccess => locale.languageCode == 'ar' ? 'تم تسجيل الدخول بنجاح' : 'Login successful';
  String get registerSuccess => locale.languageCode == 'ar' ? 'تم إنشاء الحساب بنجاح' : 'Registration successful';
  String get logoutSuccess => locale.languageCode == 'ar' ? 'تم تسجيل الخروج بنجاح' : 'Logout successful';
  String get passwordResetSent => locale.languageCode == 'ar' ? 'تم إرسال رابط إعادة تعيين كلمة المرور' : 'Password reset link sent';
  String get passwordChanged => locale.languageCode == 'ar' ? 'تم تغيير كلمة المرور بنجاح' : 'Password changed successfully';
  String get otpSent => locale.languageCode == 'ar' ? 'تم إرسال رمز التحقق' : 'OTP sent successfully';
  String get otpVerified => locale.languageCode == 'ar' ? 'تم التحقق من الرمز بنجاح' : 'OTP verified successfully';

  // ── Theme ────────────────────────────────────────────────
  String get lightTheme => locale.languageCode == 'ar' ? 'الوضع الفاتح' : 'Light Theme';
  String get darkTheme => locale.languageCode == 'ar' ? 'الوضع الداكن' : 'Dark Theme';
  String get language => locale.languageCode == 'ar' ? 'اللغة' : 'Language';
  String get arabic => locale.languageCode == 'ar' ? 'العربية' : 'Arabic';
  String get english => locale.languageCode == 'ar' ? 'English' : 'English';

  // ── Landing Page ─────────────────────────────────────────
  String get welcome => locale.languageCode == 'ar' ? 'مرحباً بك' : 'Welcome';
  String get getStarted => locale.languageCode == 'ar' ? 'ابدأ الآن' : 'Get Started';
  String get learnMore => locale.languageCode == 'ar' ? 'اعرف المزيد' : 'Learn More';
  String get features => locale.languageCode == 'ar' ? 'المميزات' : 'Features';
  String get pricing => locale.languageCode == 'ar' ? 'الأسعار' : 'Pricing';
  String get contact => locale.languageCode == 'ar' ? 'اتصل بنا' : 'Contact';
  String get support => locale.languageCode == 'ar' ? 'الدعم الفني' : 'Support';
  String get about => locale.languageCode == 'ar' ? 'عن التطبيق' : 'About';
  String get faq => locale.languageCode == 'ar' ? 'الأسئلة الشائعة' : 'FAQ';
  String get privacy => locale.languageCode == 'ar' ? 'سياسة الخصوصية' : 'Privacy Policy';
  String get terms => locale.languageCode == 'ar' ? 'شروط الاستخدام' : 'Terms of Service';
  String get downloadApp => locale.languageCode == 'ar' ? 'تحميل التطبيق' : 'Download App';
  String get systemRequirements => locale.languageCode == 'ar' ? 'متطلبات النظام' : 'System Requirements';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}