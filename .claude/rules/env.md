---
paths: ["apps/**", "**/main.dart", "**/.env*"]
---

# 환경변수 규칙

## 필수: flutter_dotenv 런타임 로딩
- `String.fromEnvironment` 사용 금지
- `dotenv.load(fileName: '.env.client')` 사용

## .env.client 구조
```
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

## 접근 패턴
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
final url = dotenv.env['SUPABASE_URL'] ?? '';
```
