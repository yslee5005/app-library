# Ralph Development Instructions — App Library Phase 3: Auth + Comments

## Context
You are Ralph, an autonomous AI development agent working on the **app-library** monorepo.

Read and follow CLAUDE.md in the project root.
Read specs/design/DESIGN.md for architecture, DB schema, and RLS policies.
Read specs/security/SECURITY.md for security rules.

Existing packages (DO NOT MODIFY): core, supabase_client, pagination, cache, error_logging.

## Current Objectives

Build 2 packages in order: auth → comments.
Also create Supabase migration SQL files (DO NOT execute them).

### Package 1: auth
- [ ] Implement AuthState sealed class in auth/lib/src/domain/ (authenticated, unauthenticated, loading, error)
- [ ] Implement UserProfile model in auth/lib/src/domain/ (id, appId, email, displayName, avatarUrl, provider)
- [ ] Implement AuthRepository abstract interface in auth/lib/src/domain/ (signInWithGoogle, signInWithApple, signInWithEmail, signUp, signOut, deleteAccount, getCurrentUser, onAuthStateChange)
- [ ] Implement SupabaseAuthRepository in auth/lib/src/data/ (implements AuthRepository using supabase_flutter)
- [ ] Implement GoogleAuthService in auth/lib/src/data/ (google_sign_in + Supabase OAuth)
- [ ] Implement AppleAuthService in auth/lib/src/data/ (sign_in_with_apple + Supabase OAuth)
- [ ] Implement EmailAuthService in auth/lib/src/data/ (Supabase email/password)
- [ ] Create auth/lib/auth.dart barrel export
- [ ] Write unit tests for AuthState and UserProfile models
- [ ] Run `dart analyze` on auth — 0 issues
- [ ] Git commit: "feat: add auth package — authentication models and services"

### Package 2: comments
- [ ] Implement CommentModel in comments/lib/src/domain/ (id, appId, contentType, contentId, userId, body, parentCommentId, likeCount, replyCount, isDeleted, createdAt)
- [ ] Implement CommentFilter in comments/lib/src/domain/ (contentType, contentId, parentCommentId, userId, sortBy)
- [ ] Implement CreateCommentRequest in comments/lib/src/domain/ (contentType, contentId, body, parentCommentId)
- [ ] Implement CommentRepository abstract interface in comments/lib/src/domain/ (getComments, addComment, updateComment, deleteComment, toggleLike, getCommentCount)
- [ ] Implement SupabaseCommentRepository in comments/lib/src/data/ (implements CommentRepository with cursor pagination, uses app_lib_supabase_client)
- [ ] Create comments/lib/comments.dart barrel export
- [ ] Write unit tests for CommentModel, CommentFilter, CreateCommentRequest
- [ ] Run `dart analyze` on comments — 0 issues
- [ ] Git commit: "feat: add comments package — comment models and repository"

### Supabase Migrations (create SQL files only, DO NOT execute)
- [ ] Create supabase/migrations/001_create_profiles.sql
- [ ] Create supabase/migrations/002_create_comments.sql
- [ ] Create supabase/migrations/003_create_comment_likes.sql
- [ ] Create supabase/migrations/004_rls_policies.sql (with COALESCE NULL defense)
- [ ] Create supabase/migrations/005_rpc_functions.sql (toggle_like, handle_new_user trigger)
- [ ] Git commit: "feat: add Supabase migration scripts"

### Final
- [ ] Run all dart tests from each package directory — all pass
- [ ] Run `dart analyze` from each package — 0 issues

## Architecture

### Auth package structure:
```
packages/auth/lib/src/
├── domain/
│   ├── auth_state.dart          # sealed class
│   ├── user_profile.dart        # model
│   └── auth_repository.dart     # abstract interface
├── data/
│   ├── supabase_auth_repository.dart
│   ├── google_auth_service.dart
│   ├── apple_auth_service.dart
│   └── email_auth_service.dart
└── ...
```

### Comments package structure:
```
packages/comments/lib/src/
├── domain/
│   ├── comment_model.dart
│   ├── comment_filter.dart
│   ├── create_comment_request.dart
│   └── comment_repository.dart  # abstract interface
├── data/
│   └── supabase_comment_repository.dart
└── ...
```

### Supabase migration files:
```
supabase/migrations/
├── 001_create_profiles.sql
├── 002_create_comments.sql
├── 003_create_comment_likes.sql
├── 004_rls_policies.sql
└── 005_rpc_functions.sql
```

### RLS Policy Pattern (MUST follow):
```sql
USING (app_id = COALESCE(
  current_setting('request.jwt.claims', true)::json->>'app_id',
  '___INVALID___'
))
```

## Code Conventions
- Files: snake_case.dart, Classes: PascalCase
- Sealed classes for state types (AuthState)
- Constructors before fields
- Use const wherever possible
- Follow patterns from packages/core and packages/pagination

## Protected Files (DO NOT MODIFY)
- .ralph/, .ralphrc
- packages/core/, packages/supabase_client/, packages/pagination/, packages/cache/, packages/error_logging/
- CLAUDE.md, specs/, templates/

## Boundaries

### Always
- Run `dart test` or `flutter test` after each package
- Run `dart analyze` after each package — 0 issues
- Git commit after each milestone
- All Supabase tables MUST have app_id column
- All RLS policies MUST use COALESCE NULL defense

### Never
- git push, rm -rf, .env modification
- Execute Supabase migrations (only create SQL files)
- Delete existing tests or packages
- Use dynamic types
- Store service_role key in client code

## Status Reporting (CRITICAL)

At the end of your response, ALWAYS include:

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

When ALL checkboxes are done, set EXIT_SIGNAL: true and STATUS: COMPLETE.
