import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/user_model.dart';

/// واجهة مستودع المصادقة - التعريف الأساسي للعمليات
abstract class AuthRepository {
  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  /// يرجع [UserModel] عند النجاح أو [Failure] عند الفشل
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });

  /// تسجيل حساب جديد
  /// يرجع [UserModel] عند النجاح أو [Failure] عند الفشل
  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  });

  /// التحقق من رمز OTP
  /// يرجع true عند النجاح أو [Failure] عند الفشل
  Future<Either<Failure, bool>> verifyOTP({
    required String email,
    required String otp,
  });

  /// طلب استعادة كلمة المرور
  /// يرسل رمز التحقق عبر البريد أو الهاتف
  Future<Either<Failure, bool>> forgotPassword({
    required String contactInfo,
    required String method, // 'email' or 'phone'
  });

  /// تغيير كلمة المرور باستخدام رمز التحقق
  /// يرجع true عند النجاح أو [Failure] عند الفشل
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  /// تغيير كلمة المرور للمستخدم المسجل دخول
  /// يرجع true عند النجاح أو [Failure] عند الفشل
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// تسجيل الخروج
  /// يرجع true عند النجاح أو [Failure] عند الفشل
  Future<Either<Failure, bool>> logout();

  /// الحصول على المستخدم الحالي من الجلسة
  /// يرجع [UserModel] إذا كان هناك مستخدم مسجل دخول
  Future<Either<Failure, UserModel?>> getCurrentUser();

  /// التحقق من صحة جلسة التسجيل
  Future<Either<Failure, bool>> isUserLoggedIn();

  /// تحديث بيانات المستخدم
  /// يرجع [UserModel] المحدثة عند النجاح
  Future<Either<Failure, UserModel>> updateProfile({
    required String userId,
    required Map<String, dynamic> updates,
  });

  /// تسجيل الدخول عبر وسائل التواصل الاجتماعي
  /// يرجع [UserModel] عند النجاح أو [Failure] عند الفشل
  Future<Either<Failure, UserModel>> loginWithSocial({
    required String provider, // 'google', 'facebook', 'apple'
    required String token,
  });
}
