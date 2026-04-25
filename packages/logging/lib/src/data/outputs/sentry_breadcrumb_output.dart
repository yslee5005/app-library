import 'package:app_lib_error_logging/error_logging.dart';

import '../../domain/log_entry.dart';
import '../../domain/log_level.dart';
import '../../domain/log_output.dart';

/// Forwards log entries to [ErrorLoggingService] as Sentry breadcrumbs.
///
/// Error-level entries also trigger [captureException].
class SentryBreadcrumbOutput implements LogOutput {
  const SentryBreadcrumbOutput({required this.errorService});

  final ErrorLoggingService errorService;

  @override
  void write(LogEntry entry) {
    // Always add breadcrumb
    errorService.addBreadcrumb(
      message: entry.message,
      category: entry.category.name,
      data: {
        'level': entry.level.name,
        if (entry.tag != null) 'tag': entry.tag!,
      },
    );

    // Error+ entries also capture exception
    if (entry.level >= LogLevel.error && entry.error != null) {
      errorService.captureException(
        entry.error!,
        stackTrace: entry.stackTrace,
        level: _toErrorLevel(entry.level),
      );
    }
  }

  static ErrorLevel _toErrorLevel(LogLevel level) => switch (level) {
    LogLevel.error => ErrorLevel.error,
    LogLevel.warning => ErrorLevel.warning,
    _ => ErrorLevel.info,
  };
}
