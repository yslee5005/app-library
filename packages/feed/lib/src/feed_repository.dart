import 'feed_comment.dart';
import 'feed_item.dart';

/// Abstract feed repository interface.
abstract class FeedRepository {
  Future<List<FeedItem>> getFeed({
    String? category,
    String? cursor,
    int limit = 20,
  });

  Future<FeedItem> createPost({
    required String content,
    String? displayName,
    required String category,
  });

  Future<void> deletePost(String postId);

  Future<bool> toggleLike(String postId);

  Future<bool> toggleSave(String postId);

  Future<List<FeedComment>> getComments(String postId);

  Future<FeedComment> createComment({
    required String postId,
    required String content,
    String? parentId,
  });

  Future<void> deleteComment(String commentId);

  Future<void> reportPost(String postId, String reason);
}
