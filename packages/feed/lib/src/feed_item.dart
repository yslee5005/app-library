import 'feed_comment.dart';

/// A single post in the social feed.
class FeedItem {
  const FeedItem({
    required this.id,
    required this.userId,
    this.displayName,
    required this.category,
    required this.content,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    required this.createdAt,
    this.comments = const [],
  });

  final String id;
  final String userId;
  final String? displayName;
  final String category;
  final String content;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime createdAt;
  final List<FeedComment> comments;
}
