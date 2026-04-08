import '../data/content_catalog.dart';
import '../models/content_item.dart';
import 'content_service.dart';

/// A search result containing the matched item and a text snippet.
class SearchResult {
  const SearchResult({required this.item, required this.snippet});

  final ContentItem item;
  final String snippet;
}

/// Simple in-memory search across all loaded content.
class SearchService {
  SearchService(this._contentService);

  final ContentService _contentService;

  /// Index: maps content id -> full lowercase text.
  final Map<String, String> _index = {};

  /// Build (or rebuild) the search index from all catalog items.
  Future<void> buildIndex() async {
    for (final item in ContentCatalog.items) {
      final text = await _contentService.loadContent(item);
      _index[item.id] = text.toLowerCase();
    }
  }

  /// Search for [query] across all content.
  ///
  /// Returns items whose title or body contain the query (case-insensitive),
  /// together with a surrounding snippet.
  List<SearchResult> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    final results = <SearchResult>[];

    for (final item in ContentCatalog.items) {
      // Match against title first
      if (item.title.toLowerCase().contains(q)) {
        results.add(SearchResult(item: item, snippet: item.title));
        continue;
      }

      // Match against body
      final body = _index[item.id];
      if (body == null) continue;
      final idx = body.indexOf(q);
      if (idx < 0) continue;

      // Extract a snippet around the match
      final start = (idx - 40).clamp(0, body.length);
      final end = (idx + q.length + 40).clamp(0, body.length);
      var snippet = body.substring(start, end).replaceAll('\n', ' ').trim();
      if (start > 0) snippet = '...$snippet';
      if (end < body.length) snippet = '$snippet...';

      results.add(SearchResult(item: item, snippet: snippet));
    }

    return results;
  }
}
