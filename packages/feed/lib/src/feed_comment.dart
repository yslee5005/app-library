/// A comment on a feed item.
class FeedComment {
  const FeedComment({
    required this.id,
    required this.postId,
    required this.userId,
    this.displayName,
    required this.content,
    this.parentId,
    required this.createdAt,
  });

  final String id;
  final String postId;
  final String userId;
  final String? displayName;
  final String content;
  final String? parentId;
  final DateTime createdAt;
}
