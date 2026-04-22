import 'package:app_lib_audio_recorder/audio_recorder.dart';
import 'package:app_lib_audio_storage/audio_storage.dart';
import 'package:app_lib_subscriptions/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/qt/view/qt_view.dart';
import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/models/qt_passage.dart';
import 'package:abba/providers/providers.dart';
import 'package:abba/services/mock/mock_ai_service.dart';
import 'package:abba/services/mock/mock_auth_repository.dart';
import 'package:abba/services/mock/mock_community_repository.dart';
import 'package:abba/services/mock/mock_notification_service.dart';
import 'package:abba/services/mock/mock_prayer_repository.dart';
import 'package:abba/services/mock_data.dart';
import 'package:abba/services/qt_repository.dart';
import 'package:abba/theme/abba_theme.dart';
import '../helpers/test_app.dart';

/// Builds a test app using a specific QtRepository — avoids the duplicate-
/// override error that Riverpod 3 throws when `buildTestApp`'s default
/// [qtRepositoryProvider] override collides with a per-test override.
Widget buildTestAppWithQtRepo(QtRepository qtRepo, {String locale = 'en'}) {
  final mockData = MockDataService();
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(MockAuthRepository(mockData)),
      aiServiceProvider.overrideWithValue(MockAiService(mockData)),
      audioRecorderServiceProvider
          .overrideWithValue(MockAudioRecorderService()),
      audioStorageServiceProvider.overrideWithValue(MockAudioStorageService()),
      prayerRepositoryProvider.overrideWithValue(MockPrayerRepository()),
      communityRepositoryProvider.overrideWithValue(
        MockCommunityRepository(mockData),
      ),
      subscriptionServiceProvider.overrideWithValue(MockSubscriptionService()),
      notificationServiceProvider.overrideWithValue(MockNotificationService()),
      qtRepositoryProvider.overrideWithValue(qtRepo),
      localeProvider.overrideWith((ref) => locale),
    ],
    child: MaterialApp(
      home: const QtView(),
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
        Locale('ja'),
        Locale('es'),
        Locale('zh'),
      ],
    ),
  );
}

void main() {
  group('QtView', () {
    testWidgets('renders QT page', (tester) async {
      await tester.pumpWidget(buildTestApp(const QtView()));
      // Advance past all reveal timers (5 cards × 600ms + 400ms = ~3400ms)
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should render a Scaffold
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('shows error state with Retry when repository throws',
        (tester) async {
      int callCount = 0;
      await tester.pumpWidget(
        buildTestAppWithQtRepo(
          _FailingQtRepository(onCall: () => callCount++),
        ),
      );
      // Let the FutureProvider's async future settle, then pump frames.
      // runAsync processes real microtasks (needed for FutureProvider's
      // async-gap), then pump() flushes the resulting state rebuild.
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      });
      await tester.pump();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(
        find.text(
          "Couldn't load today's passages. Please check your connection.",
        ),
        findsOneWidget,
      );
      expect(find.text('Try again'), findsOneWidget);
      expect(callCount, 1);
    });

    testWidgets('Retry button re-invokes repository', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(
        buildTestAppWithQtRepo(
          _FailingQtRepository(onCall: () => callCount++),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(callCount, 1);

      await tester.tap(find.text('Try again'));
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      });
      await tester.pump();

      expect(
        callCount,
        2,
        reason: 'Retry should invalidate and re-fetch the provider',
      );
    });

    testWidgets('shows error state when repository returns empty list',
        (tester) async {
      await tester.pumpWidget(
        buildTestAppWithQtRepo(_EmptyQtRepository()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });
  });
}

class _FailingQtRepository implements QtRepository {
  final void Function()? onCall;
  _FailingQtRepository({this.onCall});

  @override
  Future<List<QTPassage>> getTodayPassages({required String locale}) async {
    onCall?.call();
    throw Exception('network-down');
  }
}

class _EmptyQtRepository implements QtRepository {
  @override
  Future<List<QTPassage>> getTodayPassages({required String locale}) async {
    return const <QTPassage>[];
  }
}
