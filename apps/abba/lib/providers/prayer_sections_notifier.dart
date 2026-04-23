import 'package:flutter_riverpod/legacy.dart';

import '../models/prayer.dart';
import '../services/ai_analysis_exception.dart';

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
  bool get isT3Complete => guidance != null || aiPrayer != null || historicalStory != null;
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

  void reset() => state = const PrayerSectionsState();

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
}

/// Phase 4.1 — PrayerSectionsNotifier provider. AutoDispose so each
/// new prayer gets a fresh state.
final prayerSectionsProvider =
    StateNotifierProvider.autoDispose<PrayerSectionsNotifier, PrayerSectionsState>(
  (ref) => PrayerSectionsNotifier(),
);
