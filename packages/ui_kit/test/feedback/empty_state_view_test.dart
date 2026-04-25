import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('EmptyStateView', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const EmptyStateView(
            title: 'No items',
            subtitle: 'Try adding something',
          ),
        ),
      );
      expect(find.text('No items'), findsOneWidget);
      expect(find.text('Try adding something'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        buildApp(const EmptyStateView(title: 'Empty', icon: Icons.inbox)),
      );
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('shows action button and fires callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildApp(
          EmptyStateView(
            title: 'Empty',
            actionLabel: 'Refresh',
            onAction: () => tapped = true,
          ),
        ),
      );
      expect(find.text('Refresh'), findsOneWidget);
      await tester.tap(find.text('Refresh'));
      expect(tapped, isTrue);
    });

    testWidgets('hides action button when no label', (tester) async {
      await tester.pumpWidget(buildApp(const EmptyStateView(title: 'Empty')));
      expect(find.byType(FilledButton), findsNothing);
    });
  });
}
