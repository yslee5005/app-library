import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/qt_meditation_result.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../widgets/premium_modal.dart';
import '../widgets/application_card.dart';
import '../widgets/growth_story_card.dart';
import '../widgets/meditation_analysis_card.dart';
import '../widgets/related_knowledge_card.dart';

class QtDashboardView extends ConsumerWidget {
  const QtDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final resultAsync = ref.watch(qtMeditationResultProvider);
    final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l10n.qtDashboardTitle, style: AbbaTypography.h1),
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
    QtMeditationResult result,
    AppLocalizations l10n,
    String locale,
    bool isPremium,
  ) {
    void showPremiumUpgrade() {
      showPremiumModal(context).then((purchased) {
        if (purchased) ref.invalidate(isPremiumProvider);
      });
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.xl),
      children: [
        // 1. Meditation Analysis Card
        MeditationAnalysisCard(
          analysis: result.analysis,
          title: l10n.meditationAnalysisTitle,
          keyThemeLabel: l10n.keyThemeLabel,
          locale: locale,
        ),
        // 2. Application Card
        ApplicationCard(
          application: result.application,
          title: l10n.applicationTitle,
          whatLabel: l10n.applicationWhat,
          whenLabel: l10n.applicationWhen,
          contextLabel: l10n.applicationContext,
          locale: locale,
        ),
        // 3. Related Knowledge Card
        RelatedKnowledgeCard(
          knowledge: result.knowledge,
          title: l10n.relatedKnowledgeTitle,
          originalWordLabel: l10n.originalWordLabel,
          historicalContextLabel: l10n.historicalContextLabel,
          crossReferencesLabel: l10n.crossReferencesLabel,
          locale: locale,
        ),
        // 4. Growth Story Card (Premium)
        if (result.growthStory != null)
          GrowthStoryCard(
            growthStory: result.growthStory!,
            title: l10n.growthStoryTitle,
            lessonLabel: l10n.todayLesson,
            locale: locale,
            onUnlock: showPremiumUpgrade,
            isUserPremium: isPremium,
          ),
        const SizedBox(height: AbbaSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.md),
          child: AbbaButton(
            label: l10n.backToHome,
            onPressed: () => context.go('/home'),
            isHero: true,
          ),
        ),
      ],
    );
  }
}
