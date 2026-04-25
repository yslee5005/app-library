import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../filters/sensitive_data_filter.dart';
import '../services/error_level.dart';
import '../services/error_logging_service.dart';

/// Provider for the [ErrorLoggingService].
///
/// Apps must override this provider with their concrete implementation
/// (e.g., Sentry) in the root ProviderScope:
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     errorLoggingServiceProvider.overrideWithValue(SentryLoggingService()),
///   ],
///   child: MyApp(),
/// )
/// ```
final errorLoggingServiceProvider = Provider<ErrorLoggingService>(
  (ref) =>
      throw UnimplementedError(
        'errorLoggingServiceProvider must be overridden with a concrete '
        'ErrorLoggingService implementation (e.g., Sentry).',
      ),
);

/// Convenience provider that logs with automatic sensitive-data masking.
///
/// Usage:
/// ```dart
/// ref.read(safeLoggerProvider).log('User email: foo@bar.com');
/// // Actually logged as: "User email: f***o@b***r.com"
/// ```
final safeLoggerProvider = Provider<SafeLogger>((ref) {
  return SafeLogger(service: ref.watch(errorLoggingServiceProvider));
});

/// Logger that automatically masks sensitive data before sending.
class SafeLogger {
  const SafeLogger({required this.service});

  final ErrorLoggingService service;

  Future<void> log(String message, {ErrorLevel level = ErrorLevel.info}) {
    return service.log(SensitiveDataFilter.mask(message), level: level);
  }

  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    ErrorLevel level = ErrorLevel.error,
    Map<String, String>? tags,
  }) {
    return service.captureException(
      exception,
      stackTrace: stackTrace,
      level: level,
      tags: tags,
    );
  }
}
