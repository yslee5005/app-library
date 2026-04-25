import 'feed_comment.dart';
import 'feed_item.dart';
import 'feed_repository.dart';

/// In-memory mock feed repository for development and testing.
class MockFeedRepository implements FeedRepository {
  final _posts = <String, FeedItem>{};
  final _comments = <String, FeedComment>{};
  final _likedPosts = <String>{};
  final _savedPosts = <String>{};
  int _idCounter = 0;

  String _nextId() => 'mock_${++_idCounter}';

  @override
  Future<List<FeedItem>> getFeed({
    String? category,
    String? cursor,
    int limit = 20,
  }) async {
    var items =
        _posts.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (category != null) {
      items = items.where((i) => i.category == category).toList();
    }

    return items.take(limit).toList();
  }

  @override
  Future<FeedItem> createPost({
    required String content,
    String? displayName,
    required String category,
  }) async {
    final id = _nextId();
    final item = FeedItem(
      id: id,
      userId: 'mock_user',
      displayName: displayName,
      category: category,
      content: content,
      createdAt: DateTime.now(),
    );
    _posts[id] = item;
    return item;
  }

  @override
  Future<void> deletePost(String postId) async {
    _posts.remove(postId);
  }

  @override
  Future<bool> toggleLike(String postId) async {
    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      return false;
    }
    _likedPosts.add(postId);
    return true;
  }

  @override
  Future<bool> toggleSave(String postId) async {
    if (_savedPosts.contains(postId)) {
      _savedPosts.remove(postId);
      return false;
    }
    _savedPosts.add(postId);
    return true;
  }

  @override
  Future<List<FeedComment>> getComments(String postId) async {
    return _comments.values.where((c) => c.postId == postId).toList();
  }

  @override
  Future<FeedComment> createComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    final id = _nextId();
    final comment = FeedComment(
      id: id,
      postId: postId,
      userId: 'mock_user',
      content: content,
      parentId: parentId,
      createdAt: DateTime.now(),
    );
    _comments[id] = comment;
    return comment;
  }

  @override
  Future<void> deleteComment(String commentId) async {
    _comments.remove(commentId);
  }

  @override
  Future<void> reportPost(String postId, String reason) async {
    // No-op in mock
  }
}
