# Ralph Agent Configuration — App Library Foundation

## Environment

### Binaries (all in PATH)
```
flutter  → /opt/homebrew/bin/flutter
dart     → /opt/homebrew/bin/dart
melos    → dart pub global activate melos (if not installed)
```

### SDK Requirements
- Dart SDK: ^3.7.0
- Flutter: >=3.29.0

---

## Build Instructions

### Initial Setup
```bash
# From project root: /Users/yonghunjeong/Documents/ys/app-library

# Install melos globally (if needed)
dart pub global activate melos

# Bootstrap all packages (resolves dependencies)
melos bootstrap
```

### Per-Package Dependency Resolution
```bash
# Pure Dart packages
cd packages/core && dart pub get
cd packages/cache && dart pub get
cd packages/error_logging && dart pub get
cd packages/l10n && dart pub get

# Flutter packages
cd packages/supabase_client && flutter pub get
cd packages/auth && flutter pub get
cd packages/pagination && flutter pub get
cd packages/comments && flutter pub get
cd packages/theme && flutter pub get
cd packages/notifications && flutter pub get
cd packages/ui_kit && flutter pub get

# Apps
cd apps/showcase && flutter pub get
cd apps/pet-life && flutter pub get
cd apps/template_app && flutter pub get  # after creation
```

---

## Melos Commands (run from project root)

| Command | Description |
|---------|-------------|
| `melos bootstrap` | Resolve all dependencies across workspace |
| `melos run analyze` | `dart analyze` on all packages |
| `melos run test` | `flutter test` on all packages |
| `melos run test:dart` | `dart test` on pure Dart packages only |
| `melos run build_runner` | `build_runner build` on packages with freezed/riverpod |
| `melos run format` | `dart format lib` on all packages |
| `melos run clean` | `flutter clean` on all packages |

---

## Test Instructions

### Per-Package Testing
```bash
# Pure Dart packages (NO Flutter dependency)
cd packages/core && dart test
cd packages/cache && dart test
cd packages/error_logging && dart test
cd packages/l10n && dart test

# Flutter packages
cd packages/supabase_client && flutter test
cd packages/auth && flutter test
cd packages/pagination && flutter test
cd packages/comments && flutter test
cd packages/theme && flutter test
cd packages/notifications && flutter test
cd packages/ui_kit && flutter test

# Apps
cd apps/pet-life && flutter test
cd apps/showcase && flutter test
```

### Run All Tests
```bash
melos run test        # flutter test on all
melos run test:dart   # dart test on pure Dart only
```

---

## Analyze Instructions

```bash
# Analyze all packages
melos run analyze

# Analyze single package
cd packages/<name> && dart analyze

# Analyze from root (workspace-aware)
dart analyze
```

**Target: 0 errors, 0 warnings acceptable if intentional.**

---

## Code Generation (freezed / riverpod)

```bash
# Single package
cd packages/<name> && dart run build_runner build --delete-conflicting-outputs

# All packages that use build_runner
melos run build_runner
```

Run after modifying:
- Any `.freezed.dart` model
- Any `@riverpod` annotated provider
- Any `@JsonSerializable` class

---

## Directory Structure Reference

```
app-library/
├── CLAUDE.md
├── melos.yaml
├── pubspec.yaml                    # Pub Workspaces root
├── analysis_options.yaml
├── .env.example
├── .gitignore
├── .ralphrc
│
├── specs/
│   ├── requirements/REQUIREMENTS.md
│   ├── design/DESIGN.md
│   ├── tasks/TASKS.md
│   └── security/SECURITY.md
│
├── .ralph/                         # Ralph config (PROTECTED)
│   ├── PROMPT.md
│   ├── fix_plan.md
│   └── AGENT.md
│
├── .claude/                        # Claude Code config (PROTECTED)
│   └── rules/
│       ├── packages.md
│       ├── security.md
│       └── flutter-layout.md
│
├── packages/
│   ├── core/                       # Tier 1: Pure Dart, 0 external deps
│   │   ├── lib/
│   │   │   ├── core.dart           # barrel export
│   │   │   └── src/
│   │   │       ├── errors/         # AppException sealed hierarchy
│   │   │       ├── models/         # PaginatedResult, PaginationParams
│   │   │       ├── utils/          # Result<T>
│   │   │       └── constants/      # AppConstants
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_core
│   │
│   ├── supabase_client/            # Tier 2: core + supabase_flutter
│   │   ├── lib/
│   │   │   ├── supabase_client.dart
│   │   │   └── src/
│   │   │       ├── client/         # AppSupabaseClient
│   │   │       ├── config/         # SupabaseConfig
│   │   │       └── providers/      # supabaseClientProvider (TODO)
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_supabase_client
│   │
│   ├── auth/                       # Tier 2: core + supabase_client + google/apple
│   │   ├── lib/src/
│   │   │   ├── domain/             # AuthRepository, AuthState, UserProfile
│   │   │   ├── data/               # Google/Apple/Email services, SupabaseAuthRepository
│   │   │   └── providers/          # authStateProvider, currentUserProvider
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_auth
│   │
│   ├── pagination/                 # Tier 2: core + supabase_client
│   │   ├── lib/src/
│   │   │   ├── domain/             # PaginatedRepository, PaginationState
│   │   │   ├── data/               # PaginatedSupabaseRepository (TODO)
│   │   │   ├── providers/          # PaginationNotifier
│   │   │   └── widgets/            # InfiniteScrollList/Grid (TODO)
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_pagination
│   │
│   ├── comments/                   # Tier 3: core + supabase_client + pagination
│   │   ├── lib/src/
│   │   │   ├── domain/             # CommentModel, CommentFilter, CommentRepository
│   │   │   ├── data/               # SupabaseCommentRepository
│   │   │   ├── providers/          # comment providers
│   │   │   └── widgets/            # CommentSheet, CommentItem (TODO)
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_comments
│   │
│   ├── cache/                      # Tier 2: core only (Pure Dart)
│   │   ├── lib/src/
│   │   │   ├── interfaces/         # CacheInterface, CacheEntry
│   │   │   ├── memory/             # MemoryCache
│   │   │   ├── manager/            # CacheManager
│   │   │   └── mixins/             # CacheManagementMixin (TODO)
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_cache
│   │
│   ├── error_logging/              # Tier 2: core only (Pure Dart)
│   │   ├── lib/src/
│   │   │   ├── services/           # ErrorLevel, ErrorLoggingService
│   │   │   └── filters/            # SensitiveDataFilter
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_error_logging
│   │
│   ├── theme/                      # Tier 2: core + flutter
│   │   ├── lib/src/
│   │   │   ├── tokens/             # AppColors, AppSpacing, AppRadius, AppTypography
│   │   │   ├── config/             # ThemeConfig
│   │   │   └── generators/         # ThemeGenerator
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_theme
│   │
│   ├── l10n/                       # Tier 2: core only (Pure Dart)
│   │   ├── lib/src/
│   │   │   ├── services/           # LanguageService
│   │   │   └── utils/              # RelativeTimeFormatter, NumberFormatter
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_l10n
│   │
│   ├── notifications/              # Tier 2: core + flutter_local_notifications
│   │   ├── lib/src/
│   │   │   ├── domain/             # NotificationMessage, NotificationRepository
│   │   │   ├── data/               # LocalNotificationService
│   │   │   └── providers/          # notificationProvider (TODO)
│   │   ├── test/
│   │   └── pubspec.yaml            # name: app_lib_notifications
│   │
│   └── ui_kit/                     # Tier 3: core + theme
│       ├── lib/src/
│       │   ├── navigation/         # AppBottomNavBar, AppShell, etc.
│       │   ├── onboarding/         # LoginForm, SignUpForm, etc.
│       │   ├── profile/            # ProfileHeader, SettingsScreen, etc.
│       │   ├── feed/               # AppCard, FeedListView, etc.
│       │   ├── search/             # AppSearchBar, ChipFilterBar, etc.
│       │   ├── forms/              # AppButton, AppTextField, etc.
│       │   ├── feedback/           # EmptyStateView, ShimmerWidget, etc.
│       │   ├── media/              # AppAvatar, ImageCarousel, etc.
│       │   └── data_viz/           # AppProgressBar, HeatmapCalendar, etc.
│       ├── test/
│       └── pubspec.yaml            # name: app_lib_ui_kit
│
├── apps/
│   ├── showcase/                   # UI Kit demo app
│   ├── pet-life/                   # Pet Life consumer app
│   └── template_app/              # Starter template (TODO)
│
└── supabase/
    └── migrations/                 # SQL migration files (TODO)
```

---

## Package Dependency Graph

```
core (Pure Dart, 0 deps)
│
├── supabase_client ── (core + supabase_flutter + flutter_riverpod)
│   │
│   ├── auth ────────── (+ google_sign_in, sign_in_with_apple)
│   │
│   ├── pagination ──── (core + supabase_client + flutter_riverpod)
│   │   │
│   │   └── comments ── (+ pagination)
│   │
│   └── notifications ── (+ flutter_local_notifications, timezone)
│
├── cache ───────────── (core only, Pure Dart)
│
├── error_logging ───── (core only, Pure Dart)
│
├── l10n ────────────── (core only, Pure Dart)
│
├── theme ───────────── (core + flutter)
│
└── ui_kit ──────────── (core + theme)
```

**Rule: arrows flow DOWN only. Reverse dependency = forbidden.**

---

## New Package Checklist

When adding a new package:
1. Create directory under `packages/`
2. Create `pubspec.yaml` with `name: app_lib_<name>`, `resolution: workspace`
3. Create `lib/<name>.dart` barrel export
4. Create `lib/src/` with domain/, data/, providers/, widgets/ as needed
5. Create `test/` with at least one test file
6. Add to root `pubspec.yaml` workspace list
7. Run `melos bootstrap`
8. Run `dart analyze` or `flutter analyze`

---

## Protected Files (DO NOT MODIFY)

```
.ralph/          # Ralph configuration
.ralphrc         # Ralph settings
specs/           # Specification documents
templates/       # File templates
CLAUDE.md        # AI behavior rules
.claude/         # Claude Code rules
.moai/           # MoAI configuration
.env             # Environment variables (DO NOT CREATE/MODIFY)
.env.*           # Environment variable variants
```

---

## Git Workflow

```bash
# Check status
git status

# Stage specific files
git add packages/<name>/lib/ packages/<name>/test/ packages/<name>/pubspec.yaml

# Commit with Korean message
git commit -m "feat: <패키지명> 구현 완료 — <상세 설명>"

# NEVER push
# git push  ← FORBIDDEN during Ralph execution

# NEVER force delete
# rm -rf    ← FORBIDDEN
```

### Commit Message Convention
```
feat: <description>     # 새 기능
fix: <description>      # 버그 수정
test: <description>     # 테스트 추가/수정
refactor: <description> # 리팩토링
docs: <description>     # 문서
chore: <description>    # 설정/빌드
```

---

## Troubleshooting

### `melos bootstrap` fails
```bash
# Clean and retry
melos run clean
melos bootstrap
```

### Dependency resolution fails
```bash
# Check workspace list in root pubspec.yaml
# Ensure all packages are listed
# Run from root:
dart pub get
```

### `build_runner` conflicts
```bash
cd packages/<name>
dart run build_runner build --delete-conflicting-outputs
```

### Analyzer errors
```bash
# Fix imports first
dart fix --apply
# Then manual fixes
dart analyze
```
