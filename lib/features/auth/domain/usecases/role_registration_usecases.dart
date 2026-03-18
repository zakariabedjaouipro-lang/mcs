/// Use Cases for role-based registration
/// حالات الاستخدام المتعلقة بالتسجيل المعتمد على الأدوار
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/registration_request_model.dart';
import 'package:mcs/core/models/role_model.dart';
import 'package:mcs/core/models/role_permissions_model.dart';
import 'package:mcs/core/models/user_profile_model.dart';
import 'package:mcs/core/services/role_based_authentication_service.dart';
import 'package:mcs/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

// ═══════════════════════════════════════════════════════════════════
// GET ALL ROLES USE CASE
// ═══════════════════════════════════════════════════════════════════

class GetAllRolesUseCase extends UseCase<List<RoleModel>, NoParams> {
  GetAllRolesUseCase(this.authService);

  final RoleBasedAuthenticationService authService;

  @override
  Future<Either<Failure, List<RoleModel>>> call(NoParams params) async {
    try {
      final roles = await authService.getAllRoles();
      return Right(roles);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل استرجاع الأدوار: $e'));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// GET PUBLIC ROLES USE CASE
// ═══════════════════════════════════════════════════════════════════

class GetPublicRolesUseCase extends UseCase<List<RoleModel>, NoParams> {
  GetPublicRolesUseCase(this.authService);

  final RoleBasedAuthenticationService authService;

  @override
  Future<Either<Failure, List<RoleModel>>> call(NoParams params) async {
    try {
      final roles = await authService.getPublicRoles();
      return Right(roles);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل استرجاع الأدوار العامة: $e'));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// GET ROLE PERMISSIONS USE CASE
// ═══════════════════════════════════════════════════════════════════

class GetRolePermissionsParams extends Equatable {
  const GetRolePermissionsParams({required this.roleId});

  final String roleId;

  @override
  List<Object?> get props => [roleId];
}

class GetRolePermissionsUseCase
    extends UseCase<RolePermissions, GetRolePermissionsParams> {
  GetRolePermissionsUseCase(this.authService);

  final RoleBasedAuthenticationService authService;

  @override
  Future<Either<Failure, RolePermissions>> call(
      GetRolePermissionsParams params) async {
    try {
      final permissions = await authService.getRolePermissions(params.roleId);
      return Right(permissions);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل استرجاع الصلاحيات: $e'));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// CREATE REGISTRATION REQUEST USE CASE
// ═══════════════════════════════════════════════════════════════════

class CreateRegistrationRequestParams extends Equatable {
  const CreateRegistrationRequestParams({
    required this.userId,
    required this.roleId,
    this.requestedData,
  });

  final String userId;
  final String roleId;
  final Map<String, dynamic>? requestedData;

  @override
  List<Object?> get props => [userId, roleId, requestedData];
}

class CreateRegistrationRequestUseCase
    extends UseCase<RegistrationRequest, CreateRegistrationRequestParams> {
  CreateRegistrationRequestUseCase(this.authService);

  final RoleBasedAuthenticationService authService;

  @override
  Future<Either<Failure, RegistrationRequest>> call(
    CreateRegistrationRequestParams params,
  ) async {
    try {
      final request = await authService.createRegistrationRequest(
        userId: params.userId,
        roleId: params.roleId,
        requestedData: params.requestedData,
      );
      return Right(request);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل إنشاء طلب التسجيل: $e'));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// VERIFY EMAIL USE CASE
// ═══════════════════════════════════════════════════════════════════

class VerifyEmailParams extends Equatable {
  const VerifyEmailParams({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class VerifyEmailUseCase extends UseCase<bool, VerifyEmailParams> {
  VerifyEmailUseCase(this.authService);

  final RoleBasedAuthenticationService authService;

  @override
  Future<Either<Failure, bool>> call(VerifyEmailParams params) async {
    try {
      final result = await authService.verifyEmailForUser(params.userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل التحقق من البريد: $e'));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// ENABLE 2FA USE CASE
// ═══════════════════════════════════════════════════════════════════

class Enable2FAParams extends Equatable {
  const Enable2FAParams({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class Enable2FAUseCase extends UseCase<bool, Enable2FAParams> {
  Enable2FAUseCase(this.authService);

  final RoleBasedAuthenticationService authService;

  @override
  Future<Either<Failure, bool>> call(Enable2FAParams params) async {
    try {
      final result = await authService.enable2FAForUser(params.userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل تفعيل المصادقة الثنائية: $e'));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// GET PENDING REGISTRATION REQUESTS USE CASE
// ═══════════════════════════════════════════════════════════════════

class GetPendingRegistrationRequestsUseCase
    extends UseCase<List<RegistrationRequest>, NoParams> {
  GetPendingRegistrationRequestsUseCase(this.authService);

  final RoleBasedAuthenticationService authService;

  @override
  Future<Either<Failure, List<RegistrationRequest>>> call(
      NoParams params) async {
    try {
      final requests = await authService.getPendingRegistrationRequests();
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل استرجاع الطلبات المعلقة: $e'));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// APPROVE REGISTRATION REQUEST USE CASE
// ═══════════════════════════════════════════════════════════════════

class ApproveRegistrationRequestParams extends Equatable {
  const ApproveRegistrationRequestParams({
    required this.requestId,
    required this.reviewedBy,
  });

  final String requestId;
  final String reviewedBy;

  @override
  List<Object?> get props => [requestId, reviewedBy];
}

class ApproveRegistrationRequestUseCase
    extends UseCase<RegistrationRequest, ApproveRegistrationRequestParams> {
  ApproveRegistrationRequestUseCase(this.authService);

  final RoleBasedAuthenticationService authService;

  @override
  Future<Either<Failure, RegistrationRequest>> call(
    ApproveRegistrationRequestParams params,
  ) async {
    try {
      final request = await authService.approveRegistrationRequest(
        requestId: params.requestId,
        reviewedBy: params.reviewedBy,
      );
      return Right(request);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل إعتماد طلب التسجيل: $e'));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// REJECT REGISTRATION REQUEST USE CASE
// ═══════════════════════════════════════════════════════════════════

class RejectRegistrationRequestParams extends Equatable {
  const RejectRegistrationRequestParams({
    required this.requestId,
    required this.reviewedBy,
    required this.rejectionReason,
  });

  final String requestId;
  final String reviewedBy;
  final String rejectionReason;

  @override
  List<Object?> get props => [requestId, reviewedBy, rejectionReason];
}

class RejectRegistrationRequestUseCase
    extends UseCase<RegistrationRequest, RejectRegistrationRequestParams> {
  RejectRegistrationRequestUseCase(this.authService);

  final RoleBasedAuthenticationService authService;

  @override
  Future<Either<Failure, RegistrationRequest>> call(
    RejectRegistrationRequestParams params,
  ) async {
    try {
      final request = await authService.rejectRegistrationRequest(
        requestId: params.requestId,
        reviewedBy: params.reviewedBy,
        rejectionReason: params.rejectionReason,
      );
      return Right(request);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل رفض طلب التسجيل: $e'));
    }
  }
}
