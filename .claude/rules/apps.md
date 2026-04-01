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
