import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../models/qt_meditation_result.dart';
import '../../../providers/providers.dart';
import 'package:app_lib_logging/logging.dart';

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

    // Get actual user id from auth state
    final userId = ref.read(currentUserProvider)?.id ?? 'anonymous';

    // Check network before calling AI API
    final hasNetwork = await NetworkChecker.hasConnection();
    if (!hasNetwork) {
      _setFallbackResult(transcript);
      _aiDone = true;
      _navigateIfReady();
      return;
    }

    try {
      PrayerResult result;
      String savedTranscript;
      String? audioStoragePath;
      final prayerId = _generateId();

      if (isVoiceMode) {
        // Voice mode: upload + analyze in parallel
        final storageService = ref.read(audioStorageServiceProvider);

        final futures = await Future.wait([
          // [0] Gemini analysis (transcription + analysis)
          aiService.analyzePrayerFromAudio(
            audioFilePath: audioPath,
            locale: locale,
          ),
          // [1] Storage upload
          storageService.uploadAudio(
            localPath: audioPath,
            userId: userId,
            recordId: prayerId,
          ).catchError((_) => ''), // non-fatal: continue even if upload fails
        ]);

        final audioResult =
            futures[0] as ({PrayerResult result, String transcription});
        audioStoragePath = futures[1] as String;
        if (audioStoragePath.isEmpty) audioStoragePath = null;

        result = audioResult.result;
        savedTranscript = audioResult.transcription;
        prayerLog.info('Voice prayer analyzed + uploaded, transcript=${savedTranscript.length}');
      } else {
        // Text mode: send transcript to Gemini
        result = await aiService.analyzePrayerCore(
          transcript: transcript,
          locale: locale,
        );
        savedTranscript = transcript;
      }

      prayerLog.info(
        '[Prayer-Analyze] done: locale=$locale '
        'ref="${result.scripture.reference}" '
        'hint="${result.scripture.keyWordHint}" '
        'reason=${result.scripture.reason.length}chars '
        'posture=${result.scripture.posture.length}chars '
        'original=${result.scripture.originalWords.length}words',
      );

      // Phase 6: fill Scripture.verse from PD bundle (BibleTextService).
      // AI only picks reference — verse text comes from the bundle.
      result = await _enrichScriptureVerse(result, locale);

      ref.read(prayerResultProvider.notifier).state = AsyncValue.data(result);

      // Save prayer with result
      final repo = ref.read(prayerRepositoryProvider);
      await repo.savePrayer(
        Prayer(
          id: prayerId,
          userId: userId,
          transcript: savedTranscript,
          mode: 'prayer',
          audioPath: isVoiceMode ? audioPath : null,
          audioStoragePath: audioStoragePath,
          createdAt: DateTime.now(),
          result: result,
        ),
      );
      await repo.updateStreak();

      // Invalidate providers so calendar/history/heatmap refresh
      ref.invalidate(streakProvider);
      ref.invalidate(userProfileProvider);
      ref.invalidate(prayerHeatmapProvider('prayer'));
      ref.invalidate(prayerHeatmapProvider('qt'));
      ref.invalidate(streakByModeProvider('prayer'));
      ref.invalidate(streakByModeProvider('qt'));

      // Show streak celebration notification for milestones
      await _checkStreakCelebration();

      prayerLog.info('Prayer saved successfully');
    } catch (e, stackTrace) {
      prayerLog.error('Prayer AI analysis failed', error: e, stackTrace: stackTrace);
      _setFallbackResult(transcript);
    }

    _aiDone = true;

    prayerLog.info('AI loading finished');

    _navigateIfReady();
  }

  Future<void> _analyzeQtMeditation() async {
    final meditationText = ref.read(currentTranscriptProvider);
    final passageRef = ref.read(currentPassageRefProvider);
    final passageText = ref.read(currentPassageTextProvider);
    final locale = ref.read(localeProvider);
    final aiService = ref.read(aiServiceProvider);

    final userId = ref.read(currentUserProvider)?.id ?? 'anonymous';

    final hasNetwork = await NetworkChecker.hasConnection();
    if (!hasNetwork) {
      _setFallbackMeditationResult();
      _aiDone = true;
      _navigateIfReady();
      return;
    }

    try {
      final result = await aiService.analyzeMeditation(
        passageReference: passageRef,
        passageText: passageText,
        meditationText: meditationText,
        locale: locale,
      );
      ref.read(qtMeditationResultProvider.notifier).state =
          AsyncValue.data(result);

      // Save as QT prayer
      final repo = ref.read(prayerRepositoryProvider);
      await repo.savePrayer(
        Prayer(
          id: _generateId(),
          userId: userId,
          transcript: meditationText,
          mode: 'qt',
          qtPassageRef: passageRef,
          createdAt: DateTime.now(),
        ),
      );
      await repo.updateStreak();

      // Invalidate providers so calendar/history/heatmap refresh
      ref.invalidate(streakProvider);
      ref.invalidate(userProfileProvider);
      ref.invalidate(prayerHeatmapProvider('prayer'));
      ref.invalidate(prayerHeatmapProvider('qt'));
      ref.invalidate(streakByModeProvider('prayer'));
      ref.invalidate(streakByModeProvider('qt'));

      // Show streak celebration notification for milestones
      await _checkStreakCelebration();

      qtLog.info('QT meditation saved successfully');
    } catch (e, stackTrace) {
      qtLog.error('QT meditation analysis failed', error: e, stackTrace: stackTrace);
      _setFallbackMeditationResult();
    }

    _aiDone = true;
    _navigateIfReady();
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

  void _setFallbackResult(String transcript) {
    ref.read(prayerResultProvider.notifier).state = AsyncValue.data(
      PrayerResult(
        scripture: const Scripture(
          reference: 'Psalm 23:1',
          // verse populated at runtime by BibleTextService
        ),
        bibleStory: const BibleStory(
          title: 'God is faithful',
          summary:
              'Even when we cannot see the way, God is faithfully guiding our steps.',
        ),
        testimony: transcript,
      ),
    );
  }

  void _setFallbackMeditationResult() {
    ref.read(qtMeditationResultProvider.notifier).state = const AsyncValue.data(
      QtMeditationResult(
        analysis: MeditationAnalysis(
          keyThemeEn: 'God\'s Faithfulness',
          keyThemeKo: '하나님의 신실하심',
          insightEn:
              'Your meditation reveals a heart seeking God\'s guidance and peace.',
          insightKo: '당신의 묵상에서 하나님의 인도와 평안을 구하는 마음이 느껴집니다.',
        ),
        application: ApplicationSuggestion(
          action: '오늘 잠시 조용히 묵상하는 시간을 가져보세요',
        ),
        knowledge: RelatedKnowledge(
          historicalContextEn:
              'The biblical concept of meditation involves deep reflection on God\'s Word.',
          historicalContextKo: '성경에서의 묵상은 하나님의 말씀에 대한 깊은 성찰을 의미합니다.',
          crossReferences: [
            CrossReference(reference: 'Psalm 1:2', text: ''),
            CrossReference(reference: 'Joshua 1:8', text: ''),
          ],
        ),
      ),
    );
  }

  /// Generate a unique ID: timestamp + random hex suffix
  static String _generateId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rand = Random().nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '$now-$rand';
  }

  void _navigateIfReady() {
    if (_navigated) return;
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
}
