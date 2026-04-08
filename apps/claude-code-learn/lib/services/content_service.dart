import 'package:flutter/services.dart' show rootBundle;

import '../data/content_catalog.dart';
import '../models/content_item.dart';

/// Loads markdown content from Flutter assets and caches it in memory.
class ContentService {
  final Map<String, String> _cache = {};

  /// Load the markdown string for the given [item].
  ///
  /// Returns the cached value if already loaded.
  Future<String> loadContent(ContentItem item) async {
    if (_cache.containsKey(item.id)) {
      return _cache[item.id]!;
    }
    final path = 'assets/content/${item.assetPath}';
    final data = await rootBundle.loadString(path);
    _cache[item.id] = data;
    return data;
  }

  /// Load markdown by content id.
  Future<String> loadById(String id) async {
    final item = ContentCatalog.findById(id);
    if (item == null) return '# Not Found\n\nContent "$id" does not exist.';
    return loadContent(item);
  }

  /// Pre-load all content into the memory cache.
  Future<void> preloadAll() async {
    for (final item in ContentCatalog.items) {
      await loadContent(item);
    }
  }

  /// Clear the in-memory cache.
  void clearCache() => _cache.clear();
}
