import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
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

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          '${l10n.dashboardTitle} 🌸',
          style: AbbaTypography.h1,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.comingSoon)),
              );
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: resultAsync.when(
        data: (result) => _buildContent(context, result, l10n, locale),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PrayerResult result,
    AppLocalizations l10n,
    String locale,
  ) {
    void showPremiumSnackBar() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.comingSoon)),
      );
    }

    final testimonyText = locale == 'ko'
        ? result.testimony
        : result.testimony;

    return ListView(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.xl),
      children: [
        ScriptureCard(
          scripture: result.scripture,
          title: l10n.scriptureTitle,
          locale: locale,
        ),
        BibleStoryCard(
          bibleStory: result.bibleStory,
          title: l10n.bibleStoryTitle,
          locale: locale,
        ),
        TestimonyCard(
          testimony: testimonyText,
          title: l10n.testimonyTitle,
          editLabel: l10n.testimonyEdit,
        ),
        if (result.guidance != null)
          GuidanceCard(
            guidance: result.guidance!,
            title: l10n.guidanceTitle,
            locale: locale,
            onUnlock: showPremiumSnackBar,
          ),
        if (result.aiPrayer != null)
          AiPrayerCard(
            aiPrayer: result.aiPrayer!,
            title: l10n.aiPrayerTitle,
            locale: locale,
            onUnlock: showPremiumSnackBar,
          ),
        if (result.originalLanguage != null)
          OriginalLangCard(
            originalLanguage: result.originalLanguage!,
            title: l10n.originalLangTitle,
            locale: locale,
            onUnlock: showPremiumSnackBar,
          ),
        const SizedBox(height: AbbaSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.md),
          child: AbbaButton(
            label: '🏠 ${l10n.backToHome}',
            onPressed: () => context.go('/home'),
            isHero: true,
          ),
        ),
      ],
    );
  }
}
