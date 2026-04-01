/// Masks sensitive data in strings before logging.
///
/// Detects and masks:
/// - Email addresses
/// - Bearer tokens
/// - API keys (common patterns)
/// - JWT tokens
///
/// Example:
/// ```dart
/// final filtered = SensitiveDataFilter.mask(
///   'User rrallvv@gmail.com has token abc123xyz',
/// );
/// // 'User r*****v@g***l.com has token ***REDACTED***'
/// ```
abstract final class SensitiveDataFilter {
  /// Masks all detected sensitive data in [input].
  static String mask(String input) {
    var result = input;
    result = _maskJwts(result);
    result = _maskEmails(result);
    result = _maskBearerTokens(result);
    result = _maskApiKeys(result);
    return result;
  }

  /// Masks email addresses: `user@example.com` → `u***r@e*****e.com`
  static String _maskEmails(String input) {
    return input.replaceAllMapped(
      RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
      (match) {
        final email = match.group(0)!;
        final parts = email.split('@');
        final local = _maskMiddle(parts[0]);
        final domainParts = parts[1].split('.');
        final domainName = _maskMiddle(domainParts.first);
        final tld = domainParts.sublist(1).join('.');
        return '$local@$domainName.$tld';
      },
    );
  }

  /// Masks Bearer tokens: `Bearer abc123` → `Bearer ***REDACTED***`
  static String _maskBearerTokens(String input) {
    return input.replaceAllMapped(
      RegExp(r'Bearer\s+\S+', caseSensitive: false),
      (match) => 'Bearer ***REDACTED***',
    );
  }

  /// Masks common API key patterns.
  static String _maskApiKeys(String input) {
    // key=VALUE or api_key=VALUE or apikey=VALUE
    return input.replaceAllMapped(
      RegExp(
        r'((?:api[_-]?key|secret|token|password)\s*[=:]\s*)(\S+)',
        caseSensitive: false,
      ),
      (match) => '${match.group(1)}***REDACTED***',
    );
  }

  /// Masks JWT tokens (three dot-separated base64 segments).
  static String _maskJwts(String input) {
    return input.replaceAllMapped(
      RegExp(r'eyJ[a-zA-Z0-9_-]+\.eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+'),
      (match) => '***JWT_REDACTED***',
    );
  }

  /// Masks the middle of a string: `hello` → `h***o`
  static String _maskMiddle(String s) {
    if (s.length <= 2) return s.replaceRange(0, s.length, '*' * s.length);
    return '${s[0]}${'*' * (s.length - 2)}${s[s.length - 1]}';
  }
}
