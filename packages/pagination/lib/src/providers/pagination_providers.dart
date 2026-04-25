import 'package:app_lib_core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/paginated_repository.dart';
import '../domain/pagination_state.dart';

/// Creates a paginated notifier provider for any [PaginatedRepository<T>].
///
/// Since generic providers can't be expressed as a single static `final`,
/// use this factory to create typed providers for each data type.
///
/// ```dart
/// // In your app or feature package:
/// final articleListProvider = createPaginationProvider<Article>();
///
/// // Then override the repository:
/// ProviderScope(
///   overrides: [
///     articleRepoProvider.overrideWithValue(myArticleRepo),
///   ],
///   child: MyApp(),
/// )
/// ```
AsyncNotifierProvider<PaginationNotifier<T>, PaginationState<T>>
createPaginationProvider<T>() {
  return AsyncNotifierProvider<PaginationNotifier<T>, PaginationState<T>>(
    PaginationNotifier<T>.new,
  );
}

/// Key that uniquely identifies a [PaginatedRepository] provider
/// for the family-based pagination pattern.
///
/// Apps can subclass or use this directly when they need multiple
/// paginated lists of the same type.
class PaginationKey {
  const PaginationKey(this.id);

  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PaginationKey && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Generic async notifier for cursor-based pagination.
///
/// Subclass this to bind a specific [PaginatedRepository<T>]:
///
/// ```dart
/// class ArticleListNotifier extends PaginationNotifier<Article> {
///   @override
///   PaginatedRepository<Article> get repository =>
///       ref.watch(articleRepositoryProvider);
/// }
/// ```
class PaginationNotifier<T> extends AsyncNotifier<PaginationState<T>> {
  /// Override this getter in subclasses to provide the repository.
  ///
  /// Throws [UnimplementedError] by default — subclasses must override.
  PaginatedRepository<T> get repository {
    throw UnimplementedError(
      'PaginationNotifier.repository must be overridden. '
      'Create a subclass and provide your PaginatedRepository<$T>.',
    );
  }

  @override
  Future<PaginationState<T>> build() async {
    final result = await repository.fetchPage(const PaginationParams());
    return switch (result) {
      Success(:final value) => PaginationLoaded<T>(
        items: value.items,
        hasMore: value.hasMore,
        cursor: value.cursor,
        cursorId: value.cursorId,
        totalCount: value.totalCount,
      ),
      Failure(:final exception) => PaginationError<T>(exception: exception),
    };
  }

  /// Loads the next page of items.
  ///
  /// No-op if not in a [PaginationLoaded] state or if [hasMore] is false.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null) return;
    if (current is! PaginationLoaded<T>) return;
    if (!current.hasMore) return;

    state = AsyncData(PaginationLoading<T>(items: current.items));

    final result = await repository.fetchPage(
      PaginationParams(cursor: current.cursor, cursorId: current.cursorId),
    );

    state = switch (result) {
      Success(:final value) => AsyncData(current.appendPage(value)),
      Failure(:final exception) => AsyncData(
        PaginationError<T>(exception: exception, items: current.items),
      ),
    };
  }

  /// Refreshes the list from the first page, discarding all loaded data.
  Future<void> refresh() async {
    state = const AsyncLoading();

    final result = await repository.fetchPage(const PaginationParams());

    state = switch (result) {
      Success(:final value) => AsyncData(
        PaginationLoaded<T>(
          items: value.items,
          hasMore: value.hasMore,
          cursor: value.cursor,
          cursorId: value.cursorId,
          totalCount: value.totalCount,
        ),
      ),
      Failure(:final exception) => AsyncData(
        PaginationError<T>(exception: exception),
      ),
    };
  }

  // --- Mutation helpers ---

  /// Append a single item to the end (for ascending-order lists).
  ///
  /// No-op if state is not [PaginationLoaded].
  void appendItem(T item) {
    final current = state.value;
    if (current is PaginationLoaded<T>) {
      state = AsyncData(current.appendItem(item));
    }
  }

  /// Prepend a single item (for optimistic adds).
  ///
  /// No-op if state is not [PaginationLoaded].
  void prependItem(T item) {
    final current = state.value;
    if (current is PaginationLoaded<T>) {
      state = AsyncData(current.prependItem(item));
    }
  }

  /// Update an item in-place by predicate.
  ///
  /// Finds the first item matching [test] and replaces it with the result
  /// of [update]. No-op if state is not [PaginationLoaded].
  void updateItem(bool Function(T) test, T Function(T) update) {
    final current = state.value;
    if (current is PaginationLoaded<T>) {
      state = AsyncData(current.updateItem(test, update));
    }
  }

  /// Remove an item by predicate.
  ///
  /// Removes the first item matching [test].
  /// No-op if state is not [PaginationLoaded].
  void removeItem(bool Function(T) test) {
    final current = state.value;
    if (current is PaginationLoaded<T>) {
      state = AsyncData(current.removeItem(test));
    }
  }
}
