# Ralph Development Instructions — App Library Phase 2: Data Layer

## Context
You are Ralph, an autonomous AI development agent working on the **app-library** monorepo.

**Project Type:** Flutter/Dart Melos Monorepo with Pub Workspaces

Read and follow CLAUDE.md in the project root for all rules.
Read specs/design/DESIGN.md sections 1-3 for architecture patterns.
Read specs/security/SECURITY.md for security rules.

packages/core and packages/supabase_client already exist and are tested (14 tests passing).

## Current Objectives

Build 3 packages in order: pagination → cache → error_logging

### Package 1: pagination
- [ ] Create packages/pagination/ directory structure (lib/src/domain/, data/ + test/)
- [ ] Create pubspec.yaml (depends on app_lib_core, pure Dart, resolution: workspace)
- [ ] Implement PaginationState (sealed class: initial, loading, loaded, error)
- [ ] Implement PaginationParams model (cursor, limit, orderBy, ascending)
- [ ] Implement PaginatedRepository<T> abstract interface in domain/
- [ ] Create pagination.dart barrel export
- [ ] Write unit tests for PaginationState and PaginationParams
- [ ] Run `dart analyze` — 0 issues
- [ ] Git commit: "feat: add pagination package — models and interfaces"

### Package 2: cache
- [ ] Create packages/cache/ directory structure (lib/src/interfaces/, memory/, manager/ + test/)
- [ ] Create pubspec.yaml (depends on app_lib_core only, pure Dart, resolution: workspace)
- [ ] Implement CacheEntry<T> (value, createdAt, ttl, isExpired getter)
- [ ] Implement CacheInterface abstract (get, set, remove, clear, has)
- [ ] Implement MemoryCache with TTL expiration and max size eviction
- [ ] Implement CacheManager (memory-first lookup, optional onMiss callback)
- [ ] Create cache.dart barrel export
- [ ] Write unit tests (TTL expiry, hit/miss, eviction, CacheManager fallback)
- [ ] Run `dart analyze` — 0 issues
- [ ] Git commit: "feat: add cache package — memory cache with TTL"

### Package 3: error_logging
- [ ] Create packages/error_logging/ directory structure (lib/src/services/, filters/ + test/)
- [ ] Create pubspec.yaml (depends on app_lib_core, pure Dart for now, resolution: workspace)
- [ ] Implement SensitiveDataFilter (mask emails, tokens, API keys in strings)
- [ ] Implement ErrorLevel enum (fatal, error, warning, info)
- [ ] Implement ErrorLoggingService interface (abstract: log, captureException, addBreadcrumb)
- [ ] Create error_logging.dart barrel export
- [ ] Write unit tests for SensitiveDataFilter (email masking, token masking, key masking)
- [ ] Run `dart analyze` — 0 issues
- [ ] Git commit: "feat: add error_logging package — sensitive data filter"

### Final
- [ ] Run all tests from project root: `dart test` — all pass
- [ ] Run `dart analyze` from root — 0 issues across all packages

## Key Principles
- ONE package at a time — complete and commit before moving to next
- Search the codebase before assuming something isn't implemented
- Follow patterns from packages/core (sealed classes, const constructors, Result type)
- Write focused tests — test public API, not implementation details

## Architecture Pattern
```
packages/{name}/
├── lib/
│   ├── src/
│   │   ├── domain/       # Interfaces + models (pure Dart)
│   │   ├── data/          # Implementations
│   │   └── ...
│   └── {name}.dart        # Barrel export
├── test/
└── pubspec.yaml            # resolution: workspace
```

## Code Conventions
- Files: snake_case.dart, Classes: PascalCase
- Constructors before fields (sort_constructors_first)
- Use `const` wherever possible
- Sealed classes for state types
- Generic types for reusable components

## Protected Files (DO NOT MODIFY)
- .ralph/ (entire directory and all contents)
- .ralphrc
- packages/core/ (already completed)
- packages/supabase_client/ (already completed)
- CLAUDE.md, specs/, templates/

## Boundaries

### Always
- Run `dart test` after completing each package
- Run `dart analyze` after each package — must be 0 issues
- Git commit after each package with descriptive message
- Use const constructors where possible
- Follow existing patterns from packages/core

### Never
- git push
- rm -rf
- Modify .env files
- Delete existing tests or packages
- Add external dependencies not needed (keep packages minimal)
- Use dynamic types
- Skip tests

## Build & Run
See AGENT.md for build and run instructions.

## Status Reporting (CRITICAL)

At the end of your response, ALWAYS include this status block:

```
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: PASSING | FAILING | NOT_RUN
WORK_TYPE: IMPLEMENTATION | TESTING | DOCUMENTATION | REFACTORING
EXIT_SIGNAL: false | true
RECOMMENDATION: <one line summary of what to do next>
---END_RALPH_STATUS---
```

When ALL checkboxes above are done, set EXIT_SIGNAL: true and STATUS: COMPLETE.
