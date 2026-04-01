import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppAvatar', () {
    testWidgets('shows initials when no image', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppAvatar(name: 'John Doe')),
      );
      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('shows single initial for one-word name', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppAvatar(name: 'Alice')),
      );
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('shows ? when name is null', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppAvatar()),
      );
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders CircleAvatar', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppAvatar(name: 'Test User')),
      );
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('respects size parameter', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppAvatar(name: 'A', size: AvatarSize.lg)),
      );
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, AvatarSize.lg.radius);
    });

    testWidgets('respects custom radius', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppAvatar(name: 'A', customRadius: 60)),
      );
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, 60);
    });
  });
}
