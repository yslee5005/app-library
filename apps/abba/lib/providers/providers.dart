import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../models/prayer.dart';
import '../models/qt_passage.dart';
import '../models/user_profile.dart';
import '../services/ai_service.dart';
import '../services/auth_service.dart';
import '../services/mock_data.dart';
import '../services/prayer_repository.dart';
import '../services/stt_service.dart';
import '../services/tts_service.dart';

// ---------------------------------------------------------------------------
// Core data (kept for backward compat, loads JSON mock)
// ---------------------------------------------------------------------------
final mockDataServiceProvider = Provider<MockDataService>((ref) {
  return MockDataService();
});

// ---------------------------------------------------------------------------
// Service providers — mock/real branching via AppConfig.useMock
// These are overridden in main.dart with concrete implementations
// ---------------------------------------------------------------------------
final authServiceProvider = Provider<AuthService>((ref) {
  throw UnimplementedError('authServiceProvider must be overridden');
});

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

// ---------------------------------------------------------------------------
// Auth state
// ---------------------------------------------------------------------------
final authStateProvider = StateProvider<AbbaAuthState>((ref) {
  return const AbbaAuthState();
});

// ---------------------------------------------------------------------------
// Data providers
// ---------------------------------------------------------------------------
final userProfileProvider = FutureProvider<UserProfile>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState.isAuthenticated && authState.user != null) {
    return Future.value(authState.user!);
  }
  return ref.watch(mockDataServiceProvider).getUserProfile();
});

final prayerResultProvider =
    StateProvider<AsyncValue<PrayerResult>>((ref) {
  return const AsyncValue.loading();
});

final qtPassagesProvider = FutureProvider<List<QTPassage>>((ref) {
  return ref.watch(mockDataServiceProvider).getQTPassages();
});

final communityPostsProvider = FutureProvider<List<CommunityPost>>((ref) {
  return ref.watch(mockDataServiceProvider).getCommunityPosts();
});

// ---------------------------------------------------------------------------
// Calendar & Prayer data providers (Phase 2)
// ---------------------------------------------------------------------------

/// Prayers for a specific date (used by Calendar day detail)
final calendarPrayersProvider =
    FutureProvider.family<List<Prayer>, DateTime>((ref, date) {
  final repo = ref.watch(prayerRepositoryProvider);
  return repo.getPrayersByDate(date);
});

/// Monthly prayer dates (for calendar markers)
final monthlyPrayerDaysProvider = FutureProvider.family<Set<DateTime>,
    ({int year, int month})>((ref, params) async {
  final repo = ref.watch(prayerRepositoryProvider);
  final prayers = await repo.getPrayersByMonth(params.year, params.month);
  return prayers.map((p) {
    final d = p.createdAt;
    return DateTime(d.year, d.month, d.day);
  }).toSet();
});

/// Streak data from repository
final streakProvider =
    FutureProvider<({int current, int best})>((ref) {
  final repo = ref.watch(prayerRepositoryProvider);
  return repo.getStreak();
});

// ---------------------------------------------------------------------------
// App state
// ---------------------------------------------------------------------------
final localeProvider = StateProvider<String>((ref) => 'en');

/// Tracks current prayer transcript from recording
final currentTranscriptProvider = StateProvider<String>((ref) => '');

/// Today's prayer count for free user limiting
final todayPrayerCountProvider = StateProvider<int>((ref) => 0);
