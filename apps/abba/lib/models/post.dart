class CommunityPost {
  final String id;
  final String userId;
  final String? displayName;
  final String? avatarUrl;
  final String category; // 'testimony' | 'prayer_request'
  final String content;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime createdAt;
  final List<Comment> comments;

  const CommunityPost({
    required this.id,
    required this.userId,
    this.displayName,
    this.avatarUrl,
    required this.category,
    required this.content,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    required this.createdAt,
    this.comments = const [],
  });

  CommunityPost copyWith({
    bool? isLiked,
    bool? isSaved,
    int? likeCount,
    List<Comment>? comments,
    int? commentCount,
  }) {
    return CommunityPost(
      id: id,
      userId: userId,
      displayName: displayName,
      avatarUrl: avatarUrl,
      category: category,
      content: content,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt,
      comments: comments ?? this.comments,
    );
  }

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      category: json['category'] as String,
      content: json['content'] as String,
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      isSaved: json['is_saved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Comment {
  final String id;
  final String userId;
  final String? displayName;
  final String content;
  final String? parentCommentId;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.userId,
    this.displayName,
    required this.content,
    this.parentCommentId,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String?,
      content: json['content'] as String,
      parentCommentId: json['parent_comment_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
