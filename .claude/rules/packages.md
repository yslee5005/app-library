---
paths: ["packages/**"]
---

# Package Development Rules

## Structure
- Each package: `domain/` (interface+model) → `data/` (implementation) → `providers/` (Riverpod) → `widgets/` (optional)
- domain must be pure Dart (no Flutter dependency)

## Dependencies
- Unidirectional only: core ← supabase_client ← auth/pagination ← comments
- Reverse dependencies absolutely forbidden
- core has zero external dependencies

## Coding Conventions
- Riverpod 3.0: @riverpod annotation
- Models: freezed + json_serializable
- Repository: interface (domain) + implementation (data) separated
- Files: snake_case.dart, Classes: PascalCase

## Generalization Rules
- No app-specific references (devotion_id → content_type + content_id)
- All Supabase operations auto-scoped with app_id
- Static singletons → constructor injection (DI compatible)

## When Making Changes
- core interface changes → Ask First + CHANGELOG required
- New external dependency → Ask First
- Breaking change → major version bump
