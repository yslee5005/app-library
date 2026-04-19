---
paths: ["apps/**", "scripts/**", "**/.env*", "README.md", "**/main.dart"]
---

# Workspace Setup (read before running or building)

This repo ships secrets via gitignored files. Cloning is not enough — each
machine needs a local env bootstrap before any app can run. Run
`./scripts/doctor.sh` to see what is missing on the current machine.

## gitignored files that must exist locally

| Path | Owner | How to recreate |
|------|-------|-----------------|
| `.env` | root, shared + server-only keys | Copy `.env.example` → `.env`, fill values |
| `apps/<app>/.env.client` | per app, app-specific keys | Copy `apps/<app>/.env.example` → `.env.client`, fill values |
| `apps/<app>/.env.runtime` | per app, generated | `./scripts/prepare_env.sh <app>` |
| `apps/<app>/ios/Podfile` | per app, iOS build config | Local change (pin `platform :ios, '15.0'`); re-run `pod install` |
| `apps/<app>/ios/Pods/` | per app, CocoaPods cache | `cd apps/<app>/ios && pod install --repo-update` |

## Agent boot checklist

Before recommending `flutter run`, `pod install`, or any build command,
assume nothing about the local setup and run:

```bash
./scripts/doctor.sh <app>
```

Interpret the output:

- **All checks passed** → safe to continue with the user's request.
- **Any `✗` failure** → surface the exact fix lines to the user before
  doing anything else. Do not paper over with workarounds.
- **`!` warning** → note it in the response; usually non-blocking.

## First-time bootstrap (human-facing)

```bash
# 1. Fill the root secrets
cp .env.example .env
$EDITOR .env

# 2. Fill each app's client-side config
cp apps/abba/.env.example apps/abba/.env.client
$EDITOR apps/abba/.env.client

# 3. Generate merged runtime env for each app you need
./scripts/prepare_env.sh abba

# 4. Verify
./scripts/doctor.sh abba

# 5. iOS (macOS only)
cd apps/abba/ios && pod install --repo-update && cd -

# 6. Run
flutter run apps/abba
```

## Syncing secrets across your own machines

The simplest option without adding a vault service is to keep the real
`.env` and `apps/<app>/.env.client` files in an iCloud Drive folder and
symlink them into the repo:

```bash
mkdir -p ~/Library/Mobile\ Documents/com~apple~CloudDocs/app-library-secrets
mv .env ~/Library/Mobile\ Documents/com~apple~CloudDocs/app-library-secrets/root.env
ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/app-library-secrets/root.env .env
```

Repeat the `ln -s` on the second machine after iCloud has synced.
`doctor.sh` treats symlinks and real files identically.

For larger teams, move to 1Password CLI (`op inject`) or Doppler instead.

## Never commit

- `.env`, any `.env.*` except `*.example` (the `.gitignore` enforces this)
- `apps/<app>/.env.runtime` (regenerated every run)
- `apps/<app>/ios/Podfile`, `Podfile.lock`, `Pods/` (gitignored to avoid
  Xcode version churn; pin platform locally only)

## Runtime safety net

Even if this guide is ignored, `AppConfig.validate()` in each app throws a
`StateError` at launch when required keys are empty. That prevents a build
with placeholders from reaching production but is a last-resort guard —
`doctor.sh` is the real preflight.
