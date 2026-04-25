import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/prayer_summary_card.dart';
import 'package:abba/models/prayer.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [PrayerSummaryCard].
///
/// Focus:
///   - Expanded: renders all 3 bucket labels (gratitude/petition/intercession)
///     plus every bullet item.
///   - Collapsed summary line joins non-empty buckets with counts.
///   - Empty bucket hides that label entirely.
void main() {
  group('PrayerSummaryCard', () {
    testWidgets('expanded: renders all 3 bucket labels and bullets', (
      tester,
    ) async {
      final summary = TestFixtures.prayerSummary();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: PrayerSummaryCard(
                prayerSummary: summary,
                title: 'Prayer Summary',
                gratitudeLabel: 'Gratitude',
                petitionLabel: 'Petition',
                intercessionLabel: 'Intercession',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header.
      expect(find.text('Prayer Summary'), findsOneWidget);
      expect(find.text('📋'), findsOneWidget);

      // Collapsed summary row: "Gratitude 2 · Petition 1 · Intercession 2"
      expect(
        find.text('Gratitude 2 · Petition 1 · Intercession 2'),
        findsOneWidget,
      );

      // Expand to reveal the sections.
      await tester.tap(find.text('Prayer Summary'));
      await tester.pumpAndSettle();

      // All 3 bucket labels render as pills.
      expect(find.text('Gratitude'), findsOneWidget);
      expect(find.text('Petition'), findsOneWidget);
      expect(find.text('Intercession'), findsOneWidget);

      // All bullet items render.
      for (final item in summary.gratitude) {
        expect(find.text(item), findsOneWidget);
      }
      for (final item in summary.petition) {
        expect(find.text(item), findsOneWidget);
      }
      for (final item in summary.intercession) {
        expect(find.text(item), findsOneWidget);
      }
    });

    testWidgets('empty intercession bucket is omitted from summary and body', (
      tester,
    ) async {
      const summary = PrayerSummary(
        gratitude: ['Thanks for today.'],
        petition: ['Grant wisdom.'],
        intercession: [],
      );

      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: PrayerSummaryCard(
                prayerSummary: summary,
                title: 'Prayer Summary',
                gratitudeLabel: 'Gratitude',
                petitionLabel: 'Petition',
                intercessionLabel: 'Intercession',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Collapsed summary includes only the non-empty buckets.
      expect(find.text('Gratitude 1 · Petition 1'), findsOneWidget);

      await tester.tap(find.text('Prayer Summary'));
      await tester.pumpAndSettle();

      // Intercession label is NOT rendered (empty bucket).
      expect(find.text('Intercession'), findsNothing);

      // Remaining buckets + items still present.
      expect(find.text('Gratitude'), findsOneWidget);
      expect(find.text('Petition'), findsOneWidget);
      expect(find.text('Thanks for today.'), findsOneWidget);
      expect(find.text('Grant wisdom.'), findsOneWidget);
    });
  });
}
