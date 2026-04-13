# Ralph — App Library Foundation (전체 패키지 완성)

## Context
You are Ralph working on **app-library** monorepo.
Build the shared Flutter component library (11 packages) to production-ready quality.
Read `CLAUDE.md` for project rules and boundaries.
Read `specs/requirements/REQUIREMENTS.md` for full requirements.
Read `specs/design/DESIGN.md` for architecture and structure.
Read `specs/tasks/TASKS.md` for task checklist.
Read `.claude/rules/packages.md` for package development rules.
Read `.claude/rules/security.md` for security constraints.
Read `.claude/rules/flutter-layout.md` for layout rules.

**Mission:** Complete ALL packages (Phase 1-5) so new apps can assemble packages and ship.

## Tech Stack
- Flutter (Dart 3.9+), Riverpod 3.0, Supabase, freezed, go_router, Melos + Pub Workspaces
- Hexagonal Architecture: core <- data <- providers <- app (reverse dependency forbidden)
- Each package: domain/ (interfaces+models) -> data/ (implementations) -> providers/ (Riverpod) -> widgets/ (optional UI)

## Package Inventory (Current State)
All 11 packages exist with initial implementations:
1. **core** — AppException hierarchy, Result<T>, PaginatedResult, PaginationParams, AppConstants. Tests: result_test.dart
2. **supabase_client** — AppSupabaseClient, SupabaseConfig. Tests: supabase_config_test.dart
3. **auth** — AuthRepository, AuthState, UserProfile, Google/Apple/Email services, SupabaseAuthRepository, auth_providers. Tests: auth_test.dart
4. **pagination** — PaginatedRepository, PaginationState, pagination_providers. Tests: pagination_test.dart
5. **comments** — CommentModel, CommentFilter, CommentRepository, SupabaseCommentRepository, comment_providers. Tests: comments_test.dart
6. **cache** — CacheInterface, CacheEntry, MemoryCache, CacheManager. Tests: cache_test.dart (pure Dart)
7. **error_logging** — ErrorLevel, ErrorLoggingService, SensitiveDataFilter. Tests: error_logging_test.dart (pure Dart)
8. **theme** — AppColors, AppSpacing, AppRadius, AppTypography, ThemeConfig, ThemeGenerator. Tests: theme_test.dart
9. **l10n** — LanguageService, RelativeTimeFormatter, NumberFormatter. Tests: l10n_test.dart (pure Dart)
10. **notifications** — NotificationMessage, NotificationRepository, LocalNotificationService. Tests: notification_message_test.dart
11. **ui_kit** — 40+ widgets across 8 categories. Tests: 8 test files

Apps: showcase (demo app), pet-life (consumer app)

## Checklist — Work in Order, ONE Package Per Loop

### Phase 1: Foundation Verification
- [ ] Verify `melos bootstrap` works (resolve any dependency issues)
- [ ] Run `dart test` on core package — fix any failures
- [ ] Run `flutter test` on supabase_client — fix any failures
- [ ] Run `dart analyze` on root — fix any analyzer errors
- [ ] Verify core barrel export covers all public APIs
- [ ] Add missing tests for core if any (PaginatedResult, PaginationParams, AppConstants)
- [ ] Git commit: "fix: Phase 1 기반 패키지 검증 및 수정"

### Phase 2: Data Layer Verification
- [ ] Run `dart test` on cache package — fix any failures
- [ ] Run `dart test` on error_logging package — fix any failures
- [ ] Run `flutter test` on pagination package — fix any failures
- [ ] Verify cache has CacheManagementMixin (add if missing per TASKS.md)
- [ ] Verify error_logging has Riverpod provider (add if missing per TASKS.md)
- [ ] Verify pagination has InfiniteScrollList/Grid widgets (add if missing per TASKS.md)
- [ ] Add missing tests for data layer packages
- [ ] Git commit: "fix: Phase 2 데이터 레이어 패키지 검증 및 보완"

### Phase 3: Auth + Comments Verification
- [ ] Create Supabase migration SQL files (supabase/migrations/)
- [ ] Run `flutter test` on auth package — fix any failures
- [ ] Run tests on comments package — fix any failures
- [ ] Verify auth has all required providers (authStateProvider, currentUserProvider)
- [ ] Verify comments has widget layer (CommentSheet, CommentItem, ReplyList, CommentInput)
- [ ] Add missing tests
- [ ] Git commit: "fix: Phase 3 인증/댓글 패키지 검증 및 보완"

### Phase 4: UI + Polish Verification
- [ ] Run `flutter test` on theme package — fix any failures
- [ ] Run `flutter test` on notifications package — fix any failures
- [ ] Run `flutter test` (or dart test) on l10n package — fix any failures
- [ ] Run `flutter test` on ui_kit package — fix any failures
- [ ] Verify theme has all design tokens per TASKS.md
- [ ] Verify notifications has Riverpod provider (add if missing)
- [ ] Verify l10n has Riverpod provider (localeProvider, add if missing)
- [ ] Verify ui_kit covers all TASKS.md widgets
- [ ] Git commit: "fix: Phase 4 UI/테마/알림/다국어 검증 및 보완"

### Phase 5: Integration + template_app
- [ ] Create `apps/template_app/` with full structure:
  - main.dart: Supabase init + Sentry + ProviderScope
  - app.dart: MaterialApp.router + theme
  - config/app_config.dart
  - router/app_router.dart (go_router: login/home/settings)
  - features/home/, features/login/, features/settings/
- [ ] Add `apps/template_app` to root pubspec.yaml workspace
- [ ] Add `apps/template_app` to melos.yaml packages
- [ ] Run `melos bootstrap` — success
- [ ] Run `melos run analyze` — 0 errors across all packages
- [ ] Run `melos run test` — all tests pass
- [ ] Git commit: "feat: Phase 5 template_app 및 전체 통합 완료"

## Execution Rules

### Per Loop
1. Pick ONE package (or one phase sub-task)
2. Read existing implementation files first
3. **Type-First 순서로 작업:**

   **■ 새 코드 작성 시 (누락 컴포넌트 추가):**
   a. 모델/타입 먼저 (freezed 클래스, sealed class, enum, typedef)
   b. `dart run build_runner build --delete-conflicting-outputs` 실행 → 생성 파일 확인
   c. 인터페이스 정의 (abstract class, repository interface)
   d. 구현 (data layer — implements interface)
   e. Provider 정의 (Riverpod providers)
   f. 위젯 (UI layer — 타입이 확정된 상태에서 작성)

   **■ 기존 코드 수정 시:**
   a. 모델/타입 변경이 있으면 → 모델 먼저 수정
   b. `dart run build_runner build --delete-conflicting-outputs` 실행 → 생성 파일 갱신
   c. 영향받는 구현/provider/위젯 순서대로 수정

   **■ 공통 원칙:**
   - 타입이 확정되지 않은 상태에서 구현 코드 작성 금지
   - build_runner 대상 파일(freezed/riverpod) 수정 후 반드시 즉시 실행
   - import 경로는 barrel export 기준으로 통일

4. Run tests: `dart test` (pure Dart) or `flutter test` (Flutter)
5. Run analyzer: `dart analyze`
6. 0 errors required before moving on
7. Git commit in Korean with descriptive message

### Package Test Commands
| Package | Type | Test Command |
|---------|------|-------------|
| core | Pure Dart | `cd packages/core && dart test` |
| cache | Pure Dart | `cd packages/cache && dart test` |
| error_logging | Pure Dart | `cd packages/error_logging && dart test` |
| l10n | Pure Dart | `cd packages/l10n && dart test` |
| supabase_client | Flutter | `cd packages/supabase_client && flutter test` |
| auth | Flutter | `cd packages/auth && flutter test` |
| pagination | Flutter | `cd packages/pagination && flutter test` |
| comments | Flutter | `cd packages/comments && flutter test` |
| theme | Flutter | `cd packages/theme && flutter test` |
| notifications | Flutter | `cd packages/notifications && flutter test` |
| ui_kit | Flutter | `cd packages/ui_kit && flutter test` |

### Phase 7: Unit Tests + Flow Tests
- [ ] Create test/models/ — PetProfile, DailyRoutine, DailyLog model tests
  - Construction, serialization (toJson/fromJson), edge cases
- [ ] Create test/services/life_calculator_test.dart
  - Remaining days calculation (breed median lifespan - current age)
  - Remaining walks (remaining days × walks per day)
  - Human age conversion (16 × ln(dog_age) + 31)
  - Life percentage (current age / median lifespan × 100)
  - Edge cases: newborn puppy (0 days), very old dog (past median)
- [ ] Create test/services/dog_state_test.dart
  - Returns happy when all routines completed today
  - Returns wants_walk when walk not done and hour > 10
  - Returns sad when no routines done for 3+ days
  - Returns sleeping when hour is 22-6
  - Returns very_happy when perfect day streak > 0
  - Returns bored when walk not done for 3+ days
- [ ] Create test/services/breed_data_test.dart
  - Loads breed database JSON correctly
  - Finds breed by ID
  - Returns genetic health risks for known breed
  - Returns empty risks for unknown breed
  - Returns "limited" data_confidence for rare breeds
- [ ] Create test/services/pet_storage_test.dart
  - Save and load PetProfile
  - Save and load DailyLog
  - Streak calculation: consecutive days count
  - Streak reset when day missed
  - Streak freeze: doesn't reset when freeze active
- [ ] Create test/flow/onboarding_flow_test.dart (widget test)
  - Can select breed from list
  - Can enter name, age, weight
  - Can toggle routines on/off
  - Completing onboarding saves profile
  - Navigates to home after completion
- [ ] Create test/flow/routine_completion_flow_test.dart (widget test)
  - Tapping routine card marks it complete
  - Completion updates streak count
  - Completion changes dog state/speech
  - All routines complete → "완벽한 하루" state
- [ ] Run all tests: `flutter test` — ALL PASS
- [ ] Git commit: "test: pet-life unit tests + flow tests — all passing"

## Protected Files
- .ralph/, .ralphrc, specs/, templates/, CLAUDE.md, .claude/, .moai/
- DO NOT modify .env files
- DO NOT run git push
- DO NOT run rm -rf
- DO NOT modify existing app code in apps/pet-life/ or apps/showcase/ (unless fixing imports)

## Boundaries

### Always
- Follow existing code patterns already in the codebase
- Use sealed classes for state types (like AppException, AuthState, PaginationState)
- Use const constructors where possible
- Barrel export all public APIs from package root
- Run analyzer after each change
- Korean commit messages

### Never
- git push, rm -rf
- Modify .env files
- Add app-specific logic to packages
- Create circular dependencies
- Use static singletons (use constructor injection)
- Trust client app_id in RLS (JWT app_metadata only)
- pub.dev publish

### Ask First
- New external dependency
- core interface changes
- Supabase schema/RLS changes

## Status Reporting
```
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
PHASE: 1 | 2 | 3 | 4 | 5
CURRENT_PACKAGE: <package_name>
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: PASS | FAIL | NOT_RUN
ANALYZE_STATUS: CLEAN | ERRORS | NOT_RUN
WORK_TYPE: VERIFICATION | IMPLEMENTATION | FIX | TEST
EXIT_SIGNAL: false | true
RECOMMENDATION: <one line>
---END_RALPH_STATUS---
```
When ALL phases done -> EXIT_SIGNAL: true, STATUS: COMPLETE.
