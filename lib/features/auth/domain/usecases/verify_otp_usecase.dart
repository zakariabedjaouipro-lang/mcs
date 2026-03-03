import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mcs/core/errors/failures.dart';
import 'package:mcs/core/usecases/usecase.dart';
import 'package:mcs/features/auth/domain/repositories/auth_repository.dart';

/// حالة الاستخدام للتحقق من OTP
/// يحول طلب التحقق من رمز OTP إلى [Either<Failure, bool>]
class VerifyOTPUseCase implements UseCase<bool, VerifyOTPParams> {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyOTPParams params) async {
    return repository.verifyOTP(
      email: params.email,
      otp: params.otp,
    );
  }
}

/// معاملات حالة الاستخدام VerifyOTPUseCase
class VerifyOTPParams extends Equatable {
  final String email;
  final String otp;

  const VerifyOTPParams({
    required this.email,
    required this.otp,
  });

  @override
  List<Object> get props => [email, otp];
}
