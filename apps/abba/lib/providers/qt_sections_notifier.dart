import 'dart:async';

import 'package:app_lib_logging/logging.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/prayer.dart' show Scripture;
import '../models/prayer_tier_result.dart';
import '../models/qt_meditation_result.dart';
import '../services/ai_analysis_exception.dart';
import '../services/prayer_repository.dart';

/// Phase 4.2 — state container for a single QT meditation's tier results.
/// Mirrors [PrayerSectionsState] for the Prayer flow. Dashboard watches
/// this provider to render QT cards progressively as each tier arrives.
class QtSectionsState {
  /// T1 sections
  final MeditationSummary? meditationSummary;
  final Scripture? scripture;

  /// T2 sections
  final ApplicationSuggestion? application;
  final RelatedKnowledge? knowledge;

  /// Per-tier failures (keys: 't1' | 't2').
  final Map<String, AiAnalysisException> failedTiers;

  /// DB row id once savePendingPrayer returns.
  final String? prayerId;

  const QtSectionsState({
    this.meditationSummary,
    this.scripture,
    this.application,
    this.knowledge,
    this.failedTiers = const {},
    this.prayerId,
  });

  bool get isT1Complete => meditationSummary != null && scripture != null;
  bool get isT2Complete => application != null && knowledge != null;
  bool get hasAnyFailure => failedTiers.isNotEmpty;

  QtSectionsState copyWith({
    MeditationSummary? meditationSummary,
    Scripture? scripture,
    ApplicationSuggestion? application,
    RelatedKnowledge? knowledge,
    Map<String, AiAnalysisException>? failedTiers,
    String? prayerId,
  }) {
    return QtSectionsState(
      meditationSummary: meditationSummary ?? this.meditationSummary,
      scripture: scripture ?? this.scripture,
      application: application ?? this.application,
      knowledge: knowledge ?? this.knowledge,
      failedTiers: failedTiers ?? this.failedTiers,
      prayerId: prayerId ?? this.prayerId,
    );
  }
}

class QtSectionsNotifier extends StateNotifier<QtSectionsState> {
  QtSectionsNotifier() : super(const QtSectionsState());

  StreamSubscription<TierResult>? _sub;

  void reset() {
    _sub?.cancel();
    _sub = null;
    state = const QtSectionsState();
  }

  void setPrayerId(String id) {
    state = state.copyWith(prayerId: id);
  }

  void setT1({
    required MeditationSummary meditationSummary,
    required Scripture scripture,
  }) {
    state = state.copyWith(
      meditationSummary: meditationSummary,
      scripture: scripture,
    );
  }

  void setT2({
    required ApplicationSuggestion application,
    required RelatedKnowledge knowledge,
  }) {
    state = state.copyWith(application: application, knowledge: knowledge);
  }

  /// Fill every tier at once from a stored [QtMeditationResult] (used when
  /// revisiting a past QT from Calendar / My Page).
  void setAllFromResult(QtMeditationResult result) {
    state = state.copyWith(
      meditationSummary: result.meditationSummary,
      scripture: result.scripture,
      application: result.application,
      knowledge: result.knowledge,
    );
  }

  void setTierFailed(String tier, AiAnalysisException error) {
    final next = Map<String, AiAnalysisException>.from(state.failedTiers);
    next[tier] = error;
    state = state.copyWith(failedTiers: next);
  }

  /// Phase 4.2 — subscribe to a QT tiered Gemini stream. Same shape as
  /// [PrayerSectionsNotifier.startPrayerStream]: the notifier owns the
  /// subscription so it survives navigation from ai_loading_view to
  /// Dashboard. [t1Completer] resolves on the first T1 event so the caller
  /// can block navigation until T1 is decided.
  void startMeditationStream({
    required Stream<TierResult> stream,
    required PrayerRepository repo,
    required String prayerId,
    required Completer<QtTierT1Result> t1Completer,
  }) {
    _sub?.cancel();
    setPrayerId(prayerId);
    _sub = stream.listen(
      (tier) async {
        switch (tier) {
          case QtTierT1Result t1:
            setT1(
              meditationSummary: t1.meditationSummary,
              scripture: t1.scripture,
            );
            if (!t1Completer.isCompleted) t1Completer.complete(t1);
            await _persistTier(repo, prayerId, 't1', {
              'meditation_summary': t1.meditationSummary.toJson(),
              'scripture': _scriptureToJson(t1.scripture),
            });
          case QtTierT2Result t2:
            setT2(application: t2.application, knowledge: t2.knowledge);
            await _persistTier(repo, prayerId, 't2', {
              'application': t2.application.toJson(),
              'knowledge': t2.knowledge.toJson(),
            });
          case TierFailed f:
            setTierFailed(f.tier, f.error);
            if (f.tier == 't1' && !t1Completer.isCompleted) {
              t1Completer.completeError(f.error);
            }
          case TierT1Result _:
          case TierT2Result _:
          case TierT3Result _:
            // Prayer tier events never belong on the QT stream; ignore.
            break;
        }
      },
      onError: (Object e, StackTrace st) {
        qtLog.error('QT stream error', error: e, stackTrace: st);
        if (!t1Completer.isCompleted) {
          t1Completer.completeError(
            AiAnalysisException(
              'Stream error',
              kind: AiAnalysisFailureKind.apiError,
              cause: e,
              causeStackTrace: st,
            ),
          );
        }
      },
      cancelOnError: false,
    );
  }

  Future<void> _persistTier(
    PrayerRepository repo,
    String prayerId,
    String tier,
    Map<String, dynamic> sectionData,
  ) async {
    try {
      await repo.updateTierResult(
        prayerId: prayerId,
        tier: tier,
        sectionData: sectionData,
      );
    } catch (e, st) {
      qtLog.error(
        'updateTierResult failed tier=$tier',
        error: e,
        stackTrace: st,
      );
    }
  }

  Map<String, dynamic> _scriptureToJson(Scripture s) => {
        'reference': s.reference,
        'verse': s.verse,
        'reason': s.reason,
        'posture': s.posture,
        'key_word_hint': s.keyWordHint,
        'original_words': s.originalWords.map((w) => w.toJson()).toList(),
      };

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// Phase 4.2 — QtSectionsNotifier provider. Non-autoDispose (mirrors
/// Prayer) so the stream subscription survives navigation. Callers must
/// call [reset] before starting a new meditation to clear stale state.
final qtSectionsProvider =
    StateNotifierProvider<QtSectionsNotifier, QtSectionsState>(
  (ref) => QtSectionsNotifier(),
);
