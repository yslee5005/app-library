import '../interfaces/cache_interface.dart';

/// Two-level cache manager with memory-first lookup and optional fallback.
///
/// Checks [primary] first, then [secondary] (if provided).
/// On a secondary hit, the value is promoted to primary.
///
/// Example:
/// ```dart
/// final manager = CacheManager(primary: memoryCache);
/// final value = await manager.getOrFetch<User>(
///   'user:123',
///   ttl: Duration(minutes: 5),
///   onMiss: () => api.fetchUser('123'),
/// );
/// ```
class CacheManager {
  const CacheManager({required this.primary, this.secondary});

  /// First cache to check (typically memory).
  final CacheInterface primary;

  /// Second cache to check (typically disk). Optional.
  final CacheInterface? secondary;

  /// Gets a value from cache, or fetches it via [onMiss] if not found.
  ///
  /// On a miss, the fetched value is stored in primary (and secondary
  /// if present) with the given [ttl].
  Future<T> getOrFetch<T>(
    String key, {
    required Duration ttl,
    required Future<T> Function() onMiss,
  }) async {
    // Check primary
    final primaryValue = primary.get<T>(key);
    if (primaryValue != null) return primaryValue;

    // Check secondary
    final sec = secondary;
    if (sec != null) {
      final secondaryValue = sec.get<T>(key);
      if (secondaryValue != null) {
        // Promote to primary
        primary.set<T>(key, secondaryValue, ttl: ttl);
        return secondaryValue;
      }
    }

    // Fetch from source
    final value = await onMiss();
    primary.set<T>(key, value, ttl: ttl);
    sec?.set<T>(key, value, ttl: ttl);
    return value;
  }

  /// Gets a value from cache only (no fetch). Returns `null` on miss.
  T? get<T>(String key) {
    final primaryValue = primary.get<T>(key);
    if (primaryValue != null) return primaryValue;

    final sec = secondary;
    if (sec != null) {
      final secondaryValue = sec.get<T>(key);
      if (secondaryValue != null) {
        // Promote to primary
        primary.set<T>(key, secondaryValue, ttl: const Duration(minutes: 5));
        return secondaryValue;
      }
    }

    return null;
  }

  /// Removes a key from all cache levels.
  void remove(String key) {
    primary.remove(key);
    secondary?.remove(key);
  }

  /// Clears all cache levels.
  void clear() {
    primary.clear();
    secondary?.clear();
  }
}
