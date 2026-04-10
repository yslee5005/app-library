-- ============================================================
-- Public Schema — Multi-Tenant Infrastructure
-- Shared tables for all apps (blacklabelled, abba, pet-life, etc.)
-- ============================================================

-- =====================
-- 1. Tenants (앱/브랜드 단위)
-- =====================
CREATE TABLE IF NOT EXISTS tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  plan TEXT DEFAULT 'free' CHECK (plan IN ('free', 'pro', 'business')),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;

-- 누구나 활성 테넌트 목록 조회 가능 (공개 정보)
CREATE POLICY "tenants_select_active" ON tenants
  FOR SELECT USING (is_active = true);

-- =====================
-- 2. User-Tenant Mapping
-- =====================
CREATE TABLE IF NOT EXISTS user_tenants (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'viewer' CHECK (role IN ('owner', 'editor', 'viewer')),
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, tenant_id)
);

ALTER TABLE user_tenants ENABLE ROW LEVEL SECURITY;

-- 자기 소속 테넌트만 조회
CREATE POLICY "user_tenants_select_own" ON user_tenants
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()));

-- owner만 멤버 추가 가능
CREATE POLICY "user_tenants_insert" ON user_tenants
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_tenants ut
      WHERE ut.user_id = (SELECT auth.uid())
        AND ut.tenant_id = user_tenants.tenant_id
        AND ut.role = 'owner'
    )
  );

-- owner만 역할 변경 가능
CREATE POLICY "user_tenants_update" ON user_tenants
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_tenants ut
      WHERE ut.user_id = (SELECT auth.uid())
        AND ut.tenant_id = user_tenants.tenant_id
        AND ut.role = 'owner'
    )
  );

-- owner만 멤버 제거 가능
CREATE POLICY "user_tenants_delete" ON user_tenants
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_tenants ut
      WHERE ut.user_id = (SELECT auth.uid())
        AND ut.tenant_id = user_tenants.tenant_id
        AND ut.role = 'owner'
    )
  );

CREATE INDEX idx_user_tenants_user ON user_tenants(user_id, tenant_id);

-- =====================
-- 3. Tenant Settings
-- =====================
CREATE TABLE IF NOT EXISTS tenant_settings (
  tenant_id UUID PRIMARY KEY REFERENCES tenants(id) ON DELETE CASCADE,
  theme TEXT DEFAULT 'default',
  logo_url TEXT,
  locale TEXT DEFAULT 'ko',
  feature_flags JSONB DEFAULT '{}'::jsonb
);

ALTER TABLE tenant_settings ENABLE ROW LEVEL SECURITY;

-- 소속 테넌트 설정 조회
CREATE POLICY "tenant_settings_select" ON tenant_settings
  FOR SELECT TO authenticated
  USING (tenant_id IN (SELECT tenant_id FROM user_tenants WHERE user_id = (SELECT auth.uid())));

-- owner만 설정 변경
CREATE POLICY "tenant_settings_update" ON tenant_settings
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_tenants ut
      WHERE ut.user_id = (SELECT auth.uid())
        AND ut.tenant_id = tenant_settings.tenant_id
        AND ut.role = 'owner'
    )
  );

-- =====================
-- 4. Languages (공통)
-- =====================
CREATE TABLE IF NOT EXISTS languages (
  code TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true
);

ALTER TABLE languages ENABLE ROW LEVEL SECURITY;

-- 누구나 언어 목록 조회 가능
CREATE POLICY "languages_select_all" ON languages
  FOR SELECT USING (true);

-- =====================
-- 5. Translations (공통 다국어)
-- =====================
CREATE TABLE IF NOT EXISTS translations (
  id SERIAL PRIMARY KEY,
  table_schema TEXT NOT NULL,
  table_name TEXT NOT NULL,
  record_id INTEGER NOT NULL,
  field_name TEXT NOT NULL,
  lang_code TEXT NOT NULL REFERENCES languages(code),
  value TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (table_schema, table_name, record_id, field_name, lang_code)
);

ALTER TABLE translations ENABLE ROW LEVEL SECURITY;

-- 누구나 번역 조회 가능
CREATE POLICY "translations_select_all" ON translations
  FOR SELECT USING (true);

-- 인증된 사용자만 번역 추가/수정
CREATE POLICY "translations_insert" ON translations
  FOR INSERT TO authenticated
  WITH CHECK (true);

CREATE POLICY "translations_update" ON translations
  FOR UPDATE TO authenticated
  USING (true);

CREATE INDEX idx_translations_lookup
  ON translations(table_schema, table_name, record_id, lang_code);

-- =====================
-- 6. Helper Function — 소속 테넌트 ID 목록
-- =====================
CREATE OR REPLACE FUNCTION auth.user_tenant_ids()
RETURNS SETOF UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT tenant_id
  FROM public.user_tenants
  WHERE user_id = (SELECT auth.uid())
$$;

-- =====================
-- 7. Helper Function — 특정 테넌트의 역할
-- =====================
CREATE OR REPLACE FUNCTION auth.user_role_in_tenant(p_tenant_id UUID)
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT role
  FROM public.user_tenants
  WHERE user_id = (SELECT auth.uid())
    AND tenant_id = p_tenant_id
  LIMIT 1
$$;

-- =====================
-- 8. Trigger — updated_at 자동 갱신
-- =====================
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
