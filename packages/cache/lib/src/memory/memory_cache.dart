import '../interfaces/cache_entry.dart';
import '../interfaces/cache_interface.dart';

/// In-memory cache with TTL expiration and max size eviction.
///
/// When [maxSize] is reached, the oldest entry is evicted.
/// Expired entries are removed on access (lazy eviction).
class MemoryCache implements CacheInterface {
  MemoryCache({this.maxSize = 100});

  /// Maximum number of entries before eviction.
  final int maxSize;

  final Map<String, CacheEntry<Object>> _store = {};

  /// Current number of (possibly expired) entries in the cache.
  int get length => _store.length;

  @override
  T? get<T>(String key) {
    final entry = _store[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _store.remove(key);
      return null;
    }

    return entry.value as T;
  }

  @override
  void set<T>(String key, T value, {required Duration ttl}) {
    // Evict oldest if at capacity (and not replacing an existing key)
    if (!_store.containsKey(key) && _store.length >= maxSize) {
      _store.remove(_store.keys.first);
    }

    _store[key] = CacheEntry<Object>(value: value as Object, ttl: ttl);
  }

  @override
  bool remove(String key) {
    return _store.remove(key) != null;
  }

  @override
  void clear() {
    _store.clear();
  }

  @override
  bool has(String key) {
    final entry = _store[key];
    if (entry == null) return false;

    if (entry.isExpired) {
      _store.remove(key);
      return false;
    }

    return true;
  }
}
