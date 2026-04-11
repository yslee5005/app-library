-- ============================================================
-- Seed Data — BlackLabelled tenant + languages
-- ============================================================

-- Languages
INSERT INTO languages (code, name, is_active) VALUES
  ('ko', '한국어', true),
  ('en', 'English', true),
  ('ja', '日本語', false),
  ('zh', '中文', false)
ON CONFLICT (code) DO NOTHING;

-- BlackLabelled tenant
INSERT INTO tenants (id, name, slug, plan, is_active) VALUES
  ('00000000-0000-0000-0000-000000000001', 'BlackLabelled', 'blacklabelled', 'pro', true)
ON CONFLICT (slug) DO NOTHING;

-- BlackLabelled settings
INSERT INTO tenant_settings (tenant_id, theme, locale, feature_flags) VALUES
  ('00000000-0000-0000-0000-000000000001', 'dark', 'ko', '{"map_view": true}'::jsonb)
ON CONFLICT (tenant_id) DO NOTHING;
