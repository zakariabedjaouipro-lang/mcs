import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mcs/core/errors/failures.dart';

/// Abstract base class for all use cases.
///
/// [T] - return type of the use case
/// [Params] - parameters required by the use case
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Parameters placeholder for use cases that don't require any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

