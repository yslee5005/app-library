import 'package:app_lib_auth/auth.dart' hide UserProfile;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Re-export auth providers for views (without UserProfile to avoid collision)
export 'package:app_lib_auth/auth.dart'
    show authRepositoryProvider, authNotifierProvider, currentUserProvider, isAnonymousProvider;

import '../models/post.dart';
import '../models/prayer.dart';
import '../models/qt_meditation_result.dart';
import '../models/qt_passage.dart';
import '../models/user_profile.dart';
import '../services/ai_service.dart';
import '../services/community_repository.dart';
import '../services/mock_data.dart';
import '../services/notification_service.dart';
import '../services/prayer_repository.dart';
import '../services/qt_repository.dart';
import '../services/stt_service.dart';
import '../services/subscription_service.dart';
import '../services/tts_service.dart';

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

final sttServiceProvider = Provider<SttService>((ref) {
  throw UnimplementedError('sttServiceProvider must be overridden');
});

final ttsServiceProvider = Provider<TtsService>((ref) {
  throw UnimplementedError('ttsServiceProvider must be overridden');
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
final premiumContentProvider =
    StateProvider<AsyncValue<PremiumContent>?>((ref) => null);

final qtPassagesProvider = FutureProvider<List<QTPassage>>((ref) {
  final repo = ref.watch(qtRepositoryProvider);
  return repo.getTodayPassages();
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
final calendarPrayersProvider = FutureProvider.autoDispose.family<List<Prayer>, DateTime>((
  ref,
  date,
) {
  final repo = ref.watch(prayerRepositoryProvider);
  return repo.getPrayersByDate(date);
});

/// Monthly prayer dates (for calendar markers)
final monthlyPrayerDaysProvider =
    FutureProvider.autoDispose.family<Set<DateTime>, ({int year, int month})>((
      ref,
      params,
    ) async {
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
  HeatmapDay add(int durationSeconds) => HeatmapDay(
    count: count + 1,
    minutes: minutes + (durationSeconds ~/ 60),
  );
}

/// Prayer heatmap data: daily prayer counts + duration for last 84 days.
final prayerHeatmapProvider =
    FutureProvider.autoDispose<Map<DateTime, HeatmapDay>>((ref) async {
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
      final dateKey = DateTime(p.createdAt.year, p.createdAt.month, p.createdAt.day);
      final daysAgo = now.difference(dateKey).inDays;
      if (daysAgo <= 84) {
        result[dateKey] = (result[dateKey] ?? const HeatmapDay()).add(p.durationSeconds);
      }
    }
  }
  return result;
});

// ---------------------------------------------------------------------------
// App state
// ---------------------------------------------------------------------------
final localeProvider = StateProvider<String>((ref) => 'ko');

/// Tracks current prayer transcript from recording
final currentTranscriptProvider = StateProvider<String>((ref) => '');

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

/// Today's prayer count for free user limiting
final todayPrayerCountProvider = StateProvider<int>((ref) => 0);

/// Whether a prayer/QT recording session is currently active.
/// Used to guard navigation (tab bar, back button) during active sessions.
final isRecordingProvider = StateProvider<bool>((ref) => false);
