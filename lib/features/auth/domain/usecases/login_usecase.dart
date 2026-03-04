import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/user_model.dart';
import 'package:mcs/core/usecases/usecase.dart';
import 'package:mcs/features/auth/domain/repositories/auth_repository.dart';

/// حالة الاستخدام لتسجيل الدخول
/// يحول طلب تسجيل الدخول إلى [Either<Failure, UserModel>]
class LoginUseCase implements UseCase<UserModel, LoginParams> {
  LoginUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, UserModel>> call(LoginParams params) async {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// معاملات حالة الاستخدام LoginUseCase
class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
