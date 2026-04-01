/// Abstract interface for a key-value cache.
///
/// Implementations may store data in memory, on disk, or both.
abstract interface class CacheInterface {
  /// Returns the cached value for [key], or `null` if not found or expired.
  T? get<T>(String key);

  /// Stores [value] under [key] with the given [ttl].
  void set<T>(String key, T value, {required Duration ttl});

  /// Removes the entry for [key]. Returns `true` if it existed.
  bool remove(String key);

  /// Removes all entries.
  void clear();

  /// Whether a non-expired entry exists for [key].
  bool has(String key);
}
