import 'log_category.dart';
import 'log_level.dart';

/// Immutable log entry passed to [LogOutput] implementations.
class LogEntry {
  const LogEntry({
    required this.level,
    required this.message,
    required this.category,
    required this.timestamp,
    this.tag,
    this.error,
    this.stackTrace,
  });

  final LogLevel level;
  final String message;
  final LogCategory category;
  final DateTime timestamp;
  final String? tag;
  final Object? error;
  final StackTrace? stackTrace;

  /// Formatted prefix: `[CATEGORY] HH:MM:SS`
  String get prefix {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    final cat = category.name.toUpperCase();
    return '[$cat] $h:$m:$s';
  }
}
