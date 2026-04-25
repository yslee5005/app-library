/// Validates that required environment variables are present at app startup.
///
/// Usage:
/// ```dart
/// void main() {
///   EnvValidator.validate(
///     required: ['SUPABASE_URL', 'SUPABASE_ANON_KEY', 'APP_ID'],
///     optional: ['SENTRY_DSN'],
///     values: {
///       'SUPABASE_URL': const String.fromEnvironment('SUPABASE_URL'),
///       'SUPABASE_ANON_KEY': const String.fromEnvironment('SUPABASE_ANON_KEY'),
///       'APP_ID': const String.fromEnvironment('APP_ID'),
///       'SENTRY_DSN': const String.fromEnvironment('SENTRY_DSN'),
///     },
///   );
///   runApp(const MyApp());
/// }
/// ```
final class EnvValidator {
  const EnvValidator._();

  /// Validates environment variables. Throws [EnvValidationException] if
  /// any required keys are missing or empty.
  ///
  /// [required] — keys that must be present and non-empty.
  /// [optional] — keys that are checked for format but allowed to be empty.
  /// [values] — map of key→value from `String.fromEnvironment` or Platform.environment.
  static void validate({
    required List<String> required,
    List<String> optional = const [],
    required Map<String, String> values,
  }) {
    final missing = <String>[];
    final empty = <String>[];
    final formatErrors = <String, String>{};

    for (final key in required) {
      final value = values[key];
      if (value == null) {
        missing.add(key);
      } else if (value.isEmpty) {
        empty.add(key);
      } else {
        final error = _validateFormat(key, value);
        if (error != null) formatErrors[key] = error;
      }
    }

    for (final key in optional) {
      final value = values[key];
      if (value != null && value.isNotEmpty) {
        final error = _validateFormat(key, value);
        if (error != null) formatErrors[key] = error;
      }
    }

    if (missing.isNotEmpty || empty.isNotEmpty || formatErrors.isNotEmpty) {
      throw EnvValidationException(
        missing: missing,
        empty: empty,
        formatErrors: formatErrors,
      );
    }
  }

  /// Format validation for known key patterns.
  static String? _validateFormat(String key, String value) {
    final keyUpper = key.toUpperCase();

    if (keyUpper.contains('URL') || keyUpper.contains('DSN')) {
      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        return 'must start with http:// or https://';
      }
    }

    if (keyUpper.contains('ANON_KEY') || keyUpper.contains('SECRET')) {
      if (value.length < 20) {
        return 'suspiciously short (${value.length} chars)';
      }
    }

    if (keyUpper == 'APP_ID') {
      if (value.contains(' ')) {
        return 'must not contain spaces';
      }
      if (!RegExp(r'^[a-z][a-z0-9_-]*$').hasMatch(value)) {
        return 'must be lowercase alphanumeric with hyphens/underscores';
      }
    }

    return null;
  }
}

/// Thrown when environment validation fails.
final class EnvValidationException implements Exception {
  const EnvValidationException({
    this.missing = const [],
    this.empty = const [],
    this.formatErrors = const {},
  });

  final List<String> missing;
  final List<String> empty;
  final Map<String, String> formatErrors;

  @override
  String toString() {
    final parts = <String>[];

    if (missing.isNotEmpty) {
      parts.add('Missing: ${missing.join(', ')}');
    }
    if (empty.isNotEmpty) {
      parts.add('Empty: ${empty.join(', ')}');
    }
    if (formatErrors.isNotEmpty) {
      final formatted = formatErrors.entries
          .map((e) => '${e.key}: ${e.value}')
          .join(', ');
      parts.add('Invalid format: $formatted');
    }

    return 'EnvValidationException — ${parts.join(' | ')}';
  }
}
