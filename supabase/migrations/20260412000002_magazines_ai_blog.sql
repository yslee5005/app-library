-- ============================================================
-- Magazines AI Blog System — Schema Extension
-- ============================================================

-- 1. magazines 테이블 확장
ALTER TABLE blacklabelled.magazines
  ADD COLUMN html_content TEXT,
  ADD COLUMN status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
  ADD COLUMN project_id UUID REFERENCES blacklabelled.products(id) ON DELETE SET NULL,
  ADD COLUMN tags TEXT[],
  ADD COLUMN seo_keywords TEXT[],
  ADD COLUMN slug TEXT,
  ADD COLUMN ai_generated BOOLEAN DEFAULT false;

CREATE UNIQUE INDEX idx_bl_magazines_slug
  ON blacklabelled.magazines(slug)
  WHERE slug IS NOT NULL;

-- 기존 3개 seed 매거진을 published로
UPDATE blacklabelled.magazines SET status = 'published' WHERE status IS NULL;

-- 2. AI 분석 캐시 (이미지/프로젝트 재분석 방지)
CREATE TABLE blacklabelled.ai_analysis_cache (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  target_type TEXT NOT NULL CHECK (target_type IN ('product', 'product_image')),
  target_id UUID NOT NULL,
  analysis JSONB NOT NULL,
  model TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (target_type, target_id, model)
);

ALTER TABLE blacklabelled.ai_analysis_cache ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ai_cache_select" ON blacklabelled.ai_analysis_cache
  FOR SELECT USING (true);
CREATE POLICY "ai_cache_insert_admin" ON blacklabelled.ai_analysis_cache
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );
