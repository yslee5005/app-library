import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/prayer.dart' show ScriptureOriginalWord;
import 'package:abba/models/qt_meditation_result.dart';

void main() {
  group('MeditationSummary', () {
    test('fromJson parses summary + topic + insight (Phase 5C)', () {
      final summary = MeditationSummary.fromJson({
        'summary': '하나님의 신실하심을 묵상하는 시간',
        'topic': '목자 되신 여호와',
        'insight': '당신의 묵상은 신뢰에 닿아 있습니다.',
      });
      expect(summary.summary, '하나님의 신실하심을 묵상하는 시간');
      expect(summary.topic, '목자 되신 여호와');
      expect(summary.insight, '당신의 묵상은 신뢰에 닿아 있습니다.');
      expect(summary.isEmpty, isFalse);
    });

    test('fromJson defaults empty strings for missing fields', () {
      final summary = MeditationSummary.fromJson(const {});
      expect(summary.summary, isEmpty);
      expect(summary.topic, isEmpty);
      expect(summary.insight, isEmpty);
      expect(summary.isEmpty, isTrue);
    });

    test('isEmpty true only when ALL three fields blank (Phase 5C)', () {
      expect(
        const MeditationSummary(summary: 'x', topic: '').isEmpty,
        isFalse,
      );
      expect(
        const MeditationSummary(summary: '', topic: 'y').isEmpty,
        isFalse,
      );
      expect(
        const MeditationSummary(summary: '', topic: '', insight: 'z').isEmpty,
        isFalse,
      );
      expect(
        const MeditationSummary(summary: '', topic: '').isEmpty,
        isTrue,
      );
    });
  });

  group('QtMeditationResult.fromJson — Phase 1 + 5C format', () {
    test('parses meditation_summary (with insight) + scripture', () {
      final json = {
        'meditation_summary': {
          'summary': '오늘 묵상은 하나님의 평안에 닿아 있습니다.',
          'topic': '평안의 근원',
          'insight': '당신의 묵상은 신뢰에 맞닿아 있습니다.',
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
              'meaning': '나의 목자',
            },
          ],
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
      // Phase 5C — insight absorbed into meditationSummary.
      expect(result.meditationSummary.insight, '당신의 묵상은 신뢰에 맞닿아 있습니다.');
      expect(result.scripture.reference, 'Psalm 23:1-3');
      expect(result.scripture.reason, isNotEmpty);
      expect(result.scripture.posture, isNotEmpty);
      expect(result.scripture.keyWordHint, isNotEmpty);
      expect(result.scripture.originalWords, hasLength(1));
      expect(result.scripture.originalWords.first.word, 'רֹעִי');
      expect(result.application.action, isNotEmpty);
      expect(result.knowledge.historicalContext, isNotEmpty);
      expect(result.knowledge.crossReferences, hasLength(1));
    });

    test('growthStory single-field Phase 1 prompt output', () {
      final json = {
        'meditation_summary': {'summary': 's', 'topic': 't', 'insight': 'x'},
        'application': {'action': 'y'},
        'knowledge': {'historical_context': 'z'},
        'growth_story': {
          'title': '조지 뮐러 — 아침 빵',
          'summary': '1838년 브리스톨, 조지 뮐러는 비어 있는 식탁 앞에 섰습니다.',
          'lesson': '하나님은 구하기 전에 응답의 길을 여십니다.',
          'is_premium': true,
        },
      };

      final result = QtMeditationResult.fromJson(json);
      expect(result.growthStory, isNotNull);
      expect(result.growthStory!.title, '조지 뮐러 — 아침 빵');
      expect(result.growthStory!.summary, isNotEmpty);
      expect(result.growthStory!.lesson, isNotEmpty);
      expect(result.growthStory!.isPremium, isTrue);
    });
  });

  group('QtMeditationResult.fromJson — legacy compat', () {
    test('legacy record with analysis.insight (absorbed into meditationSummary)', () {
      // Phase 5C: the legacy `analysis` block is absorbed into
      // `meditation_summary.insight` so historical DB records keep rendering
      // the insight in the new unified MeditationSummaryCard.
      final json = {
        'analysis': {
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

      // No meditation_summary block → summary/topic empty.
      expect(result.meditationSummary.summary, isEmpty);
      expect(result.meditationSummary.topic, isEmpty);
      // Legacy analysis.insight_en absorbed (English first).
      expect(result.meditationSummary.insight, 'insight');
      // isEmpty is false because insight is populated.
      expect(result.meditationSummary.isEmpty, isFalse);
      // No scripture in legacy → default empty Scripture.
      expect(result.scripture.reference, isEmpty);
      // Legacy historical_context_en preferred.
      expect(result.knowledge.historicalContext, 'context');
    });

    test('legacy growth_story with _en/_ko fields still parses (English first)', () {
      final json = {
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
      // Phase 4: no locale context at parse time → _en preferred, _ko fallback.
      expect(result.growthStory!.title, 'Old Title');
      expect(result.growthStory!.summary, 'Old English summary');
      expect(result.growthStory!.lesson, 'Old lesson');
      expect(result.growthStory!.isPremium, isTrue);
    });

    test('tolerates completely empty sub-objects (defensive defaults)', () {
      final json = {
        'application': {},
        'knowledge': {},
      };
      final result = QtMeditationResult.fromJson(json);
      expect(result.meditationSummary.isEmpty, isTrue);
      expect(result.scripture.reference, isEmpty);
      expect(result.meditationSummary.insight, isEmpty);
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
        'meditation_summary': {'summary': 's', 'topic': 't', 'insight': 'i'},
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

  group('GrowthStory — Phase 4 single-field', () {
    test('parses new single-field schema (title / summary / lesson)', () {
      final story = GrowthStory.fromJson({
        'title': 'George Müller — The Morning of Bread',
        'summary':
            'On a cold November morning in 1838, the orphanage on Wilson '
                'Street sat in mist. Three hundred children stared at empty '
                'pewter plates. George Müller folded his hands and said, '
                'Father, we thank You for the food You are about to provide. '
                'Before the amen left his lips, the baker knocked at the door.',
        'lesson':
            'For whatever feels empty in your life today, remember: the '
                'Shepherd was already opening the door of provision before '
                'you finished your prayer.',
        'is_premium': true,
      });

      expect(story.title, 'George Müller — The Morning of Bread');
      expect(story.summary, contains('November morning in 1838'));
      expect(story.lesson, contains('Shepherd'));
      expect(story.isPremium, isTrue);
    });

    test('legacy dual-field JSON prefers _en over _ko (Phase 4 compat)', () {
      final story = GrowthStory.fromJson({
        'title_en': 'Augustine Milan',
        'title_ko': '아우구스티누스 밀라노',
        'summary_en': 'Under the fig tree...',
        'summary_ko': '무화과나무 아래에서...',
        'lesson_en': 'Take up and read.',
        'lesson_ko': '집어 들고 읽으라.',
        // no is_premium → defaults to true (premium card)
      });

      expect(story.title, 'Augustine Milan');
      expect(story.summary, 'Under the fig tree...');
      expect(story.lesson, 'Take up and read.');
      expect(story.isPremium, isTrue);
    });

    test('all fields missing → empty strings, isPremium defaults to true', () {
      final story = GrowthStory.fromJson(const {});
      expect(story.title, isEmpty);
      expect(story.summary, isEmpty);
      expect(story.lesson, isEmpty);
      expect(story.isPremium, isTrue);
    });

    test('QtMeditationResult.fromJson propagates single-field growth_story', () {
      final result = QtMeditationResult.fromJson({
        'meditation_summary': {'summary': 's', 'topic': 't', 'insight': 'i'},
        'application': {'action': 'a'},
        'knowledge': {'historical_context': 'h'},
        'growth_story': {
          'title': 'Corrie ten Boom — Ravensbrück',
          'summary': 'In the flea-infested barrack, Betsie read the Shepherd Psalm aloud.',
          'lesson': 'The Shepherd can lead you through any valley today.',
          'is_premium': true,
        },
      });

      expect(result.growthStory, isNotNull);
      expect(result.growthStory!.title, 'Corrie ten Boom — Ravensbrück');
      expect(result.growthStory!.summary, contains('Betsie'));
      expect(result.growthStory!.lesson, contains('Shepherd'));
    });
  });

  // ---------------------------------------------------------------------------
  // Phase 5B (qt_output_redesign) — ApplicationSuggestion 3 time blocks
  // ---------------------------------------------------------------------------
  group('ApplicationSuggestion Phase 5B 3-block', () {
    test('parses new 3-block JSON', () {
      final app = ApplicationSuggestion.fromJson({
        'morning_action': 'Before rising, whisper a line from Psalm 23.',
        'day_action': 'At lunch, pause and say "my shepherd" once.',
        'evening_action': 'Before dinner, read Psalm 23:1 with family.',
      });
      expect(app.morningAction, startsWith('Before rising'));
      expect(app.dayAction, contains('my shepherd'));
      expect(app.eveningAction, contains('Psalm 23:1'));
      expect(app.action, isEmpty);
      expect(app.hasTimeBlocks, isTrue);
    });

    test('legacy single `action` JSON falls back (hasTimeBlocks false)', () {
      final app = ApplicationSuggestion.fromJson({
        'action': '오늘 저녁 식사 전 시편 23편을 한 번 소리 내어 읽으세요.',
      });
      expect(app.action, contains('시편 23편'));
      expect(app.morningAction, isEmpty);
      expect(app.dayAction, isEmpty);
      expect(app.eveningAction, isEmpty);
      expect(app.hasTimeBlocks, isFalse);
    });

    test('oldest legacy `action_ko`/`action_en` fallback', () {
      final legacyEn = ApplicationSuggestion.fromJson({
        'action_en': 'Read Psalm 23 aloud tonight.',
        'action_ko': '오늘 밤 시편 23편을 소리 내어 읽으세요.',
      });
      // fromJson prefers action_ko first (historical behavior preserved).
      expect(legacyEn.action, '오늘 밤 시편 23편을 소리 내어 읽으세요.');
      expect(legacyEn.hasTimeBlocks, isFalse);

      final legacyEnOnly = ApplicationSuggestion.fromJson({
        'action_en': 'Read Psalm 23 aloud tonight.',
      });
      expect(legacyEnOnly.action, 'Read Psalm 23 aloud tonight.');
    });

    test('hasTimeBlocks true when only morning is populated', () {
      const app = ApplicationSuggestion(morningAction: 'whisper a verse');
      expect(app.hasTimeBlocks, isTrue);
      expect(app.dayAction, isEmpty);
      expect(app.eveningAction, isEmpty);
    });

    test('hasTimeBlocks false when nothing set', () {
      const app = ApplicationSuggestion();
      expect(app.hasTimeBlocks, isFalse);
      expect(app.action, isEmpty);
    });

    test('3-block schema coexists with legacy `action` (both preserved)', () {
      // Simulates a Gemini response that still carries a legacy action field
      // alongside the new 3-block. Both should parse; hasTimeBlocks wins.
      final app = ApplicationSuggestion.fromJson({
        'action': '오늘 조용히 묵상하는 시간을 가져보세요.',
        'morning_action': '아침에 침대에서 한 구절 속삭이기',
        'day_action': '점심에 한 번 호흡하며 기도',
        'evening_action': '저녁 식사 전 가족과 함께 읽기',
      });
      expect(app.hasTimeBlocks, isTrue);
      expect(app.action, '오늘 조용히 묵상하는 시간을 가져보세요.');
      expect(app.morningAction, isNotEmpty);
      expect(app.dayAction, isNotEmpty);
      expect(app.eveningAction, isNotEmpty);
    });

    test('QtMeditationResult.fromJson propagates 3-block application', () {
      final result = QtMeditationResult.fromJson({
        'meditation_summary': {'summary': 's', 'topic': 't', 'insight': 'i'},
        'application': {
          'morning_action': 'm',
          'day_action': 'd',
          'evening_action': 'e',
        },
        'knowledge': {},
      });
      expect(result.application.hasTimeBlocks, isTrue);
      expect(result.application.morningAction, 'm');
      expect(result.application.dayAction, 'd');
      expect(result.application.eveningAction, 'e');
    });
  });

  group('QtMeditationResult.copyWithScripture', () {
    test('replaces scripture, preserves other fields', () {
      final original = QtMeditationResult.fromJson({
        'meditation_summary': {'summary': 's', 'topic': 't', 'insight': 'i'},
        'scripture': {'reference': 'Psalm 23:1'},
        'application': {'action': 'a'},
        'knowledge': {},
      });

      final next = original.copyWithScripture(
        original.scripture.withVerse('여호와는 나의 목자시니'),
      );

      expect(next.scripture.reference, 'Psalm 23:1');
      expect(next.scripture.verse, '여호와는 나의 목자시니');
      expect(next.meditationSummary.topic, 't');
      expect(next.meditationSummary.insight, 'i');
    });
  });

  // ---------------------------------------------------------------------------
  // Phase 5C (qt_output_redesign) — MeditationAnalysis absorbed into
  // MeditationSummary.insight. Legacy DB records carrying `analysis.insight`
  // (any locale variant) must still surface the insight in the new location.
  // ---------------------------------------------------------------------------
  group('Phase 5C analysis absorption', () {
    test('new JSON: meditation_summary.insight parses directly', () {
      final result = QtMeditationResult.fromJson({
        'meditation_summary': {
          'summary': '요약',
          'topic': '주제',
          'insight': '당신의 묵상은 신뢰에 닿아 있습니다.',
        },
        'application': {},
        'knowledge': {},
      });
      expect(result.meditationSummary.insight, '당신의 묵상은 신뢰에 닿아 있습니다.');
    });

    test('legacy JSON: analysis.insight → meditationSummary.insight', () {
      // Pre-Phase-5C record carrying only the old `analysis.insight` block.
      final result = QtMeditationResult.fromJson({
        'analysis': {'insight': '레거시 통찰'},
        'application': {},
        'knowledge': {},
      });
      expect(result.meditationSummary.insight, '레거시 통찰');
      expect(result.meditationSummary.summary, isEmpty);
      expect(result.meditationSummary.topic, isEmpty);
    });

    test('legacy JSON: analysis.insight_en/insight_ko → absorbed (_en first)',
        () {
      // Even older pre-Phase-5A record with dual-locale insight pair.
      final result = QtMeditationResult.fromJson({
        'analysis': {
          'insight_en': 'Your meditation touches trust.',
          'insight_ko': '당신의 묵상은 신뢰에 닿아 있습니다.',
        },
        'application': {},
        'knowledge': {},
      });
      // _en preferred at parse time (no locale context available).
      expect(result.meditationSummary.insight, 'Your meditation touches trust.');
    });

    test('no insight anywhere → empty string, isEmpty depends on other fields',
        () {
      final empty = QtMeditationResult.fromJson({
        'application': {},
        'knowledge': {},
      });
      expect(empty.meditationSummary.insight, isEmpty);
      expect(empty.meditationSummary.isEmpty, isTrue);

      // With only topic populated, card still renders (not empty) but
      // insight section stays hidden.
      final topicOnly = QtMeditationResult.fromJson({
        'meditation_summary': {'topic': '오늘의 주제'},
        'application': {},
        'knowledge': {},
      });
      expect(topicOnly.meditationSummary.insight, isEmpty);
      expect(topicOnly.meditationSummary.isEmpty, isFalse);
    });

    test('meditation_summary.insight wins over legacy analysis.insight', () {
      // When both coexist during rollout, the new location is authoritative.
      final result = QtMeditationResult.fromJson({
        'meditation_summary': {
          'summary': 's',
          'topic': 't',
          'insight': '새 위치 통찰',
        },
        'analysis': {'insight': '레거시 통찰'},
        'application': {},
        'knowledge': {},
      });
      expect(result.meditationSummary.insight, '새 위치 통찰');
    });
  });

  // ---------------------------------------------------------------------------
  // Phase 5A (qt_output_redesign) — i18n single-field unification (non-analysis)
  // ---------------------------------------------------------------------------
  group('Phase 5A i18n single-field (non-analysis)', () {
    test('RelatedKnowledge.fromJson — single `historical_context` + legacy fallback', () {
      final fresh = RelatedKnowledge.fromJson({
        'historical_context': '다윗은 유대 광야의 목자였습니다.',
      });
      expect(fresh.historicalContext, '다윗은 유대 광야의 목자였습니다.');

      final legacy = RelatedKnowledge.fromJson({
        'historical_context_en': 'David was a shepherd of Judea.',
        'historical_context_ko': '다윗은 유대 광야의 목자였습니다.',
      });
      expect(legacy.historicalContext, 'David was a shepherd of Judea.');
    });

    test('OriginalWord.fromJson — single `meaning` + legacy fallback', () {
      final fresh = OriginalWord.fromJson({
        'word': 'רֹעִי',
        'transliteration': "ro'i",
        'language': 'Hebrew',
        'meaning': '나의 목자',
      });
      expect(fresh.meaning, '나의 목자');

      final legacy = OriginalWord.fromJson({
        'word': 'רֹעִי',
        'transliteration': "ro'i",
        'language': 'Hebrew',
        'meaning_en': 'my shepherd',
        'meaning_ko': '나의 목자',
      });
      // Phase 5A: _en preferred.
      expect(legacy.meaning, 'my shepherd');
    });

    test('ScriptureOriginalWord.fromJson — single-field + legacy (Prayer shared)', () {
      // Prayer + QT share this model. Shared migration must not regress Prayer.
      final fresh = ScriptureOriginalWord.fromJson({
        'word': 'רֹעִי',
        'transliteration': "ro'i",
        'language': 'Hebrew',
        'meaning': '나의 목자',
        'nuance': '친밀한 언약 관계',
      });
      expect(fresh.meaning, '나의 목자');
      expect(fresh.nuance, '친밀한 언약 관계');

      final legacy = ScriptureOriginalWord.fromJson({
        'word': 'רֹעִי',
        'transliteration': "ro'i",
        'language': 'Hebrew',
        'meaning_en': 'my shepherd',
        'meaning_ko': '나의 목자',
        'nuance_en': 'intimate covenant',
        'nuance_ko': '친밀한 언약',
      });
      expect(legacy.meaning, 'my shepherd');
      expect(legacy.nuance, 'intimate covenant');
    });
  });
}
