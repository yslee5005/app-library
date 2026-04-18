import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:abba/app.dart';
import 'package:abba/providers/providers.dart';
import 'package:abba/services/mock/mock_ai_service.dart';
import 'package:abba/services/mock/mock_auth_repository.dart';
import 'package:abba/services/mock/mock_community_repository.dart';
import 'package:abba/services/mock/mock_notification_service.dart';
import 'package:abba/services/mock/mock_prayer_repository.dart';
import 'package:abba/services/mock/mock_qt_repository.dart';
import 'package:abba/services/mock/mock_stt_service.dart';
import 'package:abba/services/mock/mock_subscription_service.dart';
import 'package:abba/services/mock_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full E2E Flow', () {
    testWidgets('Welcome → Login → Home navigation', (tester) async {
      final mockData = MockDataService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider
                .overrideWithValue(MockAuthRepository(mockData)),
            aiServiceProvider
                .overrideWithValue(MockAiService(mockData)),
            sttServiceProvider.overrideWithValue(MockSttService()),
            prayerRepositoryProvider
                .overrideWithValue(MockPrayerRepository()),
            communityRepositoryProvider
                .overrideWithValue(MockCommunityRepository(mockData)),
            subscriptionServiceProvider
                .overrideWithValue(MockSubscriptionService()),
            notificationServiceProvider
                .overrideWithValue(MockNotificationService()),
            qtRepositoryProvider
                .overrideWithValue(MockQtRepository(mockData)),
          ],
          child: const AbbaApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Step 1: Welcome screen
      expect(find.text('Abba'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);

      // Step 2: Tap "Get Started" → navigate to Login
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Step 3: Login screen — tap Google login
      expect(find.text('Continue with Google'), findsOneWidget);
      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Step 4: Home screen with pray/QT buttons
      expect(find.text('Pray'), findsOneWidget);
      expect(find.text('Quiet Time'), findsOneWidget);
    });

    testWidgets('Tab navigation works', (tester) async {
      final mockData = MockDataService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider
                .overrideWithValue(MockAuthRepository(mockData)),
            aiServiceProvider
                .overrideWithValue(MockAiService(mockData)),
            sttServiceProvider.overrideWithValue(MockSttService()),
            prayerRepositoryProvider
                .overrideWithValue(MockPrayerRepository()),
            communityRepositoryProvider
                .overrideWithValue(MockCommunityRepository(mockData)),
            subscriptionServiceProvider
                .overrideWithValue(MockSubscriptionService()),
            notificationServiceProvider
                .overrideWithValue(MockNotificationService()),
            qtRepositoryProvider
                .overrideWithValue(MockQtRepository(mockData)),
          ],
          child: const AbbaApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate past welcome and login
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tab to Calendar
      await tester.tap(find.text('📅'));
      await tester.pumpAndSettle();

      // Tab to Community
      await tester.tap(find.text('🌻'));
      await tester.pumpAndSettle();

      // Tab to Settings
      await tester.tap(find.text('⚙️'));
      await tester.pumpAndSettle();

      // Tab back to Home
      await tester.tap(find.text('🌳'));
      await tester.pumpAndSettle();

      expect(find.text('Pray'), findsOneWidget);
    });
  });
}
