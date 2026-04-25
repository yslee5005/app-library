import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Scaffold(body: SizedBox(height: 600, child: child)),
    );
  }

  testWidgets('renders items from itemBuilder', (tester) async {
    await tester.pumpWidget(
      buildApp(
        FeedListView(
          itemCount: 3,
          itemBuilder: (context, index) => Text('Item $index'),
        ),
      ),
    );

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
  });

  testWidgets('shows emptyWidget when itemCount is 0', (tester) async {
    await tester.pumpWidget(
      buildApp(
        const FeedListView(
          itemCount: 0,
          itemBuilder: _neverCalled,
          emptyWidget: Text('No items'),
        ),
      ),
    );

    expect(find.text('No items'), findsOneWidget);
  });

  testWidgets('shows loading indicator when isLoadingMore is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        FeedListView(
          itemCount: 1,
          itemBuilder: (context, index) => Text('Item $index'),
          isLoadingMore: true,
          hasMore: true,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('does not show loading indicator when hasMore is false', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        FeedListView(
          itemCount: 1,
          itemBuilder: (context, index) => Text('Item $index'),
          isLoadingMore: true,
          hasMore: false,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('supports pull-to-refresh when onRefresh is provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        FeedListView(
          itemCount: 3,
          itemBuilder:
              (context, index) =>
                  SizedBox(height: 50, child: Text('Item $index')),
          onRefresh: () async {},
        ),
      ),
    );

    // RefreshIndicator should be present
    expect(find.byType(RefreshIndicator), findsOneWidget);
  });
}

Widget _neverCalled(BuildContext context, int index) {
  throw StateError('Should not be called');
}
