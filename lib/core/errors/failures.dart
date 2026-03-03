/// Failure classes used across the domain layer.
///
/// Follows Clean Architecture: use-cases return `Either<Failure, T>`.
library;

import 'package:equatable/equatable.dart';

/// Base failure class.
abstract class Failure extends Equatable {
  const Failure({this.message = '', this.code});

  /// Human-readable error message.
  final String message;

  /// Optional machine-readable error code.
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

// ── Server / Network ───────────────────────────────────────

/// Returned when a remote API call fails.
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error', super.code});
}

/// Returned when there is no internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code,
  });
}

/// Returned when a request times out.
class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Request timed out', super.code});
}

// ── Auth ────────────────────────────────────────────────────

/// Returned for authentication-related errors.
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed', super.code});
}

/// Returned when the user's session has expired.
class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({
    super.message = 'Session expired. Please log in again.',
    super.code,
  });
}

/// Returned when the user doesn't have permission for the action.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'You do not have permission to perform this action',
    super.code,
  });
}

// ── Validation ─────────────────────────────────────────────

/// Returned when input validation fails.
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation error', super.code});
}

// ── Data ────────────────────────────────────────────────────

/// Returned when a requested resource is not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Resource not found', super.code});
}

/// Returned when local cache operations fail.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error', super.code});
}

// ── Subscription ───────────────────────────────────────────

/// Returned when the clinic's subscription is invalid.
class SubscriptionFailure extends Failure {
  const SubscriptionFailure({
    super.message = 'Subscription is not active',
    super.code,
  });
}

// ── Generic ────────────────────────────────────────────────

/// Catch-all for unexpected failures.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code,
  });
}
