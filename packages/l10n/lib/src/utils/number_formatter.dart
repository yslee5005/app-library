/// Formats numbers into compact human-readable strings.
///
/// Examples: 1200 → "1.2K", 3400000 → "3.4M".
class NumberFormatter {
  const NumberFormatter({this.locale = 'en'});

  /// Language code (currently formatting is locale-independent).
  final String locale;

  /// Formats [number] as a compact string.
  ///
  /// Numbers < 1000 are returned as-is (with decimal trimming).
  /// 1K–999K, 1M–999M, 1B+ use K/M/B suffixes.
  String compact(num number) {
    final abs = number.abs();
    final sign = number < 0 ? '-' : '';

    if (abs < 1000) return '$sign${_trimDecimal(abs)}';
    if (abs < 1000000) return '$sign${_format(abs / 1000)}K';
    if (abs < 1000000000) return '$sign${_format(abs / 1000000)}M';
    return '$sign${_format(abs / 1000000000)}B';
  }

  String _format(double value) {
    // Show one decimal place, but drop ".0"
    if (value >= 100) return value.round().toString();
    if (value >= 10) {
      final rounded = (value * 10).round() / 10;
      return _trimDecimal(rounded);
    }
    final rounded = (value * 10).round() / 10;
    return _trimDecimal(rounded);
  }

  String _trimDecimal(num value) {
    final s = value.toString();
    if (s.endsWith('.0')) return s.substring(0, s.length - 2);
    return s;
  }
}
