import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lib_logging/logging.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../providers/qt_sections_notifier.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../widgets/staggered_fade_in.dart';
import '../widgets/application_card.dart';
import '../widgets/meditation_summary_card.dart';
import '../widgets/qt_coaching_card.dart';
import '../widgets/related_knowledge_card.dart';
import '../widgets/scripture_card.dart';

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

  /// Phase 4.2 R-A6 — wrap a card that can appear mid-scroll (T2 arrival)
  /// in an implicit fade + slide transition. Mirror of Prayer Dashboard.
  Widget _progressiveFadeIn({
    required Key key,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      builder: (context, t, c) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 16),
          child: c,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    // Phase 4.2 R-A6 — progressive source of truth. Streaming path
    // (ai_loading_view) and Calendar/History revisit both populate this.
    final sections = ref.watch(qtSectionsProvider);
    final isPremium = ref.watch(isPremiumProvider).value ?? false;

    final awaitingT1 =
        sections.meditationSummary == null && sections.scripture == null;

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
      body: awaitingT1
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context, sections, l10n, locale, isPremium),
    );
  }

  Widget _buildContent(
    BuildContext context,
    QtSectionsState sections,
    AppLocalizations l10n,
    String locale,
    bool isPremium,
  ) {
    void showPremiumUpgrade() {
      appLogger.info('Premium card tapped', category: LogCategory.subscription);
      context.push('/settings/membership');
    }

    final hasApplication = sections.application != null &&
        (sections.application!.hasTimeBlocks ||
            sections.application!.action.isNotEmpty);
    final hasKnowledge = sections.knowledge != null &&
        (sections.knowledge!.historicalContext.isNotEmpty ||
            sections.knowledge!.crossReferences.isNotEmpty ||
            sections.knowledge!.originalWord != null);

    int i = 0;
    return ListView(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.xl),
      children: [
        // 0. QT Coaching Card (Pro, on-demand — outside tier stream per SPEC §Scope)
        StaggeredFadeIn(
          index: i++,
          child: QtCoachingCard(
            locale: locale,
            isUserPremium: isPremium,
            onUnlock: showPremiumUpgrade,
          ),
        ),
        // 1. Meditation Summary Card (T1)
        if (sections.meditationSummary != null)
          StaggeredFadeIn(
            index: i++,
            child: MeditationSummaryCard(
              meditationSummary: sections.meditationSummary!,
              title: l10n.meditationSummaryTitle,
              topicLabel: l10n.meditationTopicLabel,
            ),
          ),
        // 2. Scripture Card (T1)
        if (sections.scripture != null &&
            sections.scripture!.reference.isNotEmpty)
          StaggeredFadeIn(
            index: i++,
            child: ScriptureCard(
              scripture: sections.scripture!,
              title: l10n.qtScriptureTitle,
              initiallyExpanded: true,
            ),
          ),
        // 3. Application Card (T2, fades in when background tier arrives)
        if (hasApplication)
          _progressiveFadeIn(
            key: const ValueKey('qt-application'),
            child: ApplicationCard(
              application: sections.application!,
              title: l10n.applicationTitle,
            ),
          ),
        // 4. Related Knowledge Card (T2)
        if (hasKnowledge)
          _progressiveFadeIn(
            key: const ValueKey('qt-knowledge'),
            child: RelatedKnowledgeCard(
              knowledge: sections.knowledge!,
              title: l10n.relatedKnowledgeTitle,
              originalWordLabel: l10n.originalWordLabel,
              historicalContextLabel: l10n.historicalContextLabel,
              crossReferencesLabel: l10n.crossReferencesLabel,
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
