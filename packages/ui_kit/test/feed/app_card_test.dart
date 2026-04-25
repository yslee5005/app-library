import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('AppCard vertical layout', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(buildApp(const AppCard(title: 'Test Title')));

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppCard(title: 'Title', subtitle: 'Subtitle text')),
      );

      expect(find.text('Subtitle text'), findsOneWidget);
    });

    testWidgets('renders image when provided', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppCard(title: 'With Image', image: Placeholder())),
      );

      expect(find.byType(Placeholder), findsOneWidget);
    });

    testWidgets('renders trailing widget', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppCard(title: 'With Trailing', trailing: Icon(Icons.bookmark)),
        ),
      );

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildApp(AppCard(title: 'Tappable', onTap: () => tapped = true)),
      );

      await tester.tap(find.text('Tappable'));
      expect(tapped, isTrue);
    });
  });

  group('AppCard horizontal layout', () {
    testWidgets('renders in horizontal layout', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppCard(
            title: 'Horizontal',
            subtitle: 'Sub',
            image: Placeholder(),
            layout: AppCardLayout.horizontal,
          ),
        ),
      );

      expect(find.text('Horizontal'), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);
    });
  });
}
