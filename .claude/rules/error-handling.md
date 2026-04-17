---
paths: ["packages/**", "apps/**"]
---

# Error Handling Rules

## 30-Type Error Defense Checklist

All package/app code must follow these rules.

## A. Build Time

- `melos analyze` must pass (strict lint)
- freezed/json_serializable models must be committed after `melos build_runner`
- .env keys must be validated with `EnvValidator.validate()` on app start
- Branch environments with `AppEnvironment.fromString()`

## B. Runtime

### Exception Handling
- All exceptions must use `AppException` subclasses (throw Exception is forbidden)
- Network calls must use try-catch + `NetworkException`
- DB calls must use try-catch + `DatabaseException`
- In catch(e), either `rethrow` or wrap in `AppException` (swallowing is forbidden)

### Result Pattern
- Repository return values: `Result<T>` usage recommended
- ViewModel uses `result.when(success: ..., failure: ...)` pattern

### State Management
- When using AsyncNotifier, handle all 3 AsyncValue states: loading/error/data
- Branch `ref.watch()` results with `.when()` (never ignore error)

### Permissions
- Check permissions before camera/location/notification usage + show guidance UI on denial
- `permission_handler` package is used at app level only (do not put in core/)

## C. UI/UX

### 3 States Required
All data display screens must implement 3 states:
- **Loading**: `SkeletonLoader` or `CircularProgressIndicator`
- **Error**: `ErrorStateView` + retry button
- **Empty**: `EmptyStateView` + guidance message

### Overflow Prevention
- `Text` widget: `maxLines` + `overflow: TextOverflow.ellipsis`
- Lists: wrap with `Expanded` or `Flexible`
- Long content: wrap with `SingleChildScrollView`
- Hardcoded width/height is forbidden → use `ScreenSize`

### Design Consistency
- Colors: use `Theme.of(context).colorScheme` (hardcoding forbidden)
- Spacing: multiples of 8 (8, 16, 24, 32)
- Fonts: use `Theme.of(context).textTheme`

## D. Data/Backend

- Supabase calls must go through `AppSupabaseClient` (automatic app_id scoping)
- RLS policies: COALESCE + app_id filter required
- Verify freezed model matches Supabase schema
- Nullable fields must also be declared nullable in the model

## E. Deployment

- Release builds: `--obfuscate --split-debug-info` required
- Verify verbose logging is disabled in `AppEnvironment.prod`
- Feature flags: new features must be wrapped in `FeatureFlag` for gradual rollout
