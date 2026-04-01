/// Request payload for creating a new comment.
class CreateCommentRequest {
  const CreateCommentRequest({
    required this.contentType,
    required this.contentId,
    required this.body,
    this.parentCommentId,
  });

  /// The type of content this comment is attached to.
  final String contentType;

  /// The ID of the content this comment is attached to.
  final String contentId;

  /// The comment text.
  final String body;

  /// Parent comment ID for nested replies (null for top-level comments).
  final String? parentCommentId;

  /// Converts to a JSON map for Supabase insertion.
  Map<String, dynamic> toJson() {
    return {
      'content_type': contentType,
      'content_id': contentId,
      'body': body,
      if (parentCommentId != null) 'parent_comment_id': parentCommentId,
    };
  }

  @override
  String toString() =>
      'CreateCommentRequest(contentType: $contentType, contentId: $contentId)';
}
