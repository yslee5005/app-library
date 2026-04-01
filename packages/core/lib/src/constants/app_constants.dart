/// Shared constants across the App Library.
abstract final class AppConstants {
  /// Default page size for pagination.
  static const int defaultPageSize = 20;

  /// Maximum page size allowed.
  static const int maxPageSize = 100;

  /// Default cache TTL in seconds.
  static const int defaultCacheTtlSeconds = 300;

  /// RLS invalid app_id fallback (used in COALESCE).
  static const String rlsInvalidAppId = '___INVALID___';
}
