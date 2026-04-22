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

/// Stub that returns a caller-controlled [OfferingPrices].
class _StubPricesSubscriptionService extends MockSubscriptionService {
  _StubPricesSubscriptionService(this._prices);

  final OfferingPrices? _prices;

  @override
  Future<OfferingPrices?> getOfferingPrices() async => _prices;
}

Widget _buildMembershipTestApp({
  required SubscriptionService service,
  String locale = 'en',
}) {
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
      localeProvider.overrideWith((ref) => locale),
    ],
    child: MaterialApp(
      home: const MembershipView(),
      theme: abbaTheme(),
      locale: Locale(locale),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
    ),
  );
}

void main() {
  group('MembershipView dynamic pricing', () {
    testWidgets(
      'shows store-localized yearly price when offering is available',
      (tester) async {
        final service = _StubPricesSubscriptionService(
          const OfferingPrices(
            monthlyPriceString: '₩9,900',
            yearlyPriceString: '₩69,000',
            yearlyPriceMonthlyString: '₩5,750',
            savingsPercent: 42,
            currencyCode: 'KRW',
          ),
        );

        await tester.pumpWidget(_buildMembershipTestApp(service: service));
        // Allow the FutureProvider to resolve.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        // Default tab is yearly (_selectedPlan = 1) → yearly price shown.
        expect(find.text('₩69,000'), findsOneWidget);
        // ARB default yearly price should NOT appear.
        expect(find.text(r'$49.99 / yr'), findsNothing);
      },
    );

    testWidgets(
      'falls back to ARB yearly price when offering returns null',
      (tester) async {
        // Plain MockSubscriptionService.getOfferingPrices returns a USD
        // OfferingPrices by default; stub a null-returning variant.
        final service = _StubPricesSubscriptionService(null);

        await tester.pumpWidget(_buildMembershipTestApp(service: service));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        // ARB (English) default for yearlyPrice in app_en.arb is "$49.99 / yr".
        expect(find.text(r'$49.99 / yr'), findsOneWidget);
      },
    );
  });
}
