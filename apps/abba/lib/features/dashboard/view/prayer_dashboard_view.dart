import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lib_logging/logging.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../providers/providers.dart';
import '../../../services/ai_service.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../widgets/staggered_fade_in.dart';
import '../widgets/ai_prayer_card.dart';
import '../widgets/historical_story_card.dart';
import '../widgets/prayer_summary_card.dart';
import '../widgets/scripture_card.dart';
import '../widgets/testimony_card.dart';

class PrayerDashboardView extends ConsumerStatefulWidget {
  const PrayerDashboardView({super.key});

  @override
  ConsumerState<PrayerDashboardView> createState() =>
      _PrayerDashboardViewState();
}

class _PrayerDashboardViewState extends ConsumerState<PrayerDashboardView> {
  bool _premiumLoading = false;
  PremiumContent? _premiumContent;

  @override
  void initState() {
    super.initState();
    prayerLog.info('Prayer dashboard opened');
  }

  Future<void> _loadPremiumContent() async {
    if (_premiumLoading || _premiumContent != null) return;

    setState(() => _premiumLoading = true);

    try {
      final transcript = ref.read(currentTranscriptProvider);
      final locale = ref.read(localeProvider);
      final aiService = ref.read(aiServiceProvider);

      final content = await aiService.analyzePrayerPremium(
        transcript: transcript,
        locale: locale,
      );

      if (mounted) {
        setState(() {
          _premiumContent = content;
          _premiumLoading = false;
        });

        // Merge premium content into prayerResultProvider
        final currentResult = ref.read(prayerResultProvider).value;
        if (currentResult != null) {
          ref.read(prayerResultProvider.notifier).state = AsyncValue.data(
            currentResult.copyWithPremium(
              historicalStory: content.historicalStory,
              aiPrayer: content.aiPrayer,
              guidance: content.guidance,
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) setState(() => _premiumLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final resultAsync = ref.watch(prayerResultProvider);
    final isPremium = ref.watch(isPremiumProvider).value ?? false;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            prayerLog.debug('Back to home from dashboard');
            context.go('/home');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l10n.prayerDashboardTitle, style: AbbaTypography.h1),
        actions: [
          IconButton(
            onPressed: () {
              prayerLog.info('Prayer result shared');
              context.push('/community/write');
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: resultAsync.when(
        data: (result) =>
            _buildContent(context, result, l10n, locale, isPremium),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(l10n.errorGeneric)),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PrayerResult result,
    AppLocalizations l10n,
    String locale,
    bool isPremium,
  ) {
    void showPremiumUpgrade() {
      appLogger.info('Premium card tapped', category: LogCategory.subscription);
      context.push('/settings/membership');
    }

    final testimonyText = result.testimony(locale);

    // Check if premium content is available (from full analyzePrayer or on-demand)
    final hasHistoricalStory = result.historicalStory != null;
    final hasAiPrayer = result.aiPrayer != null;
    final showPremiumSection = isPremium && (!hasHistoricalStory || !hasAiPrayer);

    int i = 0;
    return ListView(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.xl),
      children: [
        // 1. Prayer Summary Card
        if (result.prayerSummary != null)
          StaggeredFadeIn(
            index: i++,
            child: PrayerSummaryCard(
              prayerSummary: result.prayerSummary!,
              title: l10n.prayerSummaryTitle,
              gratitudeLabel: l10n.gratitudeLabel,
              petitionLabel: l10n.petitionLabel,
              intercessionLabel: l10n.intercessionLabel,
            ),
          ),
        // 2. Scripture Card
        StaggeredFadeIn(
          index: i++,
          child: ScriptureCard(
            scripture: result.scripture,
            title: l10n.scriptureTitle,
            locale: locale,
            initiallyExpanded: false,
          ),
        ),
        // 3. Testimony Card
        StaggeredFadeIn(
          index: i++,
          child: TestimonyCard(
            testimony: testimonyText,
            title: l10n.testimonyTitle,
          ),
        ),
        // 4. Historical Story Card (Premium — on-demand)
        if (hasHistoricalStory)
          StaggeredFadeIn(
            index: i++,
            child: HistoricalStoryCard(
              historicalStory: result.historicalStory!,
              title: l10n.historicalStoryTitle,
              lessonLabel: l10n.todayLesson,
              locale: locale,
              onUnlock: showPremiumUpgrade,
              isUserPremium: isPremium,
            ),
          ),
        // 5. AI Prayer Card (Premium — on-demand)
        if (hasAiPrayer)
          StaggeredFadeIn(
            index: i++,
            child: AiPrayerCard(
              aiPrayer: result.aiPrayer!,
              title: l10n.aiPrayerTitle,
              locale: locale,
              onUnlock: showPremiumUpgrade,
              isUserPremium: isPremium,
            ),
          ),
        // 6. Load premium button (if premium user but content not yet loaded)
        if (showPremiumSection)
          StaggeredFadeIn(
            index: i++,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AbbaSpacing.md,
                vertical: AbbaSpacing.sm,
              ),
              child: _premiumLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AbbaSpacing.md),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : OutlinedButton.icon(
                      onPressed: _loadPremiumContent,
                      icon: const Text('✨', style: TextStyle(fontSize: 18)),
                      label: Text(
                        l10n.historicalStoryTitle,
                        style: AbbaTypography.body.copyWith(
                          color: AbbaColors.sage,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AbbaColors.sage.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AbbaRadius.lg),
                        ),
                        padding: const EdgeInsets.all(AbbaSpacing.md),
                      ),
                    ),
            ),
          ),
        // Non-premium user: show locked cards to encourage upgrade
        if (!isPremium && !hasHistoricalStory)
          StaggeredFadeIn(
            index: i++,
            child: HistoricalStoryCard(
              historicalStory: HistoricalStory.placeholder(),
              title: l10n.historicalStoryTitle,
              lessonLabel: l10n.todayLesson,
              locale: locale,
              onUnlock: showPremiumUpgrade,
              isUserPremium: false,
            ),
          ),
        if (!isPremium && !hasAiPrayer)
          StaggeredFadeIn(
            index: i++,
            child: AiPrayerCard(
              aiPrayer: AiPrayer.placeholder(),
              title: l10n.aiPrayerTitle,
              locale: locale,
              onUnlock: showPremiumUpgrade,
              isUserPremium: false,
            ),
          ),
        StaggeredFadeIn(
          index: i++,
          child: Padding(
            padding: const EdgeInsets.only(
              left: AbbaSpacing.md,
              right: AbbaSpacing.md,
              top: AbbaSpacing.lg,
            ),
            child: AbbaButton(
              label: l10n.backToHome,
              onPressed: () {
                prayerLog.debug('Back to home from dashboard');
                context.go('/home');
              },
              isHero: true,
            ),
          ),
        ),
      ],
    );
  }
}
