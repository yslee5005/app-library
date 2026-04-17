---
paths: ["apps/**", "**/main.dart", "**/.env*"]
---

# Environment Variable Rules

## Required: flutter_dotenv Runtime Loading
- Do not use `String.fromEnvironment`
- Use `dotenv.load(fileName: '.env.client')`

## .env.client Structure
```
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

## Access Pattern
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
final url = dotenv.env['SUPABASE_URL'] ?? '';
```
