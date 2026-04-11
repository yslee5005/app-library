---
paths: ["supabase/**"]
---

# Supabase 규칙

## 멀티테넌시 전략
- **스키마 분리**: 앱별 PostgreSQL 스키마 (`blacklabelled`, `abba` 등)
- **공유 인프라**: `public` 스키마에 `tenants`, `user_tenants`, `languages`, `translations`
- **테넌트 연결**: `tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE`

## 테이블 생성 필수 사항
- `tenant_id UUID NOT NULL REFERENCES public.tenants(id)` 컬럼 필수
- `created_at TIMESTAMPTZ NOT NULL DEFAULT now()` 필수
- PK: `UUID PRIMARY KEY DEFAULT gen_random_uuid()`
- 테이블명: snake_case, 복수형
- 생성 즉시 `ENABLE ROW LEVEL SECURITY`

## RLS 정책 패턴
```sql
-- 읽기 전용 공개 데이터 (포트폴리오 등)
FOR SELECT USING (true);

-- soft delete 필터
FOR SELECT USING (deleted_at IS NULL);

-- 관리자 쓰기 정책
-- ⚠️ INSERT의 WITH CHECK에서 NEW. 접두사 사용 금지!
-- Supabase RLS는 INSERT 시 NEW 참조를 지원하지 않음.
-- 컬럼명을 직접 사용해야 함 (tenant_id, NOT NEW.tenant_id)
FOR INSERT WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.user_tenants ut
    WHERE ut.user_id = auth.uid()
      AND ut.tenant_id = tenant_id          -- ✅ 올바름
      -- AND ut.tenant_id = NEW.tenant_id   -- ❌ 에러 발생
      AND ut.role IN ('owner', 'admin')
  )
);
```

## 스키마 생성 패턴
```sql
CREATE SCHEMA IF NOT EXISTS {app_name};
GRANT USAGE ON SCHEMA {app_name} TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA {app_name} TO anon, authenticated, service_role;
```

## 마이그레이션
- 파일명: `{timestamp}_{설명}.sql` (예: 20260411000001_public_multi_tenant.sql)
- 순서: public 인프라 → 앱 스키마 → seed 데이터

## 절대 금지
- service_role 키 클라이언트 코드에 포함
- RLS 없는 테이블 배포
- DB 마이그레이션 직접 실행 (Ralph 중 포함) → 사용자가 수동 적용
- 하드코딩 UUID (gen_random_uuid() 사용)

## RPC 함수
- SECURITY DEFINER로 선언
- 입력값 검증 필수
