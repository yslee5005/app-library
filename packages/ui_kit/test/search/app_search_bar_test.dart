import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('AppSearchBar', () {
    testWidgets('renders with hint text', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppSearchBar(hint: 'Search here')),
      );
      expect(find.text('Search here'), findsOneWidget);
    });

    testWidgets('shows search icon', (tester) async {
      await tester.pumpWidget(buildApp(const AppSearchBar()));
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows clear button after typing', (tester) async {
      await tester.pumpWidget(buildApp(const AppSearchBar()));
      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clear button resets text', (tester) async {
      String? lastValue;
      await tester.pumpWidget(
        buildApp(AppSearchBar(onChanged: (v) => lastValue = v)),
      );

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      expect(lastValue, '');
      expect(
        (tester.widget<TextField>(find.byType(TextField))).controller?.text,
        '',
      );
    });

    testWidgets('calls onChanged after debounce', (tester) async {
      String? lastValue;
      await tester.pumpWidget(
        buildApp(
          AppSearchBar(
            debounceDuration: const Duration(milliseconds: 100),
            onChanged: (v) => lastValue = v,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();
      // Not yet fired.
      expect(lastValue, isNull);

      // Wait for debounce.
      await tester.pump(const Duration(milliseconds: 150));
      expect(lastValue, 'test');
    });

    testWidgets('calls onSubmitted when user presses done', (tester) async {
      String? submitted;
      await tester.pumpWidget(
        buildApp(AppSearchBar(onSubmitted: (v) => submitted = v)),
      );

      await tester.enterText(find.byType(TextField), 'query');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(submitted, 'query');
    });
  });
}
