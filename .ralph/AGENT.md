# Ralph Agent Configuration — App Library

## Build Instructions

```bash
# Resolve dependencies (from project root)
dart pub get
```

## Test Instructions

```bash
# Run tests for pure Dart packages
cd packages/core && dart test
# Run tests for Flutter packages (when applicable)
# cd packages/{name} && flutter test
```

## Analyze Instructions

```bash
# Analyze all code
dart analyze
```

## Notes
- This is a Melos monorepo with Pub Workspaces
- `packages/core` is pure Dart (use `dart test`)
- Flutter packages use `flutter test`
- Always run from project root for workspace resolution
- Read CLAUDE.md for project rules and boundaries
