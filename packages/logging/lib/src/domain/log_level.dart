/// Severity level for log messages.
enum LogLevel implements Comparable<LogLevel> {
  debug(0),
  info(1),
  warning(2),
  error(3);

  const LogLevel(this.value);
  final int value;

  @override
  int compareTo(LogLevel other) => value.compareTo(other.value);

  bool operator >=(LogLevel other) => value >= other.value;
}
