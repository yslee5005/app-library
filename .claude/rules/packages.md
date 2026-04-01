---
paths: ["packages/**"]
---

# 패키지 개발 규칙

## 구조
- 각 패키지: `domain/` (interface+model) → `data/` (구현) → `providers/` (Riverpod) → `widgets/` (선택)
- domain은 순수 Dart (Flutter 의존성 금지)

## 의존성
- 단방향만 허용: core ← supabase_client ← auth/pagination ← comments
- 역방향 의존 절대 금지
- core는 외부 의존성 0개

## 코딩 컨벤션
- Riverpod 3.0: @riverpod 어노테이션
- Models: freezed + json_serializable
- Repository: interface(domain) + 구현체(data) 분리
- 파일: snake_case.dart, 클래스: PascalCase

## 일반화 규칙
- 앱 특정 참조 금지 (devotion_id → content_type + content_id)
- 모든 Supabase 작업에 app_id 자동 스코핑
- static 싱글톤 → 생성자 주입 (DI 호환)

## 변경 시
- core 인터페이스 변경 → Ask First + CHANGELOG 필수
- 새 외부 의존성 �� Ask First
- Breaking change → major 버전 증가
