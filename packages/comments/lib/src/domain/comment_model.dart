/// Represents a comment attached to any content type.
///
/// Comments are multi-tenant (scoped by app_id) and support
/// nested replies via [parentCommentId].
class CommentModel {
  const CommentModel({
    required this.id,
    required this.appId,
    required this.contentType,
    required this.contentId,
    required this.userId,
    required this.body,
    this.parentCommentId,
    this.likeCount = 0,
    this.replyCount = 0,
    this.isDeleted = false,
    this.isLiked = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a [CommentModel] from a Supabase row.
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      appId: json['app_id'] as String,
      contentType: json['content_type'] as String,
      contentId: json['content_id'] as String,
      userId: json['user_id'] as String,
      body: json['body'] as String,
      parentCommentId: json['parent_comment_id'] as String?,
      likeCount: json['like_count'] as int? ?? 0,
      replyCount: json['reply_count'] as int? ?? 0,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isLiked: json['is_liked'] as bool? ?? false,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  final String id;
  final String appId;

  /// The type of content this comment is attached to (e.g., 'article', 'product').
  final String contentType;

  /// The ID of the content this comment is attached to.
  final String contentId;

  /// The user who wrote this comment.
  final String userId;

  /// The comment text.
  final String body;

  /// Parent comment ID for nested replies (null for top-level comments).
  final String? parentCommentId;

  /// Number of likes on this comment.
  final int likeCount;

  /// Number of replies to this comment.
  final int replyCount;

  /// Whether the comment has been soft-deleted.
  final bool isDeleted;

  /// Whether the current user has liked this comment.
  final bool isLiked;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Whether this is a reply (has a parent comment).
  bool get isReply => parentCommentId != null;

  /// Converts to a JSON map for display/serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_id': appId,
      'content_type': contentType,
      'content_id': contentId,
      'user_id': userId,
      'body': body,
      if (parentCommentId != null) 'parent_comment_id': parentCommentId,
      'like_count': likeCount,
      'reply_count': replyCount,
      'is_deleted': isDeleted,
    };
  }

  /// Creates a copy with the given fields replaced.
  CommentModel copyWith({
    String? id,
    String? appId,
    String? contentType,
    String? contentId,
    String? userId,
    String? body,
    String? parentCommentId,
    int? likeCount,
    int? replyCount,
    bool? isDeleted,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      contentType: contentType ?? this.contentType,
      contentId: contentId ?? this.contentId,
      userId: userId ?? this.userId,
      body: body ?? this.body,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      isDeleted: isDeleted ?? this.isDeleted,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CommentModel(id: $id, contentType: $contentType, contentId: $contentId)';
}
