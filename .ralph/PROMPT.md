# Ralph Development Instructions — App Library Phase 4: Theme + Notifications + L10n

## Context
You are Ralph, an autonomous AI development agent working on the **app-library** monorepo.

Read and follow CLAUDE.md in the project root.
Read specs/design/DESIGN.md for architecture patterns.

Existing packages (DO NOT MODIFY): core, supabase_client, pagination, cache, error_logging, auth, comments.

## Current Objectives

Build 3 packages in order: theme → notifications → l10n

### Package 1: theme
- [ ] Create packages/theme/ directory structure (lib/src/tokens/, config/, generators/ + test/)
- [ ] Create pubspec.yaml (depends on app_lib_core + flutter, resolution: workspace)
- [ ] Implement AppColors class in tokens/ (seed color based, light/dark variants)
- [ ] Implement AppSpacing class in tokens/ (xs, sm, md, lg, xl constants)
- [ ] Implement AppRadius class in tokens/ (sm, md, lg, xl constants)
- [ ] Implement AppTypography class in tokens/ (heading, body, caption text styles)
- [ ] Implement ThemeConfig in config/ (seedColor, fontFamily, borderRadius → input)
- [ ] Implement ThemeGenerator in generators/ (ThemeConfig → ThemeData for light + dark)
- [ ] Create theme.dart barrel export
- [ ] Write unit tests (ThemeGenerator produces valid ThemeData, light/dark differ)
- [ ] Run `flutter analyze` — 0 issues
- [ ] Git commit: "feat: add theme package — seed color based theme generator"

### Package 2: notifications
- [ ] Create packages/notifications/ directory structure (lib/src/domain/, data/ + test/)
- [ ] Create pubspec.yaml (depends on app_lib_core + flutter_local_notifications, resolution: workspace)
- [ ] Implement NotificationMessage model in domain/ (id, title, body, payload, scheduledAt)
- [ ] Implement NotificationRepository abstract interface in domain/ (show, schedule, cancel, cancelAll, requestPermission)
- [ ] Implement LocalNotificationService in data/ (wraps flutter_local_notifications)
- [ ] Create notifications.dart barrel export
- [ ] Write unit tests for NotificationMessage model
- [ ] Run `flutter analyze` — 0 issues
- [ ] Git commit: "feat: add notifications package — local notification service"

### Package 3: l10n
- [ ] Create packages/l10n/ directory structure (lib/src/services/, utils/ + test/)
- [ ] Create pubspec.yaml (depends on app_lib_core only, pure Dart, resolution: workspace)
- [ ] Implement RelativeTimeFormatter in utils/ (e.g., "3 minutes ago", "yesterday", supports en/ko)
- [ ] Implement NumberFormatter in utils/ (compact numbers: 1.2K, 3.4M)
- [ ] Implement LanguageService in services/ (get system locale, supported locales list)
- [ ] Create l10n.dart barrel export
- [ ] Write unit tests for RelativeTimeFormatter and NumberFormatter
- [ ] Run `dart analyze` — 0 issues
- [ ] Git commit: "feat: add l10n package — relative time and number formatters"

### Final
- [ ] All tests pass in all 3 new packages

## Code Conventions
- Sealed classes for state types, const where possible
- Constructors before fields, snake_case files, PascalCase classes
- Follow existing patterns from packages/core

## Protected Files (DO NOT MODIFY)
- .ralph/, .ralphrc, packages/core/, packages/supabase_client/, packages/pagination/, packages/cache/, packages/error_logging/, packages/auth/, packages/comments/, supabase/

## Boundaries
### Always
- Run tests after each package, git commit after each package
### Never
- git push, rm -rf, .env modification, delete existing code
### If Stuck
- Skip Flutter widget tests if simulator not available, focus on unit tests

## Status Reporting
```
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: PASSING | FAILING | NOT_RUN
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false | true
RECOMMENDATION: <one line>
---END_RALPH_STATUS---
```
When ALL checkboxes done → EXIT_SIGNAL: true, STATUS: COMPLETE.
