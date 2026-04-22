import 'package:app_lib_audio_recorder/audio_recorder.dart';
import 'package:app_lib_audio_storage/audio_storage.dart';
import 'package:app_lib_subscriptions/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/settings/view/membership_view.dart';
import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/providers/providers.dart';
import 'package:abba/services/mock/mock_auth_repository.dart';
import 'package:abba/services/mock/mock_community_repository.dart';
import 'package:abba/services/mock/mock_notification_service.dart';
import 'package:abba/services/mock/mock_prayer_repository.dart';
import 'package:abba/services/mock/mock_qt_repository.dart';
import 'package:abba/services/mock/mock_ai_service.dart';
import 'package:abba/services/mock_data.dart';
import 'package:abba/theme/abba_theme.dart';

/// Mock service that reports premium + a caller-controlled
/// [ActiveSubscriptionInfo] so we can exercise the grace banner branch.
class _GraceStubSubscriptionService extends MockSubscriptionService {
  _GraceStubSubscriptionService(this._info);

  final ActiveSubscriptionInfo? _info;

  @override
  Future<bool> get isPremium async => _info != null;

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async =>
      _info != null ? SubscriptionStatus.premium : SubscriptionStatus.free;

  @override
  Future<ActiveSubscriptionInfo?> getActiveSubscription() async => _info;
}

Widget _buildApp({required SubscriptionService service}) {
  final mockData = MockDataService();

  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(MockAuthRepository(mockData)),
      aiServiceProvider.overrideWithValue(MockAiService(mockData)),
      audioRecorderServiceProvider.overrideWithValue(MockAudioRecorderService()),
      audioStorageServiceProvider.overrideWithValue(MockAudioStorageService()),
      prayerRepositoryProvider.overrideWithValue(MockPrayerRepository()),
      communityRepositoryProvider.overrideWithValue(
        MockCommunityRepository(mockData),
      ),
      subscriptionServiceProvider.overrideWithValue(service),
      notificationServiceProvider.overrideWithValue(MockNotificationService()),
      qtRepositoryProvider.overrideWithValue(MockQtRepository(mockData)),
      localeProvider.overrideWith((ref) => 'en'),
    ],
    child: MaterialApp(
      home: const MembershipView(),
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
  group('MembershipView grace period banner', () {
    testWidgets('renders banner + update CTA when billing issue is flagged',
        (tester) async {
      final service = _GraceStubSubscriptionService(
        ActiveSubscriptionInfo(
          productId: 'com.ystech.abba.monthly',
          expiresDate: DateTime.now().add(const Duration(days: 10)),
          willRenew: true,
          periodType: PeriodType.normal,
          billingIssueDetectedAt:
              DateTime.now().subtract(const Duration(days: 2)),
        ),
      );

      await tester.pumpWidget(_buildApp(service: service));
      // Let isPremiumProvider + activeSubscriptionProvider resolve.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Payment issue detected'), findsOneWidget);
      expect(find.text('Update payment'), findsOneWidget);
    });

    testWidgets('stays silent when no billing issue is flagged',
        (tester) async {
      final service = _GraceStubSubscriptionService(
        ActiveSubscriptionInfo(
          productId: 'com.ystech.abba.monthly',
          expiresDate: DateTime.now().add(const Duration(days: 20)),
          willRenew: true,
          periodType: PeriodType.normal,
        ),
      );

      await tester.pumpWidget(_buildApp(service: service));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Payment issue detected'), findsNothing);
      expect(find.text('Update payment'), findsNothing);
    });
  });
}
