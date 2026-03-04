import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/models/user_model.dart';
import 'package:mcs/core/usecases/usecase.dart';
import 'package:mcs/features/auth/domain/repositories/auth_repository.dart';

/// حالة الاستخدام للتسجيل
/// يحول طلب التسجيل إلى [Either<Failure, UserModel>]
class RegisterUseCase implements UseCase<UserModel, RegisterParams> {
  RegisterUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, UserModel>> call(RegisterParams params) async {
    return repository.register(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
      role: params.role,
    );
  }
}

/// معاملات حالة الاستخدام RegisterUseCase
class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;

  @override
  List<Object> get props => [name, email, phone, password, role];
}
