/// Formats a [DateTime] as a human-readable relative time string.
///
/// Supports English (`en`) and Korean (`ko`) locales.
class RelativeTimeFormatter {
  const RelativeTimeFormatter({this.locale = 'en'});

  /// Language code (`en` or `ko`).
  final String locale;

  /// Formats [dateTime] relative to [now].
  ///
  /// If [now] is omitted, uses [DateTime.now].
  String format(DateTime dateTime, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final diff = reference.difference(dateTime);
    final isFuture = diff.isNegative;
    final absDiff = diff.abs();

    final text = _formatDuration(absDiff);
    return _wrap(text, isFuture);
  }

  String _formatDuration(Duration duration) {
    final seconds = duration.inSeconds;
    final minutes = duration.inMinutes;
    final hours = duration.inHours;
    final days = duration.inDays;

    if (seconds < 60) return _unit(seconds, 'second');
    if (minutes < 60) return _unit(minutes, 'minute');
    if (hours < 24) return _unit(hours, 'hour');
    if (days < 7) return _unit(days, 'day');
    if (days < 30) return _unit(days ~/ 7, 'week');
    if (days < 365) return _unit(days ~/ 30, 'month');
    return _unit(days ~/ 365, 'year');
  }

  String _unit(int value, String unit) {
    if (locale == 'ko') return _koUnit(value, unit);
    if (value == 1) return '1 $unit';
    return '$value ${unit}s';
  }

  String _koUnit(int value, String unit) {
    const map = {
      'second': '초',
      'minute': '분',
      'hour': '시간',
      'day': '일',
      'week': '주',
      'month': '개월',
      'year': '년',
    };
    return '$value${map[unit] ?? unit}';
  }

  String _wrap(String text, bool isFuture) {
    if (locale == 'ko') {
      return isFuture ? '$text 후' : '$text 전';
    }
    return isFuture ? 'in $text' : '$text ago';
  }
}
