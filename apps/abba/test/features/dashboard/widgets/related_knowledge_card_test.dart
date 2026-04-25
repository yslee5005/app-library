import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/widgets/related_knowledge_card.dart';

import '../../../helpers/test_app.dart';
import '../../../helpers/test_fixtures.dart';

/// Widget tests for [RelatedKnowledgeCard].
///
/// Focus:
///   - With originalWord: word + transliteration + language + meaning render,
///     plus historicalContext and each crossReference.
///   - Without originalWord: originalWord section is hidden; context and
///     crossReferences still render.
void main() {
  group('RelatedKnowledgeCard', () {
    testWidgets(
      'with originalWord: renders word, context, and cross-references',
      (tester) async {
        final knowledge = TestFixtures.relatedKnowledge();

        await tester.pumpWidget(
          buildTestApp(
            Scaffold(
              body: SingleChildScrollView(
                child: RelatedKnowledgeCard(
                  knowledge: knowledge,
                  title: 'Related Knowledge',
                  originalWordLabel: 'Original Word',
                  historicalContextLabel: 'Historical Context',
                  crossReferencesLabel: 'Cross References',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Header visible.
        expect(find.text('Related Knowledge'), findsOneWidget);
        expect(find.text('🔤'), findsOneWidget);

        // Expand.
        await tester.tap(find.text('Related Knowledge'));
        await tester.pumpAndSettle();

        // OriginalWord block.
        expect(find.text('Original Word'), findsOneWidget);
        // Word + transliteration render as `"word  (translit)"` single string.
        final ow = knowledge.originalWord!;
        expect(
          find.text('${ow.word}  (${ow.transliteration})'),
          findsOneWidget,
        );
        expect(find.text(ow.language), findsOneWidget);
        expect(find.text(ow.meaning), findsOneWidget);

        // Historical context block.
        expect(find.text('Historical Context'), findsOneWidget);
        expect(find.text(knowledge.historicalContext), findsOneWidget);

        // Cross References block.
        expect(find.text('Cross References'), findsOneWidget);
        for (final ref in knowledge.crossReferences) {
          expect(find.text(ref.reference), findsOneWidget);
          expect(find.text(ref.text), findsOneWidget);
        }
      },
    );

    testWidgets(
      'without originalWord: originalWord section hidden, context and refs still render',
      (tester) async {
        final knowledge = TestFixtures.relatedKnowledge(
          includeOriginalWord: false,
        );

        await tester.pumpWidget(
          buildTestApp(
            Scaffold(
              body: SingleChildScrollView(
                child: RelatedKnowledgeCard(
                  knowledge: knowledge,
                  title: 'Related Knowledge',
                  originalWordLabel: 'Original Word',
                  historicalContextLabel: 'Historical Context',
                  crossReferencesLabel: 'Cross References',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Related Knowledge'));
        await tester.pumpAndSettle();

        // Original Word label must NOT render when originalWord is null.
        expect(find.text('Original Word'), findsNothing);

        // Context + cross-references remain.
        expect(find.text('Historical Context'), findsOneWidget);
        expect(find.text(knowledge.historicalContext), findsOneWidget);
        expect(find.text('Cross References'), findsOneWidget);
      },
    );
  });
}
