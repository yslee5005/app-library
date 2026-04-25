import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(buildApp(const AppButton(label: 'Click me')));
      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildApp(AppButton(label: 'Tap', onPressed: () => tapped = true)),
      );
      await tester.tap(find.text('Tap'));
      expect(tapped, isTrue);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(buildApp(const AppButton(label: 'Disabled')));
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows loading indicator when isLoading', (tester) async {
      await tester.pumpWidget(
        buildApp(AppButton(label: 'Save', isLoading: true, onPressed: () {})),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders as OutlinedButton for outline variant', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            label: 'Outline',
            variant: AppButtonVariant.outline,
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('renders as TextButton for text variant', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            label: 'Text',
            variant: AppButtonVariant.text,
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        buildApp(AppButton(label: 'Add', icon: Icons.add, onPressed: () {})),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });
  });
}
