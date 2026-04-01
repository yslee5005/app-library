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
    this.totalCount,
  });

  /// All loaded items across all pages.
  final List<T> items;

  /// Whether more pages are available.
  final bool hasMore;

  /// Cursor for fetching the next page.
  final String? cursor;

  /// Total count of items (if provided by server).
  final int? totalCount;

  /// Creates a new state with an additional page appended.
  PaginationLoaded<T> appendPage(PaginatedResult<T> page) {
    return PaginationLoaded<T>(
      items: [...items, ...page.items],
      hasMore: page.hasMore,
      cursor: page.cursor,
      totalCount: page.totalCount ?? totalCount,
    );
  }
}

/// An error occurred while fetching data.
///
/// [items] contains previously loaded items (if any).
final class PaginationError<T> extends PaginationState<T> {
  const PaginationError({
    required this.exception,
    this.items = const [],
  });

  final AppException exception;

  /// Previously loaded items before the error occurred.
  final List<T> items;
}
