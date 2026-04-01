import 'package:app_lib_core/core.dart';

import 'comment_filter.dart';
import 'comment_model.dart';
import 'create_comment_request.dart';

/// Abstract interface for comment operations.
///
/// Implementations handle CRUD, replies, likes, and pagination
/// for comments scoped by app_id, content_type, and content_id.
abstract interface class CommentRepository {
  /// Fetches a paginated list of comments matching [filter].
  Future<Result<PaginatedResult<CommentModel>>> getComments({
    required CommentFilter filter,
    required PaginationParams params,
    String? currentUserId,
  });

  /// Creates a new comment.
  Future<Result<CommentModel>> addComment({
    required CreateCommentRequest request,
    required String userId,
  });

  /// Updates a comment's body.
  Future<Result<CommentModel>> updateComment({
    required String commentId,
    required String body,
    required String userId,
  });

  /// Soft-deletes a comment (sets is_deleted = true).
  Future<Result<void>> deleteComment({
    required String commentId,
    required String userId,
  });

  /// Toggles a like on a comment (atomic operation).
  ///
  /// Returns a record of (isLiked, likeCount).
  Future<Result<({bool isLiked, int likeCount})>> toggleLike({
    required String commentId,
    required String userId,
  });

  /// Returns the total comment count for the given content.
  Future<Result<int>> getCommentCount({
    required String contentType,
    required String contentId,
  });
}
