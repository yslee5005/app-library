import 'package:abba/models/post.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/models/qt_meditation_result.dart';
import 'package:abba/models/qt_passage.dart';
import 'package:abba/models/user_profile.dart';

// Ralph #6 — shared card fixtures used by dashboard widget tests.
// Kept additive so existing tests are untouched.

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

  // ---------------------------------------------------------------------------
  // Ralph #6 — Dashboard card fixtures.
  // ---------------------------------------------------------------------------

  /// AiPrayer with a representative citation per (quote/science/example) type.
  /// `isPremium` drives the ProBlur gate inside `AiPrayerCard`.
  static AiPrayer aiPrayer({bool isPremium = true}) => AiPrayer(
        text: 'Father, guide our steps today.',
        isPremium: isPremium,
        citations: const [
          Citation(
            type: 'quote',
            source: 'Augustine',
            content: 'Our hearts are restless until they rest in You.',
          ),
          Citation(
            type: 'science',
            source: 'Harvard Study 2023',
            content: 'Gratitude practice lowers cortisol by 23%.',
          ),
          Citation(
            type: 'example',
            source: '',
            content: 'A widow keeps a morning gratitude journal.',
          ),
        ],
      );

  /// GrowthStory — spiritual narrative of a biblical figure. `isPremium=true`
  /// combined with `isUserPremium=false` makes `GrowthStoryCard` show ProBlur.
  static GrowthStory growthStory({bool isPremium = true}) => GrowthStory(
        title: 'Hannah at Shiloh',
        summary: 'Hannah wept bitterly before the Lord, pouring out her soul.',
        lesson: 'Even silent prayers reach God when the heart is broken.',
        isPremium: isPremium,
      );

  /// QtCoaching — realistic scores + bullets. `overallFeedback(locale)` picks
  /// the right locale variant; both are filled so `en`/`ko` tests both work.
  static QtCoaching qtCoaching() => const QtCoaching(
        scores: QtScores(
          comprehension: 4,
          application: 3,
          depth: 5,
          authenticity: 4,
        ),
        strengths: [
          'You tied the passage to your morning commute.',
          'Your confession was specific, not generic.',
        ],
        improvements: [
          'Consider memorizing one key word for the week.',
        ],
        overallFeedbackEn:
            'Your meditation shows deep engagement with the text.',
        overallFeedbackKo: '본문과 깊이 씨름하신 흔적이 느껴집니다.',
        expertLevel: 'growing',
      );

  /// MeditationSummary with all three fields populated.
  static MeditationSummary meditationSummary({
    String summary = 'Today I meditated on God as my shepherd.',
    String topic = "Shepherd's Care",
    String insight = 'Trusting God in uncertainty is an act of worship.',
  }) => MeditationSummary(
        summary: summary,
        topic: topic,
        insight: insight,
      );

  // ---------------------------------------------------------------------------
  // Ralph Task B — additional dashboard card fixtures.
  // ---------------------------------------------------------------------------

  /// BibleStory with realistic title + summary copy.
  static BibleStory bibleStory({
    String title = 'David the Shepherd King',
    String summary =
        'Before David became the mighty king of Israel, he was a humble shepherd boy who learned to trust God in quiet fields.',
  }) => BibleStory(title: title, summary: summary);

  /// Guidance with `isPremium` drives the ProBlur gate inside `GuidanceCard`.
  static Guidance guidance({
    bool isPremium = true,
    String content =
        'Your prayer reflects a heart of gratitude — keep leaning into that posture as you walk through today.',
  }) => Guidance(content: content, isPremium: isPremium);

  /// HistoricalStory with reference + summary + lesson populated.
  /// `isPremium=true` combined with `isUserPremium=false` triggers ProBlur.
  static HistoricalStory historicalStory({bool isPremium = true}) =>
      HistoricalStory(
        title: "Hannah's Prayer at Shiloh",
        reference: '1 Samuel 1-2',
        summary:
            'Every year, Hannah went up to Shiloh with her family and wept bitterly before the Lord because she had no children.',
        lesson: 'God hears prayers that have no sound.',
        isPremium: isPremium,
      );

  /// PrayerSummary with gratitude/petition/intercession bucket data.
  static PrayerSummary prayerSummary() => const PrayerSummary(
        gratitude: [
          'Thank You for my family.',
          'Grateful for this morning light.',
        ],
        petition: ['Grant me wisdom for today\'s meeting.'],
        intercession: [
          'Watch over my mother\'s health.',
          'Comfort my friend who is grieving.',
        ],
      );

  /// PrayerCoaching with realistic scores + bullets + level.
  /// `overallFeedback(locale)` picks the right locale variant.
  static PrayerCoaching prayerCoaching() => const PrayerCoaching(
        scores: CoachingScores(
          specificity: 4,
          godCenteredness: 3,
          actsBalance: 5,
          authenticity: 4,
        ),
        strengths: [
          'You prayed with concrete, specific words rather than vague phrases.',
          'Your confession named actual situations from today.',
        ],
        improvements: [
          'Consider pausing longer after praise, before moving to petition.',
        ],
        overallFeedbackEn:
            'Your prayer shows strong ACTS balance and real authenticity.',
        overallFeedbackKo:
            '기도에 ACTS 균형과 진정성이 잘 드러납니다.',
        expertLevel: 'growing',
      );

  /// RelatedKnowledge fixture with `originalWord`, `historicalContext`,
  /// and at least one `crossReference`. `includeOriginalWord=false` lets
  /// tests cover the null-originalWord branch.
  static RelatedKnowledge relatedKnowledge({
    bool includeOriginalWord = true,
  }) => RelatedKnowledge(
        originalWord: includeOriginalWord
            ? const OriginalWord(
                word: "רֹעִי",
                transliteration: "ro'i",
                language: 'Hebrew',
                meaning:
                    'my shepherd — implies intimate, personal care and guidance.',
              )
            : null,
        historicalContext:
            'Psalm 23 was composed by David, drawing on his years as a shepherd in the hills around Bethlehem.',
        crossReferences: const [
          CrossReference(
            reference: 'John 10:11',
            text: 'I am the good shepherd.',
          ),
          CrossReference(
            reference: 'Isaiah 40:11',
            text: 'He tends his flock like a shepherd.',
          ),
        ],
      );

  /// ApplicationSuggestion with 3 time-block actions populated.
  /// `hasTimeBlocks` will be true — card renders the 3-block layout.
  static ApplicationSuggestion applicationSuggestion() =>
      const ApplicationSuggestion(
        morningAction:
            'Thank God for one specific gift before you rise from bed.',
        dayAction:
            'Pause once mid-day to remember you are being led by a shepherd.',
        eveningAction:
            'Write one moment of care you received from God today.',
      );

  /// ApplicationSuggestion with only the legacy single `action` field.
  /// `hasTimeBlocks` is false — card renders the legacy single-line layout.
  static ApplicationSuggestion applicationSuggestionLegacy() =>
      const ApplicationSuggestion(
        action: 'Quietly trust that you are being led today, even when unclear.',
      );
}
