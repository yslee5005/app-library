/// A bookmarked content item.
class Bookmark {
  const Bookmark({required this.contentId, required this.createdAt});

  final String contentId;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'contentId': contentId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      contentId: json['contentId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
