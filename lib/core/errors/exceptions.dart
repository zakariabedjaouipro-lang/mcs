/// Exception classes used in the data layer.
///
/// These are caught by repository implementations and converted
/// into [Failure] objects for the domain layer.
library;

/// Base exception with an optional message and status code.
abstract class AppException implements Exception {
  const AppException({this.message = '', this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType: $message (status: $statusCode)';
}

// ── Server / Network ───────────────────────────────────────

/// Thrown when a Supabase or remote API call returns an error.
class ServerException extends AppException {
  const ServerException({super.message = 'Server error', super.statusCode});
}

/// Thrown when the device has no internet connectivity.
class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection'});
}

/// Thrown when a network request exceeds the timeout duration.
class TimeoutException extends AppException {
  const TimeoutException({super.message = 'Request timed out'});
}

// ── Auth ────────────────────────────────────────────────────

/// Thrown for authentication errors (wrong credentials, expired OTP, etc.).
class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication failed',
    super.statusCode,
  });
}

/// Thrown when the user's token/session is no longer valid.
class SessionExpiredException extends AppException {
  const SessionExpiredException({
    super.message = 'Session expired',
    super.statusCode = 401,
  });
}

/// Thrown when the user lacks permissions for the requested action.
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.statusCode = 403,
  });
}

// ── Data ────────────────────────────────────────────────────

/// Thrown when a query returns no results for an expected record.
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
  });
}

/// Thrown when local storage / cache operations fail.
class CacheException extends AppException {
  const CacheException({super.message = 'Cache error'});
}

// ── Validation ─────────────────────────────────────────────

/// Thrown when data does not pass validation before being sent.
class ValidationException extends AppException {
  const ValidationException({super.message = 'Validation error'});
}

// ── Subscription ───────────────────────────────────────────

/// Thrown when the clinic's subscription is expired or suspended.
class SubscriptionException extends AppException {
  const SubscriptionException({
    super.message = 'Subscription is not active',
  });
}
