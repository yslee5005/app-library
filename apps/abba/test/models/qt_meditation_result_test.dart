import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/qt_meditation_result.dart';

void main() {
  group('MeditationSummary', () {
    test('fromJson parses summary + topic', () {
      final summary = MeditationSummary.fromJson({
        'summary': '하나님의 신실하심을 묵상하는 시간',
        'topic': '목자 되신 여호와',
      });
      expect(summary.summary, '하나님의 신실하심을 묵상하는 시간');
      expect(summary.topic, '목자 되신 여호와');
      expect(summary.isEmpty, isFalse);
    });

    test('fromJson defaults empty strings for missing fields', () {
      final summary = MeditationSummary.fromJson(const {});
      expect(summary.summary, isEmpty);
      expect(summary.topic, isEmpty);
      expect(summary.isEmpty, isTrue);
    });

    test('isEmpty true only when both fields blank', () {
      expect(
        const MeditationSummary(summary: 'x', topic: '').isEmpty,
        isFalse,
      );
      expect(
        const MeditationSummary(summary: '', topic: 'y').isEmpty,
        isFalse,
      );
      expect(
        const MeditationSummary(summary: '', topic: '').isEmpty,
        isTrue,
      );
    });
  });

  group('QtMeditationResult.fromJson — Phase 1 new format', () {
    test('parses meditation_summary + scripture + analysis', () {
      final json = {
        'meditation_summary': {
          'summary': '오늘 묵상은 하나님의 평안에 닿아 있습니다.',
          'topic': '평안의 근원',
        },
        'scripture': {
          'reference': 'Psalm 23:1-3',
          'reason': '당신의 묵상은 신뢰에 닿아 있습니다.',
          'posture': '한 구절씩 천천히 읽어 보세요.',
          'key_word_hint': "'나의 목자' = 히브리어 '로이'",
          'original_words': [
            {
              'word': 'רֹעִי',
              'transliteration': "ro'i",
              'language': 'Hebrew',
              'meaning_en': 'my shepherd',
              'meaning_ko': '나의 목자',
            },
          ],
        },
        'analysis': {
          'insight': '당신의 묵상은 신뢰에 맞닿아 있습니다.',
        },
        'application': {
          'action': '오늘 저녁 식사 전 시편 23편을 한 번 소리 내어 읽으세요.',
        },
        'knowledge': {
          'historical_context': '다윗은 목자 경험에서 시편 23편을 썼습니다.',
          'cross_references': [
            {'reference': 'Isaiah 40:11', 'text': '...'},
          ],
        },
      };

      final result = QtMeditationResult.fromJson(json);

      expect(result.meditationSummary.summary,
          '오늘 묵상은 하나님의 평안에 닿아 있습니다.');
      expect(result.meditationSummary.topic, '평안의 근원');
      expect(result.scripture.reference, 'Psalm 23:1-3');
      expect(result.scripture.reason, isNotEmpty);
      expect(result.scripture.posture, isNotEmpty);
      expect(result.scripture.keyWordHint, isNotEmpty);
      expect(result.scripture.originalWords, hasLength(1));
      expect(result.scripture.originalWords.first.word, 'רֹעִי');
      // Phase 1 single `insight` → propagates to both locale variants.
      expect(result.analysis.insightEn, isNotEmpty);
      expect(result.analysis.insightKo, isNotEmpty);
      expect(result.application.action, isNotEmpty);
      expect(result.knowledge.historicalContextEn, isNotEmpty);
      expect(result.knowledge.historicalContextKo, isNotEmpty);
      expect(result.knowledge.crossReferences, hasLength(1));
    });

    test('growthStory single-field Phase 1 prompt output', () {
      final json = {
        'analysis': {'insight': 'x'},
        'application': {'action': 'y'},
        'knowledge': {'historical_context': 'z'},
        'growth_story': {
          'title': '직조공의 무늬',
          'summary': '한 소녀가 할머니가 태피스트리를 짜는 모습을 바라보았습니다.',
          'lesson': '하나님은 엉킨 실에서도 아름다움을 만드십니다.',
          'is_premium': true,
        },
      };

      final result = QtMeditationResult.fromJson(json);
      expect(result.growthStory, isNotNull);
      expect(result.growthStory!.titleEn, '직조공의 무늬');
      expect(result.growthStory!.titleKo, '직조공의 무늬');
      expect(result.growthStory!.summaryEn, isNotEmpty);
      expect(result.growthStory!.isPremium, isTrue);
    });
  });

  group('QtMeditationResult.fromJson — legacy compat', () {
    test('legacy record without meditation_summary synthesizes topic from keyTheme', () {
      final json = {
        'analysis': {
          'key_theme_en': "God's Faithfulness",
          'key_theme_ko': '신실하심',
          'insight_en': 'insight',
          'insight_ko': '통찰',
        },
        'application': {
          'action': '행동',
        },
        'knowledge': {
          'historical_context_en': 'context',
          'historical_context_ko': '배경',
          'cross_references': [],
        },
      };

      final result = QtMeditationResult.fromJson(json);

      // No meditation_summary in legacy → summary empty, topic inferred.
      expect(result.meditationSummary.summary, isEmpty);
      expect(result.meditationSummary.topic, "God's Faithfulness");
      // No scripture in legacy → default empty Scripture.
      expect(result.scripture.reference, isEmpty);
      // Legacy fields still readable.
      expect(result.analysis.keyThemeKo, '신실하심');
      expect(result.analysis.insightKo, '통찰');
    });

    test('legacy growth_story with _en/_ko fields still parses', () {
      final json = {
        'analysis': {'insight': ''},
        'application': {'action': ''},
        'knowledge': {},
        'growth_story': {
          'title_en': 'Old Title',
          'title_ko': '옛 제목',
          'summary_en': 'Old English summary',
          'summary_ko': '옛 한국어 요약',
          'lesson_en': 'Old lesson',
          'lesson_ko': '옛 교훈',
          'is_premium': true,
        },
      };

      final result = QtMeditationResult.fromJson(json);
      expect(result.growthStory!.titleEn, 'Old Title');
      expect(result.growthStory!.titleKo, '옛 제목');
      expect(result.growthStory!.summaryKo, '옛 한국어 요약');
    });

    test('tolerates completely empty sub-objects (defensive defaults)', () {
      final json = {
        'analysis': {},
        'application': {},
        'knowledge': {},
      };
      final result = QtMeditationResult.fromJson(json);
      expect(result.meditationSummary.isEmpty, isTrue);
      expect(result.scripture.reference, isEmpty);
      expect(result.analysis.insightEn, isEmpty);
      expect(result.application.action, isEmpty);
      expect(result.knowledge.crossReferences, isEmpty);
      expect(result.growthStory, isNull);
    });
  });

  group('RelatedKnowledge.citations — Phase 3 (qt_output_redesign)', () {
    test('parses citations array when present', () {
      final knowledge = RelatedKnowledge.fromJson({
        'historical_context': '배경 설명',
        'citations': [
          {
            'type': 'history',
            'source': 'Phillip Keller, 1970',
            'content': '팔레스타인 양들은 급류를 두려워했습니다.',
          },
          {
            'type': 'science',
            'source': 'Journal of Behavioral Medicine, 2012',
            'content': '정기적 묵상자는 코르티솔이 23% 낮다는 보고.',
          },
          {
            'type': 'quote',
            'source': 'Augustine, Confessions',
            'content': '우리의 마음은 당신 안에서 쉴 때까지 쉬지 못합니다.',
          },
        ],
      });

      expect(knowledge.citations, hasLength(3));
      expect(knowledge.citations[0].type, 'history');
      expect(knowledge.citations[0].source, 'Phillip Keller, 1970');
      expect(knowledge.citations[1].type, 'science');
      expect(knowledge.citations[2].type, 'quote');
    });

    test('defaults to empty list when citations key is missing', () {
      final knowledge = RelatedKnowledge.fromJson({
        'historical_context': '배경 설명',
        'cross_references': [],
      });
      expect(knowledge.citations, isEmpty);
    });

    test('filters out citations with empty content', () {
      final knowledge = RelatedKnowledge.fromJson({
        'citations': [
          {'type': 'quote', 'source': 'A', 'content': 'valid content'},
          {'type': 'quote', 'source': 'B', 'content': ''},
          {'type': 'history', 'source': 'C', 'content': 'another valid'},
        ],
      });
      expect(knowledge.citations, hasLength(2));
      expect(knowledge.citations[0].content, 'valid content');
      expect(knowledge.citations[1].content, 'another valid');
    });

    test('QtMeditationResult.fromJson propagates citations through knowledge',
        () {
      final json = {
        'analysis': {'insight': 'i'},
        'application': {'action': 'a'},
        'knowledge': {
          'historical_context': 'h',
          'citations': [
            {
              'type': 'example',
              'source': '',
              'content': '일상의 한 장면',
            },
          ],
        },
      };
      final result = QtMeditationResult.fromJson(json);
      expect(result.knowledge.citations, hasLength(1));
      expect(result.knowledge.citations.first.type, 'example');
      expect(result.knowledge.citations.first.source, isEmpty);
      expect(result.knowledge.citations.first.content, '일상의 한 장면');
    });
  });

  group('QtMeditationResult.copyWithScripture', () {
    test('replaces scripture, preserves other fields', () {
      final original = QtMeditationResult.fromJson({
        'meditation_summary': {'summary': 's', 'topic': 't'},
        'scripture': {'reference': 'Psalm 23:1'},
        'analysis': {'insight': 'i'},
        'application': {'action': 'a'},
        'knowledge': {},
      });

      final next = original.copyWithScripture(
        original.scripture.withVerse('여호와는 나의 목자시니'),
      );

      expect(next.scripture.reference, 'Psalm 23:1');
      expect(next.scripture.verse, '여호와는 나의 목자시니');
      expect(next.meditationSummary.topic, 't');
      expect(next.analysis.insightEn, 'i');
    });
  });
}
