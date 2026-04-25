/// Represents a page of results with cursor-based pagination.
class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.hasMore,
    this.cursor,
    this.cursorId,
    this.totalCount,
  });

  /// Creates an empty result.
  const PaginatedResult.empty()
    : items = const [],
      hasMore = false,
      cursor = null,
      cursorId = null,
      totalCount = 0;

  /// The items in this page.
  final List<T> items;

  /// Whether there are more items to load.
  final bool hasMore;

  /// The cursor for fetching the next page.
  final String? cursor;

  /// Secondary cursor for composite cursor pagination.
  ///
  /// Used when ordering by a non-unique column (e.g., `created_at`)
  /// and a tie-breaker (e.g., `id`) is needed for deterministic paging.
  final String? cursorId;

  /// Total count of items (if available from the server).
  final int? totalCount;
}

/// Parameters for a paginated query.
class PaginationParams {
  const PaginationParams({
    this.cursor,
    this.cursorId,
    this.limit = 20,
    this.orderBy = 'created_at',
    this.ascending = false,
  });

  /// Cursor for the next page (null for first page).
  final String? cursor;

  /// Secondary cursor for composite cursor pagination.
  ///
  /// Used alongside [cursor] when ordering by a non-unique column
  /// and an `id` tie-breaker is needed for deterministic paging.
  final String? cursorId;

  /// Number of items per page.
  final int limit;

  /// Column to order by.
  final String orderBy;

  /// Ascending or descending order.
  final bool ascending;
}
