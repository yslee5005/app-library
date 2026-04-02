import 'package:app_lib_comments/comments.dart';
import 'package:app_lib_core/core.dart';

/// Mock implementation of [CommentRepository] for the showcase app.
///
/// Stores comments in memory — no real backend.
class MockCommentRepository implements CommentRepository {
  final List<CommentModel> _comments = List.generate(
    5,
    (i) => CommentModel(
      id: 'comment-$i',
      appId: 'showcase',
      contentType: 'article',
      contentId: 'article-1',
      userId: 'user-$i',
      body: _sampleBodies[i % _sampleBodies.length],
      likeCount: i * 2,
      replyCount: i == 0 ? 1 : 0,
      createdAt: DateTime.now().subtract(Duration(hours: i)),
    ),
  );

  final Set<String> _likedCommentIds = {};
  int _nextId = 100;

  static const _sampleBodies = [
    'This is amazing! Great work on this.',
    'Really useful, thanks for sharing.',
    'I have a question about the implementation.',
    'Awesome showcase app!',
    'Would love to see more examples.',
  ];

  @override
  Future<Result<PaginatedResult<CommentModel>>> getComments({
    required CommentFilter filter,
    required PaginationParams params,
    String? currentUserId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final filtered = _comments
        .where((c) =>
            c.contentType == filter.contentType &&
            c.contentId == filter.contentId &&
            !c.isDeleted,)
        .toList();

    // Apply cursor-based pagination
    var startIndex = 0;
    if (params.cursor != null) {
      startIndex = int.tryParse(params.cursor!) ?? 0;
    }

    final endIndex = (startIndex + params.limit).clamp(0, filtered.length);
    final pageItems = filtered.sublist(
      startIndex.clamp(0, filtered.length),
      endIndex,
    );

    // Mark liked comments for current user
    final items = pageItems.map((c) {
      return c.copyWith(isLiked: _likedCommentIds.contains(c.id));
    }).toList();

    return Success(PaginatedResult(
      items: items,
      hasMore: endIndex < filtered.length,
      cursor: endIndex < filtered.length ? '$endIndex' : null,
      totalCount: filtered.length,
    ),);
  }

  @override
  Future<Result<CommentModel>> addComment({
    required CreateCommentRequest request,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final comment = CommentModel(
      id: 'comment-${_nextId++}',
      appId: 'showcase',
      contentType: request.contentType,
      contentId: request.contentId,
      userId: userId,
      body: request.body,
      parentCommentId: request.parentCommentId,
      createdAt: DateTime.now(),
    );

    _comments.insert(0, comment);
    return Success(comment);
  }

  @override
  Future<Result<CommentModel>> updateComment({
    required String commentId,
    required String body,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final index = _comments.indexWhere((c) => c.id == commentId);
    if (index == -1) {
      return const Failure(DatabaseException(message: 'Comment not found'));
    }

    final updated = _comments[index].copyWith(
      body: body,
      updatedAt: DateTime.now(),
    );
    _comments[index] = updated;
    return Success(updated);
  }

  @override
  Future<Result<void>> deleteComment({
    required String commentId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final index = _comments.indexWhere((c) => c.id == commentId);
    if (index == -1) {
      return const Failure(DatabaseException(message: 'Comment not found'));
    }

    _comments[index] = _comments[index].copyWith(isDeleted: true);
    return const Success(null);
  }

  @override
  Future<Result<({bool isLiked, int likeCount})>> toggleLike({
    required String commentId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final index = _comments.indexWhere((c) => c.id == commentId);
    if (index == -1) {
      return const Failure(DatabaseException(message: 'Comment not found'));
    }

    final wasLiked = _likedCommentIds.contains(commentId);
    if (wasLiked) {
      _likedCommentIds.remove(commentId);
      _comments[index] = _comments[index].copyWith(
        likeCount: (_comments[index].likeCount - 1).clamp(0, 999),
      );
    } else {
      _likedCommentIds.add(commentId);
      _comments[index] = _comments[index].copyWith(
        likeCount: _comments[index].likeCount + 1,
      );
    }

    return Success((
      isLiked: !wasLiked,
      likeCount: _comments[index].likeCount,
    ),);
  }

  @override
  Future<Result<int>> getCommentCount({
    required String contentType,
    required String contentId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final count = _comments
        .where((c) =>
            c.contentType == contentType &&
            c.contentId == contentId &&
            !c.isDeleted,)
        .length;
    return Success(count);
  }
}
