import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/ai_prayer_card.dart';
import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/models/prayer.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [AiPrayerCard].
///
/// Focus:
///   - Pro user sees prayer text + citations (quote/science/example).
///   - Free user sees the ProBlur lock state (no body content rendered).
///   - `AiPrayer.placeholder()` renders for Free fallback (locked).
///
/// Ralph #5 already covered ProBlur internals — we only verify INTEGRATION
/// (the card wires title/icon into ProBlur correctly when locked).
void main() {
  group('AiPrayerCard', () {
    testWidgets('Pro user: renders text + expanded citations', (tester) async {
      final prayer = TestFixtures.aiPrayer(isPremium: true);

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: AiPrayerCard(
                aiPrayer: prayer,
                title: 'A Prayer for You',
                isUserPremium: true,
                onUnlock: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Unlocked card uses ExpandableCard — title + summary are visible.
      expect(find.text('A Prayer for You'), findsOneWidget);
      expect(find.text('🙏'), findsOneWidget);

      // Tap the header to expand (ExpandableCard starts collapsed here).
      await tester.tap(find.text('A Prayer for You'));
      await tester.pumpAndSettle();

      // Prayer body is now visible (expandedContent).
      expect(find.text(prayer.text), findsWidgets);

      // Tap the citations chevron to reveal them.
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final citationsHeader = find.textContaining(l10n.aiPrayerCitationsTitle);
      expect(citationsHeader, findsOneWidget);
      await tester.tap(citationsHeader);
      await tester.pumpAndSettle();

      // All three citation types render their content.
      expect(
        find.text('"Our hearts are restless until they rest in You."'),
        findsOneWidget,
      );
      expect(
        find.text('"Gratitude practice lowers cortisol by 23%."'),
        findsOneWidget,
      );
      expect(
        find.text('"A widow keeps a morning gratitude journal."'),
        findsOneWidget,
      );
    });

    testWidgets('Free user: shows ProBlur lock and hides prayer text', (
      tester,
    ) async {
      final prayer = TestFixtures.aiPrayer(isPremium: true);

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AiPrayerCard(
              aiPrayer: prayer,
              title: 'A Prayer for You',
              isUserPremium: false,
              onUnlock: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Title + icon still visible (discovery UX — Pro blur rule).
      expect(find.text('A Prayer for You'), findsOneWidget);
      expect(find.text('🙏'), findsOneWidget);

      // Prayer text is NOT rendered while locked (content=SizedBox.shrink).
      expect(find.text(prayer.text), findsNothing);

      // Membership badge (from ProBlur) is shown.
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.membershipTitle), findsOneWidget);
    });

    testWidgets('Free fallback: placeholder hides body, shows lock', (
      tester,
    ) async {
      // AiPrayer.placeholder() is the Free fallback the card system hands to
      // locked users — verify the card still treats it as locked.
      final placeholder = AiPrayer.placeholder('en');

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: AiPrayerCard(
              aiPrayer: placeholder,
              title: 'A Prayer for You',
              isUserPremium: false,
              onUnlock: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Locked card still exposes title + icon.
      expect(find.text('A Prayer for You'), findsOneWidget);
      expect(find.text('🙏'), findsOneWidget);

      // Placeholder text is inside `text` but should NOT render under the
      // locked ProBlur (content=SizedBox.shrink).
      expect(find.text(placeholder.text), findsNothing);
    });
  });
}
