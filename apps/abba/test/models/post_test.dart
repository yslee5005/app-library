import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/post.dart';

void main() {
  group('CommunityPost', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'post-1',
        'user_id': 'user-1',
        'display_name': 'Grace Kim',
        'avatar_url': null,
        'category': 'testimony',
        'content': 'God is faithful!',
        'like_count': 24,
        'comment_count': 5,
        'is_liked': false,
        'is_saved': false,
        'is_hidden': false,
        'report_count': 0,
        'created_at': '2026-04-06T08:30:00Z',
        'comments': [
          {
            'id': 'comment-1',
            'user_id': 'user-2',
            'display_name': 'John',
            'content': 'Praise God!',
            'parent_comment_id': null,
            'created_at': '2026-04-06T09:00:00Z',
          },
        ],
      };

      final post = CommunityPost.fromJson(json);

      expect(post.id, 'post-1');
      expect(post.userId, 'user-1');
      expect(post.displayName, 'Grace Kim');
      expect(post.avatarUrl, isNull);
      expect(post.category, 'testimony');
      expect(post.content, 'God is faithful!');
      expect(post.likeCount, 24);
      expect(post.commentCount, 5);
      expect(post.isLiked, false);
      expect(post.isSaved, false);
      expect(post.isHidden, false);
      expect(post.reportCount, 0);
      expect(post.comments.length, 1);
    });

    test('anonymous post has null displayName', () {
      final json = {
        'id': 'post-2',
        'user_id': 'user-3',
        'display_name': null,
        'category': 'prayer_request',
        'content': 'Please pray for me.',
        'created_at': '2026-04-06T10:00:00Z',
      };

      final post = CommunityPost.fromJson(json);
      expect(post.displayName, isNull);
    });

    test('copyWith creates modified copy', () {
      final post = CommunityPost(
        id: 'post-1',
        userId: 'user-1',
        category: 'testimony',
        content: 'Content',
        createdAt: DateTime(2026, 4, 6),
      );

      final liked = post.copyWith(isLiked: true, likeCount: 1);

      expect(liked.isLiked, true);
      expect(liked.likeCount, 1);
      expect(liked.id, 'post-1'); // unchanged
      expect(liked.content, 'Content'); // unchanged
    });

    test('toJson serializes correctly', () {
      final post = CommunityPost(
        id: 'post-1',
        userId: 'user-1',
        displayName: 'Grace',
        category: 'testimony',
        content: 'Content',
        likeCount: 5,
        commentCount: 2,
        createdAt: DateTime.parse('2026-04-06T08:00:00Z'),
      );

      final json = post.toJson();

      expect(json['id'], 'post-1');
      expect(json['user_id'], 'user-1');
      expect(json['display_name'], 'Grace');
      expect(json['category'], 'testimony');
      expect(json['like_count'], 5);
    });

    test('defaults for optional fields', () {
      final json = {
        'id': 'post-3',
        'user_id': 'user-1',
        'category': 'testimony',
        'content': 'Test',
        'created_at': '2026-04-06T08:00:00Z',
      };

      final post = CommunityPost.fromJson(json);

      expect(post.likeCount, 0);
      expect(post.commentCount, 0);
      expect(post.isLiked, false);
      expect(post.isSaved, false);
      expect(post.isHidden, false);
      expect(post.reportCount, 0);
      expect(post.comments, isEmpty);
    });
  });

  group('Comment', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'comment-1',
        'user_id': 'user-2',
        'display_name': 'John',
        'content': 'Praise God!',
        'parent_comment_id': null,
        'created_at': '2026-04-06T09:00:00Z',
      };

      final comment = Comment.fromJson(json);

      expect(comment.id, 'comment-1');
      expect(comment.userId, 'user-2');
      expect(comment.displayName, 'John');
      expect(comment.content, 'Praise God!');
      expect(comment.parentCommentId, isNull);
    });

    test('reply has parentCommentId', () {
      final json = {
        'id': 'comment-3',
        'user_id': 'user-1',
        'display_name': 'Grace',
        'content': 'Thank you!',
        'parent_comment_id': 'comment-1',
        'created_at': '2026-04-06T09:30:00Z',
      };

      final reply = Comment.fromJson(json);
      expect(reply.parentCommentId, 'comment-1');
    });

    test('toJson serializes correctly', () {
      final comment = Comment(
        id: 'c1',
        userId: 'u1',
        displayName: 'Name',
        content: 'Hello',
        parentCommentId: 'c0',
        createdAt: DateTime.parse('2026-04-06T09:00:00Z'),
      );

      final json = comment.toJson();

      expect(json['id'], 'c1');
      expect(json['parent_comment_id'], 'c0');
    });
  });
}
