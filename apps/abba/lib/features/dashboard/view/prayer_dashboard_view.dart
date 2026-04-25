import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../providers/prayer_sections_notifier.dart';
import '../../../providers/providers.dart';
import '../../../services/ai_service.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../widgets/staggered_fade_in.dart';
import '../widgets/ai_prayer_card.dart';
import '../widgets/bible_story_card.dart';
import '../widgets/historical_story_card.dart';
import '../widgets/prayer_coaching_card.dart';
import '../widgets/prayer_summary_card.dart';
import '../widgets/scripture_card.dart';
import '../widgets/testimony_card.dart';

/// Resolves audio storage path → signed URL for playback.
final _currentAudioUrlProvider = FutureProvider<String?>((ref) async {
  final audioPath = ref.watch(currentAudioPathProvider);
  if (audioPath == null || audioPath.isEmpty) return null;

  // Use local file path for playback (uploaded copy exists in Storage)
  return audioPath;
});

class PrayerDashboardView extends ConsumerStatefulWidget {
  const PrayerDashboardView({super.key});

  @override
  ConsumerState<PrayerDashboardView> createState() =>
      _PrayerDashboardViewState();
}

class _PrayerDashboardViewState extends ConsumerState<PrayerDashboardView> {
  bool _premiumLoading = false;
  PremiumContent? _premiumContent;

  /// Phase 4.1 INT-032 — 3s fallback timer. If the user never scrolls to the
  /// Premium region (cold start on iPad where the list fits on screen), fire
  /// T3 anyway so Pro users are not penalised for sitting still.
  Timer? _t3FallbackTimer;

  @override
  void initState() {
    super.initState();
    prayerLog.info('Prayer dashboard opened');
    _t3FallbackTimer = Timer(const Duration(seconds: 3), _maybeTriggerT3);
  }

  @override
  void dispose() {
    _t3FallbackTimer?.cancel();
    super.dispose();
  }

  /// Phase 4.1 INT-032 — T3 trigger gate. Fired either by VisibilityDetector
  /// (scroll >= 30%) or the 3s fallback timer, whichever comes first. The
  /// notifier's `t3Triggered` flag prevents re-firing across sources.
  void _maybeTriggerT3() {
    if (!mounted) return;
    // Free / Trial users MUST NOT hit Premium AI. ProBlur shows preview UI
    // instead (Wave C). T3 Premium is Pro-only — Trial daily 3-cap is for
    // T1/T2 only per effectiveTierProvider semantics.
    final tier = ref.read(effectiveTierProvider).value;
    if (tier != EffectiveTier.pro) return;
    final sections = ref.read(prayerSectionsProvider);
    if (sections.t3Triggered) return;
    // Need T1 and T2 context for coherent T3 generation.
    if (sections.summary == null ||
        sections.scripture == null ||
        sections.bibleStory == null) {
      return;
    }
    ref.read(prayerSectionsProvider.notifier).markT3Triggered();
    _loadPremiumContent();
  }

  /// Phase 4.1 INT-028 — wrap a card that can appear mid-scroll (T2 / T3
  /// arrival) in an implicit fade + slide transition. Unlike
  /// [StaggeredFadeIn], this doesn't rely on a mount-time delay; the
  /// animation runs once the key is first inserted into the list.
  Widget _progressiveFadeIn({
    required Key key,
    required int index,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      builder: (context, t, c) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, (1 - t) * 16), child: c),
      ),
      child: child,
    );
  }

  Future<void> _loadPremiumContent() async {
    // Free / Trial users MUST NOT hit Premium AI. ProBlur shows preview UI
    // instead (Wave C). Defensive gate — also enforced by _maybeTriggerT3 and
    // by the showPremiumSection visibility guard.
    final tier = ref.read(effectiveTierProvider).value;
    if (tier != EffectiveTier.pro) return;
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

        // Merge premium content into prayerResultProvider (legacy)
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
        // Phase 4.1 INT-028 — also surface to progressive renderer.
        ref
            .read(prayerSectionsProvider.notifier)
            .setT3(
              guidance: content.guidance,
              aiPrayer: content.aiPrayer,
              historicalStory: content.historicalStory,
            );
      }
    } catch (e, stackTrace) {
      prayerLog.error(
        'Premium content generation failed',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) setState(() => _premiumLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    // Phase 4.1 INT-028 — progressive source of truth. Streaming path
    // (ai_loading_view) and Calendar/History revisit both populate this;
    // prayerResultProvider stays as a compatibility read for a couple of
    // downstream consumers (e.g. community write).
    final sections = ref.watch(prayerSectionsProvider);
    final isPremium = ref.watch(isPremiumProvider).value ?? false;
    // Wave C — warm effectiveTierProvider so the synchronous read inside
    // _maybeTriggerT3 / _loadPremiumContent resolves to a non-null value by
    // the time the 3s fallback timer fires. Without this watch the provider
    // never starts its async fetch.
    ref.watch(effectiveTierProvider);

    // While T1 has not arrived (no scripture/summary yet), show spinner. The
    // Dashboard is reachable as soon as T1 resolves from streaming, so this
    // is mostly a safety net for past prayers with corrupt data.
    final awaitingT1 = sections.summary == null && sections.scripture == null;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            prayerLog.debug('Back from prayer dashboard');
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
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
      body: awaitingT1
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context, sections, l10n, locale, isPremium),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PrayerSectionsState sections,
    AppLocalizations l10n,
    String locale,
    bool isPremium,
  ) {
    void showPremiumUpgrade() {
      appLogger.info('Premium card tapped', category: LogCategory.subscription);
      context.push('/settings/membership');
    }

    final testimonyText = sections.testimony ?? '';
    final hasTestimony = testimonyText.isNotEmpty;
    final hasHistoricalStory = sections.historicalStory != null;
    final hasAiPrayer = sections.aiPrayer != null;
    final showPremiumSection =
        isPremium && (!hasHistoricalStory || !hasAiPrayer);

    int i = 0;
    return ListView(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.xl),
      children: [
        // 1. Prayer Summary Card (T1, animates)
        if (sections.summary != null)
          StaggeredFadeIn(
            index: i++,
            child: PrayerSummaryCard(
              prayerSummary: sections.summary!,
              title: l10n.prayerSummaryTitle,
              gratitudeLabel: l10n.gratitudeLabel,
              petitionLabel: l10n.petitionLabel,
              intercessionLabel: l10n.intercessionLabel,
              audioUrl: ref.watch(_currentAudioUrlProvider).value,
              audioLabel: l10n.myPrayerAudioLabel,
              animate: true,
            ),
          ),
        // 2. Scripture Card (T1)
        if (sections.scripture != null)
          StaggeredFadeIn(
            index: i++,
            child: ScriptureCard(
              scripture: sections.scripture!,
              title: l10n.scriptureTitle,
              initiallyExpanded: false,
            ),
          ),
        // 3. Bible Story Card (T2) — REQUIREMENTS §4.6 Free+Premium 모두 노출
        if (sections.bibleStory != null)
          _progressiveFadeIn(
            key: const ValueKey('bible-story'),
            index: i++,
            child: BibleStoryCard(
              bibleStory: sections.bibleStory!,
              title: l10n.bibleStoryTitle,
            ),
          ),
        // 4. Testimony Card (T2, fades in when background tier arrives)
        if (hasTestimony)
          _progressiveFadeIn(
            key: const ValueKey('testimony'),
            index: i++,
            child: TestimonyCard(
              testimony: testimonyText,
              title: l10n.testimonyTitle,
              helperText: l10n.testimonyHelperText,
            ),
          ),
        // 4. Prayer Coaching Card (Pro — first Pro card, on-demand analysis)
        //    Wraps the Pro region entry with a VisibilityDetector so that
        //    scrolling into the Pro territory fires T3 eagerly (faster
        //    than the 3s fallback) for Pro users.
        VisibilityDetector(
          key: const Key('prayer-pro-region'),
          onVisibilityChanged: (info) {
            if (info.visibleFraction >= 0.3) _maybeTriggerT3();
          },
          child: StaggeredFadeIn(
            index: i++,
            child: PrayerCoachingCard(
              locale: locale,
              isUserPremium: isPremium,
              onUnlock: showPremiumUpgrade,
            ),
          ),
        ),
        // 5. Historical Story Card (T3 premium on-demand)
        if (hasHistoricalStory)
          _progressiveFadeIn(
            key: const ValueKey('historical-story'),
            index: i++,
            child: HistoricalStoryCard(
              historicalStory: sections.historicalStory!,
              title: l10n.historicalStoryTitle,
              lessonLabel: l10n.todayLesson,
              onUnlock: showPremiumUpgrade,
              isUserPremium: isPremium,
            ),
          ),
        // 6. AI Prayer Card (T3 premium on-demand)
        if (hasAiPrayer)
          _progressiveFadeIn(
            key: const ValueKey('ai-prayer'),
            index: i++,
            child: AiPrayerCard(
              aiPrayer: sections.aiPrayer!,
              title: l10n.aiPrayerTitle,
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
              historicalStory: HistoricalStory.placeholder(locale),
              title: l10n.historicalStoryTitle,
              lessonLabel: l10n.todayLesson,
              onUnlock: showPremiumUpgrade,
              isUserPremium: false,
            ),
          ),
        if (!isPremium && !hasAiPrayer)
          StaggeredFadeIn(
            index: i++,
            child: AiPrayerCard(
              aiPrayer: AiPrayer.placeholder(locale),
              title: l10n.aiPrayerTitle,
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
