import 'package:flutter_test/flutter_test.dart';
import 'package:abba/services/mock_data.dart';

import '../helpers/test_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDataService service;

  setUp(() {
    // Use in-memory fixtures via `fromData` — bypasses `rootBundle`
    // (asset shim is not wired in `flutter_test` for raw `assets/mock/*.json`).
    service = MockDataService.fromData(
      prayerResult: TestFixtures.prayerResult(),
      qtMeditationResult: TestFixtures.qtMeditationResult(),
      qtPassages: TestFixtures.qtPassages(),
      communityPosts: TestFixtures.communityPosts(),
      userProfile: TestFixtures.userProfile(),
    );
  });

  group('MockDataService', () {
    test('getPrayerResult loads and parses JSON', () async {
      final result = await service.getPrayerResult();

      expect(result.scripture.reference, isNotEmpty);
      // Phase 6: verse is populated from PD bundle at runtime, not JSON mock.
      expect(result.bibleStory.title, isNotEmpty);
      expect(result.testimony, isNotEmpty);
      expect(result.aiPrayer, isNotNull);
      expect(result.prayerSummary, isNotNull);
      expect(result.historicalStory, isNotNull);
    });

    test('getPrayerResult caches result', () async {
      final result1 = await service.getPrayerResult();
      final result2 = await service.getPrayerResult();

      expect(identical(result1, result2), true);
    });

    test('getQTPassages loads 5 passages', () async {
      final passages = await service.getQTPassages();

      expect(passages, isNotEmpty);
      expect(passages.length, 5);
      expect(passages[0].id, 'qt-1');
      expect(passages[0].reference, 'Psalm 23:1-6');
    });

    test('getCommunityPosts loads posts with comments', () async {
      final posts = await service.getCommunityPosts();

      expect(posts, isNotEmpty);
      expect(posts[0].id, 'post-1');
      expect(posts[0].category, 'testimony');
      expect(posts[0].comments, isNotEmpty);
    });

    test('getUserProfile loads profile', () async {
      final profile = await service.getUserProfile();

      expect(profile.id, 'mock-user-1');
      expect(profile.name, 'Grace');
      expect(profile.email, 'grace@example.com');
      expect(profile.totalPrayers, 45);
    });
  });
}
