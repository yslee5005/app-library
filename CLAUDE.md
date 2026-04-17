# App Library

Flutter master reference library. Store verified code and copy-paste into independent repos when building new apps.

## Core Strategy
- **Master Reference** (this repo) = verified code storage
- **Each App** = independent, copy-paste from master + customize
- **Shared Infra** = 1 Supabase + 1 Sentry, isolated by per-app PostgreSQL schema
- **No Cross-App Dependencies** = modifying one app never affects another

## Tech Stack
Flutter (Dart 3.9+), Riverpod 3.0, Supabase, go_router, freezed, Sentry, Next.js (web)

## Commands
```bash
# Flutter
flutter analyze apps/{app}
flutter run --profile  # Physical device (iOS 26 JIT restriction)
flutter run             # Simulator

# Next.js (BlackLabelled web)
cd apps/blacklabelled/web && npm run build
cd apps/blacklabelled/web && npx vitest run

# Supabase (manual only — Ralph must never run directly)
supabase db push --linked
```

## Boundaries

### Always
- New table → enable RLS immediately
- RLS must have COALESCE NULL defense
- flutter_dotenv runtime loading (`String.fromEnvironment` is forbidden)
- .env → .gitignore
- Release → `--obfuscate`
- **Anonymous-First** — all apps start without login
- Always Read the target file before modifying

### Never
- Include service_role key in client
- Include JWT Secret in client
- Store tokens in SharedPreferences
- Publish to pub.dev
- rm -rf
- Commit .env files
- Make login a prerequisite for app launch

### Ask First
- Supabase schema/RLS changes
- Interface changes to master reference code
- Running DB migrations directly

## MoAI Workflow

### Decision Gate (must run /decide for feature decisions)
- Changes that alter user behavior/experience → run `/decide`, present options → STOP
- Bug fixes/refactoring → 5W1H analysis → STOP
- **Code modification only after "실행" (execute)** — never decide arbitrarily without option selection

### Analysis/Planning ("계획해" (plan only) = analysis only, no code modification)
- Deep research via Agent + file Read required
- Output: Problem Definition / Key Findings / Execution Plan / Expected Results
- Include false positive check
- STOP — wait until "실행" (execute)

### Execution (after "실행" (execute))
- 3+ files → use Ralph agent
- Explain implementation direction in 1 line before writing code
- Run `flutter analyze` / `next build` after completion
- Over-optimization check: "Is this needed for MVP?"

### Ralph Loop
- Max iterations: 10
- Done: zero errors + logic verified

### Context Management
- 1 conversation = 1 feature unit
- If it gets long → commit → new conversation

## Detailed Rules (auto-loaded)
`.claude/rules/` directory contains domain-specific rule files:
- `auth.md` — Anonymous-First authentication pattern
- `env.md` — flutter_dotenv usage
- `security.md` — Key/secret protection
- `supabase.md` — Tables/RLS/migrations
- `responsive.md` — Responsive layout
- `apps.md` — App structure/naming
- `deploy.md` — Deployment checklist + recommended packages
- `copy-paste.md` — Master→app copy-paste guide
- `moai.md` — MoAI prompt template
