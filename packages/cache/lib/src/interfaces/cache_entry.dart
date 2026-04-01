/// A cached value with metadata for TTL-based expiration.
class CacheEntry<T> {
  CacheEntry({
    required this.value,
    required this.ttl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// The cached value.
  final T value;

  /// Time-to-live duration.
  final Duration ttl;

  /// When this entry was created.
  final DateTime createdAt;

  /// Whether this entry has expired.
  bool get isExpired => DateTime.now().difference(createdAt) >= ttl;
}
