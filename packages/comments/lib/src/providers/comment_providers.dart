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
  const CommentListKey({required this.contentType, required this.contentId});

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
final commentListProvider = AsyncNotifierProvider.family<
  CommentListNotifier,
  PaginationState<CommentModel>,
  CommentListKey
>(CommentListNotifier.new);

// ---------------------------------------------------------------------------
// Adapter: wraps CommentRepository as PaginatedRepository<CommentModel>
// ---------------------------------------------------------------------------

/// Adapts a [CommentRepository] + [CommentFilter] into [PaginatedRepository]
/// so that [PaginationNotifier] can drive pagination generically.
class _CommentPaginatedAdapter implements PaginatedRepository<CommentModel> {
  const _CommentPaginatedAdapter({
    required CommentRepository repository,
    required CommentFilter filter,
  }) : _repository = repository,
       _filter = filter;

  final CommentRepository _repository;
  final CommentFilter _filter;

  @override
  Future<Result<PaginatedResult<CommentModel>>> fetchPage(
    PaginationParams params,
  ) {
    return _repository.getComments(filter: _filter, params: params);
  }
}

// ---------------------------------------------------------------------------
// CommentListNotifier — extends PaginationNotifier
// ---------------------------------------------------------------------------

/// Manages paginated comment loading, adding, liking, and deleting
/// for a specific content item.
///
/// Extends [PaginationNotifier] to reuse generic pagination logic
/// (build, loadMore, refresh, prependItem, updateItem, removeItem).
class CommentListNotifier extends PaginationNotifier<CommentModel> {
  CommentListNotifier(this._key);

  final CommentListKey _key;
  late final CommentRepository _repo;

  @override
  PaginatedRepository<CommentModel> get repository =>
      _CommentPaginatedAdapter(repository: _repo, filter: _filter);

  late final CommentFilter _filter;

  @override
  Future<PaginationState<CommentModel>> build() {
    _repo = ref.watch(commentRepositoryProvider);
    _filter = CommentFilter(
      contentType: _key.contentType,
      contentId: _key.contentId,
    );

    return super.build();
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
      prependItem(value);
    }
  }

  /// Toggles a like on a comment and updates the local state.
  Future<void> toggleLike({
    required String commentId,
    required String userId,
  }) async {
    final result = await _repo.toggleLike(commentId: commentId, userId: userId);

    if (result case Success(:final value)) {
      updateItem(
        (c) => c.id == commentId,
        (c) => c.copyWith(isLiked: value.isLiked, likeCount: value.likeCount),
      );
    }
  }

  /// Soft-deletes a comment and removes it from the list.
  Future<void> deleteComment({
    required String commentId,
    required String userId,
  }) async {
    final result = await _repo.deleteComment(
      commentId: commentId,
      userId: userId,
    );

    if (result case Success()) {
      removeItem((c) => c.id == commentId);
    }
  }
}

// ---------------------------------------------------------------------------
// ReplyListNotifier — family-keyed per parent comment
// ---------------------------------------------------------------------------

/// Key for the [replyListProvider] family — identifies a reply list
/// by content type, content ID, and parent comment ID.
class ReplyListKey {
  const ReplyListKey({
    required this.contentType,
    required this.contentId,
    required this.parentCommentId,
  });

  final String contentType;
  final String contentId;
  final String parentCommentId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReplyListKey &&
          contentType == other.contentType &&
          contentId == other.contentId &&
          parentCommentId == other.parentCommentId;

  @override
  int get hashCode => Object.hash(contentType, contentId, parentCommentId);
}

/// Family provider for paginated reply lists.
///
/// Each unique [ReplyListKey] gets its own [ReplyListNotifier]
/// managing replies for a specific parent comment.
///
/// ```dart
/// final key = ReplyListKey(
///   contentType: 'article',
///   contentId: '123',
///   parentCommentId: 'comment-456',
/// );
/// final replies = ref.watch(replyListProvider(key));
/// ```
final replyListProvider = AsyncNotifierProvider.family<
  ReplyListNotifier,
  PaginationState<CommentModel>,
  ReplyListKey
>(ReplyListNotifier.new);

/// Manages paginated reply loading for a specific parent comment.
///
/// Replies are sorted oldest-first (ascending) unlike parent comments.
/// Extends [PaginationNotifier] for generic pagination.
class ReplyListNotifier extends PaginationNotifier<CommentModel> {
  ReplyListNotifier(this._key);

  final ReplyListKey _key;
  late final CommentRepository _repo;

  @override
  PaginatedRepository<CommentModel> get repository =>
      _CommentPaginatedAdapter(repository: _repo, filter: _filter);

  late final CommentFilter _filter;

  @override
  Future<PaginationState<CommentModel>> build() {
    _repo = ref.watch(commentRepositoryProvider);
    _filter = CommentFilter(
      contentType: _key.contentType,
      contentId: _key.contentId,
      parentCommentId: _key.parentCommentId,
      sortBy: CommentSortBy.oldest, // Replies: oldest first
    );

    return super.build();
  }

  /// Adds a reply and appends it to the end of the list.
  ///
  /// Unlike parent comments which are prepended (newest first),
  /// replies are appended (oldest first).
  Future<void> addReply({required String body, required String userId}) async {
    final request = CreateCommentRequest(
      contentType: _filter.contentType,
      contentId: _filter.contentId,
      body: body,
      parentCommentId: _key.parentCommentId,
    );

    final result = await _repo.addComment(request: request, userId: userId);

    if (result case Success(:final value)) {
      // Replies are oldest-first, so new reply goes to end.
      appendItem(value);
    }
  }

  /// Toggles a like on a reply and updates the local state.
  Future<void> toggleLike({
    required String commentId,
    required String userId,
  }) async {
    final result = await _repo.toggleLike(commentId: commentId, userId: userId);

    if (result case Success(:final value)) {
      updateItem(
        (c) => c.id == commentId,
        (c) => c.copyWith(isLiked: value.isLiked, likeCount: value.likeCount),
      );
    }
  }

  /// Soft-deletes a reply and removes it from the list.
  Future<void> deleteReply({
    required String commentId,
    required String userId,
  }) async {
    final result = await _repo.deleteComment(
      commentId: commentId,
      userId: userId,
    );

    if (result case Success()) {
      removeItem((c) => c.id == commentId);
    }
  }
}
