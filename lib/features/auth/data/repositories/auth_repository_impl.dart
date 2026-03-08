import 'package:dartz/dartz.dart';
import 'package:mcs/core/enums/user_role.dart';
import 'package:mcs/core/errors/exceptions.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/user_model.dart';
import 'package:mcs/core/services/auth_service.dart';
import 'package:mcs/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// تنفيذ مستودع المصادقة
/// يتعامل مع تحويل الاستثناءات إلى [Failure] objects
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
  }) : _authService = authService;
  final AuthService _authService;

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      final authUser = result.user;
      if (authUser == null) {
        return const Left(AuthFailure(message: 'فشل تسجيل الدخول'));
      }

      final roleStr = authUser.userMetadata?['role'] as String? ?? 'patient';
      final createdAt = _parseDateTime(authUser.createdAt);
      final updatedAt = _parseDateTime(authUser.updatedAt);
      final userId = authUser.id;

      final user = UserModel(
        id: userId,
        fullName: authUser.userMetadata?['name'] as String?,
        email: authUser.email ?? '',
        phone: authUser.phone,
        role: UserRole.fromDbValue(roleStr),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      return Right(user);
    } on AppException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'فشل تسجيل الدخول: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final result = await _authService.signUpWithEmail(
        email: email,
        password: password,
        metadata: {'name': name, 'phone': phone, 'role': role},
      );

      final user = UserModel(
        id: result.user?.id ?? '',
        fullName: name,
        email: email,
        phone: phone,
        role: UserRole.fromDbValue(role),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return Right(user);
    } on AppException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'فشل التسجيل: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      await _authService.verifyOtp(
        contactInfo: email,
        token: otp,
        otpType: OtpType.email,
      );

      return const Right(true);
    } on AppException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'فشل التحقق من OTP: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword({
    required String contactInfo,
    required String method,
  }) async {
    try {
      if (method == 'email') {
        await _authService.resetPassword(email: contactInfo);
      }

      return const Right(true);
    } on AppException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'فشل إرسال رمز التحقق: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      // First verify the OTP before resetting password
      await _authService.verifyOtp(
        contactInfo: email,
        token: otp,
        otpType: OtpType.email,
      );

      // Then update the password
      await _authService.updatePassword(newPassword: newPassword);

      return const Right(true);
    } on AppException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'فشل إعادة تعيين كلمة المرور: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Get current user's email
      final authUser = _authService.currentUser;
      if (authUser == null || authUser.email == null) {
        return const Left(AuthFailure(message: 'المستخدم غير مسجل الدخول'));
      }

      // Re-authenticate with current password to verify it's correct
      await _authService.reauthenticate(
        email: authUser.email!,
        password: currentPassword,
      );

      // Update to new password
      await _authService.updatePassword(newPassword: newPassword);

      return const Right(true);
    } on AppException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'فشل تغيير كلمة المرور: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _authService.signOut();

      return const Right(true);
    } on AppException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'فشل تسجيل الخروج: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final authUser = _authService.currentUser;

      if (authUser == null) {
        return const Right(null);
      }

      final roleStr = authUser.userMetadata?['role'] as String? ?? 'patient';
      final createdAt = _parseDateTime(authUser.createdAt);
      final updatedAt = _parseDateTime(authUser.updatedAt);
      final userId = authUser.id;

      final user = UserModel(
        id: userId,
        fullName: authUser.userMetadata?['name'] as String?,
        email: authUser.email ?? '',
        phone: authUser.phone,
        role: UserRole.fromDbValue(roleStr),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      return Right(user);
    } catch (e) {
      return Left(
        ServerFailure(message: 'فشل الحصول على بيانات المستخدم: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isUserLoggedIn() async {
    try {
      final user = _authService.currentUser;
      return Right(user != null);
    } catch (e) {
      return Left(
        ServerFailure(message: 'خطأ في التحقق من الجلسة: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _authService.updateUserMetadata(updates);

      final authUser = _authService.currentUser;
      if (authUser == null) {
        return const Left(AuthFailure(message: 'المستخدم غير مصرح'));
      }

      final roleStr = updates['role'] as String? ??
          authUser.userMetadata?['role'] as String? ??
          'patient';
      final createdAt = _parseDateTime(authUser.createdAt);

      final user = UserModel(
        id: authUser.id,
        fullName: updates['fullName'] as String? ??
            authUser.userMetadata?['name'] as String?,
        email: authUser.email ?? '',
        phone: updates['phone'] as String? ?? authUser.phone,
        role: UserRole.fromDbValue(roleStr),
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

      return Right(user);
    } on AppException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'فشل تحديث الملف الشخصي: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginWithSocial({
    required String provider,
    required String token,
  }) async {
    try {
      throw UnimplementedError('Social login not yet implemented');
    } on AppException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(
        ServerFailure(message: 'فشل تسجيل الدخول عبر وسائل التواصل: $e'),
      );
    }
  }

  /// Helper function to parse DateTime from String
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

