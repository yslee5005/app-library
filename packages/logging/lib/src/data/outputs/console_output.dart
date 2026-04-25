import 'package:flutter/foundation.dart';

import '../../domain/log_entry.dart';
import '../../domain/log_level.dart';
import '../../domain/log_output.dart';

/// Outputs log entries to the terminal via [debugPrint].
///
/// Guaranteed to show in `flutter run` terminal in both debug and profile mode.
/// Uses emoji prefixes for quick visual scanning.
class ConsoleOutput implements LogOutput {
  const ConsoleOutput();

  @override
  void write(LogEntry entry) {
    final icon = _levelIcon(entry.level);
    final buffer =
        StringBuffer()
          ..write(icon)
          ..write(' ')
          ..write(entry.prefix)
          ..write(' ')
          ..write(entry.message);

    if (entry.error != null) {
      buffer
        ..write('\n')
        ..write('   ')
        ..write(_levelIcon(entry.level))
        ..write(' ERROR: ')
        ..write(entry.error);
    }

    debugPrint(buffer.toString());

    if (entry.stackTrace != null) {
      final lines = entry.stackTrace.toString().split('\n').take(5);
      for (final line in lines) {
        debugPrint('      $line');
      }
    }
  }

  static String _levelIcon(LogLevel level) => switch (level) {
    LogLevel.debug => '\u{1F535}', // 🔵
    LogLevel.info => '\u{1F7E2}', // 🟢
    LogLevel.warning => '\u{1F7E1}', // 🟡
    LogLevel.error => '\u{1F534}', // 🔴
  };
}
