/// Simple, compile-safe feature flag system for multi-app library.
///
/// Each app defines its own flags via `--dart-define` or a config map.
/// No external dependencies — pure Dart.
///
/// Usage:
/// ```dart
/// // 1. Define flags per app
/// class PetLifeFlags {
///   static const notifications = FeatureFlag('notifications', defaultValue: true);
///   static const darkMode = FeatureFlag('dark_mode', defaultValue: false);
///   static const comments = FeatureFlag('comments', defaultValue: true);
/// }
///
/// // 2. Initialize at app startup (from --dart-define or remote config)
/// FeatureFlagRegistry.init({
///   'notifications': true,
///   'dark_mode': false,
///   'comments': true,
/// });
///
/// // 3. Check anywhere
/// if (PetLifeFlags.notifications.isEnabled) {
///   // show notification settings
/// }
/// ```
final class FeatureFlag {
  const FeatureFlag(this.key, {this.defaultValue = false});

  /// Unique identifier for this flag.
  final String key;

  /// Default value when not explicitly set in the registry.
  final bool defaultValue;

  /// Whether this flag is currently enabled.
  bool get isEnabled => FeatureFlagRegistry.isEnabled(key, defaultValue);

  /// Whether this flag is currently disabled.
  bool get isDisabled => !isEnabled;

  @override
  String toString() => 'FeatureFlag($key: ${isEnabled ? "ON" : "OFF"})';
}

/// Global registry for feature flag values.
///
/// Initialize once at app startup. Thread-safe for single-isolate Dart.
final class FeatureFlagRegistry {
  FeatureFlagRegistry._();

  static final Map<String, bool> _flags = {};
  static bool _initialized = false;

  /// Initialize with a map of flag key → enabled status.
  ///
  /// Call once in `main()` before `runApp()`.
  /// Calling again merges new values (does not clear existing).
  static void init(Map<String, bool> flags) {
    _flags.addAll(flags);
    _initialized = true;
  }

  /// Check if a flag is enabled. Uses [defaultValue] if not in registry.
  static bool isEnabled(String key, [bool defaultValue = false]) {
    return _flags[key] ?? defaultValue;
  }

  /// Override a single flag at runtime (e.g., from remote config).
  static void set(String key, bool value) {
    _flags[key] = value;
  }

  /// Returns all currently registered flags.
  static Map<String, bool> get all => Map.unmodifiable(_flags);

  /// Whether [init] has been called.
  static bool get isInitialized => _initialized;

  /// Reset all flags. **For testing only.**
  static void reset() {
    _flags.clear();
    _initialized = false;
  }
}
