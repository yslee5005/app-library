import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../models/prayer_tier_result.dart';
import '../../../models/qt_meditation_result.dart';
import '../../../providers/prayer_sections_notifier.dart';
import '../../../providers/providers.dart';
import '../../../providers/qt_sections_notifier.dart';
import 'package:app_lib_logging/logging.dart';

import '../../../services/ai_analysis_exception.dart';
import '../../../services/network_checker.dart';
import '../../../theme/abba_theme.dart';

class AiLoadingView extends ConsumerStatefulWidget {
  const AiLoadingView({super.key});

  @override
  ConsumerState<AiLoadingView> createState() => _AiLoadingViewState();
}

class _AiLoadingViewState extends ConsumerState<AiLoadingView>
    with SingleTickerProviderStateMixin {
  int _stage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Timer? _stageTimer;
  bool _aiDone = false;
  bool _minTimePassed = false;
  bool _navigated = false;

  // Phase 3 Pending/Retry (2026-04-23)
  // Client-session counter — resets on app restart so the user always has a
  // fresh 3-try budget when returning to a stuck prayer.
  int _retryCount = 0;
  static const _maxRetries = 3;

  // DB row id returned by savePendingPrayer. Shared across retries so we
  // UPDATE the existing pending row instead of creating duplicates.
  String? _pendingPrayerId;

  // Cached audio storage path across retries (uploaded only once).
  String? _savedAudioStoragePath;

  // Non-null when the current attempt failed. Build() shows an error view
  // instead of the loading animation.
  AiAnalysisException? _error;

  static const _icons = ['🌱', '🌿', '🌸'];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _stageTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (_stage < 2) {
        setState(() => _stage++);
        if (_stage == 1) _fadeController.forward();
      } else {
        timer.cancel();
      }
    });

    // Minimum 3 seconds display
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      _minTimePassed = true;
      _navigateIfReady();
    });

    prayerLog.info('AI loading started');

    // Phase 4.1 INT-027 / 4.2 R-A5 — reset section state for this
    // prayer / meditation so stale sections from a prior run never flash.
    ref.read(prayerSectionsProvider.notifier).reset();
    ref.read(qtSectionsProvider.notifier).reset();

    // Call AI service based on mode
    final mode = ref.read(currentPrayerModeProvider);
    if (mode == 'qt') {
      _analyzeQtMeditation();
    } else {
      _analyzeWithAi();
    }
  }

  Future<void> _analyzeWithAi() async {
    final transcript = ref.read(currentTranscriptProvider);
    final audioPath = ref.read(currentAudioPathProvider);
    final locale = ref.read(localeProvider);
    final aiService = ref.read(aiServiceProvider);
    final isVoiceMode = audioPath != null && audioPath.isNotEmpty;
    final userId = ref.read(currentUserProvider)?.id ?? 'anonymous';
    final repo = ref.read(prayerRepositoryProvider);

    // ────────────────────────────────────────────────────────────────────
    // Step 1 (first attempt only) — persist raw prayer BEFORE AI.
    // Voice mode: upload audio to Storage first, then INSERT pending row.
    // On retry (_pendingPrayerId != null), skip this block — row already
    // exists.
    // ────────────────────────────────────────────────────────────────────
    if (_pendingPrayerId == null) {
      try {
        if (isVoiceMode) {
          final storageService = ref.read(audioStorageServiceProvider);
          final audioRecordId = _generateId();
          final uploaded = await storageService
              .uploadAudio(
                localPath: audioPath,
                userId: userId,
                recordId: audioRecordId,
              )
              .catchError((_) => '');
          _savedAudioStoragePath = uploaded.isEmpty ? null : uploaded;
        }

        _pendingPrayerId = await repo.savePendingPrayer(
          Prayer(
            id: _generateId(),
            userId: userId,
            transcript: isVoiceMode ? '' : transcript,
            mode: 'prayer',
            audioPath: isVoiceMode ? audioPath : null,
            audioStoragePath: _savedAudioStoragePath,
            createdAt: DateTime.now(),
            aiStatus: PrayerAiStatus.pending,
          ),
        );
        prayerLog.info('Pending prayer saved id=$_pendingPrayerId voice=$isVoiceMode');
      } catch (e, st) {
        prayerLog.error('savePendingPrayer failed', error: e, stackTrace: st);
        _setErrorState(AiAnalysisException(
          'Failed to save prayer',
          kind: AiAnalysisFailureKind.network,
          cause: e,
          causeStackTrace: st,
        ));
        return;
      }
    }

    // ────────────────────────────────────────────────────────────────────
    // Step 2 — network precondition.
    // ────────────────────────────────────────────────────────────────────
    final hasNetwork = await ref.read(networkCheckerProvider).hasConnection();
    if (!hasNetwork) {
      _setErrorState(const AiAnalysisException(
        'No network connection',
        kind: AiAnalysisFailureKind.network,
      ));
      return;
    }

    // ────────────────────────────────────────────────────────────────────
    // Step 3 — Gemini analysis. Text mode streams tiers (T1 → navigate,
    // T2 fills in on Dashboard). Voice mode still goes through the single
    // multimodal call (transcribe + analyze) and then fans out to both
    // providers so the Dashboard progressive renderer sees the result.
    // ────────────────────────────────────────────────────────────────────
    if (isVoiceMode) {
      await _runAudioAnalysis(
        aiService: aiService,
        audioPath: audioPath,
        locale: locale,
        repo: repo,
      );
    } else {
      await _runTextStreamAnalysis(
        aiService: aiService,
        transcript: transcript,
        locale: locale,
        repo: repo,
      );
    }
  }

  /// Phase 4.1 INT-027 — text-mode streaming path. Hands the Gemini stream
  /// to [PrayerSectionsNotifier] which persists each tier via the
  /// `update_prayer_tier` RPC. The view awaits only T1; T2 continues to
  /// flow in the background after navigation.
  Future<void> _runTextStreamAnalysis({
    required dynamic aiService,
    required String transcript,
    required String locale,
    required dynamic repo,
  }) async {
    final userName = ref.read(userProfileProvider).value?.name ?? '';
    final t1Completer = Completer<TierT1Result>();
    final sectionsNotifier = ref.read(prayerSectionsProvider.notifier);

    try {
      final stream = aiService.analyzePrayerStreamed(
        transcript: transcript,
        locale: locale,
        userName: userName,
      ) as Stream<TierResult>;

      sectionsNotifier.startPrayerStream(
        stream: stream,
        repo: repo,
        prayerId: _pendingPrayerId!,
        t1Completer: t1Completer,
      );

      final t1 = await t1Completer.future;
      if (!mounted) return;

      // Mirror T1 into the legacy [prayerResultProvider] so the current
      // Dashboard (still reading from it until INT-028) renders with
      // placeholders for T2+ fields. Empty BibleStory + testimony are safe:
      // Dashboard already guards "result.prayerSummary != null" etc.
      final partial = PrayerResult(
        scripture: t1.scripture,
        bibleStory: const BibleStory(title: '', summary: ''),
        testimony: '',
        prayerSummary: t1.summary,
      );
      ref.read(prayerResultProvider.notifier).state = AsyncValue.data(partial);

      prayerLog.info(
        '[Prayer-Stream] T1 ready ref="${t1.scripture.reference}" — navigating',
      );

      // Flip DB row to completed so Calendar/History pick it up. The T2
      // UPDATE from the notifier stays a JSONB merge and does not clobber
      // this completion marker.
      await repo.completePrayer(
        prayerId: _pendingPrayerId!,
        transcript: transcript,
        result: partial,
      );

      ref.invalidate(streakProvider);
      ref.invalidate(userProfileProvider);
      ref.invalidate(prayerHeatmapProvider('prayer'));
      ref.invalidate(prayerHeatmapProvider('qt'));
      ref.invalidate(streakByModeProvider('prayer'));
      ref.invalidate(streakByModeProvider('qt'));

      await _checkStreakCelebration();

      _aiDone = true;
      _navigateIfReady();
    } on AiAnalysisException catch (e) {
      prayerLog.error(
        'Prayer stream T1 failed (${e.kind})',
        error: e.cause,
        stackTrace: e.causeStackTrace,
      );
      _setErrorState(e);
    } catch (e, stackTrace) {
      prayerLog.error('Unexpected prayer stream error',
          error: e, stackTrace: stackTrace);
      _setErrorState(AiAnalysisException(
        'Unexpected error during analysis',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: stackTrace,
      ));
    }
  }

  /// Legacy audio path. Multimodal Gemini returns a full [PrayerResult]
  /// in one call, so we do not stream — but we still mirror the result
  /// into [prayerSectionsProvider] so the Dashboard renders with the same
  /// progressive widget tree the text path populates.
  Future<void> _runAudioAnalysis({
    required dynamic aiService,
    required String audioPath,
    required String locale,
    required dynamic repo,
  }) async {
    try {
      final audioResult = await aiService.analyzePrayerFromAudio(
        audioFilePath: audioPath,
        locale: locale,
      );
      PrayerResult result = audioResult.result;
      final savedTranscript = audioResult.transcription;
      prayerLog.info(
        'Voice prayer analyzed, transcript=${savedTranscript.length}',
      );

      result = await _enrichScriptureVerse(result, locale);

      await repo.completePrayer(
        prayerId: _pendingPrayerId!,
        transcript: savedTranscript,
        result: result,
      );

      ref.read(prayerResultProvider.notifier).state = AsyncValue.data(result);
      ref.read(prayerSectionsProvider.notifier).setAllFromResult(result);

      ref.invalidate(streakProvider);
      ref.invalidate(userProfileProvider);
      ref.invalidate(prayerHeatmapProvider('prayer'));
      ref.invalidate(prayerHeatmapProvider('qt'));
      ref.invalidate(streakByModeProvider('prayer'));
      ref.invalidate(streakByModeProvider('qt'));

      await _checkStreakCelebration();

      prayerLog.info('Prayer (audio) completed + saved');
      _aiDone = true;
      _navigateIfReady();
    } on AiAnalysisException catch (e) {
      prayerLog.error(
        'AI analysis failed (${e.kind})',
        error: e.cause,
        stackTrace: e.causeStackTrace,
      );
      _setErrorState(e);
    } catch (e, stackTrace) {
      prayerLog.error('Unexpected AI error', error: e, stackTrace: stackTrace);
      _setErrorState(AiAnalysisException(
        'Unexpected error during analysis',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: stackTrace,
      ));
    }
  }

  Future<void> _analyzeQtMeditation() async {
    final meditationText = ref.read(currentTranscriptProvider);
    final passageRef = ref.read(currentPassageRefProvider);
    final passageText = ref.read(currentPassageTextProvider);
    final locale = ref.read(localeProvider);
    final aiService = ref.read(aiServiceProvider);
    final userId = ref.read(currentUserProvider)?.id ?? 'anonymous';
    final repo = ref.read(prayerRepositoryProvider);

    // Step 1 — persist raw meditation BEFORE AI (first attempt only).
    if (_pendingPrayerId == null) {
      try {
        _pendingPrayerId = await repo.savePendingPrayer(
          Prayer(
            id: _generateId(),
            userId: userId,
            transcript: meditationText,
            mode: 'qt',
            qtPassageRef: passageRef,
            createdAt: DateTime.now(),
            aiStatus: PrayerAiStatus.pending,
          ),
        );
        qtLog.info('Pending QT saved id=$_pendingPrayerId');
      } catch (e, st) {
        qtLog.error('savePendingPrayer (QT) failed', error: e, stackTrace: st);
        _setErrorState(AiAnalysisException(
          'Failed to save meditation',
          kind: AiAnalysisFailureKind.network,
          cause: e,
          causeStackTrace: st,
        ));
        return;
      }
    }

    // Step 2 — network precondition.
    final hasNetwork = await ref.read(networkCheckerProvider).hasConnection();
    if (!hasNetwork) {
      _setErrorState(const AiAnalysisException(
        'No network connection',
        kind: AiAnalysisFailureKind.network,
      ));
      return;
    }

    // Step 3 — Gemini analysis via streamed QT tiers. Mirrors
    // _runTextStreamAnalysis for Prayer.
    await _runQtStreamAnalysis(
      aiService: aiService,
      meditation: meditationText,
      passageRef: passageRef,
      passageText: passageText,
      locale: locale,
      repo: repo,
    );
  }

  /// Phase 4.2 R-A5 — QT streaming path. Hands the QT Gemini stream to
  /// [QtSectionsNotifier] which persists each tier via `update_prayer_tier`
  /// RPC. View awaits only T1; T2 continues in background after navigation.
  Future<void> _runQtStreamAnalysis({
    required dynamic aiService,
    required String meditation,
    required String passageRef,
    required String passageText,
    required String locale,
    required dynamic repo,
  }) async {
    final userName = ref.read(userProfileProvider).value?.name ?? '';
    final t1Completer = Completer<QtTierT1Result>();
    final sectionsNotifier = ref.read(qtSectionsProvider.notifier);

    try {
      final stream = aiService.analyzeMeditationStreamed(
        meditation: meditation,
        passageRef: passageRef,
        passageText: passageText,
        locale: locale,
        userName: userName,
      ) as Stream<TierResult>;

      sectionsNotifier.startMeditationStream(
        stream: stream,
        repo: repo,
        prayerId: _pendingPrayerId!,
        t1Completer: t1Completer,
      );

      final t1 = await t1Completer.future;
      if (!mounted) return;

      qtLog.info(
        '[QT-Stream] T1 ready ref="${t1.scripture.reference}" '
        'topic="${t1.meditationSummary.topic}" — navigating',
      );

      // Mirror T1 into legacy qtMeditationResultProvider for downstream
      // consumers still reading from it. T2 continues filling sections
      // via the notifier after navigation.
      final partial = QtMeditationResult(
        meditationSummary: t1.meditationSummary,
        scripture: t1.scripture,
        application: const ApplicationSuggestion(),
        knowledge: const RelatedKnowledge(),
      );
      ref.read(qtMeditationResultProvider.notifier).state =
          AsyncValue.data(partial);

      // Flip DB row to completed so Calendar/History pick it up. T2 UPDATE
      // from the notifier stays a JSONB merge and does not clobber this.
      await repo.completePrayer(
        prayerId: _pendingPrayerId!,
        transcript: meditation,
        qtResult: partial,
      );

      ref.invalidate(streakProvider);
      ref.invalidate(userProfileProvider);
      ref.invalidate(prayerHeatmapProvider('prayer'));
      ref.invalidate(prayerHeatmapProvider('qt'));
      ref.invalidate(streakByModeProvider('prayer'));
      ref.invalidate(streakByModeProvider('qt'));

      await _checkStreakCelebration();

      _aiDone = true;
      _navigateIfReady();
    } on AiAnalysisException catch (e) {
      qtLog.error(
        'QT stream T1 failed (${e.kind})',
        error: e.cause,
        stackTrace: e.causeStackTrace,
      );
      _setErrorState(e);
    } catch (e, stackTrace) {
      qtLog.error('Unexpected QT stream error',
          error: e, stackTrace: stackTrace);
      _setErrorState(AiAnalysisException(
        'Unexpected error during QT analysis',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: stackTrace,
      ));
    }
  }

  /// Check current streak and show celebration notification for milestones
  Future<void> _checkStreakCelebration() async {
    try {
      final repo = ref.read(prayerRepositoryProvider);

      // checkMilestones returns only NEWLY achieved milestones
      // (already achieved ones are skipped via UNIQUE constraint)
      final newMilestones = await repo.checkMilestones();

      if (newMilestones.isEmpty) return;

      final streak = await repo.getStreak();
      final notificationService = ref.read(notificationServiceProvider);

      // Only show celebration if the streak milestone is new
      for (final milestone in newMilestones) {
        if (milestone.endsWith('_day_streak')) {
          await notificationService.showStreakCelebration(streak.current);
          break; // one celebration per prayer
        }
      }
    } catch (e) {
      // Non-fatal — don't block prayer flow for notification errors
      prayerLog.warning('Streak celebration check failed', error: e);
    }
  }

  /// Phase 6 — Fill Scripture.verse from PD bundle. AI only picks
  /// reference; the text comes from Supabase Storage (or null → UI fallback).
  Future<PrayerResult> _enrichScriptureVerse(
    PrayerResult result,
    String locale,
  ) async {
    final reference = result.scripture.reference;
    if (reference.isEmpty) {
      prayerLog.warning(
        '[Bible-Enrich] skip: reference empty — AI did not select verse',
      );
      return result;
    }
    // Skip lookup if the hardcoded path already set a verse (e.g. mock mode).
    if (result.scripture.verse.isNotEmpty) {
      prayerLog.debug(
        '[Bible-Enrich] skip: verse already filled (${result.scripture.verse.length} chars) — hardcoded path',
      );
      return result;
    }

    prayerLog.info(
      '[Bible-Enrich] start: ref="$reference" locale=$locale',
    );

    try {
      final bibleService = ref.read(bibleTextServiceProvider);
      final verseText = await bibleService.lookup(reference, locale);
      if (verseText == null || verseText.isEmpty) {
        prayerLog.info(
          '[Bible-Enrich] null: ref="$reference" locale=$locale → UI reference-only fallback',
        );
        return result;
      }
      prayerLog.info(
        '[Bible-Enrich] ok: ref="$reference" locale=$locale verse=${verseText.length} chars',
      );
      return PrayerResult(
        scripture: result.scripture.withVerse(verseText),
        bibleStory: result.bibleStory,
        testimony: result.testimony,
        guidance: result.guidance,
        aiPrayer: result.aiPrayer,
        prayerSummary: result.prayerSummary,
        historicalStory: result.historicalStory,
      );
    } catch (e, stack) {
      prayerLog.error(
        '[Bible-Enrich] FAILED: ref="$reference" locale=$locale',
        error: e,
        stackTrace: stack,
      );
      return result;
    }
  }

  /// Phase 3 Pending/Retry: set error state so build() renders error view
  /// instead of the loading animation. DOES NOT navigate to Dashboard —
  /// error view replaces loading in-place and exposes [재시도]/[홈으로].
  void _setErrorState(AiAnalysisException error) {
    if (!mounted) return;
    setState(() {
      _error = error;
      _aiDone = true; // unblocks _navigateIfReady; but _error guard prevents nav
    });
    prayerLog.info(
      'AI loading error state: kind=${error.kind.name} '
      'retry=$_retryCount/$_maxRetries pendingId=$_pendingPrayerId',
    );
  }

  /// User tapped [다시 시도]. Clear error, reset AI status, trigger analysis.
  /// Uses same _pendingPrayerId → UPDATE existing row on success (no dup).
  void _onRetry() {
    if (!mounted) return;
    if (_retryCount >= _maxRetries) return;
    setState(() {
      _retryCount++;
      _error = null;
      _aiDone = false;
    });
    prayerLog.info('Retry triggered ($_retryCount/$_maxRetries)');
    final mode = ref.read(currentPrayerModeProvider);
    if (mode == 'qt') {
      _analyzeQtMeditation();
    } else {
      _analyzeWithAi();
    }
  }

  /// User tapped [홈으로]. Leave pending prayer in DB — Edge Function will
  /// pick it up on next app visit (Phase 4/5).
  void _onGoHome() {
    if (!mounted) return;
    context.go('/home');
  }

  // Phase 4.2 R-A5 — scripture enrichment moved inside QtTier1Analyzer so
  // the validation + verse lookup happens atomically with T1 generation.
  // The former `_enrichQtScriptureVerse` helper is no longer needed.

  /// Generate a unique ID: timestamp + random hex suffix
  static String _generateId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rand = Random().nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '$now-$rand';
  }

  void _navigateIfReady() {
    if (_navigated) return;
    if (_error != null) return; // Phase 3: don't navigate on error
    if (_aiDone && _minTimePassed && mounted) {
      _navigated = true;
      final mode = ref.read(currentPrayerModeProvider);
      if (mode == 'qt') {
        context.go('/home/qt-dashboard');
      } else {
        context.go('/home/prayer-dashboard');
      }
    }
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Phase 3 Pending/Retry: error view replaces loading animation in-place.
    if (_error != null) {
      return _buildErrorView(l10n, _error!);
    }

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _icons[_stage],
                  key: ValueKey(_stage),
                  style: const TextStyle(fontSize: 80),
                ),
              ),
              const SizedBox(height: AbbaSpacing.xl),
              Text(
                l10n.aiLoadingText,
                style: AbbaTypography.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AbbaSpacing.xl),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  l10n.aiLoadingVerse,
                  style: AbbaTypography.body.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AbbaColors.muted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AbbaSpacing.xxl),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AbbaColors.sage.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(AppLocalizations l10n, AiAnalysisException error) {
    final canRetry = _retryCount < _maxRetries;
    final isNetwork = error.kind == AiAnalysisFailureKind.network;

    final title = isNetwork ? l10n.aiErrorNetworkTitle : l10n.aiErrorApiTitle;
    final body = canRetry
        ? (isNetwork ? l10n.aiErrorNetworkBody : l10n.aiErrorApiBody)
        : l10n.aiErrorWaitAndCheck;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🌿', style: TextStyle(fontSize: 80)),
                const SizedBox(height: AbbaSpacing.xl),
                Text(
                  title,
                  style: AbbaTypography.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AbbaSpacing.md),
                Text(
                  body,
                  style: AbbaTypography.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AbbaSpacing.xxl),
                if (canRetry)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AbbaColors.sage,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AbbaRadius.md),
                        ),
                      ),
                      child: Text(
                        l10n.aiErrorRetry,
                        style: AbbaTypography.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (canRetry) const SizedBox(height: AbbaSpacing.md),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _onGoHome,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AbbaColors.warmBrown,
                      side: BorderSide(color: AbbaColors.muted),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AbbaRadius.md),
                      ),
                    ),
                    child: Text(
                      l10n.aiErrorHome,
                      style: AbbaTypography.body,
                    ),
                  ),
                ),
                if (!canRetry) ...[
                  const SizedBox(height: AbbaSpacing.md),
                  Text(
                    '($_retryCount/$_maxRetries)',
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
