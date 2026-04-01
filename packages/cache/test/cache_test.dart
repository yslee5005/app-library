import 'package:app_lib_cache/cache.dart';
import 'package:test/test.dart';

void main() {
  group('CacheEntry', () {
    test('is not expired within TTL', () {
      final entry = CacheEntry<String>(
        value: 'hello',
        ttl: const Duration(seconds: 10),
      );
      expect(entry.isExpired, isFalse);
      expect(entry.value, 'hello');
    });

    test('is expired after TTL', () {
      final entry = CacheEntry<String>(
        value: 'hello',
        ttl: Duration.zero,
        createdAt: DateTime.now().subtract(const Duration(seconds: 1)),
      );
      expect(entry.isExpired, isTrue);
    });

    test('expired with custom createdAt', () {
      final entry = CacheEntry<int>(
        value: 42,
        ttl: const Duration(minutes: 5),
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      );
      expect(entry.isExpired, isTrue);
    });
  });

  group('MemoryCache', () {
    late MemoryCache cache;

    setUp(() {
      cache = MemoryCache();
    });

    test('returns null for missing key', () {
      expect(cache.get<String>('missing'), isNull);
    });

    test('set and get a value', () {
      cache.set<String>('key', 'value', ttl: const Duration(minutes: 1));
      expect(cache.get<String>('key'), 'value');
    });

    test('has returns true for existing key', () {
      cache.set<String>('key', 'value', ttl: const Duration(minutes: 1));
      expect(cache.has('key'), isTrue);
    });

    test('has returns false for missing key', () {
      expect(cache.has('missing'), isFalse);
    });

    test('returns null for expired entry', () {
      cache.set<String>(
        'key',
        'value',
        ttl: Duration.zero,
      );
      // Immediately expired
      expect(cache.get<String>('key'), isNull);
    });

    test('has returns false for expired entry', () {
      cache.set<String>('key', 'value', ttl: Duration.zero);
      expect(cache.has('key'), isFalse);
    });

    test('remove existing key', () {
      cache.set<String>('key', 'value', ttl: const Duration(minutes: 1));
      expect(cache.remove('key'), isTrue);
      expect(cache.get<String>('key'), isNull);
    });

    test('remove missing key returns false', () {
      expect(cache.remove('missing'), isFalse);
    });

    test('clear removes all entries', () {
      cache.set<String>('a', '1', ttl: const Duration(minutes: 1));
      cache.set<String>('b', '2', ttl: const Duration(minutes: 1));
      cache.clear();
      expect(cache.length, 0);
      expect(cache.get<String>('a'), isNull);
    });

    test('evicts oldest entry when maxSize reached', () {
      final smallCache = MemoryCache(maxSize: 2);
      smallCache.set<String>('a', '1', ttl: const Duration(minutes: 1));
      smallCache.set<String>('b', '2', ttl: const Duration(minutes: 1));
      smallCache.set<String>('c', '3', ttl: const Duration(minutes: 1));

      expect(smallCache.get<String>('a'), isNull); // evicted
      expect(smallCache.get<String>('b'), '2');
      expect(smallCache.get<String>('c'), '3');
    });

    test('replacing existing key does not evict', () {
      final smallCache = MemoryCache(maxSize: 2);
      smallCache.set<String>('a', '1', ttl: const Duration(minutes: 1));
      smallCache.set<String>('b', '2', ttl: const Duration(minutes: 1));
      smallCache.set<String>('a', 'updated', ttl: const Duration(minutes: 1));

      expect(smallCache.length, 2);
      expect(smallCache.get<String>('a'), 'updated');
      expect(smallCache.get<String>('b'), '2');
    });

    test('stores different types', () {
      cache.set<int>('number', 42, ttl: const Duration(minutes: 1));
      cache.set<bool>('flag', true, ttl: const Duration(minutes: 1));
      cache.set<List<String>>(
        'list',
        ['a', 'b'],
        ttl: const Duration(minutes: 1),
      );

      expect(cache.get<int>('number'), 42);
      expect(cache.get<bool>('flag'), isTrue);
      expect(cache.get<List<String>>('list'), ['a', 'b']);
    });
  });

  group('CacheManager', () {
    late MemoryCache primary;
    late MemoryCache secondary;
    late CacheManager manager;

    setUp(() {
      primary = MemoryCache();
      secondary = MemoryCache();
      manager = CacheManager(primary: primary, secondary: secondary);
    });

    test('getOrFetch returns from primary on hit', () async {
      primary.set<String>(
        'key',
        'cached',
        ttl: const Duration(minutes: 1),
      );

      var fetchCalled = false;
      final value = await manager.getOrFetch<String>(
        'key',
        ttl: const Duration(minutes: 1),
        onMiss: () async {
          fetchCalled = true;
          return 'fetched';
        },
      );

      expect(value, 'cached');
      expect(fetchCalled, isFalse);
    });

    test('getOrFetch promotes from secondary to primary', () async {
      secondary.set<String>(
        'key',
        'from_secondary',
        ttl: const Duration(minutes: 1),
      );

      final value = await manager.getOrFetch<String>(
        'key',
        ttl: const Duration(minutes: 1),
        onMiss: () async => 'fetched',
      );

      expect(value, 'from_secondary');
      expect(primary.get<String>('key'), 'from_secondary');
    });

    test('getOrFetch calls onMiss on full miss', () async {
      final value = await manager.getOrFetch<String>(
        'key',
        ttl: const Duration(minutes: 1),
        onMiss: () async => 'fetched',
      );

      expect(value, 'fetched');
      expect(primary.get<String>('key'), 'fetched');
      expect(secondary.get<String>('key'), 'fetched');
    });

    test('get returns null on miss without fetching', () {
      final value = manager.get<String>('key');
      expect(value, isNull);
    });

    test('get promotes from secondary', () {
      secondary.set<String>(
        'key',
        'from_secondary',
        ttl: const Duration(minutes: 1),
      );

      final value = manager.get<String>('key');
      expect(value, 'from_secondary');
      expect(primary.has('key'), isTrue);
    });

    test('remove clears both levels', () {
      primary.set<String>('key', 'a', ttl: const Duration(minutes: 1));
      secondary.set<String>('key', 'b', ttl: const Duration(minutes: 1));

      manager.remove('key');

      expect(primary.has('key'), isFalse);
      expect(secondary.has('key'), isFalse);
    });

    test('clear clears both levels', () {
      primary.set<String>('a', '1', ttl: const Duration(minutes: 1));
      secondary.set<String>('b', '2', ttl: const Duration(minutes: 1));

      manager.clear();

      expect(primary.length, 0);
      expect(secondary.length, 0);
    });

    test('works without secondary cache', () async {
      final singleLevel = CacheManager(primary: MemoryCache());

      final value = await singleLevel.getOrFetch<String>(
        'key',
        ttl: const Duration(minutes: 1),
        onMiss: () async => 'fetched',
      );

      expect(value, 'fetched');
      expect(singleLevel.get<String>('key'), 'fetched');
    });
  });
}
