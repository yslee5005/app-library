import 'package:abba/models/post.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/models/qt_meditation_result.dart';
import 'package:abba/models/qt_passage.dart';
import 'package:abba/models/user_profile.dart';

/// In-memory fixtures for `MockDataService.fromData(...)` injection.
///
/// These mirror the real `assets/mock/*.json` contents closely enough that
/// existing tests which assert on concrete values (`profile.name == 'Grace'`,
/// `posts[0].id == 'post-1'`, etc.) continue to pass without needing the
/// asset bundle shim in `flutter_test`.
class TestFixtures {
  TestFixtures._();

  // ---------------------------------------------------------------------------
  // PrayerResult — matches `assets/mock/prayer_result.json` shape enough for
  // `mock_data_service_test.dart`'s expectations:
  //   - scripture.reference not empty
  //   - bibleStory.title not empty
  //   - testimony not empty
  //   - aiPrayer not null
  //   - prayerSummary not null
  //   - historicalStory not null
  // ---------------------------------------------------------------------------
  static PrayerResult prayerResult() => const PrayerResult(
        scripture: Scripture(
          reference: '시편 23:1-3',
          verse: 'The LORD is my shepherd; I shall not want.',
        ),
        bibleStory: BibleStory(
          title: 'David the Shepherd King',
          summary:
              'Before David became the mighty king of Israel, he was a humble shepherd boy.',
        ),
        testimony:
            'Lord, thank You for this new morning. Guide my steps today.',
        prayerSummary: PrayerSummary(
          gratitude: ['감사합니다'],
          petition: ['오늘 지혜를 구합니다'],
          intercession: ['이웃을 위해 기도합니다'],
        ),
        historicalStory: HistoricalStory(
          title: "Hannah's Prayer",
          reference: '사무엘상 1-2장',
          summary: 'Every year, the journey to Shiloh was the same...',
          lesson: 'God hears prayers that have no sound.',
          isPremium: true,
        ),
        aiPrayer: AiPrayer(
          text:
              'Father, before the world spun its first rotation, You were already here.',
          isPremium: true,
        ),
      );

  // ---------------------------------------------------------------------------
  // QtMeditationResult — minimal valid shape.
  // ---------------------------------------------------------------------------
  static QtMeditationResult qtMeditationResult() => const QtMeditationResult(
        meditationSummary: MeditationSummary(
          summary: 'Today I meditated on God as my shepherd.',
          topic: "Shepherd's Care",
          insight: 'Trusting God in uncertainty.',
        ),
        scripture: Scripture(reference: 'Psalm 23:1-3'),
        application: ApplicationSuggestion(
          morningAction: 'Thank God for one gift before rising.',
          dayAction: 'Pause once to remember you are being led.',
          eveningAction: 'Write one moment of care from today.',
        ),
        knowledge: RelatedKnowledge(
          historicalContext: 'Psalm 23 was written by David.',
          crossReferences: [
            CrossReference(reference: 'John 10:11', text: 'The good shepherd'),
          ],
        ),
      );

  // ---------------------------------------------------------------------------
  // QTPassages — 5 items, matches length + first id/reference asserted by
  // `mock_data_service_test.dart`.
  // ---------------------------------------------------------------------------
  static List<QTPassage> qtPassages() {
    final date = DateTime(2026, 4, 6);
    return [
      QTPassage(
        id: 'qt-1',
        reference: 'Psalm 23:1-6',
        text: 'The Lord is my shepherd; I shall not want.',
        topic: "Shepherd's Care",
        icon: '🌿',
        colorHex: '#B2DFDB',
        date: date,
      ),
      QTPassage(
        id: 'qt-2',
        reference: 'Philippians 4:6-7',
        text: 'Do not be anxious about anything...',
        topic: 'Peace in Prayer',
        icon: '🌸',
        colorHex: '#FFB7C5',
        date: date,
      ),
      QTPassage(
        id: 'qt-3',
        reference: 'Isaiah 40:31',
        text: 'But those who hope in the Lord will renew their strength.',
        topic: 'Renewed Strength',
        icon: '🐦',
        colorHex: '#B3E5FC',
        date: date,
      ),
      QTPassage(
        id: 'qt-4',
        reference: 'Proverbs 3:5-6',
        text: 'Trust in the Lord with all your heart...',
        topic: "Trusting God's Plan",
        icon: '☀️',
        colorHex: '#FFCCBC',
        date: date,
      ),
      QTPassage(
        id: 'qt-5',
        reference: 'Jeremiah 29:11',
        text: 'For I know the plans I have for you...',
        topic: 'Hope & Future',
        icon: '🌱',
        colorHex: '#D1C4E9',
        date: date,
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // CommunityPosts — at least one post with id='post-1', category='testimony',
  // and at least one comment (matches `mock_data_service_test.dart` expects).
  // ---------------------------------------------------------------------------
  static List<CommunityPost> communityPosts() {
    final created = DateTime.parse('2026-04-06T08:30:00Z');
    return [
      CommunityPost(
        id: 'post-1',
        userId: 'user-1',
        displayName: 'Grace Kim',
        category: 'testimony',
        content:
            "I've been praying for my mother's health for three months. God is faithful!",
        likeCount: 24,
        commentCount: 3,
        createdAt: created,
        comments: [
          Comment(
            id: 'comment-1',
            userId: 'user-2',
            displayName: 'John Lee',
            content: 'Praise God! What a wonderful testimony.',
            createdAt: DateTime.parse('2026-04-06T09:00:00Z'),
          ),
        ],
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // UserProfile — matches `assets/mock/user_profile.json` concrete values
  // asserted in `mock_data_service_test.dart`.
  // ---------------------------------------------------------------------------
  static UserProfile userProfile() => const UserProfile(
        id: 'mock-user-1',
        displayName: 'Grace',
        email: 'grace@example.com',
        totalPrayers: 45,
        currentStreak: 7,
        bestStreak: 21,
        locale: 'en',
        reminderTime: '06:00',
      );
}
