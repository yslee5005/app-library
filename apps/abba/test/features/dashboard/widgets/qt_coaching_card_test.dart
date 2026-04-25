import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/qt_coaching_card.dart';
import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/models/qt_meditation_result.dart';
import 'package:abba/providers/providers.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [QtCoachingCard].
///
/// Focus:
///   - Pro + data: 4 score rows, strengths, improvements, level badge.
///   - Pro + loading: spinner + loading message.
///   - Pro + error: retry button triggers provider invalidate.
///   - Free: ProBlur lock (no network call, no data).
///
/// Strategy: we override `qtCoachingProvider` per test to force the
/// AsyncValue state without involving the real AI service.
void main() {
  group('QtCoachingCard', () {
    testWidgets('Pro user + data: shows 4 scores, strengths, improvements, '
        'level badge, and feedback', (tester) async {
      final coaching = TestFixtures.qtCoaching();

      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: QtCoachingCard(
                locale: 'en',
                isUserPremium: true,
                onUnlock: _noop,
              ),
            ),
          ),
          overrides: [qtCoachingProvider.overrideWith((ref) => coaching)],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Title (with 🌿 growing badge appended) + 🎯 icon.
      expect(find.text('🎯'), findsOneWidget);
      expect(find.textContaining(l10n.qtCoachingTitle), findsWidgets);
      // Growing level badge emoji ('🌿 Growing') — 'growing' per fixture.
      expect(find.textContaining(l10n.qtCoachingLevelGrowing), findsOneWidget);

      // All 4 score axis labels.
      expect(find.text(l10n.qtCoachingScoreComprehension), findsOneWidget);
      expect(find.text(l10n.qtCoachingScoreApplication), findsOneWidget);
      expect(find.text(l10n.qtCoachingScoreDepth), findsOneWidget);
      expect(find.text(l10n.qtCoachingScoreAuthenticity), findsOneWidget);

      // Score text labels e.g. '4/5', '3/5', '5/5'.
      expect(find.text('4/5'), findsWidgets); // comprehension + authenticity
      expect(find.text('3/5'), findsOneWidget); // application
      expect(find.text('5/5'), findsOneWidget); // depth

      // Strengths section title + at least one bullet.
      expect(find.text(l10n.qtCoachingStrengthsTitle), findsOneWidget);
      expect(
        find.text('You tied the passage to your morning commute.'),
        findsOneWidget,
      );

      // Improvements section title + bullet.
      expect(find.text(l10n.qtCoachingImprovementsTitle), findsOneWidget);
      expect(
        find.text('Consider memorizing one key word for the week.'),
        findsOneWidget,
      );

      // Overall feedback (English variant).
      expect(
        find.text('Your meditation shows deep engagement with the text.'),
        findsOneWidget,
      );
    });

    testWidgets('Pro user + loading: shows loading message + spinner', (
      tester,
    ) async {
      // Never-completing future → loading state forever.
      final completer = Completer<QtCoaching>();
      addTearDown(() {
        if (!completer.isCompleted) {
          completer.complete(TestFixtures.qtCoaching());
        }
      });

      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: QtCoachingCard(
                locale: 'en',
                isUserPremium: true,
                onUnlock: _noop,
              ),
            ),
          ),
          overrides: [
            qtCoachingProvider.overrideWith((ref) => completer.future),
          ],
        ),
      );
      // Only `pump()` — don't settle (future never completes).
      await tester.pump();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      expect(find.text(l10n.qtCoachingLoadingText), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Pro user + error: shows retry button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: QtCoachingCard(
                locale: 'en',
                isUserPremium: true,
                onUnlock: _noop,
              ),
            ),
          ),
          overrides: [
            qtCoachingProvider.overrideWith(
              (ref) => Future<QtCoaching>.error(StateError('boom')),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Error message + retry button visible.
      expect(find.text(l10n.qtCoachingErrorText), findsWidgets);
      expect(find.text(l10n.qtCoachingRetryButton), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('Free user: shows ProBlur lock without reading provider', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: QtCoachingCard(
              locale: 'en',
              isUserPremium: false,
              onUnlock: _noop,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Title + lock emoji visible.
      expect(find.text('🎯'), findsOneWidget);
      expect(find.text(l10n.qtCoachingTitle), findsOneWidget);

      // No scores / strengths rendered.
      expect(find.text(l10n.qtCoachingScoreComprehension), findsNothing);
      expect(find.text(l10n.qtCoachingStrengthsTitle), findsNothing);

      // Membership badge from ProBlur.
      expect(find.text(l10n.membershipTitle), findsOneWidget);
    });
  });
}

void _noop() {}
