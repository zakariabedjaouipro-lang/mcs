import 'package:dartz/dartz.dart';

import '../errors/failure.dart';
import '../models/user_approval_model.dart';
import '../usecases/usecase.dart';

/// Get all pending approval requests
/// Use Case لجلب جميع طلبات الموافقة المعلقة
class GetPendingApprovalsUseCase
    implements UseCase<List<UserApprovalModel>, NoParams> {
  const GetPendingApprovalsUseCase(this.repository);

  final ApprovalRepository repository;

  @override
  Future<Either<Failure, List<UserApprovalModel>>> call(NoParams params) {
    return repository.getPendingApprovals();
  }
}

/// Approve a user
/// Use Case لموافقة على المستخدم
class ApproveUserUseCase implements UseCase<void, ApproveUserParams> {
  const ApproveUserUseCase(this.repository);

  final ApprovalRepository repository;

  @override
  Future<Either<Failure, void>> call(ApproveUserParams params) {
    return repository.approveUser(
      userId: params.userId,
      approvalNotes: params.approvalNotes,
    );
  }
}

class ApproveUserParams {
  const ApproveUserParams({
    required this.userId,
    this.approvalNotes,
  });

  final String userId;
  final String? approvalNotes;
}

/// Reject a user
/// Use Case لرفض المستخدم
class RejectUserUseCase implements UseCase<void, RejectUserParams> {
  const RejectUserUseCase(this.repository);

  final ApprovalRepository repository;

  @override
  Future<Either<Failure, void>> call(RejectUserParams params) {
    return repository.rejectUser(
      userId: params.userId,
      rejectionReason: params.rejectionReason,
    );
  }
}

class RejectUserParams {
  const RejectUserParams({
    required this.userId,
    required this.rejectionReason,
  });

  final String userId;
  final String rejectionReason;
}

/// Repository interface for approval operations
/// واجهة المستودع لعمليات الموافقة
abstract class ApprovalRepository {
  /// Get all pending approvals
  Future<Either<Failure, List<UserApprovalModel>>> getPendingApprovals();

  /// Get a single approval request
  Future<Either<Failure, UserApprovalModel>> getApprovalRequest(String userId);

  /// Approve a user
  Future<Either<Failure, void>> approveUser({
    required String userId,
    String? approvalNotes,
  });

  /// Reject a user
  Future<Either<Failure, void>> rejectUser({
    required String userId,
    required String rejectionReason,
  });

  /// Get approval requests by status
  Future<Either<Failure, List<UserApprovalModel>>> getApprovalsByStatus(
    ApprovalStatus status,
  );

  /// Get approval requests by role
  Future<Either<Failure, List<UserApprovalModel>>> getApprovalsByRole(
    String role,
  );
}
