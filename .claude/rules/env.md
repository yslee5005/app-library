---
paths: ["apps/**", "**/main.dart", "**/.env*"]
---

# Environment Variable Rules

## Required: flutter_dotenv Runtime Loading
- Do not use `String.fromEnvironment`
- Use `dotenv.load(fileName: '.env.runtime')`

## File Structure (2-file system)

```
app-library/
├── .env              ← server-only (service_role key, Supabase CLI)
├── .env.shared       ← shared CLIENT keys (all apps same)
├── .env.shared.example
├── apps/abba/
│   ├── .env.client   ← app-specific keys only
│   └── .env.runtime  ← generated (shared + client merged)
└── scripts/
    └── prepare_env.sh
```

| File | Contains | Location |
|------|----------|----------|
| `.env` | service_role key (server-only) | root |
| `.env.shared` | SUPABASE_URL, SUPABASE_ANON_KEY, GEMINI_API_KEY, SENTRY_DSN | root |
| `.env.client` | APP_ID, ENV, GOOGLE_IOS_CLIENT_ID, REVENUECAT_API_KEY | per app |
| `.env.runtime` | merged output (gitignored, auto-generated) | per app |

## Before Running

```bash
./scripts/prepare_env.sh abba        # generates apps/abba/.env.runtime
./scripts/prepare_env.sh blacklabelled
```

## Access Pattern
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
final url = dotenv.env['SUPABASE_URL'] ?? '';
```
