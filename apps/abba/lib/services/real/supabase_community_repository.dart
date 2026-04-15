import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/post.dart';
import '../community_repository.dart';

class SupabaseCommunityRepository implements CommunityRepository {
  final SupabaseClient _client;

  SupabaseCommunityRepository(this._client);

  String get _userId => _client.auth.currentUser!.id;

  // --- Posts ---

  @override
  Future<List<CommunityPost>> getPosts({
    String? category,
    String? cursor,
    int limit = 20,
  }) async {
    var query = _client
        .from('community_posts')
        .select()
        .eq('app_id', 'abba')
        .eq('is_hidden', false);

    if (category != null && category != 'all') {
      query = query.eq('category', category);
    }

    if (cursor != null) {
      query = query.lt('created_at', cursor);
    }

    final data = await query.order('created_at', ascending: false).limit(limit);

    final posts = <CommunityPost>[];
    for (final row in data as List) {
      final postId = row['id'] as String;
      final isLiked = await _isLiked(postId);
      final isSaved = await _isSaved(postId);
      final comments = await getComments(postId);

      posts.add(
        CommunityPost.fromJson({
          ...row as Map<String, dynamic>,
          'is_liked': isLiked,
          'is_saved': isSaved,
          'comments': comments.map((c) => c.toJson()).toList(),
        }),
      );
    }

    return posts;
  }

  @override
  Future<CommunityPost> getPostDetail(String postId) async {
    final data = await _client
        .from('community_posts')
        .select()
        .eq('id', postId)
        .eq('app_id', 'abba')
        .single();

    final isLiked = await _isLiked(postId);
    final isSaved = await _isSaved(postId);
    final comments = await getComments(postId);

    return CommunityPost.fromJson({
      ...data,
      'is_liked': isLiked,
      'is_saved': isSaved,
      'comments': comments.map((c) => c.toJson()).toList(),
    });
  }

  @override
  Future<CommunityPost> createPost({
    required String category,
    required String content,
    String? displayName,
  }) async {
    final data = await _client
        .from('community_posts')
        .insert({
          'app_id': 'abba',
          'user_id': _userId,
          'display_name': displayName,
          'category': category,
          'content': content,
        })
        .select()
        .single();

    return CommunityPost.fromJson({
      ...data,
      'is_liked': false,
      'is_saved': false,
      'comments': <Map<String, dynamic>>[],
    });
  }

  @override
  Future<void> deletePost(String postId) async {
    await _client
        .from('community_posts')
        .delete()
        .eq('id', postId)
        .eq('user_id', _userId)
        .eq('app_id', 'abba');
  }

  // --- Comments ---

  @override
  Future<List<Comment>> getComments(String postId) async {
    final data = await _client
        .from('post_comments')
        .select()
        .eq('post_id', postId)
        .eq('app_id', 'abba')
        .order('created_at', ascending: true);

    return (data as List)
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Comment> createComment({
    required String postId,
    required String content,
    String? displayName,
    String? parentCommentId,
  }) async {
    final data = await _client
        .from('post_comments')
        .insert({
          'app_id': 'abba',
          'post_id': postId,
          'user_id': _userId,
          'display_name': displayName,
          'content': content,
          'parent_comment_id': parentCommentId,
        })
        .select()
        .single();

    // Update comment count
    await _client.rpc('increment_comment_count', params: {'p_post_id': postId});

    return Comment.fromJson(data);
  }

  @override
  Future<void> deleteComment(String commentId) async {
    // Get comment to find post_id before deleting
    final comment = await _client
        .from('post_comments')
        .select('post_id')
        .eq('id', commentId)
        .eq('user_id', _userId)
        .single();

    await _client
        .from('post_comments')
        .delete()
        .eq('id', commentId)
        .eq('user_id', _userId);

    // Decrement comment count
    await _client.rpc(
      'decrement_comment_count',
      params: {'p_post_id': comment['post_id']},
    );
  }

  // --- Likes ---

  @override
  Future<bool> toggleLike(String postId) async {
    final existing = await _client
        .from('post_likes')
        .select('id')
        .eq('post_id', postId)
        .eq('user_id', _userId)
        .eq('app_id', 'abba')
        .maybeSingle();

    if (existing != null) {
      // Unlike
      await _client
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', _userId)
          .eq('app_id', 'abba');

      await _client.rpc('decrement_like_count', params: {'p_post_id': postId});
      return false;
    } else {
      // Like
      await _client.from('post_likes').insert({
        'app_id': 'abba',
        'post_id': postId,
        'user_id': _userId,
      });

      await _client.rpc('increment_like_count', params: {'p_post_id': postId});
      return true;
    }
  }

  @override
  Future<void> toggleCommentLike(String commentId) async {
    final existing = await _client
        .from('comment_likes')
        .select('id')
        .eq('comment_id', commentId)
        .eq('user_id', _userId)
        .eq('app_id', 'abba')
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('comment_likes')
          .delete()
          .eq('comment_id', commentId)
          .eq('user_id', _userId)
          .eq('app_id', 'abba');
    } else {
      await _client.from('comment_likes').insert({
        'app_id': 'abba',
        'comment_id': commentId,
        'user_id': _userId,
      });
    }
  }

  // --- Saves ---

  @override
  Future<bool> toggleSave(String postId) async {
    final existing = await _client
        .from('post_saves')
        .select('id')
        .eq('post_id', postId)
        .eq('user_id', _userId)
        .eq('app_id', 'abba')
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('post_saves')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', _userId)
          .eq('app_id', 'abba');
      return false;
    } else {
      await _client.from('post_saves').insert({
        'app_id': 'abba',
        'post_id': postId,
        'user_id': _userId,
      });
      return true;
    }
  }

  @override
  Future<List<CommunityPost>> getSavedPosts() async {
    final savedIds = await _client
        .from('post_saves')
        .select('post_id')
        .eq('user_id', _userId)
        .eq('app_id', 'abba')
        .order('created_at', ascending: false);

    if ((savedIds as List).isEmpty) return [];

    final ids = savedIds.map((e) => e['post_id'] as String).toList();

    final data = await _client
        .from('community_posts')
        .select()
        .eq('app_id', 'abba')
        .inFilter('id', ids);

    final posts = <CommunityPost>[];
    for (final row in data as List) {
      final postId = row['id'] as String;
      final comments = await getComments(postId);
      posts.add(
        CommunityPost.fromJson({
          ...row as Map<String, dynamic>,
          'is_liked': await _isLiked(postId),
          'is_saved': true,
          'comments': comments.map((c) => c.toJson()).toList(),
        }),
      );
    }
    return posts;
  }

  // --- Reports ---

  @override
  Future<void> reportPost(String postId, String reason) async {
    await _client.from('reports').insert({
      'app_id': 'abba',
      'reporter_id': _userId,
      'target_type': 'post',
      'target_id': postId,
      'reason': reason,
    });

    // Check report count, auto-hide if >= 3 (via SECURITY DEFINER RPC)
    final reports = await _client
        .from('reports')
        .select('id')
        .eq('target_type', 'post')
        .eq('target_id', postId)
        .eq('app_id', 'abba');

    await _client.rpc(
      'update_report_count',
      params: {'p_post_id': postId, 'p_count': (reports as List).length},
    );
  }

  @override
  Future<void> reportComment(String commentId, String reason) async {
    await _client.from('reports').insert({
      'app_id': 'abba',
      'reporter_id': _userId,
      'target_type': 'comment',
      'target_id': commentId,
      'reason': reason,
    });
  }

  // --- Helpers ---

  Future<bool> _isLiked(String postId) async {
    final data = await _client
        .from('post_likes')
        .select('id')
        .eq('post_id', postId)
        .eq('user_id', _userId)
        .eq('app_id', 'abba')
        .maybeSingle();
    return data != null;
  }

  Future<bool> _isSaved(String postId) async {
    final data = await _client
        .from('post_saves')
        .select('id')
        .eq('post_id', postId)
        .eq('user_id', _userId)
        .eq('app_id', 'abba')
        .maybeSingle();
    return data != null;
  }
}
