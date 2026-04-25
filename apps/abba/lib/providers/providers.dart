import 'package:app_lib_auth/auth.dart' hide UserProfile;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Re-export auth providers for views (without UserProfile to avoid collision)
export 'package:app_lib_auth/auth.dart'
    show
        authRepositoryProvider,
        authNotifierProvider,
        currentUserProvider,
        isAnonymousProvider;

// Re-export audio service providers from the shared packages so views
// can keep importing a single providers.dart.
export 'package:app_lib_audio_recorder/audio_recorder.dart'
    show audioRecorderServiceProvider;
export 'package:app_lib_audio_storage/audio_storage.dart'
    show audioStorageServiceProvider;
export 'package:app_lib_subscriptions/subscriptions.dart'
    show ActiveSubscriptionInfo, OfferingPrices;

import '../models/post.dart';
import '../models/prayer.dart';
import '../models/qt_meditation_result.dart';
import '../models/qt_passage.dart';
import '../models/user_profile.dart';
import '../services/ai_service.dart';
import '../services/bible_text_service.dart';
import '../services/community_repository.dart';
import '../services/gemini_cache_manager.dart';
import '../services/prayer_quota_service.dart';
import '../services/prayer_template_service.dart';
import '../services/mock_data.dart';
import '../services/notification_service.dart';
import '../services/prayer_repository.dart';
import '../services/qt_repository.dart';
import '../services/recent_references_service.dart';
import 'package:app_lib_subscriptions/subscriptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// Core data (kept for backward compat, loads JSON mock)
// ---------------------------------------------------------------------------
final mockDataServiceProvider = Provider<MockDataService>((ref) {
  return MockDataService();
});

// ---------------------------------------------------------------------------
// Auth — from packages/auth (authRepositoryProvider, authNotifierProvider,
// currentUserProvider, isAnonymousProvider are re-exported from app_lib_auth)
// ---------------------------------------------------------------------------

final aiServiceProvider = Provider<AiService>((ref) {
  throw UnimplementedError('aiServiceProvider must be overridden');
});

/// Phase 4.1: Shared Gemini Context Cache manager (Strategy B).
/// Lazy singleton — created when first Gemini call needs a cache id.
final geminiCacheManagerProvider = Provider<GeminiCacheManager>((ref) {
  return GeminiCacheManager(Supabase.instance.client);
});

/// Phase 4.1 INT-033: Day-1 template fallback service.
/// Loads bundled PrayerResult JSONs when Gemini is unreachable.
final prayerTemplateServiceProvider = Provider<PrayerTemplateService>((ref) {
  return PrayerTemplateService();
});

/// Looks up Bible verse text (Public Domain bundles) by reference + locale.
final bibleTextServiceProvider = Provider<BibleTextService>((ref) {
  throw UnimplementedError('bibleTextServiceProvider must be overridden');
});

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  throw UnimplementedError('prayerRepositoryProvider must be overridden');
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  throw UnimplementedError('communityRepositoryProvider must be overridden');
});

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  throw UnimplementedError('subscriptionServiceProvider must be overridden');
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('notificationServiceProvider must be overridden');
});

final qtRepositoryProvider = Provider<QtRepository>((ref) {
  throw UnimplementedError('qtRepositoryProvider must be overridden');
});

/// v7 — Reads the user's last-30-day chosen scripture references so T1
/// can rotate beyond what was already shown. Always overridden in real
/// mode (`main.dart`); mock mode falls through to a no-op stub returning [].
final recentReferencesServiceProvider = Provider<RecentReferencesService>((
  ref,
) {
  throw UnimplementedError(
    'recentReferencesServiceProvider must be overridden',
  );
});

/// v7 — Per-user cached recent references list. autoDispose so a fresh
/// fetch happens on each prayer; family keyed on userId.
final recentReferencesProvider = FutureProvider.autoDispose
    .family<List<String>, String>((ref, userId) {
      final service = ref.watch(recentReferencesServiceProvider);
      return service.getRecentReferences(userId: userId);
    });

/// Notification settings
final notificationSettingsProvider = FutureProvider<NotificationSettings>((
  ref,
) {
  final service = ref.watch(notificationServiceProvider);
  return service.getSettings();
});

/// Current subscription status (reactive)
final subscriptionStatusProvider = StreamProvider<SubscriptionStatus>((ref) {
  final service = ref.watch(subscriptionServiceProvider);
  return service.statusStream;
});

/// Quick check: is current user premium?
final isPremiumProvider = FutureProvider<bool>((ref) {
  final service = ref.watch(subscriptionServiceProvider);
  return service.isPremium;
});

/// Current active subscription details (product id, next billing date,
/// renewal flag). Null when user is free.
final activeSubscriptionProvider =
    FutureProvider.autoDispose<ActiveSubscriptionInfo?>((ref) async {
      final service = ref.watch(subscriptionServiceProvider);
      return service.getActiveSubscription();
    });

/// Latest expiration date across the user's purchase history. Null when
/// the user has never purchased. Drives the "subscription expired" banner.
final lastExpirationDateProvider = FutureProvider.autoDispose<DateTime?>((
  ref,
) async {
  final service = ref.watch(subscriptionServiceProvider);
  return service.getLatestExpirationDate();
});

/// Localized store prices (monthly, yearly, yearly-per-month, savings %).
/// Returns null when offerings are unavailable — UI must fall back to
/// the hardcoded ARB default prices.
final offeringPricesProvider = FutureProvider.autoDispose<OfferingPrices?>((
  ref,
) async {
  final service = ref.watch(subscriptionServiceProvider);
  return service.getOfferingPrices();
});

// ---------------------------------------------------------------------------
// Data providers
// ---------------------------------------------------------------------------
final userProfileProvider = FutureProvider<UserProfile>((ref) {
  return ref.watch(mockDataServiceProvider).getUserProfile();
});

final prayerResultProvider = StateProvider<AsyncValue<PrayerResult>>((ref) {
  return const AsyncValue.loading();
});

/// Premium content loaded on-demand when user expands premium cards
final premiumContentProvider = StateProvider<AsyncValue<PremiumContent>?>(
  (ref) => null,
);

/// Prayer Coaching (Pro-only). On-demand single call, evaluated against
/// `assets/docs/prayer_guide.md`. Free users: placeholder shown via ProBlur.
final prayerCoachingProvider = FutureProvider.autoDispose<PrayerCoaching>((
  ref,
) async {
  final isPremium = await ref.watch(isPremiumProvider.future);
  if (!isPremium) {
    return PrayerCoaching.placeholder();
  }
  final transcript = ref.watch(currentTranscriptProvider);
  if (transcript.trim().isEmpty) {
    return PrayerCoaching.placeholder();
  }
  final locale = ref.watch(localeProvider);
  final aiService = ref.watch(aiServiceProvider);
  return aiService.analyzePrayerCoaching(
    transcript: transcript,
    locale: locale,
  );
});

/// QT Coaching (Pro-only). On-demand single call, evaluated against
/// `assets/docs/qt_guide.md`. Free users: placeholder shown via ProBlur.
/// Phase 2 of qt_output_redesign (INT-118).
final qtCoachingProvider = FutureProvider.autoDispose<QtCoaching>((ref) async {
  final isPremium = await ref.watch(isPremiumProvider.future);
  if (!isPremium) {
    return QtCoaching.placeholder();
  }
  final meditation = ref.watch(currentTranscriptProvider);
  if (meditation.trim().isEmpty) {
    return QtCoaching.placeholder();
  }
  final scriptureRef = ref.watch(currentPassageRefProvider);
  final locale = ref.watch(localeProvider);
  final aiService = ref.watch(aiServiceProvider);
  return aiService.analyzeQtCoaching(
    meditation: meditation,
    scriptureReference: scriptureRef,
    locale: locale,
  );
});

final qtPassagesProvider = FutureProvider<List<QTPassage>>((ref) {
  final locale = ref.watch(localeProvider);
  final repo = ref.watch(qtRepositoryProvider);
  return repo.getTodayPassages(locale: locale);
});

final communityPostsProvider = FutureProvider<List<CommunityPost>>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getPosts();
});

/// Filter for community posts
final communityFilterProvider = StateProvider<String>((ref) => 'all');

/// Filtered community posts (reacts to filter changes)
final filteredCommunityPostsProvider = FutureProvider<List<CommunityPost>>((
  ref,
) {
  final filter = ref.watch(communityFilterProvider);
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getPosts(category: filter == 'all' ? null : filter);
});

/// Saved posts for current user
final savedPostsProvider = FutureProvider<List<CommunityPost>>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getSavedPosts();
});

/// My posts (current user's posts only)
final myPostsProvider = FutureProvider<List<CommunityPost>>((ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  final userId = ref.watch(currentUserProvider)?.id ?? '';
  final allPosts = await repo.getPosts();
  return allPosts.where((p) => p.userId == userId).toList();
});

// ---------------------------------------------------------------------------
// Calendar & Prayer data providers (Phase 2)
// ---------------------------------------------------------------------------

/// Prayers for a specific date (used by Calendar day detail)
final calendarPrayersProvider = FutureProvider.autoDispose
    .family<List<Prayer>, DateTime>((ref, date) {
      final repo = ref.watch(prayerRepositoryProvider);
      return repo.getPrayersByDate(date);
    });

/// Monthly prayer dates (for calendar markers)
final monthlyPrayerDaysProvider = FutureProvider.autoDispose
    .family<Set<DateTime>, ({int year, int month})>((ref, params) async {
      final repo = ref.watch(prayerRepositoryProvider);
      final prayers = await repo.getPrayersByMonth(params.year, params.month);
      return prayers.map((p) {
        final d = p.createdAt;
        return DateTime(d.year, d.month, d.day);
      }).toSet();
    });

/// Streak data from repository
final streakProvider = FutureProvider<({int current, int best})>((ref) {
  final repo = ref.watch(prayerRepositoryProvider);
  return repo.getStreak();
});

/// Heatmap cell data: count + total minutes for a day.
class HeatmapDay {
  final int count;
  final int minutes;
  const HeatmapDay({this.count = 0, this.minutes = 0});
  HeatmapDay add(int durationSeconds) =>
      HeatmapDay(count: count + 1, minutes: minutes + (durationSeconds ~/ 60));
}

/// Prayer heatmap data: daily counts + duration for last 84 days, filtered by mode.
/// Pass 'prayer' or 'qt' to get mode-specific data.
final prayerHeatmapProvider =
    FutureProvider.family<Map<DateTime, HeatmapDay>, String>((ref, mode) async {
      final repo = ref.watch(prayerRepositoryProvider);
      final now = DateTime.now();
      final result = <DateTime, HeatmapDay>{};

      final months = <({int year, int month})>{};
      for (int i = 0; i <= 84; i++) {
        final d = now.subtract(Duration(days: i));
        months.add((year: d.year, month: d.month));
      }

      for (final m in months) {
        final prayers = await repo.getPrayersByMonth(m.year, m.month);
        for (final p in prayers) {
          if (p.mode != mode) continue; // filter by mode
          final dateKey = DateTime(
            p.createdAt.year,
            p.createdAt.month,
            p.createdAt.day,
          );
          final daysAgo = now.difference(dateKey).inDays;
          if (daysAgo <= 84) {
            result[dateKey] = (result[dateKey] ?? const HeatmapDay()).add(
              p.durationSeconds,
            );
          }
        }
      }
      return result;
    });

/// Streak calculated from heatmap data, per mode.
/// Returns (current, best) streak for the given mode ('prayer' or 'qt').
final streakByModeProvider =
    FutureProvider.family<({int current, int best}), String>((ref, mode) async {
      final heatmapData = await ref.watch(prayerHeatmapProvider(mode).future);
      if (heatmapData.isEmpty) {
        return (current: 0, best: 0);
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Collect dates that have activity
      final activeDates =
          heatmapData.entries
              .where((e) => e.value.count > 0)
              .map((e) => e.key)
              .toList()
            ..sort((a, b) => b.compareTo(a)); // descending

      if (activeDates.isEmpty) return (current: 0, best: 0);

      // Current streak
      int currentStreak = 0;
      var expected = today;

      if (activeDates.first == today) {
        expected = today;
      } else if (activeDates.first == today.subtract(const Duration(days: 1))) {
        expected = today.subtract(const Duration(days: 1));
      } else {
        currentStreak = 0;
        expected = today; // won't match
      }

      for (final date in activeDates) {
        if (date == expected) {
          currentStreak++;
          expected = expected.subtract(const Duration(days: 1));
        } else if (date.isBefore(expected)) {
          break;
        }
      }

      // Best streak
      final ascending = activeDates.reversed.toList();
      int bestStreak = 0;
      int runLength = 1;
      for (int i = 1; i < ascending.length; i++) {
        final diff = ascending[i].difference(ascending[i - 1]).inDays;
        if (diff == 1) {
          runLength++;
        } else {
          if (runLength > bestStreak) bestStreak = runLength;
          runLength = 1;
        }
      }
      if (runLength > bestStreak) bestStreak = runLength;
      if (currentStreak > bestStreak) bestStreak = currentStreak;

      return (current: currentStreak, best: bestStreak);
    });

// ---------------------------------------------------------------------------
// App state
// ---------------------------------------------------------------------------
final localeProvider = StateProvider<String>((ref) => 'ko');

/// Theme mode provider for dark mode support
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

/// Tracks current prayer transcript from recording (text mode)
final currentTranscriptProvider = StateProvider<String>((ref) => '');

/// Tracks current audio file path from voice recording
final currentAudioPathProvider = StateProvider<String?>((ref) => null);

/// Current prayer mode: 'prayer' or 'qt'
final currentPrayerModeProvider = StateProvider<String>((ref) => 'prayer');

/// QT meditation result (separate from prayer result)
final qtMeditationResultProvider =
    StateProvider<AsyncValue<QtMeditationResult>>((ref) {
      return const AsyncValue.loading();
    });

/// Current QT passage reference for meditation
final currentPassageRefProvider = StateProvider<String>((ref) => '');

/// Current QT passage text for meditation
final currentPassageTextProvider = StateProvider<String>((ref) => '');

/// DEPRECATED: legacy in-memory counter kept only so older references
/// compile. New code MUST use [prayerQuotaServiceProvider] which is
/// backed by [SharedPreferences] and resets on local-day boundary.
@Deprecated('Use prayerQuotaServiceProvider')
final todayPrayerCountProvider = StateProvider<int>((ref) => 0);

// ---------------------------------------------------------------------------
// Daily prayer quota (trial soft cap + free user cap)
// ---------------------------------------------------------------------------

/// Must be overridden from `main.dart` after `SharedPreferences.getInstance()`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart',
  );
});

/// Service tracking today's prayer count (local-date scoped).
final prayerQuotaServiceProvider = Provider<PrayerQuotaService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrayerQuotaService(prefs: prefs);
});

/// Effective pricing tier for the current user.
///
/// - [free]: no active entitlement — capped at 1 prayer/day.
/// - [trial]: active entitlement with [PeriodType.trial] — capped at
///   3 prayers/day (Phase 1 trial soft cap).
/// - [pro]: any other active entitlement — unlimited.
enum EffectiveTier { free, trial, pro }

final effectiveTierProvider = FutureProvider<EffectiveTier>((ref) async {
  final info = await ref.watch(activeSubscriptionProvider.future);
  if (info == null) return EffectiveTier.free;
  if (info.periodType == PeriodType.trial) return EffectiveTier.trial;
  return EffectiveTier.pro;
});

/// Daily prayer limit for the current tier. `null` = unlimited (pro).
final dailyPrayerLimitProvider = FutureProvider<int?>((ref) async {
  final tier = await ref.watch(effectiveTierProvider.future);
  switch (tier) {
    case EffectiveTier.free:
      return 1;
    case EffectiveTier.trial:
      return 3;
    case EffectiveTier.pro:
      return null;
  }
});

/// Whether the current user is eligible for the yearly introductory free
/// trial. Used by Membership CTA to show "Start 1 month free" instead of
/// the standard price. Defaults to `false` on error (safe — never offer
/// a trial to an ineligible user).
final trialEligibleYearlyProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  final service = ref.watch(subscriptionServiceProvider);
  return service.checkYearlyTrialEligibility();
});

/// Whether a prayer/QT recording session is currently active.
/// Used to guard navigation (tab bar, back button) during active sessions.
final isRecordingProvider = StateProvider<bool>((ref) => false);
