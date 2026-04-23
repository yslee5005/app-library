import 'package:flutter_test/flutter_test.dart';

import 'package:abba/services/mock/mock_community_repository.dart';
import 'package:abba/services/mock_data.dart';

import '../helpers/test_fixtures.dart';

/// Contract tests for [MockCommunityRepository]. The real Supabase
/// implementation needs an integration environment; this suite only pins
/// the in-memory mock's behaviour (optimistic toggles, seeded posts,
/// creation + deletion).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockCommunityRepository newRepo() {
    // fromData bypasses rootBundle asset reads. Seed the mock with one
    // post that later tests can interact with.
    final mockData = MockDataService.fromData(
      communityPosts: TestFixtures.communityPosts(),
    );
    return MockCommunityRepository(mockData);
  }

  group('MockCommunityRepository', () {
    test('getPosts returns the seeded fixture post', () async {
      final repo = newRepo();
      final posts = await repo.getPosts();
      expect(posts, isNotEmpty);
      expect(posts.first.id, 'post-1');
      expect(posts.first.category, 'testimony');
    });

    test('getPostDetail returns the matching post', () async {
      final repo = newRepo();
      final post = await repo.getPostDetail('post-1');
      expect(post.id, 'post-1');
      expect(post.content, contains('mother'));
    });

    test('createPost adds a new post at the top of the feed', () async {
      final repo = newRepo();
      final before = await repo.getPosts();

      final created = await repo.createPost(
        category: 'prayer_request',
        content: 'Please pray for my interview tomorrow.',
        displayName: 'Anon',
      );

      final after = await repo.getPosts();
      expect(after, hasLength(before.length + 1));
      // Mock prepends newest-first.
      expect(after.first.id, created.id);
      expect(after.first.category, 'prayer_request');
    });

    test('deletePost removes the post', () async {
      final repo = newRepo();
      await repo.deletePost('post-1');
      final after = await repo.getPosts();
      expect(after.any((p) => p.id == 'post-1'), isFalse);
    });

    test('toggleLike flips isLiked and returns the new state', () async {
      final repo = newRepo();
      final firstToggle = await repo.toggleLike('post-1');
      final afterFirst = await repo.getPostDetail('post-1');
      expect(afterFirst.isLiked, firstToggle);

      final secondToggle = await repo.toggleLike('post-1');
      expect(secondToggle, isNot(firstToggle));
    });

    test('toggleSave flips isSaved and appears in getSavedPosts', () async {
      final repo = newRepo();
      await repo.toggleSave('post-1');
      final saved = await repo.getSavedPosts();
      expect(saved.any((p) => p.id == 'post-1'), isTrue);

      await repo.toggleSave('post-1');
      final savedAgain = await repo.getSavedPosts();
      expect(savedAgain.any((p) => p.id == 'post-1'), isFalse);
    });

    test('createComment attaches a top-level comment to the post', () async {
      final repo = newRepo();
      final comment = await repo.createComment(
        postId: 'post-1',
        content: 'Praying with you.',
      );

      expect(comment.content, 'Praying with you.');

      final post = await repo.getPostDetail('post-1');
      expect(post.comments.any((c) => c.id == comment.id), isTrue);
    });
  });
}
