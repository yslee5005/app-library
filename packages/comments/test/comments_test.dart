import 'package:app_lib_comments/src/domain/comment_filter.dart';
import 'package:app_lib_comments/src/domain/comment_model.dart';
import 'package:app_lib_comments/src/domain/comment_repository.dart';
import 'package:app_lib_comments/src/domain/create_comment_request.dart';
import 'package:app_lib_core/core.dart';
import 'package:test/test.dart';

void main() {
  group('CommentModel', () {
    test('constructs with required fields', () {
      final now = DateTime.now();
      final comment = CommentModel(
        id: '1',
        appId: 'test_app',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Hello world',
        createdAt: now,
      );

      expect(comment.id, '1');
      expect(comment.appId, 'test_app');
      expect(comment.contentType, 'post');
      expect(comment.contentId, 'p1');
      expect(comment.userId, 'u1');
      expect(comment.body, 'Hello world');
      expect(comment.createdAt, now);
    });

    test('defaults are correct', () {
      const comment = CommentModel(
        id: '1',
        appId: 'test_app',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Hello',
      );

      expect(comment.parentCommentId, isNull);
      expect(comment.likeCount, 0);
      expect(comment.replyCount, 0);
      expect(comment.isDeleted, false);
      expect(comment.isLiked, false);
      expect(comment.updatedAt, isNull);
    });

    test('isReply returns true when parentCommentId is set', () {
      const reply = CommentModel(
        id: '2',
        appId: 'test_app',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Reply',
        parentCommentId: '1',
      );

      expect(reply.isReply, isTrue);
    });

    test('isReply returns false for top-level comment', () {
      const comment = CommentModel(
        id: '1',
        appId: 'test_app',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Top level',
      );

      expect(comment.isReply, isFalse);
    });

    test('fromJson parses correctly', () {
      final json = <String, dynamic>{
        'id': 'c1',
        'app_id': 'my_app',
        'content_type': 'article',
        'content_id': 'a1',
        'user_id': 'u1',
        'body': 'Great article!',
        'parent_comment_id': null,
        'like_count': 5,
        'reply_count': 2,
        'is_deleted': false,
        'is_liked': true,
        'created_at': '2026-01-01T00:00:00.000Z',
        'updated_at': '2026-01-02T00:00:00.000Z',
      };

      final comment = CommentModel.fromJson(json);

      expect(comment.id, 'c1');
      expect(comment.appId, 'my_app');
      expect(comment.contentType, 'article');
      expect(comment.contentId, 'a1');
      expect(comment.userId, 'u1');
      expect(comment.body, 'Great article!');
      expect(comment.parentCommentId, isNull);
      expect(comment.likeCount, 5);
      expect(comment.replyCount, 2);
      expect(comment.isDeleted, false);
      expect(comment.isLiked, true);
      expect(comment.createdAt, DateTime.parse('2026-01-01T00:00:00.000Z'));
      expect(comment.updatedAt, DateTime.parse('2026-01-02T00:00:00.000Z'));
    });

    test('fromJson handles missing optional fields', () {
      final json = <String, dynamic>{
        'id': 'c1',
        'app_id': 'my_app',
        'content_type': 'post',
        'content_id': 'p1',
        'user_id': 'u1',
        'body': 'Minimal',
      };

      final comment = CommentModel.fromJson(json);

      expect(comment.likeCount, 0);
      expect(comment.replyCount, 0);
      expect(comment.isDeleted, false);
      expect(comment.isLiked, false);
      expect(comment.createdAt, isNull);
      expect(comment.updatedAt, isNull);
    });

    test('toJson produces correct map', () {
      const comment = CommentModel(
        id: 'c1',
        appId: 'my_app',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Hello',
        likeCount: 3,
        replyCount: 1,
      );

      final json = comment.toJson();

      expect(json['id'], 'c1');
      expect(json['app_id'], 'my_app');
      expect(json['content_type'], 'post');
      expect(json['content_id'], 'p1');
      expect(json['user_id'], 'u1');
      expect(json['body'], 'Hello');
      expect(json['like_count'], 3);
      expect(json['reply_count'], 1);
      expect(json['is_deleted'], false);
      expect(json.containsKey('parent_comment_id'), false);
    });

    test('toJson includes parent_comment_id when set', () {
      const reply = CommentModel(
        id: 'c2',
        appId: 'my_app',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Reply',
        parentCommentId: 'c1',
      );

      final json = reply.toJson();
      expect(json['parent_comment_id'], 'c1');
    });

    test('copyWith replaces specified fields', () {
      const original = CommentModel(
        id: 'c1',
        appId: 'app1',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Original',
        likeCount: 0,
      );

      final updated = original.copyWith(
        body: 'Updated',
        likeCount: 5,
        isLiked: true,
      );

      expect(updated.body, 'Updated');
      expect(updated.likeCount, 5);
      expect(updated.isLiked, true);
      // Unchanged fields
      expect(updated.id, 'c1');
      expect(updated.appId, 'app1');
      expect(updated.contentType, 'post');
    });

    test('equality is based on id', () {
      const comment1 = CommentModel(
        id: 'c1',
        appId: 'app1',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Hello',
      );
      const comment2 = CommentModel(
        id: 'c1',
        appId: 'app1',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Different body',
      );
      const comment3 = CommentModel(
        id: 'c2',
        appId: 'app1',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Hello',
      );

      expect(comment1, equals(comment2));
      expect(comment1, isNot(equals(comment3)));
      expect(comment1.hashCode, comment2.hashCode);
    });

    test('toString includes key fields', () {
      const comment = CommentModel(
        id: 'c1',
        appId: 'app1',
        contentType: 'article',
        contentId: 'a1',
        userId: 'u1',
        body: 'Hello',
      );

      final str = comment.toString();
      expect(str, contains('c1'));
      expect(str, contains('article'));
      expect(str, contains('a1'));
    });
  });

  group('CommentFilter', () {
    test('constructs with required fields and defaults', () {
      const filter = CommentFilter(
        contentType: 'post',
        contentId: 'p1',
      );

      expect(filter.contentType, 'post');
      expect(filter.contentId, 'p1');
      expect(filter.parentCommentId, isNull);
      expect(filter.userId, isNull);
      expect(filter.sortBy, CommentSortBy.newest);
    });

    test('constructs with all fields', () {
      const filter = CommentFilter(
        contentType: 'article',
        contentId: 'a1',
        parentCommentId: 'c1',
        userId: 'u1',
        sortBy: CommentSortBy.mostLiked,
      );

      expect(filter.contentType, 'article');
      expect(filter.contentId, 'a1');
      expect(filter.parentCommentId, 'c1');
      expect(filter.userId, 'u1');
      expect(filter.sortBy, CommentSortBy.mostLiked);
    });

    test('copyWith replaces specified fields', () {
      const original = CommentFilter(
        contentType: 'post',
        contentId: 'p1',
      );

      final updated = original.copyWith(
        sortBy: CommentSortBy.oldest,
        userId: 'u1',
      );

      expect(updated.sortBy, CommentSortBy.oldest);
      expect(updated.userId, 'u1');
      expect(updated.contentType, 'post');
      expect(updated.contentId, 'p1');
    });

    test('toString includes key fields', () {
      const filter = CommentFilter(
        contentType: 'post',
        contentId: 'p1',
      );

      final str = filter.toString();
      expect(str, contains('post'));
      expect(str, contains('p1'));
    });
  });

  group('CommentSortBy', () {
    test('newest sorts by created_at descending', () {
      expect(CommentSortBy.newest.column, 'created_at');
      expect(CommentSortBy.newest.ascending, false);
    });

    test('oldest sorts by created_at ascending', () {
      expect(CommentSortBy.oldest.column, 'created_at');
      expect(CommentSortBy.oldest.ascending, true);
    });

    test('mostLiked sorts by like_count descending', () {
      expect(CommentSortBy.mostLiked.column, 'like_count');
      expect(CommentSortBy.mostLiked.ascending, false);
    });
  });

  group('CreateCommentRequest', () {
    test('constructs with required fields', () {
      const request = CreateCommentRequest(
        contentType: 'post',
        contentId: 'p1',
        body: 'New comment',
      );

      expect(request.contentType, 'post');
      expect(request.contentId, 'p1');
      expect(request.body, 'New comment');
      expect(request.parentCommentId, isNull);
    });

    test('constructs with parentCommentId for replies', () {
      const request = CreateCommentRequest(
        contentType: 'post',
        contentId: 'p1',
        body: 'Reply',
        parentCommentId: 'c1',
      );

      expect(request.parentCommentId, 'c1');
    });

    test('toJson produces correct map', () {
      const request = CreateCommentRequest(
        contentType: 'article',
        contentId: 'a1',
        body: 'Nice!',
      );

      final json = request.toJson();

      expect(json['content_type'], 'article');
      expect(json['content_id'], 'a1');
      expect(json['body'], 'Nice!');
      expect(json.containsKey('parent_comment_id'), false);
    });

    test('toJson includes parent_comment_id when set', () {
      const request = CreateCommentRequest(
        contentType: 'post',
        contentId: 'p1',
        body: 'Reply',
        parentCommentId: 'c1',
      );

      final json = request.toJson();
      expect(json['parent_comment_id'], 'c1');
    });

    test('toString includes key fields', () {
      const request = CreateCommentRequest(
        contentType: 'post',
        contentId: 'p1',
        body: 'Hello',
      );

      final str = request.toString();
      expect(str, contains('post'));
      expect(str, contains('p1'));
    });
  });

  group('CommentRepository interface', () {
    test('can be implemented as a mock', () {
      final mock = _MockCommentRepository();
      expect(mock, isA<CommentRepository>());
    });
  });
}

/// Minimal mock to verify the interface can be implemented.
class _MockCommentRepository implements CommentRepository {
  @override
  Future<Result<CommentModel>> addComment({
    required CreateCommentRequest request,
    required String userId,
  }) async {
    return Result.success(
      CommentModel(
        id: 'mock',
        appId: 'test',
        contentType: request.contentType,
        contentId: request.contentId,
        userId: userId,
        body: request.body,
      ),
    );
  }

  @override
  Future<Result<void>> deleteComment({
    required String commentId,
    required String userId,
  }) async {
    return const Result.success(null);
  }

  @override
  Future<Result<int>> getCommentCount({
    required String contentType,
    required String contentId,
  }) async {
    return const Result.success(0);
  }

  @override
  Future<Result<PaginatedResult<CommentModel>>> getComments({
    required CommentFilter filter,
    required PaginationParams params,
    String? currentUserId,
  }) async {
    return const Result.success(
      PaginatedResult(items: [], hasMore: false),
    );
  }

  @override
  Future<Result<({bool isLiked, int likeCount})>> toggleLike({
    required String commentId,
    required String userId,
  }) async {
    return const Result.success((isLiked: true, likeCount: 1));
  }

  @override
  Future<Result<CommentModel>> updateComment({
    required String commentId,
    required String body,
    required String userId,
  }) async {
    return Result.success(
      CommentModel(
        id: commentId,
        appId: 'test',
        contentType: 'post',
        contentId: 'p1',
        userId: userId,
        body: body,
      ),
    );
  }
}
