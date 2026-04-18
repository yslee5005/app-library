import '../domain/log_category.dart';
import '../domain/log_config.dart';
import '../domain/log_entry.dart';
import '../domain/log_level.dart';
import '../domain/log_output.dart';
import 'redaction/log_redactor.dart';

/// Structured logger with category filtering, level control, and redaction.
///
/// Dispatches [LogEntry] to multiple [LogOutput] destinations.
///
/// Usage:
/// ```dart
/// final logger = Logger(
///   config: LogConfig.development,
///   outputs: [ConsoleOutput(), SentryBreadcrumbOutput(...)],
/// );
///
/// logger.info('Prayer saved', category: LogCategory.prayer);
/// logger.error('AI failed', category: LogCategory.api, error: e);
///
/// // Category-scoped:
/// final dbLog = logger.forCategory(LogCategory.db);
/// dbLog.debug('getComments cursor=$cursor');
/// ```
class Logger {
  Logger({
    required this.config,
    required List<LogOutput> outputs,
    LogRedactor? redactor,
  })  : _outputs = outputs,
        _redactor = redactor;

  final LogConfig config;
  final List<LogOutput> _outputs;
  final LogRedactor? _redactor;

  void debug(
    String message, {
    LogCategory category = LogCategory.general,
    String? tag,
  }) =>
      _log(LogLevel.debug, message, category: category, tag: tag);

  void info(
    String message, {
    LogCategory category = LogCategory.general,
    String? tag,
  }) =>
      _log(LogLevel.info, message, category: category, tag: tag);

  void warning(
    String message, {
    LogCategory category = LogCategory.general,
    String? tag,
    Object? error,
  }) =>
      _log(LogLevel.warning, message,
          category: category, tag: tag, error: error);

  void error(
    String message, {
    LogCategory category = LogCategory.general,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.error, message,
          category: category, tag: tag, error: error, stackTrace: stackTrace);

  /// Returns a category-scoped logger for convenience.
  CategoryLogger forCategory(LogCategory category) =>
      CategoryLogger._(this, category);

  void _log(
    LogLevel level,
    String message, {
    required LogCategory category,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Level filter
    if (level.value < config.minLevel.value) return;

    // Category filter
    if (config.enabledCategories != null &&
        !config.enabledCategories!.contains(category)) {
      return;
    }

    // Redact if enabled
    final finalMessage = (config.redactSensitiveData && _redactor != null)
        ? _redactor.redact(message)
        : (message.length > config.maxMessageLength
            ? '${message.substring(0, config.maxMessageLength)}... [TRUNCATED]'
            : message);

    final entry = LogEntry(
      level: level,
      message: finalMessage,
      category: category,
      timestamp: DateTime.now(),
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    for (final output in _outputs) {
      output.write(entry);
    }
  }
}

/// A logger pre-scoped to a specific [LogCategory].
class CategoryLogger {
  const CategoryLogger._(this._logger, this._category);

  final Logger _logger;
  final LogCategory _category;

  void debug(String message, {String? tag}) =>
      _logger.debug(message, category: _category, tag: tag);

  void info(String message, {String? tag}) =>
      _logger.info(message, category: _category, tag: tag);

  void warning(String message, {String? tag, Object? error}) =>
      _logger.warning(message, category: _category, tag: tag, error: error);

  void error(String message,
          {String? tag, Object? error, StackTrace? stackTrace}) =>
      _logger.error(message,
          category: _category, tag: tag, error: error, stackTrace: stackTrace);
}
