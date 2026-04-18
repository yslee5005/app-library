import '../../domain/log_entry.dart';
import '../../domain/log_output.dart';

/// Silent log output for tests and release builds.
class NoopOutput implements LogOutput {
  const NoopOutput();

  @override
  void write(LogEntry entry) {
    // Intentionally empty
  }
}
