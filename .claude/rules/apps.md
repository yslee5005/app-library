---
paths: ["apps/**"]
---

# App Development Rules

## App Structure (feature-first)
```
apps/{name}/lib/
├── main.dart
├── app.dart              # ProviderScope + MaterialApp.router
├── config/app_config.dart # appId, supabase URL/key
├── router/app_router.dart # go_router
└── features/
    └── {feature}/
        ├── viewmodel/    # written independently per app
        └── view/         # written independently per app
```

## Naming Conventions

| Item | Pattern | Example |
|------|---------|---------|
| Bundle ID (iOS) | `com.ystech.{app_name}` | `com.ystech.abba` |
| Application ID (Android) | `com.ystech.{app_name}` | `com.ystech.abba` |
| App folder name | `apps/{app_name}/` | `apps/abba/` |
| APP_ID (.env) | `{app_name}` (hyphens allowed) | `abba`, `pet-life` |
| SKU (App Store Connect) | `com.ystech.{app_name}` | `com.ystech.abba` |
| Package name prefix | `app_lib_` | `app_lib_core` |

- App names must be **lowercase + hyphens only** (e.g., `pet-life`, `abba`, `mart-scanner`)
- Bundle IDs use **underscores or removal** instead of hyphens (e.g., `pet-life` → `com.ystech.petlife`)

## New App Creation Steps
1. Step 0: YC 4P validation → generate IDEA.md
2. Step 1: Write specs/REQUIREMENTS.md
3. Copy template_app → modify app_config.dart
4. Connect only needed packages as path dependencies in pubspec.yaml
5. Implement app-specific features in features/
6. Add tables to supabase/migrations/ if needed

## Per-App Spec Templates
```markdown
# apps/{name}/specs/IDEA.md
## Persona:
## Problem:
## Promise:
## Product (MVP):
## First 100 Users:

# apps/{name}/specs/REQUIREMENTS.md
## App Name:
## One-Line Description:
## Core Features:
## Required Shared Packages:
## App-Specific Features:
## Additional Supabase Tables:
```

## Package Usage
- Import Providers from shared packages (ref.watch)
- Customize per-app via Provider overrides
- ViewModel/View must always be written independently per app

## Deployment Rules
- All apps must have ITSAppUsesNonExemptEncryption = false in Info.plist
- Bundle ID: com.ystech.{app_name}
- Deploy via fastlane (ios/fastlane/ directory)
- App Store Connect app registration is a one-time manual step (Apple policy)
