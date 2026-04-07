import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../models/user_profile.dart';
import '../../../widgets/abba_card.dart';
import '../../../widgets/premium_modal.dart';
import '../../../widgets/streak_garden.dart';
import '../../recording/view/recording_overlay.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(userProfileProvider);
    final prayerAsync = ref.watch(prayerResultProvider);

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AbbaSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AbbaSpacing.md),
              // Greeting
              profileAsync.when(
                data: (profile) => Text(
                  _getGreeting(l10n, profile.name),
                  style: AbbaTypography.h1,
                ),
                loading: () =>
                    Text(_getGreeting(l10n, ''), style: AbbaTypography.h1),
                error: (e, s) =>
                    Text(_getGreeting(l10n, ''), style: AbbaTypography.h1),
              ),
              const SizedBox(height: AbbaSpacing.xl),
              // Pray button
              AbbaButton(
                label: l10n.prayButton,
                onPressed: () => _showRecording(context, ref),
                isHero: true,
                backgroundColor: AbbaColors.sage,
              ),
              const SizedBox(height: AbbaSpacing.md),
              // QT button
              AbbaButton(
                label: l10n.qtButton,
                onPressed: () => context.go('/home/qt'),
                isHero: true,
                backgroundColor: AbbaColors.softGold,
              ),
              const SizedBox(height: AbbaSpacing.lg),
              // Streak card with growing garden
              profileAsync.when(
                data: (profile) {
                  final icon = streakGardenIcon(profile.currentStreak);
                  final label = streakGardenLabel(
                    profile.currentStreak,
                    l10n,
                  );
                  return AbbaCard(
                    margin: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Text(icon, style: const TextStyle(fontSize: 40)),
                        const SizedBox(width: AbbaSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.streakDays(profile.currentStreak),
                                style: AbbaTypography.h2,
                              ),
                              Text(
                                label,
                                style: AbbaTypography.bodySmall.copyWith(
                                  color: AbbaColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (e, s) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AbbaSpacing.md),
              // Daily Verse card
              prayerAsync.when(
                data: (result) {
                  final locale = ref.watch(localeProvider);
                  return AbbaCard(
                    margin: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('📜', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: AbbaSpacing.sm),
                            Text(l10n.dailyVerse, style: AbbaTypography.h2),
                          ],
                        ),
                        const SizedBox(height: AbbaSpacing.md),
                        Text(
                          result.scripture.verse(locale),
                          style: AbbaTypography.body,
                        ),
                        const SizedBox(height: AbbaSpacing.sm),
                        Text(
                          '— ${result.scripture.reference}',
                          style: AbbaTypography.bodySmall.copyWith(
                            color: AbbaColors.muted,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (e, s) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AbbaSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting(AppLocalizations l10n, String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning(name);
    if (hour < 18) return l10n.greetingAfternoon(name);
    return l10n.greetingEvening(name);
  }

  Future<void> _showRecording(BuildContext context, WidgetRef ref) async {
    // Check free user limit (in-memory, resets on app restart)
    final profile = ref.read(userProfileProvider).valueOrNull;
    final isFree = profile?.subscription == SubscriptionStatus.free;
    final todayCount = ref.read(todayPrayerCountProvider);

    if (isFree && todayCount >= 1) {
      if (context.mounted) {
        final purchased = await showPremiumModal(context);
        if (!purchased) return;
      }
    }

    // Increment in-memory count (resets on app restart)
    ref.read(todayPrayerCountProvider.notifier).state = todayCount + 1;

    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RecordingOverlay(),
    );
  }
}
