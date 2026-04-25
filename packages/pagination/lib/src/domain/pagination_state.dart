import 'package:app_lib_core/core.dart';

/// Represents the state of a paginated data source.
///
/// Usage with pattern matching:
/// ```dart
/// switch (state) {
///   case PaginationInitial():
///     return LoadingIndicator();
///   case PaginationLoading(:final items):
///     return ListView(items);
///   case PaginationLoaded(:final items, :final hasMore):
///     return ListView(items, showLoadMore: hasMore);
///   case PaginationError(:final exception):
///     return ErrorWidget(exception.message);
/// }
/// ```
sealed class PaginationState<T> {
  const PaginationState();
}

/// No data has been fetched yet.
final class PaginationInitial<T> extends PaginationState<T> {
  const PaginationInitial();
}

/// A page is currently being fetched.
///
/// [items] contains previously loaded items (empty on first load).
final class PaginationLoading<T> extends PaginationState<T> {
  const PaginationLoading({this.items = const []});

  final List<T> items;
}

/// Data has been successfully loaded.
final class PaginationLoaded<T> extends PaginationState<T> {
  const PaginationLoaded({
    required this.items,
    required this.hasMore,
    this.cursor,
    this.cursorId,
    this.totalCount,
  });

  /// All loaded items across all pages.
  final List<T> items;

  /// Whether more pages are available.
  final bool hasMore;

  /// Cursor for fetching the next page.
  final String? cursor;

  /// Secondary cursor for composite cursor pagination.
  final String? cursorId;

  /// Total count of items (if provided by server).
  final int? totalCount;

  /// Creates a new state with an additional page appended.
  PaginationLoaded<T> appendPage(PaginatedResult<T> page) {
    return PaginationLoaded<T>(
      items: [...items, ...page.items],
      hasMore: page.hasMore,
      cursor: page.cursor,
      cursorId: page.cursorId ?? cursorId,
      totalCount: page.totalCount ?? totalCount,
    );
  }

  /// Append a single item to the end (for optimistic adds in ascending lists).
  ///
  /// The new item appears at the last index. [totalCount] is incremented if set.
  PaginationLoaded<T> appendItem(T item) {
    return PaginationLoaded<T>(
      items: [...items, item],
      hasMore: hasMore,
      cursor: cursor,
      cursorId: cursorId,
      totalCount: totalCount != null ? totalCount! + 1 : null,
    );
  }

  /// Prepend a single item (for optimistic adds).
  ///
  /// The new item appears at index 0. [totalCount] is incremented if set.
  PaginationLoaded<T> prependItem(T item) {
    return PaginationLoaded<T>(
      items: [item, ...items],
      hasMore: hasMore,
      cursor: cursor,
      cursorId: cursorId,
      totalCount: totalCount != null ? totalCount! + 1 : null,
    );
  }

  /// Update an item in-place by predicate.
  ///
  /// Finds the first item matching [test] and replaces it with the result
  /// of [update]. Returns an unchanged state if no match is found.
  PaginationLoaded<T> updateItem(bool Function(T) test, T Function(T) update) {
    final index = items.indexWhere(test);
    if (index == -1) return this;

    final updated = List<T>.of(items);
    updated[index] = update(items[index]);

    return PaginationLoaded<T>(
      items: updated,
      hasMore: hasMore,
      cursor: cursor,
      cursorId: cursorId,
      totalCount: totalCount,
    );
  }

  /// Remove an item by predicate.
  ///
  /// Removes the first item matching [test]. [totalCount] is decremented
  /// if set. Returns an unchanged state if no match is found.
  PaginationLoaded<T> removeItem(bool Function(T) test) {
    final index = items.indexWhere(test);
    if (index == -1) return this;

    final updated = List<T>.of(items)..removeAt(index);

    return PaginationLoaded<T>(
      items: updated,
      hasMore: hasMore,
      cursor: cursor,
      cursorId: cursorId,
      totalCount: totalCount != null ? totalCount! - 1 : null,
    );
  }
}

/// An error occurred while fetching data.
///
/// [items] contains previously loaded items (if any).
final class PaginationError<T> extends PaginationState<T> {
  const PaginationError({required this.exception, this.items = const []});

  final AppException exception;

  /// Previously loaded items before the error occurred.
  final List<T> items;
}
