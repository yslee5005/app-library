import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/prayer_coaching_card.dart';
import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/providers/providers.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [PrayerCoachingCard].
///
/// Focus (mirrors `qt_coaching_card_test.dart`):
///   - Pro + data: 4 score axis labels, strengths, improvements, level badge,
///     overall feedback text visible.
///   - Pro + loading: spinner + loading message.
///   - Pro + error: retry button visible.
///   - Free: ProBlur lock — no provider read, no score labels.
///
/// Strategy: override `prayerCoachingProvider` per test to force the desired
/// AsyncValue state without involving the real AI service.
void main() {
  group('PrayerCoachingCard', () {
    testWidgets('Pro user + data: shows 4 scores, strengths, improvements, '
        'level badge, and feedback', (tester) async {
      final coaching = TestFixtures.prayerCoaching();

      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: PrayerCoachingCard(
                locale: 'en',
                isUserPremium: true,
                onUnlock: _noop,
              ),
            ),
          ),
          overrides: [
            prayerCoachingProvider.overrideWith((ref) => coaching),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // 🎯 icon always present + title (possibly with badge appended).
      expect(find.text('🎯'), findsOneWidget);
      expect(find.textContaining(l10n.coachingTitle), findsWidgets);

      // Level badge ('🌿 Growing') — from 'growing' fixture level.
      expect(
        find.textContaining(l10n.coachingLevelGrowing),
        findsOneWidget,
      );

      // 4 score axis labels.
      expect(find.text(l10n.coachingScoreSpecificity), findsOneWidget);
      expect(find.text(l10n.coachingScoreGodCentered), findsOneWidget);
      expect(find.text(l10n.coachingScoreActs), findsOneWidget);
      expect(find.text(l10n.coachingScoreAuthenticity), findsOneWidget);

      // Score text labels — specificity=4, godCenteredness=3, actsBalance=5,
      // authenticity=4 → two "4/5", one "3/5", one "5/5".
      expect(find.text('4/5'), findsWidgets);
      expect(find.text('3/5'), findsOneWidget);
      expect(find.text('5/5'), findsOneWidget);

      // Strengths section title + at least one bullet.
      expect(find.text(l10n.coachingStrengthsTitle), findsOneWidget);
      expect(
        find.text(
          'You prayed with concrete, specific words rather than vague phrases.',
        ),
        findsOneWidget,
      );

      // Improvements section title + bullet.
      expect(find.text(l10n.coachingImprovementsTitle), findsOneWidget);
      expect(
        find.text(
          'Consider pausing longer after praise, before moving to petition.',
        ),
        findsOneWidget,
      );

      // Overall feedback (English variant).
      expect(
        find.text(
          'Your prayer shows strong ACTS balance and real authenticity.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Pro user + loading: shows loading message + spinner',
        (tester) async {
      // Never-completing future → loading state forever.
      final completer = Completer<PrayerCoaching>();
      addTearDown(() {
        if (!completer.isCompleted) {
          completer.complete(TestFixtures.prayerCoaching());
        }
      });

      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: PrayerCoachingCard(
                locale: 'en',
                isUserPremium: true,
                onUnlock: _noop,
              ),
            ),
          ),
          overrides: [
            prayerCoachingProvider.overrideWith((ref) => completer.future),
          ],
        ),
      );
      // Only `pump()` — don't settle (future never completes).
      await tester.pump();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      expect(find.text(l10n.coachingLoadingText), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Pro user + error: shows retry button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: PrayerCoachingCard(
                locale: 'en',
                isUserPremium: true,
                onUnlock: _noop,
              ),
            ),
          ),
          overrides: [
            prayerCoachingProvider.overrideWith(
              (ref) => Future<PrayerCoaching>.error(StateError('boom')),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      expect(find.text(l10n.coachingErrorText), findsWidgets);
      expect(find.text(l10n.coachingRetryButton), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('Free user: shows ProBlur lock without reading provider',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const Scaffold(
            body: PrayerCoachingCard(
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
      expect(find.text(l10n.coachingTitle), findsOneWidget);

      // No scores / strengths rendered.
      expect(find.text(l10n.coachingScoreSpecificity), findsNothing);
      expect(find.text(l10n.coachingStrengthsTitle), findsNothing);

      // Membership badge from ProBlur.
      expect(find.text(l10n.membershipTitle), findsOneWidget);
    });
  });
}

void _noop() {}
