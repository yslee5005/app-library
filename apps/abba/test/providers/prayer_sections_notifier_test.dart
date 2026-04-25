import 'dart:async';

import 'package:abba/models/prayer.dart';
import 'package:abba/models/prayer_tier_result.dart';
import 'package:abba/providers/prayer_sections_notifier.dart';
import 'package:abba/services/ai_analysis_exception.dart';
import 'package:abba/services/prayer_repository.dart';
import 'package:abba/models/qt_meditation_result.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test double — records each updateTierResult call so the assertions can
/// verify both tier keys and section payloads.
class _RecordingRepo implements PrayerRepository {
  final List<(String, String, Map<String, dynamic>)> calls = [];

  @override
  Future<void> updateTierResult({
    required String prayerId,
    required String tier,
    required Map<String, dynamic> sectionData,
  }) async {
    calls.add((prayerId, tier, sectionData));
  }

  // Unused members for these tests — throw to surface accidental calls.
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  group('PrayerSectionsNotifier', () {
    late PrayerSectionsNotifier notifier;

    setUp(() {
      notifier = PrayerSectionsNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test('initial state has no sections', () {
      expect(notifier.state.summary, isNull);
      expect(notifier.state.scripture, isNull);
      expect(notifier.state.bibleStory, isNull);
      expect(notifier.state.testimony, isNull);
      expect(notifier.state.isT1Complete, isFalse);
      expect(notifier.state.isT2Complete, isFalse);
      expect(notifier.state.t3Triggered, isFalse);
    });

    test('setT1 marks summary+scripture, isT1Complete becomes true', () {
      notifier.setT1(
        summary: const PrayerSummary(
          gratitude: ['thanks'],
          petition: [],
          intercession: [],
        ),
        scripture: const Scripture(reference: 'Psalm 23:1'),
      );
      expect(notifier.state.isT1Complete, isTrue);
      expect(notifier.state.isT2Complete, isFalse);
    });

    test('reset clears all sections and the subscription', () {
      notifier.setT1(
        summary: const PrayerSummary(
          gratitude: ['a'],
          petition: [],
          intercession: [],
        ),
        scripture: const Scripture(reference: 'Psalm 23:1'),
      );
      notifier.markT3Triggered();
      notifier.reset();
      expect(notifier.state.summary, isNull);
      expect(notifier.state.t3Triggered, isFalse);
    });

    test('setTierFailed accumulates per-tier exceptions', () {
      notifier.setTierFailed(
        't2',
        const AiAnalysisException('boom', kind: AiAnalysisFailureKind.network),
      );
      expect(notifier.state.hasAnyFailure, isTrue);
      expect(notifier.state.failedTiers.keys, contains('t2'));
    });

    test(
      'startPrayerStream: T1 then T2 update state and persist in order',
      () async {
        final repo = _RecordingRepo();
        final controller = StreamController<TierResult>();
        final t1Completer = Completer<TierT1Result>();

        notifier.startPrayerStream(
          stream: controller.stream,
          repo: repo,
          prayerId: 'p1',
          t1Completer: t1Completer,
        );

        final t1 = TierT1Result(
          summary: const PrayerSummary(
            gratitude: ['g'],
            petition: [],
            intercession: [],
          ),
          scripture: const Scripture(reference: 'Psalm 23:1'),
        );
        controller.add(t1);
        final arrived = await t1Completer.future;
        expect(arrived.scripture.reference, 'Psalm 23:1');
        expect(notifier.state.isT1Complete, isTrue);

        controller.add(
          const TierT2Result(
            bibleStory: BibleStory(title: 'story', summary: 's'),
            testimony: 'testimony text',
          ),
        );
        await controller.close();
        // Let microtasks drain.
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state.isT2Complete, isTrue);
        expect(notifier.state.testimony, 'testimony text');
        expect(repo.calls.length, 2);
        expect(repo.calls[0].$1, 'p1');
        expect(repo.calls[0].$2, 't1');
        expect(repo.calls[1].$2, 't2');
      },
    );

    test(
      'startPrayerStream: TierFailed on t1 surfaces to t1Completer',
      () async {
        final repo = _RecordingRepo();
        final controller = StreamController<TierResult>();
        final t1Completer = Completer<TierT1Result>();

        notifier.startPrayerStream(
          stream: controller.stream,
          repo: repo,
          prayerId: 'p1',
          t1Completer: t1Completer,
        );

        controller.add(
          const TierFailed(
            tier: 't1',
            error: AiAnalysisException(
              'net',
              kind: AiAnalysisFailureKind.network,
            ),
          ),
        );

        expect(t1Completer.future, throwsA(isA<AiAnalysisException>()));
        await Future<void>.delayed(Duration.zero);
        expect(notifier.state.failedTiers['t1'], isNotNull);
        await controller.close();
      },
    );

    test('setAllFromResult fills every section at once', () {
      final result = PrayerResult(
        scripture: const Scripture(reference: 'John 3:16'),
        bibleStory: const BibleStory(title: 't', summary: 's'),
        testimony: 'x',
        prayerSummary: const PrayerSummary(
          gratitude: ['g'],
          petition: [],
          intercession: [],
        ),
      );
      notifier.setAllFromResult(result);
      expect(notifier.state.isT1Complete, isTrue);
      expect(notifier.state.isT2Complete, isTrue);
    });

    test(
      'QT tier events on the prayer stream are ignored gracefully',
      () async {
        final repo = _RecordingRepo();
        final controller = StreamController<TierResult>();
        final t1Completer = Completer<TierT1Result>();

        notifier.startPrayerStream(
          stream: controller.stream,
          repo: repo,
          prayerId: 'p1',
          t1Completer: t1Completer,
        );

        controller.add(
          const QtTierT1Result(
            meditationSummary: MeditationSummary(
              topic: 't',
              summary: 's',
              insight: 'i',
            ),
            scripture: Scripture(reference: 'r'),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(notifier.state.summary, isNull);
        expect(repo.calls, isEmpty);
        expect(t1Completer.isCompleted, isFalse);
        await controller.close();
      },
    );

    test('startPrayerStream: TierT1ScriptureRef resolves completer with '
        'placeholder summary BUT does NOT leak unvalidated reference into '
        'user-visible state (Wave B B2)', () async {
      final repo = _RecordingRepo();
      final controller = StreamController<TierResult>();
      final t1Completer = Completer<TierT1Result>();

      notifier.startPrayerStream(
        stream: controller.stream,
        repo: repo,
        prayerId: 'p1',
        t1Completer: t1Completer,
      );

      controller.add(const TierT1ScriptureRef('Matthew 6:33'));
      final arrived = await t1Completer.future;
      // Placeholder summary (empty lists) — full summary lands on
      // the subsequent TierT1Result.
      expect(arrived.summary.gratitude, isEmpty);
      expect(arrived.scripture.reference, 'Matthew 6:33');
      // B2 — candidate ref is held internally; UI state must NOT see it
      // until validation completes.
      expect(notifier.state.scripture, isNull);
      expect(notifier.debugScriptureRefCandidate(), 'Matthew 6:33');
      // ScriptureRef is a pre-persist signal; no RPC call yet.
      expect(repo.calls, isEmpty);
      await controller.close();
    });

    test('startPrayerStream: candidate ref is cleared and replaced with '
        'validated scripture when TierT1Result arrives (Wave B B2)', () async {
      final repo = _RecordingRepo();
      final controller = StreamController<TierResult>();
      final t1Completer = Completer<TierT1Result>();

      notifier.startPrayerStream(
        stream: controller.stream,
        repo: repo,
        prayerId: 'p2',
        t1Completer: t1Completer,
      );

      controller.add(const TierT1ScriptureRef('Romans 8:28'));
      await t1Completer.future;
      expect(notifier.debugScriptureRefCandidate(), 'Romans 8:28');
      expect(notifier.state.scripture, isNull);

      controller.add(
        TierT1Result(
          summary: const PrayerSummary(
            gratitude: ['g'],
            petition: [],
            intercession: [],
          ),
          // Note: validated scripture also includes verse text.
          scripture: const Scripture(
            reference: 'Romans 8:28',
            verse: 'And we know that all things work together for good...',
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      // Promotion: candidate cleared, state.scripture has validated verse.
      expect(notifier.debugScriptureRefCandidate(), isNull);
      expect(notifier.state.scripture?.reference, 'Romans 8:28');
      expect(notifier.state.scripture?.verse, isNotEmpty);
      await controller.close();
    });

    test(
      'startPrayerStream: T1 payload shape includes all scripture fields',
      () async {
        final repo = _RecordingRepo();
        final controller = StreamController<TierResult>();
        final t1Completer = Completer<TierT1Result>();

        notifier.startPrayerStream(
          stream: controller.stream,
          repo: repo,
          prayerId: 'p-shape',
          t1Completer: t1Completer,
        );

        controller.add(
          TierT1Result(
            summary: const PrayerSummary(
              gratitude: ['g1', 'g2'],
              petition: ['p1'],
              intercession: [],
            ),
            scripture: const Scripture(
              reference: 'Psalm 23:1',
              verse: 'The LORD is my shepherd...',
              reason: 'comfort',
              posture: 'read slowly',
              keyWordHint: 'shepherd = ro\'i',
              originalWords: [
                ScriptureOriginalWord(
                  word: 'רֹעִי',
                  transliteration: 'ro\'i',
                  language: 'Hebrew',
                  meaning: 'my shepherd',
                ),
              ],
            ),
          ),
        );
        await t1Completer.future;
        await Future<void>.delayed(Duration.zero);

        expect(repo.calls.length, 1);
        final (pid, tier, payload) = repo.calls.first;
        expect(pid, 'p-shape');
        expect(tier, 't1');
        expect(payload['prayer_summary'], {
          'gratitude': ['g1', 'g2'],
          'petition': ['p1'],
          'intercession': <String>[],
        });
        final sc = payload['scripture'] as Map;
        expect(sc['reference'], 'Psalm 23:1');
        expect(sc['verse'], 'The LORD is my shepherd...');
        expect(sc['key_word_hint'], 'shepherd = ro\'i');
        final words = sc['original_words'] as List;
        expect(words, hasLength(1));
        expect((words.first as Map)['transliteration'], 'ro\'i');
        await controller.close();
      },
    );

    test('startPrayerStream: T3 payload omits null sections', () async {
      final repo = _RecordingRepo();
      final controller = StreamController<TierResult>();
      final t1Completer = Completer<TierT1Result>();

      notifier.startPrayerStream(
        stream: controller.stream,
        repo: repo,
        prayerId: 'p-t3',
        t1Completer: t1Completer,
      );

      // Fast-forward past T1 so we can get to T3 assertion.
      controller.add(
        TierT1Result(
          summary: const PrayerSummary(
            gratitude: [],
            petition: [],
            intercession: [],
          ),
          scripture: const Scripture(reference: 'John 3:16'),
        ),
      );
      await t1Completer.future;

      // Partial T3 — only guidance, others null.
      controller.add(
        const TierT3Result(
          guidance: Guidance(content: 'take a small step', isPremium: true),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final t3Call = repo.calls.firstWhere((c) => c.$2 == 't3');
      final payload = t3Call.$3;
      expect(payload.containsKey('guidance'), isTrue);
      expect(payload.containsKey('ai_prayer'), isFalse);
      expect(payload.containsKey('historical_story'), isFalse);
      await controller.close();
    });
  });
}
