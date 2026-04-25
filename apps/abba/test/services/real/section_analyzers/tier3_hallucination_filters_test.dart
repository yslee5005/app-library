import 'package:abba/models/prayer.dart';
import 'package:abba/services/real/section_analyzers/tier3_hallucination_filters.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wave B (B4) — sanitizer hardening regression tests.
///
/// Covers:
/// - Whitelist tightening: standalone "müller" / "muller" / "moravian" no
///   longer admit unrelated stories, but full forms still pass.
/// - BAD-1 historical date-stamp pattern: "in 1547 in Wittenberg" without
///   a strict whitelist anchor is dropped.
/// - New vague-reference patterns (Korean + English).
/// - New citation bad patterns.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    appLogger = Logger(
      config: LogConfig.development,
      outputs: const [NoopOutput()],
    );
  });

  HistoricalStory hs({
    required String title,
    required String summary,
    String reference = 'Bristol, 1838',
  }) => HistoricalStory(
    title: title,
    reference: reference,
    summary: summary,
    lesson: 'lesson',
    isPremium: true,
  );

  group('sanitizeHistoricalStory — whitelist tightening (B4)', () {
    test('passes when full name "george müller" appears', () {
      final s = hs(
        title: 'George Müller and the orphans',
        summary:
            'In Bristol, George Müller cared for thousands of orphans by faith.',
      );
      expect(sanitizeHistoricalStory(s), isNotNull);
    });

    test('passes when full name "george muller" (ASCII) appears', () {
      final s = hs(
        title: 'George Muller of Bristol',
        summary:
            'George Muller prayed daily, never asking for funds publicly.',
      );
      expect(sanitizeHistoricalStory(s), isNotNull);
    });

    test('drops when only standalone "muller" matches (no full name)', () {
      // Pre-B4 this admitted ANY story where "muller" appears as a substring
      // of an unrelated name (e.g. an actor or town). Now it must drop.
      final s = hs(
        title: 'A Story About Trust',
        summary:
            'Helmut Muller was a 20th-century actor who once visited a chapel.',
      );
      expect(sanitizeHistoricalStory(s), isNull);
    });

    test('drops when only standalone "müller" (umlaut) matches', () {
      final s = hs(
        title: 'An Anecdote',
        summary:
            'Heinrich Müller-Schmidt, a German engineer, attended a service in 1972.',
      );
      expect(sanitizeHistoricalStory(s), isNull);
    });

    test('passes when "moravian brethren" appears (anchored)', () {
      final s = hs(
        title: 'The Moravian Brethren and Herrnhut',
        summary:
            'The Moravian Brethren in Herrnhut maintained a 100-year prayer vigil.',
      );
      expect(sanitizeHistoricalStory(s), isNotNull);
    });

    test('passes when "moravian missions" appears (anchored)', () {
      final s = hs(
        title: 'Moravian Missions in the West Indies',
        summary:
            'Their Moravian missions sent the first Protestant missionaries abroad.',
      );
      expect(sanitizeHistoricalStory(s), isNotNull);
    });

    test('drops when only standalone "moravian" matches (no anchor)', () {
      // Pre-B4 this admitted any "Moravian" prefix — including hallucinated
      // anecdotes. B4: must drop.
      final s = hs(
        title: 'A Moravian Lesson',
        summary:
            'A Moravian villager once told her neighbour to plant a small seed.',
      );
      expect(sanitizeHistoricalStory(s), isNull);
    });
  });

  group('sanitizeHistoricalStory — BAD-1 historical date-stamp (B4)', () {
    test('drops "in 1547 in Wittenberg"-style stamp without strict anchor', () {
      // Whitelist substring ' luther' would have admitted this pre-B4 if a
      // weak match fired (e.g. "Lutheran" was originally guarded but a
      // crafted summary can sneak past). The date-stamp gate now drops it
      // because no STRICT anchor (full name) is present.
      final s = HistoricalStory(
        title: 'A Quiet Reformer',
        reference: 'Wittenberg, 1547',
        summary:
            'In 1547 in Wittenberg a young man named  luther-stadt resident '
            'walked the streets at dawn.',
        lesson: 'lesson',
        isPremium: true,
      );
      expect(sanitizeHistoricalStory(s), isNull);
    });

    test('passes "in 1547 in Wittenberg" when "Martin Luther" is anchored', () {
      final s = HistoricalStory(
        title: 'Martin Luther in Wittenberg',
        reference: 'Wittenberg, 1546',
        summary:
            'In 1546 in Wittenberg, Martin Luther wrote his final sermon, '
            'saying we are beggars before God.',
        lesson: 'lesson',
        isPremium: true,
      );
      expect(sanitizeHistoricalStory(s), isNotNull);
    });
  });

  group('sanitizeHistoricalStory — vague references (B4)', () {
    test('drops when reference contains "centuries ago"', () {
      final s = hs(
        title: 'George Müller story',
        reference: 'centuries ago',
        summary:
            'George Müller was known for his unwavering trust in God.',
      );
      expect(sanitizeHistoricalStory(s), isNull);
    });

    test('drops when reference is "during the reformation"', () {
      final s = hs(
        title: 'A Reformation Tale',
        reference: 'During the Reformation',
        summary: 'Martin Luther stood firm at Worms, refusing to recant.',
      );
      expect(sanitizeHistoricalStory(s), isNull);
    });

    test('drops Korean vague reference "옛날에"', () {
      final s = hs(
        title: '주기철 목사 이야기',
        reference: '옛날에',
        summary: '주기철 목사는 일제 시대에 신사참배를 거부했다.',
      );
      expect(sanitizeHistoricalStory(s), isNull);
    });

    test('drops Korean vague reference "수세기 전"', () {
      final s = hs(
        title: 'Augustine of Hippo',
        reference: '수세기 전',
        summary: 'Augustine wrote Confessions reflecting on his early life.',
      );
      expect(sanitizeHistoricalStory(s), isNull);
    });

    test('drops Korean vague reference "초대교회 시절"', () {
      final s = hs(
        title: 'Augustine',
        reference: '초대교회 시절',
        summary: 'Augustine was bishop of Hippo and a great theologian.',
      );
      expect(sanitizeHistoricalStory(s), isNull);
    });
  });

  AiPrayer ap(List<Citation> cits) => AiPrayer(
    text: 'Heavenly Father...',
    citations: cits,
    isPremium: true,
  );

  group('sanitizeAiPrayer — citation bad patterns (B4)', () {
    test('drops citation with "research suggests"', () {
      final p = ap([
        const Citation(
          type: 'science',
          source: 'Research suggests prayer reduces stress',
          content: 'A short factual statement.',
        ),
      ]);
      final out = sanitizeAiPrayer(p);
      expect(out.citations, isEmpty);
    });

    test('drops citation with "studies indicate"', () {
      final p = ap([
        const Citation(
          type: 'science',
          source: 'studies indicate increased wellbeing',
          content: 'content',
        ),
      ]);
      expect(sanitizeAiPrayer(p).citations, isEmpty);
    });

    test('drops citation with "experts say"', () {
      final p = ap([
        const Citation(
          type: 'science',
          source: 'experts say it helps',
          content: 'content',
        ),
      ]);
      expect(sanitizeAiPrayer(p).citations, isEmpty);
    });

    test('drops citation with "data shows"', () {
      final p = ap([
        const Citation(
          type: 'science',
          source: 'data shows clear correlation',
          content: 'content',
        ),
      ]);
      expect(sanitizeAiPrayer(p).citations, isEmpty);
    });

    test('drops Korean citation with "전문가들에 따르면"', () {
      final p = ap([
        const Citation(
          type: 'science',
          source: '전문가들에 따르면 기도는 도움이 된다',
          content: '본문',
        ),
      ]);
      expect(sanitizeAiPrayer(p).citations, isEmpty);
    });

    test('drops Korean citation with "한 연구에서"', () {
      final p = ap([
        const Citation(
          type: 'science',
          source: '한 연구에서 밝혀졌다',
          content: '본문',
        ),
      ]);
      expect(sanitizeAiPrayer(p).citations, isEmpty);
    });

    test('drops Korean citation with "전문가에 따르면"', () {
      final p = ap([
        const Citation(
          type: 'science',
          source: '전문가에 따르면',
          content: '본문',
        ),
      ]);
      expect(sanitizeAiPrayer(p).citations, isEmpty);
    });

    test('keeps a properly-attributed citation', () {
      final p = ap([
        const Citation(
          type: 'quote',
          source: 'Augustine, Confessions, Book X',
          content: 'You have made us for yourself, O Lord...',
        ),
      ]);
      final out = sanitizeAiPrayer(p);
      expect(out.citations, hasLength(1));
    });
  });
}
