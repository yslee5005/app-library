import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/testimony_card.dart';

import '../../../helpers/test_app.dart';

/// Widget tests for [TestimonyCard].
///
/// Focus:
///   - Short transcript (<= 40 chars): summary equals full transcript.
///   - Long transcript: summary is truncated with `...`; full body appears on expand.
///   - Helper text renders in expanded body when provided.
void main() {
  group('TestimonyCard', () {
    testWidgets('short transcript: summary equals full text', (tester) async {
      const shortText = 'Lord, thank You for today.'; // 27 chars

      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: TestimonyCard(
                testimony: shortText,
                title: 'My Testimony',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header always visible.
      expect(find.text('My Testimony'), findsOneWidget);
      expect(find.text('✍️'), findsOneWidget);

      // Collapsed summary is the full text (no truncation ellipsis).
      expect(find.text(shortText), findsOneWidget);
    });

    testWidgets('long transcript: summary is truncated with ellipsis; '
        'tapping reveals full body', (tester) async {
      const longText =
          'Heavenly Father, this morning I woke with a heavy heart '
          'but Your presence found me before the sun did.';

      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: TestimonyCard(
                testimony: longText,
                title: 'My Testimony',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Collapsed: truncated summary ends in '...' and does NOT contain the
      // tail phrase which lives beyond the 40-char cutoff.
      final truncated = '${longText.substring(0, 40)}...';
      expect(find.text(truncated), findsOneWidget);
      expect(find.text(longText), findsNothing);

      // Expand → full transcript visible.
      await tester.tap(find.text('My Testimony'));
      await tester.pumpAndSettle();
      expect(find.text(longText), findsOneWidget);
    });

    testWidgets('expanded: helper text renders above transcript when provided',
        (tester) async {
      const text = 'A prayer from the heart this morning, with gratitude.';

      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: TestimonyCard(
                testimony: text,
                title: 'My Testimony',
                helperText: 'Auto-transcribed from your voice.',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Helper text only shows in expanded body.
      expect(find.text('Auto-transcribed from your voice.'), findsNothing);

      await tester.tap(find.text('My Testimony'));
      await tester.pumpAndSettle();

      expect(find.text('Auto-transcribed from your voice.'), findsOneWidget);
      expect(find.text(text), findsOneWidget);
    });
  });
}
