/// UseCase for creating demo accounts.
library;

import 'package:dartz/dartz.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/services/demo_account_service.dart';
import 'package:mcs/core/usecases/usecase.dart';

class CreateDemoAccountsUseCase
    extends UseCase<Map<String, DemoAccountResult>, NoParams> {
  CreateDemoAccountsUseCase(this._demoAccountService);

  final DemoAccountService _demoAccountService;

  @override
  Future<Either<Failure, Map<String, DemoAccountResult>>> call(
    NoParams params,
  ) async {
    try {
      final results = await _demoAccountService.createAllDemoAccounts();
      return Right(results);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to create demo accounts: $e',
        ),
      );
    }
  }
}

/// UseCase for checking if a demo account exists.
class CheckDemoAccountExistsUseCase extends UseCase<bool, String> {
  CheckDemoAccountExistsUseCase(this._demoAccountService);

  final DemoAccountService _demoAccountService;

  @override
  Future<Either<Failure, bool>> call(String role) async {
    try {
      final exists = await _demoAccountService.demoAccountExists(role);
      return Right(exists);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to check demo account: $e',
        ),
      );
    }
  }
}
