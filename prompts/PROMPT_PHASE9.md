# Ralph — Phase 9: Showcase Integration (Provider + Full Flow)

## Context
You are Ralph working on **app-library** monorepo.
All packages now have Provider layers (from Phase 8A).
UI widgets are customizable (from Phase 8C).
Update showcase app to demonstrate Provider-connected flows.

## ONLY modify:
- apps/showcase/lib/**
- apps/showcase/pubspec.yaml (add flutter_riverpod if needed)

## DO NOT modify:
- Any packages/ files
- specs/, .ralph/, .claude/

## Checklist

### Setup
- [ ] Add flutter_riverpod to showcase pubspec.yaml if not present
- [ ] Wrap ShowcaseApp with ProviderScope in main.dart
- [ ] Create mock implementations for auth and comment repositories

### Provider-Connected Demos
- [ ] Update onboarding/demos/login_form_demo.dart — connect to mock authNotifier (show loading state on tap)
- [ ] Update feed/demos/feed_list_view_demo.dart — connect to paginationProvider with mock data (load more actually adds items)
- [ ] Create a new "Full Flow Demo" in features/full_flow/ — Login → Feed → Comment flow using all providers

### Full Flow Demo Screen
- [ ] features/full_flow/view/full_flow_demo.dart
- [ ] Screen 1: Login (mock) → on success navigate to Screen 2
- [ ] Screen 2: Feed list with pagination (mock 20 items, load more adds 10)
- [ ] Screen 3: Detail → Comment list with add comment (mock)
- [ ] Add "Full Flow" card to home grid (10th category)

### Verify All Existing Demos
- [ ] Run showcase app — all 9 existing category screens load without error
- [ ] All individual demo screens navigate and render without crash
- [ ] Dark mode toggle works across all screens

### Final
- [ ] flutter analyze on showcase — 0 errors
- [ ] flutter build apk --debug succeeds
- [ ] Git commit: "feat: showcase — Provider integration + full flow demo"

## Mock Repository Pattern
```dart
class MockAuthRepository implements AuthRepository {
  @override
  Future<Result<UserProfile>> signInWithGoogle() async {
    await Future.delayed(Duration(seconds: 1)); // simulate network
    return Result.success(UserProfile(
      id: 'mock-1', appId: 'showcase', email: 'demo@example.com',
      displayName: 'Demo User', provider: 'google',
    ));
  }
  // ... implement other methods with mock data
}
```

## ProviderScope Setup
```dart
void main() {
  runApp(ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(MockAuthRepository()),
      commentRepositoryProvider.overrideWithValue(MockCommentRepository()),
    ],
    child: const ShowcaseApp(),
  ));
}
```

## Layout Rules
- Never use ListView in unbounded parent
- Forms: SingleChildScrollView + Column

## Boundaries
### Always
- Use mock data (no real Supabase connection)
- All demos must be self-contained (navigate back with AppBar)
### Never
- Modify packages/
- Connect to real backend
- Delete existing demo files

## Status Reporting
```
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: NOT_RUN
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false | true
RECOMMENDATION: <one line>
---END_RALPH_STATUS---
```
