import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/guidance_card.dart';
import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/widgets/pro_blur.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [GuidanceCard].
///
/// Focus:
///   - Pro user: ExpandableCard with 💬 icon + guidance content in body.
///   - Free user: ProBlur lock (no content body, membership badge visible).
void main() {
  group('GuidanceCard', () {
    testWidgets('Pro user: renders title, 💬 icon, and guidance content', (
      tester,
    ) async {
      final guidance = TestFixtures.guidance();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: GuidanceCard(
                guidance: guidance,
                title: 'AI Guidance',
                isUserPremium: true,
                onUnlock: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('AI Guidance'), findsOneWidget);
      expect(find.text('💬'), findsOneWidget);

      // No ProBlur (unlocked path uses ExpandableCard).
      expect(find.byType(ProBlur), findsNothing);

      // Expand to see full body.
      await tester.tap(find.text('AI Guidance'));
      await tester.pumpAndSettle();

      // Content appears at least once (collapsed summary + expanded body).
      expect(find.text(guidance.content), findsWidgets);
    });

    testWidgets('Free user: shows ProBlur lock and hides guidance content', (
      tester,
    ) async {
      final guidance = TestFixtures.guidance();

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: GuidanceCard(
              guidance: guidance,
              title: 'AI Guidance',
              isUserPremium: false,
              onUnlock: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // ProBlur is rendered in the locked path.
      expect(find.byType(ProBlur), findsOneWidget);

      // Title + icon still visible (discovery UX).
      expect(find.text('AI Guidance'), findsOneWidget);
      expect(find.text('💬'), findsOneWidget);

      // Guidance content body is NOT rendered.
      expect(find.text(guidance.content), findsNothing);

      // Membership badge (from ProBlur) is present.
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.membershipTitle), findsOneWidget);
    });
  });
}
