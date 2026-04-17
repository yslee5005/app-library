---
paths: ["packages/**", "apps/**"]
---

# Testing Rules

## Required Tests

### Packages (packages/)
- Unit tests for all public APIs
- Result-returning functions: test both success + failure cases
- Must pass `melos test`

### Apps (apps/)
- All screens: at least 1 widget test per screen
- Overflow test: use `testOverflow()` (compact + medium)
- ViewModel: state transition tests (loading → data, loading → error)

## Test Helper Usage

### Widget Tests
```dart
import 'package:app_lib_ui_kit/test/helpers/widget_test_helpers.dart';

// Quick responsive test
testResponsive('MyWidget', widget: const MyWidget());

// Individual overflow test
testOverflow('No overflow with long text',
  widget: const MyWidget(title: 'Very long text...'),
  size: TestScreenSizes.compact,
);

// Custom size test
testWidgets('Tablet layout', (tester) async {
  await tester.binding.setSurfaceSize(TestScreenSizes.expanded);
  // ...
});
```

## Test Naming
- `{feature}_test.dart` (snake_case)
- test/ mirrors the lib/src/ structure
- Group by class/feature using group()

## Prohibited
- Deleting existing tests is forbidden (Ralph rule)
- No sleep/delay-based tests → use pumpAndSettle
- No real network calls in tests → use Mocks
