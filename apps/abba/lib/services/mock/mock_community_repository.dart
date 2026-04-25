import '../../models/post.dart';
import '../community_repository.dart';
import '../mock_data.dart';

class MockCommunityRepository implements CommunityRepository {
  final MockDataService _mockData;
  final List<CommunityPost> _posts = [];
  final Set<String> _likedPostIds = {};
  final Set<String> _likedCommentIds = {};
  final Set<String> _savedPostIds = {};
  bool _initialized = false;

  MockCommunityRepository(this._mockData);

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    final posts = await _mockData.getCommunityPosts();
    // Build threaded comments: nest replies under parent comments
    for (final post in posts) {
      final enriched = _buildThreadedComments(post.comments);
      _posts.add(post.copyWith(comments: enriched));
    }
    _initialized = true;
  }

  /// Organize flat comments into threaded structure with replies nested under parents.
  List<Comment> _buildThreadedComments(List<Comment> flat) {
    final Map<String, Comment> byId = {};
    final List<String> topLevelIds = [];

    // First pass: index all comments with mock like counts
    for (final c in flat) {
      byId[c.id] = c.copyWith(likeCount: (c.id.hashCode % 5).abs());
    }

    // Second pass: attach replies to parents
    for (final c in flat) {
      final enriched = byId[c.id]!;
      if (c.parentCommentId != null && byId.containsKey(c.parentCommentId)) {
        final parent = byId[c.parentCommentId!]!;
        byId[c.parentCommentId!] = parent.copyWith(
          replies: [...parent.replies, enriched],
        );
      } else if (c.parentCommentId == null) {
        topLevelIds.add(c.id);
      }
    }

    return topLevelIds
        .map((id) => byId[id])
        .where((c) => c != null)
        .cast<Comment>()
        .toList();
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
  Future<List<Comment>> getComments(
    String postId, {
    String? cursor,
    int limit = 20,
  }) async {
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

    // Top-level comments only (replies are nested inside each comment)
    var topLevel =
        post.comments.where((c) => c.parentCommentId == null).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first

    // Cursor-based filtering
    if (cursor != null) {
      final cursorTime = DateTime.parse(cursor);
      topLevel = topLevel
          .where((c) => c.createdAt.isBefore(cursorTime))
          .toList();
    }

    if (topLevel.length > limit) topLevel = topLevel.sublist(0, limit);

    // Enrich with like state
    return topLevel.map((c) {
      return c.copyWith(
        isLiked: _likedCommentIds.contains(c.id),
        replies: c.replies.map((r) {
          return r.copyWith(isLiked: _likedCommentIds.contains(r.id));
        }).toList(),
      );
    }).toList();
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

  @override
  Future<void> toggleCommentLike(String commentId) async {
    await _ensureInitialized();
    if (_likedCommentIds.contains(commentId)) {
      _likedCommentIds.remove(commentId);
    } else {
      _likedCommentIds.add(commentId);
    }
    // Update comment like counts in posts
    for (int i = 0; i < _posts.length; i++) {
      final updated = _updateCommentLikeInList(_posts[i].comments, commentId);
      if (updated != null) {
        _posts[i] = _posts[i].copyWith(comments: updated);
        break;
      }
    }
  }

  List<Comment>? _updateCommentLikeInList(
    List<Comment> comments,
    String commentId,
  ) {
    bool found = false;
    final result = comments.map((c) {
      if (c.id == commentId) {
        found = true;
        final liked = _likedCommentIds.contains(commentId);
        return c.copyWith(
          isLiked: liked,
          likeCount: c.likeCount + (liked ? 1 : -1),
        );
      }
      // Check replies recursively
      final updatedReplies = _updateCommentLikeInList(c.replies, commentId);
      if (updatedReplies != null) {
        found = true;
        return c.copyWith(replies: updatedReplies);
      }
      return c;
    }).toList();
    return found ? result : null;
  }
}
