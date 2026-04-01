/// Filter parameters for querying comments.
///
/// Used to scope comment queries by content, parent, user, and sort order.
class CommentFilter {
  const CommentFilter({
    required this.contentType,
    required this.contentId,
    this.parentCommentId,
    this.userId,
    this.sortBy = CommentSortBy.newest,
  });

  /// The type of content to filter comments for.
  final String contentType;

  /// The ID of the content to filter comments for.
  final String contentId;

  /// Filter by parent comment (null = top-level comments only).
  final String? parentCommentId;

  /// Filter by a specific user's comments.
  final String? userId;

  /// Sort order for results.
  final CommentSortBy sortBy;

  /// Creates a copy with the given fields replaced.
  CommentFilter copyWith({
    String? contentType,
    String? contentId,
    String? parentCommentId,
    String? userId,
    CommentSortBy? sortBy,
  }) {
    return CommentFilter(
      contentType: contentType ?? this.contentType,
      contentId: contentId ?? this.contentId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      userId: userId ?? this.userId,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  String toString() =>
      'CommentFilter(contentType: $contentType, contentId: $contentId)';
}

/// Sort options for comment lists.
enum CommentSortBy {
  /// Most recent first (default).
  newest('created_at', false),

  /// Oldest first.
  oldest('created_at', true),

  /// Most liked first.
  mostLiked('like_count', false);

  const CommentSortBy(this.column, this.ascending);

  final String column;
  final bool ascending;
}
