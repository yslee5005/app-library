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

-- BlackLabelled tenant (UUID auto-generated)
INSERT INTO tenants (name, slug, plan, is_active) VALUES
  ('BlackLabelled', 'blacklabelled', 'pro', true)
ON CONFLICT (slug) DO NOTHING;

-- BlackLabelled settings (reference by slug, not hardcoded UUID)
INSERT INTO tenant_settings (tenant_id, theme, locale, feature_flags)
SELECT id, 'dark', 'ko', '{"map_view": true}'::jsonb
FROM tenants WHERE slug = 'blacklabelled'
ON CONFLICT (tenant_id) DO NOTHING;
