import 'package:dartz/dartz.dart';

import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/usecases/approval_usecase.dart';
import 'package:mcs/core/usecases/usecase.dart';

class CreateApprovalRequestParams {

  CreateApprovalRequestParams({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.role,
    required this.registrationType,
  });
  final String userId;
  final String email;
  final String fullName;
  final String role;
  final String registrationType;
}

class CreateApprovalRequestUseCase
    extends UseCase<void, CreateApprovalRequestParams> {
  CreateApprovalRequestUseCase(this.repository);

  final ApprovalRepository repository;

  @override
  Future<Either<Failure, void>> call(
    CreateApprovalRequestParams params,
  ) async {
    return repository.createApprovalRequest(
      userId: params.userId,
      email: params.email,
      fullName: params.fullName,
      role: params.role,
      registrationType: params.registrationType,
    );
  }
}