import 'package:app_lib_core/core.dart';

import 'error_level.dart';
import 'error_logging_service.dart';

/// Wraps an [ErrorLoggingService] to filter behavior based on [AppEnvironment].
///
/// - **dev**: logs everything locally, skips remote capture
/// - **staging**: logs to remote, includes breadcrumbs
/// - **prod**: logs to remote, minimal breadcrumbs, no stack traces in messages
///
/// Usage:
/// ```dart
/// final sentry = SentryLoggingService();
/// final logger = EnvironmentAwareLogging(
///   inner: sentry,
///   environment: AppEnvironment.fromString(
///     const String.fromEnvironment('ENV', defaultValue: 'dev'),
///   ),
/// );
/// ```
final class EnvironmentAwareLogging implements ErrorLoggingService {
  const EnvironmentAwareLogging({
    required this.inner,
    required this.environment,
  });

  /// The actual logging service (e.g., Sentry).
  final ErrorLoggingService inner;

  /// Current app environment.
  final AppEnvironment environment;

  @override
  Future<void> log(
    String message, {
    ErrorLevel level = ErrorLevel.info,
  }) async {
    // In dev, only print locally — don't send info/warning to remote.
    if (environment.isDebug && level != ErrorLevel.fatal && level != ErrorLevel.error) {
      return;
    }
    await inner.log(message, level: level);
  }

  @override
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    ErrorLevel level = ErrorLevel.error,
    Map<String, String>? tags,
  }) async {
    // Always capture exceptions, but add environment tag.
    final enrichedTags = {
      ...?tags,
      'environment': environment.name,
    };

    // In prod, strip stack trace from non-fatal errors to reduce noise.
    final effectiveStack = environment.showStackTraces ? stackTrace : null;

    await inner.captureException(
      exception,
      stackTrace: level == ErrorLevel.fatal ? stackTrace : effectiveStack,
      level: level,
      tags: enrichedTags,
    );
  }

  @override
  void addBreadcrumb({
    required String message,
    String? category,
    Map<String, String>? data,
  }) {
    // Only add breadcrumbs if environment supports it.
    if (!environment.captureBreadcrumbs) return;
    inner.addBreadcrumb(message: message, category: category, data: data);
  }
}
