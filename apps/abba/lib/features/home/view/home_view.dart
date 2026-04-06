import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../models/user_profile.dart';
import '../../../widgets/abba_card.dart';
import '../../../widgets/premium_modal.dart';
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
                loading: () => Text(
                  _getGreeting(l10n, ''),
                  style: AbbaTypography.h1,
                ),
                error: (e, s) => Text(
                  _getGreeting(l10n, ''),
                  style: AbbaTypography.h1,
                ),
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
              // Streak card
              profileAsync.when(
                data: (profile) => AbbaCard(
                  margin: EdgeInsets.zero,
                  child: Row(
                    children: [
                      const Text('', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: AbbaSpacing.md),
                      Expanded(
                        child: Text(
                          l10n.streakDays(profile.currentStreak),
                          style: AbbaTypography.h2,
                        ),
                      ),
                    ],
                  ),
                ),
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
                            const Text('', style: TextStyle(fontSize: 24)),
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
    // Check free user limit (persisted with SharedPreferences)
    final profile = ref.read(userProfileProvider).valueOrNull;
    final isFree = profile?.subscription == SubscriptionStatus.free;

    if (isFree) {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final lastDate = prefs.getString('last_prayer_date') ?? '';
      final count =
          lastDate == today ? (prefs.getInt('today_prayer_count') ?? 0) : 0;

      if (count >= 1) {
        if (context.mounted) await showPremiumModal(context);
        return;
      }

      // Increment and save
      await prefs.setString('last_prayer_date', today);
      await prefs.setInt('today_prayer_count', count + 1);
    }

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
