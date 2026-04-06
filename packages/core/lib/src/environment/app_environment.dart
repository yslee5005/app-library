/// Represents the current application environment.
///
/// Controls logging verbosity, debug features, and error detail levels.
///
/// Usage:
/// ```dart
/// // Determine from --dart-define
/// const envName = String.fromEnvironment('ENV', defaultValue: 'dev');
/// final env = AppEnvironment.fromString(envName);
///
/// if (env.isDebug) {
///   // show debug overlay, verbose logging
/// }
/// ```
enum AppEnvironment {
  /// Local development — full debug info, verbose logging.
  dev,

  /// Staging/QA — reduced logging, simulates prod behavior.
  staging,

  /// Production — minimal logging, no debug info, obfuscated.
  prod;

  /// Parse from string. Defaults to [dev] if unknown.
  factory AppEnvironment.fromString(String value) {
    return switch (value.toLowerCase()) {
      'prod' || 'production' => AppEnvironment.prod,
      'staging' || 'stg' => AppEnvironment.staging,
      _ => AppEnvironment.dev,
    };
  }

  /// Whether this is a debug-friendly environment.
  bool get isDebug => this == dev;

  /// Whether this is production.
  bool get isProd => this == prod;

  /// Whether error stack traces should be included in user-facing messages.
  bool get showStackTraces => this == dev;

  /// Whether verbose logging is enabled.
  bool get verboseLogging => this == dev || this == staging;

  /// Whether Sentry/error reporting should capture breadcrumbs.
  bool get captureBreadcrumbs => this != dev;

  /// Whether performance monitoring should be active.
  bool get performanceMonitoring => this == prod;
}
