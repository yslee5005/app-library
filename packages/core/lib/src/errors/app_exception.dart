/// Base exception class for all App Library exceptions.
sealed class AppException implements Exception {
  const AppException({
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $message';
}

/// Network-related exceptions (timeout, no connection, etc.)
final class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });

  final int? statusCode;
}

/// Database-related exceptions (query failed, constraint violation, etc.)
final class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    this.table,
    super.originalError,
    super.stackTrace,
  });

  final String? table;
}

/// Authentication-related exceptions
final class AuthException extends AppException {
  const AuthException({
    required super.message,
    this.code,
    super.originalError,
    super.stackTrace,
  });

  final String? code;
}

/// Cache-related exceptions
final class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.originalError,
    super.stackTrace,
  });
}

/// Validation-related exceptions (invalid input, etc.)
final class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    this.field,
    super.originalError,
    super.stackTrace,
  });

  final String? field;
}
