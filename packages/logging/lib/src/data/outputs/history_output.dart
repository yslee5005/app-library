import 'dart:collection';

import '../../domain/log_category.dart';
import '../../domain/log_entry.dart';
import '../../domain/log_level.dart';
import '../../domain/log_output.dart';

/// In-memory ring buffer [LogOutput] that stores the last [maxEntries] logs.
///
/// Provides query API for [LogViewerScreen] and log export.
///
/// ```dart
/// final history = HistoryOutput(maxEntries: 500);
/// final logger = Logger(outputs: [ConsoleOutput(), history]);
///
/// // Later: retrieve logs
/// final recent = history.entries;
/// final errors = history.where(level: LogLevel.error);
/// ```
class HistoryOutput implements LogOutput {
  HistoryOutput({this.maxEntries = 500});

  final int maxEntries;
  final Queue<LogEntry> _buffer = Queue<LogEntry>();

  @override
  void write(LogEntry entry) {
    _buffer.addLast(entry);
    if (_buffer.length > maxEntries) {
      _buffer.removeFirst();
    }
  }

  /// All entries, newest last.
  List<LogEntry> get entries => _buffer.toList();

  /// Filtered entries by level and/or category.
  List<LogEntry> where({
    LogLevel? level,
    LogCategory? category,
    String? search,
  }) {
    var result = _buffer.where((_) => true);

    if (level != null) {
      result = result.where((e) => e.level == level);
    }
    if (category != null) {
      result = result.where((e) => e.category == category);
    }
    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      result = result.where(
        (e) =>
            e.message.toLowerCase().contains(query) ||
            (e.error?.toString().toLowerCase().contains(query) ?? false),
      );
    }

    return result.toList();
  }

  /// Export all entries (or filtered) as a single string for sharing.
  String export({
    LogLevel? level,
    LogCategory? category,
    String? search,
  }) {
    final entries = where(level: level, category: category, search: search);
    final buffer = StringBuffer()
      ..writeln('=== App Logs (${entries.length} entries) ===')
      ..writeln('Exported: ${DateTime.now().toIso8601String()}')
      ..writeln();

    for (final e in entries) {
      buffer.write('${e.level.name.toUpperCase().padRight(7)} ');
      buffer.write(e.prefix);
      buffer.write(' ');
      buffer.writeln(e.message);
      if (e.error != null) {
        buffer.writeln('  ERROR: ${e.error}');
      }
      if (e.stackTrace != null) {
        // Only first 5 lines of stack trace
        final lines = e.stackTrace.toString().split('\n').take(5);
        for (final line in lines) {
          buffer.writeln('  $line');
        }
      }
    }

    return buffer.toString();
  }

  /// Total entry count.
  int get length => _buffer.length;

  /// Clear all entries.
  void clear() => _buffer.clear();
}
