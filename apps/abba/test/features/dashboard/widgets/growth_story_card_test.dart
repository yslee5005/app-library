import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/growth_story_card.dart';
import 'package:abba/l10n/generated/app_localizations.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [GrowthStoryCard].
///
/// Focus:
///   - Pro user sees title/summary/lesson + 🌱 icon.
///   - Free user sees ProBlur lock (body hidden).
///   - Lesson label is wired through the `lessonLabel` prop.
void main() {
  group('GrowthStoryCard', () {
    testWidgets('Pro user: renders title, summary, lesson, and seedling icon',
        (tester) async {
      final story = TestFixtures.growthStory();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: GrowthStoryCard(
                growthStory: story,
                title: 'Growth Story',
                lessonLabel: 'Lesson',
                isUserPremium: true,
                onUnlock: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Outer ProBlur header title + seedling icon.
      expect(find.text('Growth Story'), findsOneWidget);
      expect(find.text('🌱'), findsOneWidget);

      // Inner body: story title + summary.
      expect(find.text(story.title), findsOneWidget);
      expect(find.text(story.summary), findsOneWidget);

      // Lesson block: label + lesson body + 💡 bulb.
      expect(find.text('Lesson'), findsOneWidget);
      expect(find.text(story.lesson), findsOneWidget);
      expect(find.text('💡'), findsOneWidget);
    });

    testWidgets('Free user: ProBlur lock hides story body', (tester) async {
      final story = TestFixtures.growthStory();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: GrowthStoryCard(
              growthStory: story,
              title: 'Growth Story',
              lessonLabel: 'Lesson',
              isUserPremium: false,
              onUnlock: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Locked ProBlur still shows outer title + icon.
      expect(find.text('Growth Story'), findsOneWidget);
      expect(find.text('🌱'), findsOneWidget);

      // But story body + lesson label + lesson text are not rendered.
      expect(find.text(story.title), findsNothing);
      expect(find.text(story.summary), findsNothing);
      expect(find.text(story.lesson), findsNothing);
      expect(find.text('Lesson'), findsNothing);

      // Membership badge from ProBlur.
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.membershipTitle), findsOneWidget);
    });
  });
}
