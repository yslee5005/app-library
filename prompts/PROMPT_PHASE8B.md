# Ralph — Phase 8B: Tests + Lint Fix

## Context
You are Ralph working on **app-library** monorepo.
All packages exist. Some are missing tests, and dart analyze has ~58 info issues.
Fix lint issues and add missing tests.

## ONLY modify these files:
- packages/supabase_client/test/ (create test files)
- packages/comments/test/ (create test files)
- Any existing .dart file that has lint issues (fix them in place)

## DO NOT modify:
- Any file's logic or public API
- packages/ui_kit/ (separate phase)
- apps/, specs/, .ralph/, .claude/

## Checklist

### Supabase Client Tests
- [ ] Create packages/supabase_client/test/supabase_config_test.dart
- [ ] Test SupabaseConfig construction with required fields
- [ ] Test AppSupabaseClient.appId getter
- [ ] Test AppSupabaseClient.insert auto-injects app_id
- [ ] (Mock SupabaseClient — use simple stub, not real Supabase)

### Comments Tests
- [ ] Create packages/comments/test/comments_test.dart
- [ ] Test CommentModel construction with all fields
- [ ] Test CommentFilter construction and defaults
- [ ] Test CreateCommentRequest construction
- [ ] Test CommentRepository interface can be implemented (mock)

### Lint Fixes (dart analyze → 0 issues)
- [ ] Fix all `prefer_const_constructors` warnings
- [ ] Fix all `require_trailing_commas` warnings
- [ ] Fix all `sort_constructors_first` warnings
- [ ] Run `dart analyze` from root — target 0 issues

### Final
- [ ] Run all tests: core, pagination, cache, error_logging, l10n, supabase_client, comments — all pass
- [ ] `dart analyze` — 0 issues (info OK, no errors/warnings)
- [ ] Git commit: "test: add supabase_client and comments tests + fix lint issues"

## Test Pattern
```dart
import 'package:test/test.dart';
import 'package:app_lib_comments/comments.dart';

void main() {
  group('CommentModel', () {
    test('constructs with required fields', () {
      final comment = CommentModel(
        id: '1',
        appId: 'test',
        contentType: 'post',
        contentId: 'p1',
        userId: 'u1',
        body: 'Hello',
        createdAt: DateTime.now(),
      );
      expect(comment.id, '1');
      expect(comment.appId, 'test');
    });
  });
}
```

## Boundaries
### Always
- Run tests after creating them
- Fix lint issues without changing logic
### Never
- Change public API signatures
- Delete existing tests
- Modify ui_kit or apps

## Status Reporting
```
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: PASSING | FAILING | NOT_RUN
WORK_TYPE: TESTING
EXIT_SIGNAL: false | true
RECOMMENDATION: <one line>
---END_RALPH_STATUS---
```
