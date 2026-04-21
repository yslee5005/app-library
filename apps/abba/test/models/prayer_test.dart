import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/prayer.dart';

void main() {
  group('Prayer', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 'prayer-1',
        'user_id': 'user-1',
        'transcript': 'Dear Lord...',
        'mode': 'prayer',
        'qt_passage_ref': null,
        'created_at': '2026-04-06T08:00:00Z',
        'result': null,
      };

      final prayer = Prayer.fromJson(json);

      expect(prayer.id, 'prayer-1');
      expect(prayer.userId, 'user-1');
      expect(prayer.transcript, 'Dear Lord...');
      expect(prayer.mode, 'prayer');
      expect(prayer.qtPassageRef, isNull);
      expect(prayer.createdAt, DateTime.parse('2026-04-06T08:00:00Z'));
      expect(prayer.result, isNull);
    });

    test('fromJson parses qt mode with passage ref', () {
      final json = {
        'id': 'prayer-2',
        'user_id': 'user-1',
        'transcript': 'Thank you Lord...',
        'mode': 'qt',
        'qt_passage_ref': 'Psalm 23:1',
        'created_at': '2026-04-06T09:00:00Z',
        'result': null,
      };

      final prayer = Prayer.fromJson(json);

      expect(prayer.mode, 'qt');
      expect(prayer.qtPassageRef, 'Psalm 23:1');
    });

    test('fromJson parses nested PrayerResult', () {
      final json = {
        'id': 'prayer-3',
        'user_id': 'user-1',
        'transcript': 'Lord...',
        'mode': 'prayer',
        'created_at': '2026-04-06T10:00:00Z',
        'result': {
          'scripture': {
            'verse_en': 'The LORD is my shepherd.',
            'verse_ko': '여호와는 나의 목자시니',
            'reference': 'Psalm 23:1',
          },
          'bible_story': {
            'title_en': 'David the Shepherd',
            'title_ko': '목자 다윗',
            'summary_en': 'David was a shepherd boy.',
            'summary_ko': '다윗은 양치기 소년이었습니다.',
          },
          'testimony': {'transcript_en': 'Lord...'},
        },
      };

      final prayer = Prayer.fromJson(json);

      expect(prayer.result, isNotNull);
      expect(prayer.result!.scripture.reference, 'Psalm 23:1');
      expect(prayer.result!.bibleStory.titleEn, 'David the Shepherd');
    });
  });

  group('PrayerResult', () {
    test('fromJson parses all fields with null optionals', () {
      final json = {
        'scripture': {
          'verse_en': 'Be still.',
          'verse_ko': '가만히 있으라.',
          'reference': 'Psalm 46:10',
        },
        'bible_story': {
          'title_en': 'Stillness',
          'title_ko': '고요함',
          'summary_en': 'God calls us to be still.',
          'summary_ko': '하나님은 우리를 가만히 있으라 하십니다.',
        },
        'testimony': {'transcript_en': 'My prayer...'},
      };

      final result = PrayerResult.fromJson(json);

      expect(result.scripture.verseEn, 'Be still.');
      expect(result.testimony, 'My prayer...');
      expect(result.guidance, isNull);
      expect(result.aiPrayer, isNull);
    });

    test('fromJson parses all premium fields', () {
      final json = {
        'scripture': {'verse_en': 'v', 'verse_ko': 'v', 'reference': 'ref'},
        'bible_story': {
          'title_en': 't',
          'title_ko': 't',
          'summary_en': 's',
          'summary_ko': 's',
        },
        'testimony': {'transcript_en': 'text'},
        'guidance': {
          'content_en': 'guidance en',
          'content_ko': 'guidance ko',
          'is_premium': true,
        },
        'ai_prayer': {
          'text_en': 'prayer en',
          'text_ko': 'prayer ko',
          'audio_url': 'https://example.com/audio.mp3',
          'is_premium': true,
        },
      };

      final result = PrayerResult.fromJson(json);

      expect(result.guidance, isNotNull);
      expect(result.guidance!.isPremium, true);
      expect(result.guidance!.content('en'), 'guidance en');
      expect(result.guidance!.content('ko'), 'guidance ko');

      expect(result.aiPrayer, isNotNull);
      expect(result.aiPrayer!.audioUrl, 'https://example.com/audio.mp3');
      expect(result.aiPrayer!.text('en'), 'prayer en');
    });
  });

  group('Scripture', () {
    test('verse returns locale-based text', () {
      const scripture = Scripture(
        verseEn: 'English verse',
        verseKo: '한국어 구절',
        reference: 'Psalm 1:1',
      );

      expect(scripture.verse('en'), 'English verse');
      expect(scripture.verse('ko'), '한국어 구절');
      expect(scripture.verse('ja'), 'English verse'); // fallback to en
    });
  });

  group('BibleStory', () {
    test('title and summary return locale-based text', () {
      const story = BibleStory(
        titleEn: 'Title EN',
        titleKo: 'Title KO',
        summaryEn: 'Summary EN',
        summaryKo: 'Summary KO',
      );

      expect(story.title('en'), 'Title EN');
      expect(story.title('ko'), 'Title KO');
      expect(story.summary('en'), 'Summary EN');
      expect(story.summary('ko'), 'Summary KO');
    });
  });

  group('Guidance', () {
    test('isPremium defaults to true when missing', () {
      final guidance = Guidance.fromJson({
        'content_en': 'en',
        'content_ko': 'ko',
      });

      expect(guidance.isPremium, true);
    });
  });

  group('AiPrayer', () {
    test('audioUrl is nullable', () {
      final prayer = AiPrayer.fromJson({
        'text_en': 'en',
        'text_ko': 'ko',
        'is_premium': false,
      });

      expect(prayer.audioUrl, isNull);
      expect(prayer.isPremium, false);
    });
  });

  group('ScriptureOriginalWord', () {
    test('meaning and nuance return locale-based text', () {
      const word = ScriptureOriginalWord(
        word: 'word',
        transliteration: 'trans',
        language: 'Hebrew',
        meaningEn: 'meaning en',
        meaningKo: 'meaning ko',
        nuanceEn: 'nuance en',
        nuanceKo: 'nuance ko',
      );

      expect(word.meaning('en'), 'meaning en');
      expect(word.meaning('ko'), 'meaning ko');
      expect(word.nuance('en'), 'nuance en');
      expect(word.nuance('ko'), 'nuance ko');
      expect(word.isRtl, true);
    });
  });
}
