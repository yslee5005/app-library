import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../models/qt_meditation_result.dart';
import '../../../providers/providers.dart';
import '../../../services/error_logging_service.dart';
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

    ErrorLoggingService.addBreadcrumb('AI loading started', category: 'prayer');

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
    final locale = ref.read(localeProvider);
    final aiService = ref.read(aiServiceProvider);

    // Get actual user id from auth state
    final authState = ref.read(authStateProvider);
    final userId = authState.user?.id ?? 'anonymous';

    // Check network before calling AI API
    final hasNetwork = await NetworkChecker.hasConnection();
    if (!hasNetwork) {
      _setFallbackResult(transcript);
      _aiDone = true;
      _navigateIfReady();
      return;
    }

    try {
      final result = await aiService.analyzePrayer(
        transcript: transcript,
        locale: locale,
      );
      ref.read(prayerResultProvider.notifier).state = AsyncValue.data(result);

      // Save prayer with result
      final repo = ref.read(prayerRepositoryProvider);
      await repo.savePrayer(
        Prayer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          transcript: transcript,
          mode: 'prayer',
          createdAt: DateTime.now(),
          result: result,
        ),
      );
      await repo.updateStreak();

      // Invalidate providers so calendar/history refresh
      ref.invalidate(streakProvider);
      ref.invalidate(userProfileProvider);

      ErrorLoggingService.addBreadcrumb(
        'Prayer saved successfully',
        category: 'prayer',
      );
    } catch (e, stackTrace) {
      ErrorLoggingService.captureException(e, stackTrace);
      _setFallbackResult(transcript);
    }

    _aiDone = true;

    ErrorLoggingService.addBreadcrumb(
      'AI loading finished',
      category: 'prayer',
    );

    _navigateIfReady();
  }

  Future<void> _analyzeQtMeditation() async {
    final meditationText = ref.read(currentTranscriptProvider);
    final passageRef = ref.read(currentPassageRefProvider);
    final passageText = ref.read(currentPassageTextProvider);
    final locale = ref.read(localeProvider);
    final aiService = ref.read(aiServiceProvider);

    final authState = ref.read(authStateProvider);
    final userId = authState.user?.id ?? 'anonymous';

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
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          transcript: meditationText,
          mode: 'qt',
          qtPassageRef: passageRef,
          createdAt: DateTime.now(),
        ),
      );
      await repo.updateStreak();

      // Invalidate providers so calendar/history refresh
      ref.invalidate(streakProvider);
      ref.invalidate(userProfileProvider);

      ErrorLoggingService.addBreadcrumb(
        'QT meditation saved successfully',
        category: 'qt',
      );
    } catch (e, stackTrace) {
      ErrorLoggingService.captureException(e, stackTrace);
      _setFallbackMeditationResult();
    }

    _aiDone = true;
    _navigateIfReady();
  }

  void _setFallbackResult(String transcript) {
    ref.read(prayerResultProvider.notifier).state = AsyncValue.data(
      PrayerResult(
        scripture: const Scripture(
          verseEn: 'The LORD is my shepherd; I shall not want.',
          verseKo: '여호와는 나의 목자시니 내게 부족함이 없으리로다',
          reference: 'Psalm 23:1',
        ),
        bibleStory: const BibleStory(
          titleEn: 'God is faithful',
          titleKo: '하나님은 신실하십니다',
          summaryEn:
              'Even when we cannot see the way, God is faithfully guiding our steps.',
          summaryKo: '우리가 길을 볼 수 없을 때에도, 하나님은 신실하게 우리의 발걸음을 인도하십니다.',
        ),
        testimonyEn: transcript,
        testimonyKo: transcript,
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

  void _navigateIfReady() {
    if (_aiDone && _minTimePassed && mounted) {
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
