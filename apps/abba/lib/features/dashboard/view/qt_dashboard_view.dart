import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lib_logging/logging.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/qt_meditation_result.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../widgets/staggered_fade_in.dart';
import '../widgets/application_card.dart';
import '../widgets/growth_story_card.dart';
import '../widgets/meditation_analysis_card.dart';
import '../widgets/related_knowledge_card.dart';

class QtDashboardView extends ConsumerStatefulWidget {
  const QtDashboardView({super.key});

  @override
  ConsumerState<QtDashboardView> createState() => _QtDashboardViewState();
}

class _QtDashboardViewState extends ConsumerState<QtDashboardView> {
  @override
  void initState() {
    super.initState();
    qtLog.info('QT dashboard opened');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final resultAsync = ref.watch(qtMeditationResultProvider);
    final isPremium = ref.watch(isPremiumProvider).value ?? false;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            qtLog.debug('Back from QT dashboard');
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l10n.qtDashboardTitle, style: AbbaTypography.h1),
        actions: [
          IconButton(
            onPressed: () {
              qtLog.info('QT result shared');
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
    QtMeditationResult result,
    AppLocalizations l10n,
    String locale,
    bool isPremium,
  ) {
    void showPremiumUpgrade() {
      appLogger.info('Premium card tapped', category: LogCategory.subscription);
      context.push('/settings/membership');
    }

    int i = 0;
    return ListView(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.xl),
      children: [
        // 1. Meditation Analysis Card
        StaggeredFadeIn(
          index: i++,
          child: MeditationAnalysisCard(
            analysis: result.analysis,
            title: l10n.meditationAnalysisTitle,
            keyThemeLabel: l10n.keyThemeLabel,
            locale: locale,
            initiallyExpanded: false,
          ),
        ),
        // 2. Application Card
        StaggeredFadeIn(
          index: i++,
          child: ApplicationCard(
            application: result.application,
            title: l10n.applicationTitle,
          ),
        ),
        // 3. Related Knowledge Card
        StaggeredFadeIn(
          index: i++,
          child: RelatedKnowledgeCard(
            knowledge: result.knowledge,
            title: l10n.relatedKnowledgeTitle,
            originalWordLabel: l10n.originalWordLabel,
            historicalContextLabel: l10n.historicalContextLabel,
            crossReferencesLabel: l10n.crossReferencesLabel,
            locale: locale,
          ),
        ),
        // 4. Growth Story Card (Premium)
        if (result.growthStory != null)
          StaggeredFadeIn(
            index: i++,
            child: GrowthStoryCard(
              growthStory: result.growthStory!,
              title: l10n.growthStoryTitle,
              lessonLabel: l10n.todayLesson,
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
              label: l10n.backToHome,
              onPressed: () {
                qtLog.debug('Back to home from QT dashboard');
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
