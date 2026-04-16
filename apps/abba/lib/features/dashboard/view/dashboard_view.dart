import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../widgets/staggered_fade_in.dart';
import '../widgets/ai_prayer_card.dart';
import '../widgets/bible_story_card.dart';
import '../widgets/guidance_card.dart';
import '../widgets/original_lang_card.dart';
import '../widgets/scripture_card.dart';
import '../widgets/testimony_card.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final resultAsync = ref.watch(prayerResultProvider);
    final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('${l10n.dashboardTitle} 🌸', style: AbbaTypography.h1),
        actions: [
          IconButton(
            onPressed: () => context.go('/community/write'),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: resultAsync.when(
        data: (result) =>
            _buildContent(context, ref, result, l10n, locale, isPremium),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(l10n.errorGeneric)),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    PrayerResult result,
    AppLocalizations l10n,
    String locale,
    bool isPremium,
  ) {
    void showPremiumUpgrade() {
      context.push('/settings/membership');
    }

    final testimonyText = result.testimony(locale);

    int i = 0;
    return ListView(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.xl),
      children: [
        StaggeredFadeIn(
          index: i++,
          child: ScriptureCard(
            scripture: result.scripture,
            title: l10n.scriptureTitle,
            locale: locale,
            initiallyExpanded: false,
          ),
        ),
        StaggeredFadeIn(
          index: i++,
          child: BibleStoryCard(
            bibleStory: result.bibleStory,
            title: l10n.bibleStoryTitle,
            locale: locale,
          ),
        ),
        StaggeredFadeIn(
          index: i++,
          child: TestimonyCard(
            testimony: testimonyText,
            title: l10n.testimonyTitle,
            editLabel: l10n.testimonyEdit,
          ),
        ),
        if (result.guidance != null)
          StaggeredFadeIn(
            index: i++,
            child: GuidanceCard(
              guidance: result.guidance!,
              title: l10n.guidanceTitle,
              locale: locale,
              onUnlock: showPremiumUpgrade,
              isUserPremium: isPremium,
            ),
          ),
        if (result.aiPrayer != null)
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
        if (result.originalLanguage != null)
          StaggeredFadeIn(
            index: i++,
            child: OriginalLangCard(
              originalLanguage: result.originalLanguage!,
              title: l10n.originalLangTitle,
              locale: locale,
              onUnlock: showPremiumUpgrade,
              isUserPremium: isPremium,
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
              label: '🏠 ${l10n.backToHome}',
              onPressed: () => context.go('/home'),
              isHero: true,
            ),
          ),
        ),
      ],
    );
  }
}
