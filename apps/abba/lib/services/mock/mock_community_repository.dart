import '../../models/post.dart';
import '../community_repository.dart';
import '../mock_data.dart';

class MockCommunityRepository implements CommunityRepository {
  final MockDataService _mockData;
  final List<CommunityPost> _posts = [];
  final Set<String> _likedPostIds = {};
  final Set<String> _savedPostIds = {};
  bool _initialized = false;

  MockCommunityRepository(this._mockData);

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    final posts = await _mockData.getCommunityPosts();
    _posts.addAll(posts);
    _initialized = true;
  }

  @override
  Future<List<CommunityPost>> getPosts({
    String? category,
    String? cursor,
    int limit = 20,
  }) async {
    await _ensureInitialized();
    var result = _posts.where((p) => !p.isHidden).toList();

    if (category != null && category != 'all') {
      result = result.where((p) => p.category == category).toList();
    }

    // Apply cursor-based pagination
    if (cursor != null) {
      final cursorTime = DateTime.parse(cursor);
      result = result.where((p) => p.createdAt.isBefore(cursorTime)).toList();
    }

    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (result.length > limit) result = result.sublist(0, limit);

    return result
        .map(
          (p) => p.copyWith(
            isLiked: _likedPostIds.contains(p.id),
            isSaved: _savedPostIds.contains(p.id),
          ),
        )
        .toList();
  }

  @override
  Future<CommunityPost> getPostDetail(String postId) async {
    await _ensureInitialized();
    final post = _posts.firstWhere((p) => p.id == postId);
    return post.copyWith(
      isLiked: _likedPostIds.contains(postId),
      isSaved: _savedPostIds.contains(postId),
    );
  }

  @override
  Future<CommunityPost> createPost({
    required String category,
    required String content,
    String? displayName,
  }) async {
    await _ensureInitialized();
    final post = CommunityPost(
      id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      userId: 'mock-user',
      displayName: displayName,
      category: category,
      content: content,
      createdAt: DateTime.now(),
    );
    _posts.insert(0, post);
    return post;
  }

  @override
  Future<void> deletePost(String postId) async {
    await _ensureInitialized();
    _posts.removeWhere((p) => p.id == postId);
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
    await _ensureInitialized();
    final post = _posts.firstWhere(
      (p) => p.id == postId,
      orElse: () => CommunityPost(
        id: postId,
        userId: '',
        category: '',
        content: '',
        createdAt: DateTime.now(),
      ),
    );
    return post.comments;
  }

  @override
  Future<Comment> createComment({
    required String postId,
    required String content,
    String? displayName,
    String? parentCommentId,
  }) async {
    await _ensureInitialized();
    final comment = Comment(
      id: 'mock-comment-${DateTime.now().millisecondsSinceEpoch}',
      userId: 'mock-user',
      displayName: displayName,
      content: content,
      parentCommentId: parentCommentId,
      createdAt: DateTime.now(),
    );

    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        comments: [...post.comments, comment],
        commentCount: post.commentCount + 1,
      );
    }

    return comment;
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await _ensureInitialized();
    for (int i = 0; i < _posts.length; i++) {
      final post = _posts[i];
      final filtered = post.comments.where((c) => c.id != commentId).toList();
      if (filtered.length != post.comments.length) {
        _posts[i] = post.copyWith(
          comments: filtered,
          commentCount: post.commentCount - 1,
        );
        break;
      }
    }
  }

  @override
  Future<bool> toggleLike(String postId) async {
    await _ensureInitialized();
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return false;

    if (_likedPostIds.contains(postId)) {
      _likedPostIds.remove(postId);
      _posts[index] = _posts[index].copyWith(
        likeCount: _posts[index].likeCount - 1,
        isLiked: false,
      );
      return false;
    } else {
      _likedPostIds.add(postId);
      _posts[index] = _posts[index].copyWith(
        likeCount: _posts[index].likeCount + 1,
        isLiked: true,
      );
      return true;
    }
  }

  @override
  Future<bool> toggleSave(String postId) async {
    await _ensureInitialized();
    if (_savedPostIds.contains(postId)) {
      _savedPostIds.remove(postId);
      return false;
    } else {
      _savedPostIds.add(postId);
      return true;
    }
  }

  @override
  Future<List<CommunityPost>> getSavedPosts() async {
    await _ensureInitialized();
    return _posts
        .where((p) => _savedPostIds.contains(p.id))
        .map((p) => p.copyWith(isSaved: true))
        .toList();
  }

  @override
  Future<void> reportPost(String postId, String reason) async {
    await _ensureInitialized();
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final newCount = _posts[index].reportCount + 1;
    _posts[index] = _posts[index].copyWith(
      reportCount: newCount,
      isHidden: newCount >= 3,
    );
  }

  @override
  Future<void> reportComment(String commentId, String reason) async {
    // Mock: no-op, just acknowledge
  }
}
