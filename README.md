# app-library

Flutter monorepo: shared packages under `packages/`, individual apps under `apps/`.

## First-time setup

```bash
# 1. Fill in secrets
cp .env.example .env
$EDITOR .env

cp apps/abba/.env.example apps/abba/.env.client
$EDITOR apps/abba/.env.client

# 2. Generate merged runtime env
./scripts/prepare_env.sh abba

# 3. Verify the setup
./scripts/doctor.sh abba

# 4. (macOS) install CocoaPods for iOS
cd apps/abba/ios && pod install --repo-update && cd -

# 5. Run
flutter run apps/abba
```

`./scripts/doctor.sh` (with no argument) scans every app. Run it whenever
you switch machines, check out a branch, or hit an unexplained build error.

## Docs

- Architecture and conventions: `CLAUDE.md`
- Env file layout: `.claude/rules/env.md`
- Full setup + troubleshooting: `.claude/rules/setup.md`
- Per-app notes: `apps/<app>/CLAUDE.md`
