/// Severity level for error logging.
enum ErrorLevel {
  /// Application crash or unrecoverable error.
  fatal,

  /// An error that should be investigated.
  error,

  /// Something unexpected but not critical.
  warning,

  /// Informational message for debugging.
  info,
}
