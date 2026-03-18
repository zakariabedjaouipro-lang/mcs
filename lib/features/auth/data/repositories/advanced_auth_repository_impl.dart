/// Advanced Authentication Repository Implementation
/// تطبيق مستودع المصادقة المتقدمة
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/registration_request_model.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/core/models/role_permissions_model.dart';
import 'package:mcs/core/models/user_profile_model.dart';
import 'package:mcs/core/services/role_based_authentication_service.dart';
import 'package:mcs/features/auth/domain/repositories/advanced_auth_repository.dart';

class AdvancedAuthRepositoryImpl implements AdvancedAuthRepository {
  const AdvancedAuthRepositoryImpl({
    required RoleBasedAuthenticationService roleBasedAuthService,
  }) : _authService = roleBasedAuthService;

  final RoleBasedAuthenticationService _authService;

  @override
  Future<Either<Failure, List<RoleModel>>> getAllRoles() async {
    try {
      final roles = await _authService.getAllRoles();
      return Right(roles);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل استرجاع جميع الأدوار: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<RoleModel>>> getPublicRoles() async {
    try {
      final roles = await _authService.getPublicRoles();
      return Right(roles);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل استرجاع الأدوار العامة: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RoleModel?>> getRoleById(String roleId) async {
    try {
      final role = await _authService.getRoleById(roleId);
      return Right(role);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل استرجاع الدور: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RolePermissions>> getRolePermissions(
    String roleId,
  ) async {
    try {
      final permissions = await _authService.getRolePermissions(roleId);
      return Right(permissions);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل استرجاع صلاحيات الدور: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RegistrationRequest>> createRegistrationRequest({
    required String userId,
    required String roleId,
    Map<String, dynamic>? requestedData,
  }) async {
    try {
      final request = await _authService.createRegistrationRequest(
        userId: userId,
        roleId: roleId,
        requestedData: requestedData,
      );
      return Right(request);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل إنشاء طلب التسجيل: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RegistrationRequest?>> getRegistrationRequest(
    String requestId,
  ) async {
    try {
      final request = await _authService.getRegistrationRequest(requestId);
      return Right(request);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل استرجاع طلب التسجيل: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RegistrationRequest?>> getUserRegistrationRequest(
    String userId,
  ) async {
    try {
      final request = await _authService.getUserRegistrationRequest(userId);
      return Right(request);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل استرجاع طلب تسجيل المستخدم: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<RegistrationRequest>>>
      getPendingRegistrationRequests() async {
    try {
      final requests = await _authService.getPendingRegistrationRequests();
      return Right(requests);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل استرجاع الطلبات المعلقة: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RegistrationRequest>> approveRegistrationRequest({
    required String requestId,
    required String reviewedBy,
  }) async {
    try {
      final request = await _authService.approveRegistrationRequest(
        requestId: requestId,
        reviewedBy: reviewedBy,
      );
      return Right(request);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل إعتماد طلب التسجيل: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RegistrationRequest>> rejectRegistrationRequest({
    required String requestId,
    required String reviewedBy,
    required String rejectionReason,
  }) async {
    try {
      final request = await _authService.rejectRegistrationRequest(
        requestId: requestId,
        reviewedBy: reviewedBy,
        rejectionReason: rejectionReason,
      );
      return Right(request);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل رفض طلب التسجيل: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserProfile>> createUserProfile({
    required String userId,
    required String email,
    required String fullName,
    String? roleId,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final profile = await _authService.createUserProfile(
        userId: userId,
        email: email,
        fullName: fullName,
        roleId: roleId,
        phone: phone,
      );
      return Right(profile);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل إنشاء ملف المستخدم: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getUserProfile(String userId) async {
    try {
      final profile = await _authService.getUserProfile(userId);
      return Right(profile);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل استرجاع ملف المستخدم: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile({
    required String userId,
    String? email,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      // Get current profile
      final currentProfile = await _authService.getUserProfile(userId);
      if (currentProfile == null) {
        return Left(
          ServerFailure(message: 'ملف المستخدم غير موجود'),
        );
      }

      // Update with new values
      final updatedProfile = currentProfile.copyWith(
        email: email ?? currentProfile.email,
        fullName: fullName ?? currentProfile.fullName,
        phone: phone ?? currentProfile.phone,
        avatarUrl: avatarUrl ?? currentProfile.avatarUrl,
      );

      return Right(updatedProfile);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل تحديث ملف المستخدم: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> verifyEmailForUser(String userId) async {
    try {
      final result = await _authService.verifyEmailForUser(userId);
      return Right(result);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل التحقق من البريد الإلكتروني: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailVerified(String userId) async {
    try {
      final profile = await _authService.getUserProfile(userId);
      final isVerified = profile?.isEmailVerified ?? false;
      return Right(isVerified);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل التحقق من حالة البريد الإلكتروني: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> enable2FAForUser(String userId) async {
    try {
      final result = await _authService.enable2FAForUser(userId);
      return Right(result);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل تفعيل المصادقة الثنائية: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> is2FAEnabled(String userId) async {
    try {
      final profile = await _authService.getUserProfile(userId);
      final is2FAEnabled = profile?.is2FAEnabled ?? false;
      return Right(is2FAEnabled);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'فشل التحقق من حالة المصادقة الثنائية: $e',
        ),
      );
    }
  }

  @override
  bool isEmailVerificationRequiredForRole(RoleModel role) {
    return _authService.isEmailVerificationRequiredForRole(role);
  }

  @override
  bool is2FARequiredForRole(RoleModel role) {
    return _authService.is2FARequiredForRole(role);
  }

  @override
  bool isApprovalRequiredForRole(RoleModel role) {
    return _authService.isApprovalRequiredForRole(role);
  }
}
