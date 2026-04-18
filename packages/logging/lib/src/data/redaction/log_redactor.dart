import 'package:app_lib_error_logging/error_logging.dart';

/// Redacts sensitive data from log messages.
///
/// Applies [SensitiveDataFilter.mask] (emails, tokens, JWTs)
/// plus prayer/transcript truncation.
class LogRedactor {
  const LogRedactor({this.maxLength = 500});

  final int maxLength;

  /// Redact and truncate a log message.
  String redact(String message) {
    // Apply base sensitive data masking (emails, tokens, JWTs, API keys)
    var result = SensitiveDataFilter.mask(message);

    // Truncate long messages
    if (result.length > maxLength) {
      result = '${result.substring(0, maxLength)}... [TRUNCATED]';
    }

    return result;
  }
}
