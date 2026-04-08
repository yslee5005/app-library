---
paths: ["apps/**"]
---

# 앱 개발 규칙

## 앱 구조 (feature-first)
```
apps/{name}/lib/
├── main.dart
├── app.dart              # ProviderScope + MaterialApp.router
├── config/app_config.dart # appId, supabase URL/key
├── router/app_router.dart # go_router
└── features/
    └── {feature}/
        ├── viewmodel/    # 앱별 독립 작성
        └── view/         # 앱별 독립 작성
```

## 네이밍 컨벤션

| 항목 | 패턴 | 예시 |
|------|------|------|
| Bundle ID (iOS) | `com.ystech.{앱이름}` | `com.ystech.abba` |
| Application ID (Android) | `com.ystech.{앱이름}` | `com.ystech.abba` |
| 앱 폴더명 | `apps/{앱이름}/` | `apps/abba/` |
| APP_ID (.env) | `{앱이름}` (하이픈 허용) | `abba`, `pet-life` |
| SKU (App Store Connect) | `com.ystech.{앱이름}` | `com.ystech.abba` |
| 패키지명 prefix | `app_lib_` | `app_lib_core` |

- 앱이름은 **소문자 + 하이픈만** (예: `pet-life`, `abba`, `mart-scanner`)
- Bundle ID에는 하이픈 대신 **언더스코어 또는 제거** (예: `pet-life` → `com.ystech.petlife`)

## 새 앱 생성 순서
1. Step 0: YC 4P 검증 → IDEA.md 생성
2. Step 1: specs/REQUIREMENTS.md 작성
3. template_app 복사 → app_config.dart 수정
4. pubspec.yaml에 필요한 패키지만 path 의존성으로 연결
5. features/ 에 앱 고유 기능 구현
6. 필요 시 supabase/migrations/ 에 테이블 추가

## 앱별 spec 템플릿
```markdown
# apps/{name}/specs/IDEA.md
## Persona:
## Problem:
## Promise:
## Product (MVP):
## 첫 100명 유저:

# apps/{name}/specs/REQUIREMENTS.md
## 앱 이름:
## 한줄 설명:
## 핵심 기능:
## 필요한 공유 패키지:
## 앱 고유 기능:
## Supabase 추가 테이블:
```

## 패키지 사용
- 공유 패키지에서 Provider 가져다 쓰기 (ref.watch)
- Provider override로 앱별 커스텀 가능
- ViewModel/View는 항상 앱별 독립 작성

## 배포 규칙
- 모든 앱의 Info.plist에 ITSAppUsesNonExemptEncryption = false 필수
- Bundle ID: com.ystech.{앱이름}
- fastlane deploy로 배포 (ios/fastlane/ 디렉토리)
- App Store Connect 앱 등록은 1회 수동 (Apple 정책)
