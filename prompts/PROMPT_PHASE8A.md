# Ralph — Phase 8A: Provider Layer (Riverpod 3.0)

## Context
You are Ralph working on **app-library** monorepo.
Read CLAUDE.md. Packages auth, comments, pagination already have domain/ and data/ layers.
Now add the **providers/** layer so apps can use `ref.watch()`.

## ONLY modify these directories:
- packages/auth/lib/src/providers/
- packages/comments/lib/src/providers/
- packages/pagination/lib/src/providers/
- packages/auth/lib/auth.dart (add provider exports)
- packages/comments/lib/comments.dart (add provider exports)
- packages/pagination/lib/pagination.dart (add provider exports)
- Respective pubspec.yaml files (add riverpod dependency if missing)

## DO NOT modify:
- Any existing domain/ or data/ files
- packages/ui_kit/, packages/core/, packages/theme/
- apps/, specs/, .ralph/, .claude/

## Checklist

### Auth Providers
- [ ] Create packages/auth/lib/src/providers/auth_providers.dart
- [ ] authRepositoryProvider — Provider<AuthRepository> that throws UnimplementedError (app must override)
- [ ] authNotifierProvider — AsyncNotifier that manages AuthState (authenticated/unauthenticated/loading)
- [ ] authNotifier methods: signInWithGoogle(), signInWithEmail(email, pw), signUp(email, pw, name), signOut()
- [ ] currentUserProvider — derives UserProfile? from authNotifier
- [ ] Update auth.dart barrel export to include providers

### Comments Providers
- [ ] Create packages/comments/lib/src/providers/comment_providers.dart
- [ ] commentRepositoryProvider — Provider<CommentRepository> that throws UnimplementedError (app must override)
- [ ] commentListProvider — family AsyncNotifier(contentType, contentId) managing PaginationState<CommentModel>
- [ ] commentListNotifier methods: loadMore(), refresh(), addComment(body), toggleLike(commentId)
- [ ] Update comments.dart barrel export to include providers

### Pagination Providers
- [ ] Create packages/pagination/lib/src/providers/pagination_providers.dart
- [ ] Generic paginationProvider — family AsyncNotifier that takes PaginatedRepository<T>
- [ ] paginationNotifier methods: loadMore(), refresh()
- [ ] State management: PaginationState (initial → loading → loaded → error)
- [ ] Update pagination.dart barrel export to include providers

### Pubspec Updates
- [ ] Add flutter_riverpod: ^3.0.0 to auth, comments, pagination pubspec.yaml dependencies
- [ ] Add riverpod_annotation: ^3.0.0 to dev_dependencies
- [ ] Add build_runner and riverpod_generator to dev_dependencies

### Final
- [ ] dart analyze on auth, comments, pagination — 0 errors (warnings OK for now)
- [ ] Git commit: "feat: add Provider layer — auth, comments, pagination notifiers"

## Provider Pattern to Follow
```dart
// Simple provider pattern (no code generation needed for Phase 8A)
// Use basic Riverpod — NOT @riverpod annotation (avoid build_runner complexity)

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('Override authRepositoryProvider in your app');
});

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final result = await repo.getCurrentUser();
    return switch (result) {
      Success(value: final user?) => AuthState.authenticated(user),
      _ => const AuthState.unauthenticated(),
    };
  }
}
```

## Boundaries
### Always
- Use basic Provider/AsyncNotifierProvider (NOT @riverpod code gen)
- Repository providers must throw UnimplementedError (app overrides them)
- Git commit when done
### Never
- Modify existing domain/ or data/ files
- Add Firebase or Supabase imports to provider files
- Use StateNotifier (deprecated in Riverpod 3.0)

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
