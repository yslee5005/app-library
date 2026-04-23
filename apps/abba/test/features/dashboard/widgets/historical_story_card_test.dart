import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/historical_story_card.dart';
import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/widgets/pro_blur.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [HistoricalStoryCard].
///
/// Focus:
///   - Pro user: title, 📖 icon, story title, reference, summary, lesson block
///     (with 💡 bulb + lessonLabel) all render after expanding.
///   - Free user: ProBlur lock — no story body rendered.
void main() {
  group('HistoricalStoryCard', () {
    testWidgets('Pro user: renders title, reference, summary, and lesson block',
        (tester) async {
      final story = TestFixtures.historicalStory();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: HistoricalStoryCard(
                historicalStory: story,
                title: 'Historical Story',
                lessonLabel: 'Lesson',
                isUserPremium: true,
                onUnlock: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header visible + collapsed summary row shows the story title.
      expect(find.text('Historical Story'), findsOneWidget);
      expect(find.text('📖'), findsOneWidget);
      expect(find.text(story.title), findsOneWidget);
      // No ProBlur (unlocked).
      expect(find.byType(ProBlur), findsNothing);

      // Expand the card.
      await tester.tap(find.text('Historical Story'));
      await tester.pumpAndSettle();

      // Reference renders (italic caption).
      expect(find.text(story.reference), findsOneWidget);

      // Summary body text.
      expect(find.text(story.summary), findsOneWidget);

      // Lesson block: label + lesson text + 💡 bulb.
      expect(find.text('Lesson'), findsOneWidget);
      expect(find.text(story.lesson), findsOneWidget);
      expect(find.text('💡'), findsOneWidget);
    });

    testWidgets('Free user: ProBlur lock hides story body', (tester) async {
      final story = TestFixtures.historicalStory();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: HistoricalStoryCard(
              historicalStory: story,
              title: 'Historical Story',
              lessonLabel: 'Lesson',
              isUserPremium: false,
              onUnlock: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Locked path renders ProBlur.
      expect(find.byType(ProBlur), findsOneWidget);

      // Outer title + icon still visible.
      expect(find.text('Historical Story'), findsOneWidget);
      expect(find.text('📖'), findsOneWidget);

      // Story body (title/summary/lesson/reference) is NOT rendered.
      expect(find.text(story.title), findsNothing);
      expect(find.text(story.summary), findsNothing);
      expect(find.text(story.lesson), findsNothing);
      expect(find.text(story.reference), findsNothing);

      // Membership badge from ProBlur.
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.membershipTitle), findsOneWidget);
    });
  });
}
