import 'package:app_lib_core/core.dart';
import 'package:app_lib_pagination/pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/comment_filter.dart';
import '../domain/comment_model.dart';
import '../domain/comment_repository.dart';
import '../domain/create_comment_request.dart';

/// Provides the [CommentRepository] implementation.
///
/// Apps **must** override this provider with their concrete implementation
/// (e.g., [SupabaseCommentRepository]) in [ProviderScope.overrides].
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     commentRepositoryProvider.overrideWithValue(myCommentRepo),
///   ],
///   child: MyApp(),
/// )
/// ```
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  throw UnimplementedError(
    'commentRepositoryProvider must be overridden in your app. '
    'Add it to ProviderScope.overrides with your CommentRepository implementation.',
  );
});

/// Key for the [commentListProvider] family — identifies a comment list
/// by its content type and content ID.
class CommentListKey {
  const CommentListKey({
    required this.contentType,
    required this.contentId,
  });

  final String contentType;
  final String contentId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentListKey &&
          contentType == other.contentType &&
          contentId == other.contentId;

  @override
  int get hashCode => Object.hash(contentType, contentId);
}

/// Family provider for paginated comment lists.
///
/// Each unique [CommentListKey] (contentType + contentId) gets its own
/// [CommentListNotifier] managing independent pagination state.
///
/// ```dart
/// final key = CommentListKey(contentType: 'article', contentId: '123');
/// final comments = ref.watch(commentListProvider(key));
/// ```
final commentListProvider = AsyncNotifierProvider.family<CommentListNotifier,
    PaginationState<CommentModel>, CommentListKey>(
  CommentListNotifier.new,
);

/// Manages paginated comment loading, adding, and like toggling
/// for a specific content item.
class CommentListNotifier
    extends AsyncNotifier<PaginationState<CommentModel>> {
  CommentListNotifier(this._key);

  final CommentListKey _key;
  late final CommentRepository _repo;
  late final CommentFilter _filter;

  @override
  Future<PaginationState<CommentModel>> build() async {
    _repo = ref.watch(commentRepositoryProvider);
    _filter = CommentFilter(
      contentType: _key.contentType,
      contentId: _key.contentId,
    );

    final result = await _repo.getComments(
      filter: _filter,
      params: const PaginationParams(),
    );

    return switch (result) {
      Success(:final value) => PaginationLoaded<CommentModel>(
          items: value.items,
          hasMore: value.hasMore,
          cursor: value.cursor,
          totalCount: value.totalCount,
        ),
      Failure(:final exception) =>
        PaginationError<CommentModel>(exception: exception),
    };
  }

  /// Loads the next page of comments.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null) return;
    if (current is! PaginationLoaded<CommentModel>) return;
    if (!current.hasMore) return;

    state = AsyncData(PaginationLoading<CommentModel>(items: current.items));

    final result = await _repo.getComments(
      filter: _filter,
      params: PaginationParams(cursor: current.cursor),
    );

    state = switch (result) {
      Success(:final value) => AsyncData(current.appendPage(value)),
      Failure(:final exception) => AsyncData(
          PaginationError<CommentModel>(
            exception: exception,
            items: current.items,
          ),
        ),
    };
  }

  /// Refreshes the comment list from the first page.
  Future<void> refresh() async {
    state = const AsyncLoading<PaginationState<CommentModel>>();

    final result = await _repo.getComments(
      filter: _filter,
      params: const PaginationParams(),
    );

    state = switch (result) {
      Success(:final value) => AsyncData(
          PaginationLoaded<CommentModel>(
            items: value.items,
            hasMore: value.hasMore,
            cursor: value.cursor,
            totalCount: value.totalCount,
          ),
        ),
      Failure(:final exception) => AsyncData(
          PaginationError<CommentModel>(exception: exception),
        ),
    };
  }

  /// Adds a new comment and prepends it to the list.
  Future<void> addComment({
    required String body,
    required String userId,
    String? parentCommentId,
  }) async {
    final request = CreateCommentRequest(
      contentType: _filter.contentType,
      contentId: _filter.contentId,
      body: body,
      parentCommentId: parentCommentId,
    );

    final result = await _repo.addComment(request: request, userId: userId);

    if (result case Success(:final value)) {
      final current = state.value;
      if (current is PaginationLoaded<CommentModel>) {
        state = AsyncData(
          PaginationLoaded<CommentModel>(
            items: [value, ...current.items],
            hasMore: current.hasMore,
            cursor: current.cursor,
            totalCount:
                current.totalCount != null ? current.totalCount! + 1 : null,
          ),
        );
      }
    }
  }

  /// Toggles a like on a comment and updates the local state.
  Future<void> toggleLike({
    required String commentId,
    required String userId,
  }) async {
    final result = await _repo.toggleLike(
      commentId: commentId,
      userId: userId,
    );

    if (result case Success(:final value)) {
      final current = state.value;
      if (current is PaginationLoaded<CommentModel>) {
        final updatedItems = current.items.map((comment) {
          if (comment.id == commentId) {
            return comment.copyWith(
              isLiked: value.isLiked,
              likeCount: value.likeCount,
            );
          }
          return comment;
        }).toList();

        state = AsyncData(
          PaginationLoaded<CommentModel>(
            items: updatedItems,
            hasMore: current.hasMore,
            cursor: current.cursor,
            totalCount: current.totalCount,
          ),
        );
      }
    }
  }
}
