import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../../core/models/user_approval_model.dart';
import '../../core/usecases/approval_usecase.dart';
import '../datasources/approval_remote_data_source.dart';

/// Implementation of ApprovalRepository
class ApprovalRepositoryImpl implements ApprovalRepository {
  const ApprovalRepositoryImpl({required this.remoteDataSource});

  final ApprovalRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<UserApprovalModel>>> getPendingApprovals() async {
    try {
      final approvals = await remoteDataSource.getPendingApprovals();
      return Right(approvals);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to fetch pending approvals: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserApprovalModel>> getApprovalRequest(
    String userId,
  ) async {
    try {
      final approval = await remoteDataSource.getApprovalRequest(userId);
      return Right(approval);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to fetch approval request: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> approveUser({
    required String userId,
    String? approvalNotes,
  }) async {
    try {
      await remoteDataSource.approveUser(
        userId: userId,
        approvalNotes: approvalNotes,
      );
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to approve user: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> rejectUser({
    required String userId,
    required String rejectionReason,
  }) async {
    try {
      await remoteDataSource.rejectUser(
        userId: userId,
        rejectionReason: rejectionReason,
      );
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to reject user: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<UserApprovalModel>>> getApprovalsByStatus(
    ApprovalStatus status,
  ) async {
    try {
      final approvals =
          await remoteDataSource.getApprovalsByStatus(status.name);
      return Right(approvals);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to fetch approvals by status: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<UserApprovalModel>>> getApprovalsByRole(
    String role,
  ) async {
    try {
      final approvals = await remoteDataSource.getApprovalsByRole(role);
      return Right(approvals);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to fetch approvals by role: $e',
        ),
      );
    }
  }
}
