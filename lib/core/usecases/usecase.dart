import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mcs/core/errors/failures.dart';

/// Abstract base class for all use cases.
///
/// [Type] - return type of the use case
/// [Params] - parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Parameters placeholder for use cases that don't require any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
