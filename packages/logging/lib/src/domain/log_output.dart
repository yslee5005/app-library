import 'log_entry.dart';

/// Strategy interface for log output destinations.
///
/// Implementations include [ConsoleOutput], [SentryBreadcrumbOutput],
/// and [NoopOutput].
abstract interface class LogOutput {
  void write(LogEntry entry);
}
