import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/application_card.dart';
import 'package:abba/l10n/generated/app_localizations.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [ApplicationCard].
///
/// Focus:
///   - hasTimeBlocks=true: renders 3 time-block rows (Morning/Day/Evening)
///     with their labels + emojis + action text after expanding.
///   - Legacy single `action`: renders the action body in the expanded area
///     and uses it (truncated if > 40 chars) as the collapsed summary.
void main() {
  group('ApplicationCard', () {
    testWidgets('3 time-blocks: Morning + Day + Evening actions visible '
        'with labels and emojis', (tester) async {
      final app = TestFixtures.applicationSuggestion();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: ApplicationCard(application: app, title: 'Application'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header visible immediately.
      expect(find.text('Application'), findsOneWidget);
      expect(find.text('✏️'), findsOneWidget);

      // Expand to reveal time-block body.
      await tester.tap(find.text('Application'));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // All 3 block labels render.
      expect(find.text(l10n.applicationMorningLabel), findsOneWidget);
      expect(find.text(l10n.applicationDayLabel), findsOneWidget);
      expect(find.text(l10n.applicationEveningLabel), findsOneWidget);

      // Block emojis.
      expect(find.text('🌅'), findsOneWidget);
      expect(find.text('☀️'), findsOneWidget);
      expect(find.text('🌙'), findsOneWidget);

      // Each action's body renders.
      expect(find.text(app.morningAction), findsOneWidget);
      expect(find.text(app.dayAction), findsOneWidget);
      expect(find.text(app.eveningAction), findsOneWidget);
    });

    testWidgets('legacy single action: renders single-line body on expand', (
      tester,
    ) async {
      final app = TestFixtures.applicationSuggestionLegacy();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: ApplicationCard(application: app, title: 'Application'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Expand.
      await tester.tap(find.text('Application'));
      await tester.pumpAndSettle();

      // Legacy layout — no time-block labels/emojis.
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.applicationMorningLabel), findsNothing);
      expect(find.text('🌅'), findsNothing);

      // Legacy action body visible in expanded content.
      expect(find.text(app.action), findsOneWidget);
    });
  });
}
