import 'log_category.dart';
import 'log_level.dart';

/// Configuration for [Logger] behavior.
class LogConfig {
  const LogConfig({
    this.minLevel = LogLevel.debug,
    this.maxMessageLength = 500,
    this.enabledCategories,
    this.redactSensitiveData = true,
  });

  /// Minimum log level to process. Messages below this are dropped.
  final LogLevel minLevel;

  /// Maximum message length before auto-truncation.
  final int maxMessageLength;

  /// If non-null, only these categories are logged. Null = all enabled.
  final Set<LogCategory>? enabledCategories;

  /// Whether to apply sensitive data redaction (emails, tokens, etc.).
  final bool redactSensitiveData;

  /// Production config: warn+ only, redaction enabled.
  static const production = LogConfig(
    minLevel: LogLevel.warning,
    redactSensitiveData: true,
  );

  /// Development config: all levels, all categories.
  static const development = LogConfig(
    minLevel: LogLevel.debug,
    redactSensitiveData: false,
  );
}
