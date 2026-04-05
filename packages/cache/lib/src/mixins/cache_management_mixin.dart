import '../manager/cache_manager.dart';

/// Mixin for repositories that need transparent caching.
///
/// Add to any repository class to get `cached()` helper:
///
/// ```dart
/// class ArticleRepository with CacheManagementMixin {
///   @override
///   CacheManager get cacheManager => _cacheManager;
///
///   Future<Article> getArticle(String id) =>
///       cached('article:$id', ttl: Duration(minutes: 5),
///              fetch: () => api.fetchArticle(id));
/// }
/// ```
mixin CacheManagementMixin {
  /// The cache manager instance. Override in your class.
  CacheManager get cacheManager;

  /// Fetches a value from cache or calls [fetch] on miss.
  Future<T> cached<T>(
    String key, {
    required Duration ttl,
    required Future<T> Function() fetch,
  }) {
    return cacheManager.getOrFetch<T>(key, ttl: ttl, onMiss: fetch);
  }

  /// Invalidates a single cache entry across all levels.
  void invalidate(String key) {
    cacheManager.remove(key);
  }

  /// Invalidates all cache entries across all levels.
  void invalidateAll() {
    cacheManager.clear();
  }
}
