import 'dart:async';

import 'package:app_lib_logging/logging.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/prayer.dart';
import '../models/prayer_tier_result.dart';
import '../services/ai_analysis_exception.dart';
import '../services/prayer_repository.dart';

/// Phase 4.1 — state container for a single prayer's tier results.
/// UI watches this to render Dashboard cards progressively as each tier
/// arrives via `aiService.analyzePrayerStreamed()`.
class PrayerSectionsState {
  /// T1 sections
  final PrayerSummary? summary;
  final Scripture? scripture;

  /// T2 sections
  final BibleStory? bibleStory;
  final String? testimony;

  /// T3 sections (Pro only)
  final Guidance? guidance;
  final AiPrayer? aiPrayer;
  final HistoricalStory? historicalStory;

  /// Per-tier failures (empty = all OK). Keys: 't1' | 't2' | 't3'.
  final Map<String, AiAnalysisException> failedTiers;

  /// The prayer DB row id, once savePendingPrayer returns. Used by
  /// tier UPDATE RPCs.
  final String? prayerId;

  /// T3 trigger flag (UI scroll dedup). Once true, don't re-fire.
  final bool t3Triggered;

  const PrayerSectionsState({
    this.summary,
    this.scripture,
    this.bibleStory,
    this.testimony,
    this.guidance,
    this.aiPrayer,
    this.historicalStory,
    this.failedTiers = const {},
    this.prayerId,
    this.t3Triggered = false,
  });

  bool get isT1Complete => summary != null && scripture != null;
  bool get isT2Complete => bibleStory != null && testimony != null;
  bool get isT3Complete =>
      guidance != null || aiPrayer != null || historicalStory != null;
  bool get hasAnyFailure => failedTiers.isNotEmpty;

  PrayerSectionsState copyWith({
    PrayerSummary? summary,
    Scripture? scripture,
    BibleStory? bibleStory,
    String? testimony,
    Guidance? guidance,
    AiPrayer? aiPrayer,
    HistoricalStory? historicalStory,
    Map<String, AiAnalysisException>? failedTiers,
    String? prayerId,
    bool? t3Triggered,
  }) {
    return PrayerSectionsState(
      summary: summary ?? this.summary,
      scripture: scripture ?? this.scripture,
      bibleStory: bibleStory ?? this.bibleStory,
      testimony: testimony ?? this.testimony,
      guidance: guidance ?? this.guidance,
      aiPrayer: aiPrayer ?? this.aiPrayer,
      historicalStory: historicalStory ?? this.historicalStory,
      failedTiers: failedTiers ?? this.failedTiers,
      prayerId: prayerId ?? this.prayerId,
      t3Triggered: t3Triggered ?? this.t3Triggered,
    );
  }
}

class PrayerSectionsNotifier extends StateNotifier<PrayerSectionsState> {
  PrayerSectionsNotifier() : super(const PrayerSectionsState());

  StreamSubscription<TierResult>? _sub;

  /// Phase 4.2 Wave B (B2) — pre-validation scripture reference holding area.
  /// SSE regex emits the candidate ref ~2-3s into generation, BEFORE
  /// `Tier1Analyzer._validateScripture` has confirmed it against the local
  /// Bible bundle. We must not leak an unvalidated (possibly hallucinated)
  /// reference into the user-visible state. Promotion to `state.scripture`
  /// happens only when the full TierT1Result arrives (validation done).
  String? _scriptureRefCandidate;

  /// @visibleForTesting — exposed for assertions on the candidate buffer
  /// without leaking it through public state.
  String? debugScriptureRefCandidate() => _scriptureRefCandidate;

  void reset() {
    _sub?.cancel();
    _sub = null;
    _scriptureRefCandidate = null;
    state = const PrayerSectionsState();
  }

  void setPrayerId(String id) {
    state = state.copyWith(prayerId: id);
  }

  void setT1({required PrayerSummary summary, required Scripture scripture}) {
    state = state.copyWith(summary: summary, scripture: scripture);
  }

  void setT2({required BibleStory bibleStory, required String testimony}) {
    state = state.copyWith(bibleStory: bibleStory, testimony: testimony);
  }

  void setT3({
    Guidance? guidance,
    AiPrayer? aiPrayer,
    HistoricalStory? historicalStory,
  }) {
    state = state.copyWith(
      guidance: guidance,
      aiPrayer: aiPrayer,
      historicalStory: historicalStory,
    );
  }

  /// Instant fill all tiers (used when reviewing past prayer from Calendar).
  /// Skips tier animations; UI sees completed state immediately.
  void setAllFromResult(PrayerResult result) {
    state = state.copyWith(
      summary: result.prayerSummary,
      scripture: result.scripture,
      bibleStory: result.bibleStory,
      testimony: result.testimony,
      guidance: result.guidance,
      aiPrayer: result.aiPrayer,
      historicalStory: result.historicalStory,
    );
  }

  void setTierFailed(String tier, AiAnalysisException error) {
    final next = Map<String, AiAnalysisException>.from(state.failedTiers);
    next[tier] = error;
    state = state.copyWith(failedTiers: next);
  }

  void markT3Triggered() {
    state = state.copyWith(t3Triggered: true);
  }

  /// Phase 4.2 Wave B (B2) — internal: stash the candidate reference WITHOUT
  /// promoting it to `state.scripture`. The candidate must remain hidden
  /// from the UI until `Tier1Analyzer._validateScripture` has confirmed it
  /// against the local Bible bundle (otherwise an unvalidated/hallucinated
  /// ref could briefly render in the Dashboard scripture card header).
  void _setCandidateRef(String reference) {
    if (state.scripture != null && state.scripture!.verse.isNotEmpty) return;
    _scriptureRefCandidate = reference;
  }

  /// Phase 4.1 INT-027 / 4.2 Phase C — subscribe to a tiered Gemini stream.
  ///
  /// Lives on the notifier (not the view) so subscription survives navigation
  /// from ai_loading_view → Dashboard. T2 arriving after navigation still
  /// updates state; the Dashboard, watching this provider, rebuilds.
  ///
  /// [t1Completer] resolves on the **earliest actionable** T1 signal —
  /// either [TierT1ScriptureRef] (Phase C fast path, ~2-3s after stream
  /// start) or the full [TierT1Result] (fallback when regex never matches).
  /// A placeholder [TierT1Result] is constructed for the fast path so
  /// existing callers do not need to change their blocking contract.
  void startPrayerStream({
    required Stream<TierResult> stream,
    required PrayerRepository repo,
    required String prayerId,
    required Completer<TierT1Result> t1Completer,
  }) {
    _sub?.cancel();
    setPrayerId(prayerId);
    _sub = stream.listen(
      (tier) async {
        switch (tier) {
          case TierT1ScriptureRef ref:
            // B2 — keep the candidate ref OFF user-visible state until the
            // full T1 result (validated scripture) arrives. The completer
            // still resolves so navigation can unblock.
            _setCandidateRef(ref.reference);
            if (!t1Completer.isCompleted) {
              t1Completer.complete(
                TierT1Result(
                  summary: const PrayerSummary(
                    gratitude: [],
                    petition: [],
                    intercession: [],
                  ),
                  scripture: Scripture(reference: ref.reference),
                ),
              );
            }
          case TierT1Result t1:
            // B2 — promote validated scripture to user-visible state and
            // clear the candidate (ref already inside t1.scripture).
            _scriptureRefCandidate = null;
            setT1(summary: t1.summary, scripture: t1.scripture);
            if (!t1Completer.isCompleted) t1Completer.complete(t1);
            await _persistTier(repo, prayerId, 't1', {
              'prayer_summary': _summaryToJson(t1.summary),
              'scripture': _scriptureToJson(t1.scripture),
            });
          case TierT2Result t2:
            setT2(bibleStory: t2.bibleStory, testimony: t2.testimony);
            await _persistTier(repo, prayerId, 't2', {
              'bible_story': {
                'title': t2.bibleStory.title,
                'summary': t2.bibleStory.summary,
              },
              'testimony': t2.testimony,
            });
          case TierT3Result t3:
            setT3(
              guidance: t3.guidance,
              aiPrayer: t3.aiPrayer,
              historicalStory: t3.historicalStory,
            );
            await _persistTier(repo, prayerId, 't3', {
              if (t3.guidance != null)
                'guidance': {
                  'content': t3.guidance!.content,
                  'is_premium': t3.guidance!.isPremium,
                },
              if (t3.aiPrayer != null)
                'ai_prayer': {
                  'text': t3.aiPrayer!.text,
                  'citations': t3.aiPrayer!.citations
                      .map(
                        (c) => {
                          'type': c.type,
                          'source': c.source,
                          'content': c.content,
                        },
                      )
                      .toList(),
                  'is_premium': t3.aiPrayer!.isPremium,
                },
              if (t3.historicalStory != null)
                'historical_story': {
                  'title': t3.historicalStory!.title,
                  'reference': t3.historicalStory!.reference,
                  'summary': t3.historicalStory!.summary,
                  'lesson': t3.historicalStory!.lesson,
                  'is_premium': t3.historicalStory!.isPremium,
                },
            });
          case TierFailed f:
            setTierFailed(f.tier, f.error);
            if (f.tier == 't1' && !t1Completer.isCompleted) {
              t1Completer.completeError(f.error);
            }
          case QtTierT1ScriptureRef _:
          case QtTierT1Result _:
          case QtTierT2Result _:
            // QT tier events not used on prayer stream; ignore.
            break;
        }
      },
      onError: (Object e, StackTrace st) {
        prayerLog.error('Prayer stream error', error: e, stackTrace: st);
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
      // Non-fatal: client state is already updated; DB persistence can be
      // retried by the Edge Function on next visit (§architecture.md).
      prayerLog.error(
        'updateTierResult failed tier=$tier',
        error: e,
        stackTrace: st,
      );
    }
  }

  Map<String, dynamic> _summaryToJson(PrayerSummary s) => {
    'gratitude': s.gratitude,
    'petition': s.petition,
    'intercession': s.intercession,
  };

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

/// Phase 4.1 — PrayerSectionsNotifier provider.
///
/// NOT autoDispose: ai_loading_view starts the stream, then navigates to
/// Dashboard. Without navigation the notifier would be disposed mid-flight
/// and T2/T3 events would be dropped. Callers must invoke [reset] before
/// starting a new prayer to clear stale state.
final prayerSectionsProvider =
    StateNotifierProvider<PrayerSectionsNotifier, PrayerSectionsState>(
      (ref) => PrayerSectionsNotifier(),
    );
