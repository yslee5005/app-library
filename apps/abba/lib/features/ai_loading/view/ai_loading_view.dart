import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../providers/providers.dart';
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
      _minTimePassed = true;
      _navigateIfReady();
    });

    // Call AI service
    _analyzeWithAi();
  }

  Future<void> _analyzeWithAi() async {
    final transcript = ref.read(currentTranscriptProvider);
    final locale = ref.read(localeProvider);
    final aiService = ref.read(aiServiceProvider);

    try {
      final result = await aiService.analyzePrayer(
        transcript: transcript,
        locale: locale,
      );
      ref.read(prayerResultProvider.notifier).state = AsyncValue.data(result);

      // Save prayer with result
      final repo = ref.read(prayerRepositoryProvider);
      await repo.savePrayer(Prayer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'mock-user',
        transcript: transcript,
        mode: 'prayer',
        createdAt: DateTime.now(),
        result: result,
      ));
      await repo.updateStreak();
    } catch (e) {
      ref.read(prayerResultProvider.notifier).state =
          AsyncValue.error(e, StackTrace.current);
    }

    _aiDone = true;
    _navigateIfReady();
  }

  void _navigateIfReady() {
    if (_aiDone && _minTimePassed && mounted) {
      context.go('/home/dashboard');
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
