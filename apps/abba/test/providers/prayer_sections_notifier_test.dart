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
            gratitude: ['a'], petition: [], intercession: []),
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

    test('startPrayerStream: T1 then T2 update state and persist in order',
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
            gratitude: ['g'], petition: [], intercession: []),
        scripture: const Scripture(reference: 'Psalm 23:1'),
      );
      controller.add(t1);
      final arrived = await t1Completer.future;
      expect(arrived.scripture.reference, 'Psalm 23:1');
      expect(notifier.state.isT1Complete, isTrue);

      controller.add(const TierT2Result(
        bibleStory: BibleStory(title: 'story', summary: 's'),
        testimony: 'testimony text',
      ));
      await controller.close();
      // Let microtasks drain.
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.isT2Complete, isTrue);
      expect(notifier.state.testimony, 'testimony text');
      expect(repo.calls.length, 2);
      expect(repo.calls[0].$1, 'p1');
      expect(repo.calls[0].$2, 't1');
      expect(repo.calls[1].$2, 't2');
    });

    test('startPrayerStream: TierFailed on t1 surfaces to t1Completer',
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

      controller.add(const TierFailed(
        tier: 't1',
        error: AiAnalysisException(
          'net',
          kind: AiAnalysisFailureKind.network,
        ),
      ));

      expect(
        t1Completer.future,
        throwsA(isA<AiAnalysisException>()),
      );
      await Future<void>.delayed(Duration.zero);
      expect(notifier.state.failedTiers['t1'], isNotNull);
      await controller.close();
    });

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

    test('QT tier events on the prayer stream are ignored gracefully',
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

      controller.add(const QtTierT1Result(
        meditationSummary: MeditationSummary(
          topic: 't',
          summary: 's',
          insight: 'i',
        ),
        scripture: Scripture(reference: 'r'),
      ));
      await Future<void>.delayed(Duration.zero);
      expect(notifier.state.summary, isNull);
      expect(repo.calls, isEmpty);
      expect(t1Completer.isCompleted, isFalse);
      await controller.close();
    });
  });
}
