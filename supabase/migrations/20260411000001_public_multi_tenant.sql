-- ============================================================
-- Public Schema — Multi-Tenant Infrastructure
-- ============================================================

-- 1. Tenants
CREATE TABLE IF NOT EXISTS tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  plan TEXT DEFAULT 'free',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tenants_select" ON tenants FOR SELECT USING (true);

-- 2. User-Tenant Mapping
CREATE TABLE IF NOT EXISTS user_tenants (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'viewer',
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, tenant_id)
);

ALTER TABLE user_tenants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_tenants_select" ON user_tenants FOR SELECT USING (true);

-- 3. Tenant Settings
CREATE TABLE IF NOT EXISTS tenant_settings (
  tenant_id UUID PRIMARY KEY REFERENCES tenants(id) ON DELETE CASCADE,
  theme TEXT DEFAULT 'default',
  logo_url TEXT,
  locale TEXT DEFAULT 'ko',
  feature_flags JSONB DEFAULT '{}'::jsonb
);

ALTER TABLE tenant_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tenant_settings_select" ON tenant_settings FOR SELECT USING (true);

-- 4. Languages
CREATE TABLE IF NOT EXISTS languages (
  code TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true
);

ALTER TABLE languages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "languages_select" ON languages FOR SELECT USING (true);

-- 5. Translations
CREATE TABLE IF NOT EXISTS translations (
  id SERIAL PRIMARY KEY,
  table_schema TEXT NOT NULL,
  table_name TEXT NOT NULL,
  record_id UUID NOT NULL,
  field_name TEXT NOT NULL,
  lang_code TEXT NOT NULL REFERENCES languages(code),
  value TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (table_schema, table_name, record_id, field_name, lang_code)
);

ALTER TABLE translations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "translations_select" ON translations FOR SELECT USING (true);

CREATE INDEX idx_translations_lookup
  ON translations(table_schema, table_name, record_id, lang_code);

-- 6. updated_at trigger function
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
