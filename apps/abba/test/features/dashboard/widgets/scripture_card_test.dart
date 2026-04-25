import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/scripture_card.dart';
import 'package:abba/models/prayer.dart';

import '../../../helpers/test_app.dart';

const _shortVerse = 'The LORD is my shepherd; I shall not want.';
final _longVerse =
    'For I am persuaded, that neither death, nor life, nor angels, nor '
    'principalities, nor powers, nor things present, nor things to come, nor '
    'height, nor depth, nor any other creature, shall be able to separate us '
    'from the love of God, which is in Christ Jesus our Lord. '
    'Therefore I urge you, brothers and sisters, in view of God\'s mercy.';

void main() {
  group('ScriptureCard verse fold', () {
    Future<void> pumpAt(WidgetTester tester, Size size, Scripture s) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          Scaffold(
            body: SingleChildScrollView(
              child: ScriptureCard(
                scripture: s,
                title: 'Scripture',
                initiallyExpanded: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('short verse: no see-more affordance', (tester) async {
      await pumpAt(
        tester,
        const Size(320, 568),
        const Scripture(reference: 'Psalm 23:1', verse: _shortVerse),
      );

      expect(find.text(_shortVerse), findsOneWidget);
      expect(find.text('See more'), findsNothing);
    });

    testWidgets('long verse on compact: shows See more, tap reveals full', (
      tester,
    ) async {
      await pumpAt(
        tester,
        const Size(320, 568),
        Scripture(reference: 'Romans 8:38-39', verse: _longVerse),
      );

      // Folded: full text not yet present.
      expect(find.text(_longVerse), findsNothing);
      // CTA visible.
      expect(find.text('See more'), findsOneWidget);

      await tester.ensureVisible(find.text('See more'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('See more'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text(_longVerse), findsOneWidget);
      expect(find.text('See less'), findsOneWidget);
    });

    testWidgets('long verse on medium tablet: fold + reveal still works', (
      tester,
    ) async {
      await pumpAt(
        tester,
        const Size(768, 1024),
        Scripture(reference: 'Romans 8:31-39', verse: _longVerse),
      );

      expect(find.text('See more'), findsOneWidget);
      await tester.ensureVisible(find.text('See more'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('See more'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text(_longVerse), findsOneWidget);
    });

    testWidgets(
      'range reference + verse just over preview: still folds',
      (tester) async {
        // A 120-char verse with a "-" range reference triggers fold per
        // _shouldFoldVerse(): range branch when len > _versePreviewChars (110).
        const verse =
            'The grass withers and the flowers fall, but the word of our God endures forever, and so we set our hope on Him alone today.';
        await pumpAt(
          tester,
          const Size(320, 568),
          const Scripture(reference: 'Isaiah 40:6-8', verse: verse),
        );
        expect(find.text('See more'), findsOneWidget);
      },
    );
  });
}
