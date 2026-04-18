import '../models/post.dart';

/// Abstract community repository — mock returns local data, real calls Supabase
abstract class CommunityRepository {
  // --- Posts ---
  Future<List<CommunityPost>> getPosts({
    String? category,
    String? cursor,
    int limit = 20,
  });

  Future<CommunityPost> getPostDetail(String postId);

  Future<CommunityPost> createPost({
    required String category,
    required String content,
    String? displayName,
  });

  Future<void> deletePost(String postId);

  // --- Comments ---
  Future<List<Comment>> getComments(
    String postId, {
    String? cursor,
    int limit = 20,
  });

  Future<Comment> createComment({
    required String postId,
    required String content,
    String? displayName,
    String? parentCommentId,
  });

  Future<void> deleteComment(String commentId);

  // --- Likes ---
  Future<bool> toggleLike(String postId);

  Future<void> toggleCommentLike(String commentId);

  // --- Saves ---
  Future<bool> toggleSave(String postId);

  Future<List<CommunityPost>> getSavedPosts();

  // --- Reports ---
  Future<void> reportPost(String postId, String reason);

  Future<void> reportComment(String commentId, String reason);
}
