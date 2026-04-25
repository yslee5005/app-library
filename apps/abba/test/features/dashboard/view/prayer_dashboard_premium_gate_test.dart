import 'package:app_lib_audio_recorder/audio_recorder.dart';
import 'package:app_lib_audio_storage/audio_storage.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:app_lib_subscriptions/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/view/prayer_dashboard_view.dart';
import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/providers/prayer_sections_notifier.dart';
import 'package:abba/providers/providers.dart';
import 'package:abba/services/ai_service.dart';
import 'package:abba/services/mock/mock_ai_service.dart';
import 'package:abba/services/mock/mock_auth_repository.dart';
import 'package:abba/services/mock/mock_community_repository.dart';
import 'package:abba/services/mock/mock_notification_service.dart';
import 'package:abba/services/mock/mock_prayer_repository.dart';
import 'package:abba/services/mock/mock_qt_repository.dart';
import 'package:abba/services/mock_data.dart';
import 'package:abba/services/recent_references_service.dart';
import 'package:abba/theme/abba_theme.dart';

/// Wave C (2026-04-24) — Free / Trial users must NEVER trigger Premium AI.
///
/// Recording wrapper around [MockAiService] — counts how many times
/// [analyzePrayerPremium] is invoked. Used to assert tier-based gating.
class _RecordingAiService extends MockAiService {
  _RecordingAiService(super.mockData);

  int premiumCallCount = 0;

  @override
  Future<PremiumContent> analyzePrayerPremium({
    required String transcript,
    required String locale,
  }) async {
    premiumCallCount++;
    return super.analyzePrayerPremium(
      transcript: transcript,
      locale: locale,
    );
  }
}

/// Subscription stub that reports a specific [PeriodType] so the dashboard's
/// `effectiveTierProvider` resolves to free / trial / pro deterministically.
class _TierStubSubscriptionService extends MockSubscriptionService {
  _TierStubSubscriptionService({required this.tier});

  /// 'free' | 'trial' | 'pro'
  final String tier;

  @override
  Future<bool> get isPremium async => tier != 'free';

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    if (tier == 'free') return SubscriptionStatus.free;
    return SubscriptionStatus.premium;
  }

  @override
  Future<ActiveSubscriptionInfo?> getActiveSubscription() async {
    if (tier == 'free') return null;
    return ActiveSubscriptionInfo(
      productId: 'com.ystech.abba.monthly',
      expiresDate: DateTime.now().add(const Duration(days: 30)),
      willRenew: true,
      periodType: tier == 'trial' ? PeriodType.trial : PeriodType.normal,
    );
  }
}

/// Pre-populates [prayerSectionsProvider] with T1 + T2 so that the dashboard
/// is past the awaitingT1 spinner and the T3 trigger gate has its required
/// context.
void _seedT1T2(WidgetRef ref) {
  final notifier = ref.read(prayerSectionsProvider.notifier);
  notifier.setT1(
    summary: const PrayerSummary(
      gratitude: ['Family'],
      petition: ['Wisdom'],
      intercession: ['Friends'],
    ),
    scripture: const Scripture(
      reference: 'Psalm 23:1',
      verse: 'The LORD is my shepherd.',
    ),
  );
  notifier.setT2(
    bibleStory: const BibleStory(
      title: 'David',
      summary: 'David was a shepherd.',
    ),
    testimony: 'Lord, thank you for today.',
  );
}

/// Wraps PrayerDashboardView so the section state is seeded once the widget
/// tree is built (cannot mutate the notifier before ProviderScope exists).
class _Seeded extends ConsumerStatefulWidget {
  const _Seeded();

  @override
  ConsumerState<_Seeded> createState() => _SeededState();
}

class _SeededState extends ConsumerState<_Seeded> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _seedT1T2(ref);
    });
  }

  @override
  Widget build(BuildContext context) => const PrayerDashboardView();
}

Widget _buildHarness({required _RecordingAiService ai, required String tier}) {
  final mockData = MockDataService();
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(MockAuthRepository(mockData)),
      aiServiceProvider.overrideWithValue(ai),
      audioRecorderServiceProvider.overrideWithValue(
        MockAudioRecorderService(),
      ),
      audioStorageServiceProvider.overrideWithValue(MockAudioStorageService()),
      prayerRepositoryProvider.overrideWithValue(MockPrayerRepository()),
      communityRepositoryProvider.overrideWithValue(
        MockCommunityRepository(mockData),
      ),
      subscriptionServiceProvider.overrideWithValue(
        _TierStubSubscriptionService(tier: tier),
      ),
      notificationServiceProvider.overrideWithValue(MockNotificationService()),
      qtRepositoryProvider.overrideWithValue(MockQtRepository(mockData)),
      recentReferencesServiceProvider.overrideWithValue(
        NoopRecentReferencesService(),
      ),
      localeProvider.overrideWith((ref) => 'en'),
    ],
    child: MaterialApp(
      home: const _Seeded(),
      theme: abbaTheme(),
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ko')],
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // PrayerDashboardView's initState calls prayerLog.info(...) which
    // dereferences the global appLogger; must be initialised in tests.
    appLogger = Logger(
      config: LogConfig.development,
      outputs: const [NoopOutput()],
    );
  });

  group('PrayerDashboardView Premium gate (Wave C)', () {
    testWidgets('Free user: analyzePrayerPremium is NEVER invoked', (
      tester,
    ) async {
      final ai = _RecordingAiService(MockDataService());
      await tester.pumpWidget(_buildHarness(ai: ai, tier: 'free'));
      // Initial seed pump.
      await tester.pump();
      // Walk past the 3s fallback timer.
      await tester.pump(const Duration(seconds: 4));
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        ai.premiumCallCount,
        0,
        reason: 'Free users must never trigger Premium AI (Wave C policy).',
      );
    });

    testWidgets('Trial user: analyzePrayerPremium is NEVER invoked', (
      tester,
    ) async {
      final ai = _RecordingAiService(MockDataService());
      await tester.pumpWidget(_buildHarness(ai: ai, tier: 'trial'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 4));
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        ai.premiumCallCount,
        0,
        reason:
            'Trial users get T1/T2 daily 3-cap but T3 Premium is Pro-only.',
      );
    });

    testWidgets('Pro user: analyzePrayerPremium IS invoked exactly once', (
      tester,
    ) async {
      final ai = _RecordingAiService(MockDataService());
      await tester.pumpWidget(_buildHarness(ai: ai, tier: 'pro'));
      await tester.pump();
      // 3s fallback timer + provider future resolution.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
      // Allow the await chain inside _loadPremiumContent to settle.
      await tester.pump(const Duration(seconds: 2));

      expect(
        ai.premiumCallCount,
        1,
        reason:
            'Pro users should trigger T3 exactly once via the 3s fallback or '
            'visibility detector — never more (sections.t3Triggered dedup).',
      );
    });
  });
}
