import 'package:app_lib_audio_recorder/audio_recorder.dart';
import 'package:app_lib_audio_storage/audio_storage.dart';
import 'package:app_lib_subscriptions/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/providers/providers.dart';
import 'package:abba/services/mock/mock_auth_repository.dart';
import 'package:abba/services/mock/mock_community_repository.dart';
import 'package:abba/services/mock/mock_notification_service.dart';
import 'package:abba/services/mock/mock_prayer_repository.dart';
import 'package:abba/services/mock/mock_qt_repository.dart';
import 'package:abba/services/mock_data.dart';
import 'package:abba/services/mock/mock_ai_service.dart';
import 'package:abba/theme/abba_theme.dart';

/// Wraps a widget with all necessary providers for testing
Widget buildTestApp(
  Widget child, {
  String locale = 'en',
  List<dynamic>? overrides,
}) {
  final mockData = MockDataService();

  final defaultOverrides = [
    authRepositoryProvider.overrideWithValue(MockAuthRepository(mockData)),
    aiServiceProvider.overrideWithValue(MockAiService(mockData)),
    audioRecorderServiceProvider.overrideWithValue(MockAudioRecorderService()),
    audioStorageServiceProvider.overrideWithValue(MockAudioStorageService()),
    prayerRepositoryProvider.overrideWithValue(MockPrayerRepository()),
    communityRepositoryProvider.overrideWithValue(
      MockCommunityRepository(mockData),
    ),
    subscriptionServiceProvider.overrideWithValue(MockSubscriptionService()),
    notificationServiceProvider.overrideWithValue(MockNotificationService()),
    qtRepositoryProvider.overrideWithValue(MockQtRepository(mockData)),
    localeProvider.overrideWith((ref) => locale),
  ];

  return ProviderScope(
    overrides: [...defaultOverrides, if (overrides != null) ...overrides],
    child: MaterialApp(
      home: child,
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

/// Convenience constant for a test PrayerResult
const testPrayerResult = PrayerResult(
  scripture: Scripture(
    verseEn: 'The LORD is my shepherd.',
    verseKo: '여호와는 나의 목자시니.',
    reference: 'Psalm 23:1',
  ),
  bibleStory: BibleStory(
    titleEn: 'David',
    titleKo: '다윗',
    summaryEn: 'David was a shepherd.',
    summaryKo: '다윗은 양치기였습니다.',
  ),
  testimonyEn: 'Test prayer transcript.',
  testimonyKo: '테스트 기도 내용.',
  guidance: Guidance(
    contentEn: 'Guidance content.',
    contentKo: '조언 내용.',
    isPremium: true,
  ),
  aiPrayer: AiPrayer(
    textEn: 'A prayer for you.',
    textKo: '당신을 위한 기도.',
    isPremium: true,
  ),
  originalLanguage: OriginalLanguage(
    word: 'רֹעִי',
    transliteration: "ro'i",
    language: 'Hebrew',
    meaningEn: 'my shepherd',
    meaningKo: '나의 목자',
    contextEn: 'Context.',
    contextKo: '문맥.',
    isPremium: true,
  ),
);
