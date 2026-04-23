import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/bible_story_card.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [BibleStoryCard].
///
/// Focus:
///   - Header shows card title + 📖 icon + `bibleStory.title` as summary.
///   - Tapping expands to reveal `bibleStory.summary` body.
void main() {
  group('BibleStoryCard', () {
    testWidgets('collapsed: shows title + 📖 icon + story title summary',
        (tester) async {
      final story = TestFixtures.bibleStory();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: BibleStoryCard(
                bibleStory: story,
                title: 'Bible Story',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header is always visible.
      expect(find.text('Bible Story'), findsOneWidget);
      expect(find.text('📖'), findsOneWidget);

      // Collapsed summary line renders the story title.
      expect(find.text(story.title), findsOneWidget);

      // Body (summary paragraph) is not yet rendered while collapsed.
      expect(find.text(story.summary), findsNothing);
    });

    testWidgets('expanded: tapping header reveals story title + summary body',
        (tester) async {
      final story = TestFixtures.bibleStory();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: BibleStoryCard(
                bibleStory: story,
                title: 'Bible Story',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bible Story'));
      await tester.pumpAndSettle();

      // Both the collapsed summary row AND the expanded bold title render
      // the story title string, so we expect it to appear at least once.
      expect(find.text(story.title), findsWidgets);

      // Expanded body paragraph is now visible.
      expect(find.text(story.summary), findsOneWidget);
    });
  });
}
