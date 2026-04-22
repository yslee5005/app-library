import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/meditation_summary_card.dart';
import 'package:abba/models/qt_meditation_result.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [MeditationSummaryCard].
///
/// Focus:
///   - Renders summary + topic + insight when all three are present.
///   - Returns SizedBox.shrink() when the summary model is empty (legacy rows).
///   - Hides the insight section when insight is empty.
///   - Hides the topic row when topic is empty.
void main() {
  group('MeditationSummaryCard', () {
    testWidgets('renders all three fields (summary, topic, insight)',
        (tester) async {
      final summary = TestFixtures.meditationSummary();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: MeditationSummaryCard(
                meditationSummary: summary,
                title: "Today's Meditation",
                topicLabel: 'Topic',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Today's Meditation"), findsOneWidget);
      expect(find.text('🌱'), findsOneWidget);

      // summary body
      expect(find.text(summary.summary), findsOneWidget);

      // topic row — renders "{label} · " prefix + topic value
      expect(find.text(summary.topic), findsOneWidget);
      expect(find.text('Topic · '), findsOneWidget);

      // insight section — 🔍 magnifier + insight body
      expect(find.text('🔍'), findsOneWidget);
      expect(find.text(summary.insight), findsOneWidget);
    });

    testWidgets('empty summary → renders SizedBox.shrink (hidden)',
        (tester) async {
      const empty = MeditationSummary(summary: '', topic: '', insight: '');

      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: MeditationSummaryCard(
              meditationSummary: empty,
              title: "Today's Meditation",
              topicLabel: 'Topic',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The card should not render its header when empty.
      expect(find.text("Today's Meditation"), findsNothing);
      expect(find.text('🌱'), findsNothing);
      expect(find.text('🔍'), findsNothing);
    });

    testWidgets('insight empty → insight section is hidden', (tester) async {
      final noInsight = TestFixtures.meditationSummary(insight: '');

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: MeditationSummaryCard(
                meditationSummary: noInsight,
                title: "Today's Meditation",
                topicLabel: 'Topic',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Summary + topic still visible.
      expect(find.text(noInsight.summary), findsOneWidget);
      expect(find.text(noInsight.topic), findsOneWidget);

      // Insight section is hidden → no 🔍 icon.
      expect(find.text('🔍'), findsNothing);
    });

    testWidgets('topic empty → topic row is hidden', (tester) async {
      final noTopic = TestFixtures.meditationSummary(topic: '');

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: MeditationSummaryCard(
                meditationSummary: noTopic,
                title: "Today's Meditation",
                topicLabel: 'Topic',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Summary + insight still visible.
      expect(find.text(noTopic.summary), findsOneWidget);
      expect(find.text(noTopic.insight), findsOneWidget);

      // Topic prefix label is not rendered.
      expect(find.text('Topic · '), findsNothing);
    });
  });
}
