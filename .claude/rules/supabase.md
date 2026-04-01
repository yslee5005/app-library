---
paths: ["supabase/**"]
---

# Supabase 규칙

## 테이블 생성 필수 사항
- `app_id TEXT NOT NULL` 컬럼 필수
- `created_at TIMESTAMPTZ DEFAULT now()` 필수
- 테이블명: snake_case, 복수형
- 생성 즉시 `ENABLE ROW LEVEL SECURITY`

## RLS 정책 필수 패턴
```sql
USING (app_id = COALESCE(
  current_setting('request.jwt.claims', true)::json->>'app_id',
  '___INVALID___'
))
```
- NULL 방어 (COALESCE) 필수
- 클라이언트 파라미터의 app_id 신뢰 ���지
- JWT app_metadata에서만 app_id 읽기

## 마이그레이션
- 파일명: `{순번}_{설명}.sql` (예: 001_create_profiles.sql)
- RLS 정책은 별도 마이그레이션 파일로

## 절대 금지
- service_role 키 클라이언트 코드에 포함
- RLS 없는 테이블 배포
- DB 마이그레이션 직접 실행 (Ralph 중 포함) → 사용자가 수동 적용

## RPC 함수
- SECURITY DEFINER로 선언
- 입력값 검증 필수
