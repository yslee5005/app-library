import 'error_level.dart';

/// Abstract interface for error logging services.
///
/// Implementations may send errors to Sentry, Crashlytics,
/// or any other monitoring service.
///
/// Example:
/// ```dart
/// class SentryLoggingService implements ErrorLoggingService {
///   @override
///   Future<void> log(String message, {ErrorLevel level = ErrorLevel.info}) async {
///     Sentry.captureMessage(message, level: _toSentryLevel(level));
///   }
///   // ...
/// }
/// ```
abstract interface class ErrorLoggingService {
  /// Logs a message at the given [level].
  Future<void> log(
    String message, {
    ErrorLevel level = ErrorLevel.info,
  });

  /// Captures an exception with optional stack trace.
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    ErrorLevel level = ErrorLevel.error,
    Map<String, String>? tags,
  });

  /// Adds a breadcrumb for debugging context.
  void addBreadcrumb({
    required String message,
    String? category,
    Map<String, String>? data,
  });
}
