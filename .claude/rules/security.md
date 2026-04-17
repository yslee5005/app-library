# Global Security Rules

## Key/Secret Protection
- .env files: must be in .gitignore
- JWT Secret: never include in client
- service_role key: Edge Function environment variables only
- Inject via --dart-define at build time (no hardcoding)
- Token storage: flutter_secure_storage only (SharedPreferences is forbidden)

## Build Security
- Release: `--obfuscate --split-debug-info` required
- HTTPS only
- .env.example must not contain actual values

## Supply Chain Security
- Package name prefix: app_lib_ (prevent Dependency Confusion)
- Use path dependencies only (no pub.dev publishing)
- Commit pubspec.lock
- No indiscriminate use of dependency_overrides

## Additional Restrictions During Ralph Execution
- No git push
- No rm -rf
- No .env modification
- No DB migration execution
- No direct external API calls
- No deleting existing tests
