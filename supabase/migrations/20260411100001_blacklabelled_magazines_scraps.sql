-- ============================================================
-- BlackLabelled — Magazines + Scraps tables
-- ============================================================

-- 1. Magazines
CREATE TABLE blacklabelled.magazines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  summary TEXT,
  thumbnail_path TEXT,
  date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE blacklabelled.magazines ENABLE ROW LEVEL SECURITY;
CREATE POLICY "magazines_select" ON blacklabelled.magazines
  FOR SELECT USING (true);

CREATE INDEX idx_bl_magazines_tenant ON blacklabelled.magazines(tenant_id);
CREATE INDEX idx_bl_magazines_date ON blacklabelled.magazines(date DESC);

CREATE TRIGGER magazines_updated_at
  BEFORE UPDATE ON blacklabelled.magazines
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- 2. Scraps (Anonymous-First: user_id from auth.uid())
CREATE TABLE blacklabelled.scraps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  user_id UUID NOT NULL,
  content_type TEXT NOT NULL CHECK (content_type IN ('product', 'magazine')),
  content_id UUID NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, content_type, content_id)
);

ALTER TABLE blacklabelled.scraps ENABLE ROW LEVEL SECURITY;

CREATE POLICY "scraps_select_own" ON blacklabelled.scraps
  FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "scraps_insert_own" ON blacklabelled.scraps
  FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "scraps_delete_own" ON blacklabelled.scraps
  FOR DELETE USING (user_id = auth.uid());

CREATE INDEX idx_bl_scraps_user ON blacklabelled.scraps(user_id);
CREATE INDEX idx_bl_scraps_content ON blacklabelled.scraps(user_id, content_type, content_id);

-- 3. Seed: 매거진 (thumbnail_path = null, Admin에서 Storage 업로드 후 설정)
INSERT INTO blacklabelled.magazines (tenant_id, title, summary, thumbnail_path, date)
SELECT t.id,
  '2026 인테리어 트렌드',
  '올해 주목해야 할 인테리어 키워드를 정리했습니다. 미니멀리즘의 진화, 바이오필릭 디자인, 커브드 퍼니처 등 전문가가 선정한 트렌드를 만나보세요.',
  NULL,
  '2026-04-01'
FROM public.tenants t WHERE t.slug = 'blacklabelled';

INSERT INTO blacklabelled.magazines (tenant_id, title, summary, thumbnail_path, date)
SELECT t.id,
  '미니멀 주거 공간의 비밀',
  '적게 가지되 풍요롭게 사는 미니멀 라이프. 블랙라벨드가 제안하는 미니멀 주거 공간 설계의 핵심 원칙과 실제 적용 사례를 소개합니다.',
  NULL,
  '2026-03-15'
FROM public.tenants t WHERE t.slug = 'blacklabelled';

INSERT INTO blacklabelled.magazines (tenant_id, title, summary, thumbnail_path, date)
SELECT t.id,
  '커스텀 가구의 가치',
  '기성품이 아닌, 나만의 공간에 딱 맞는 가구. 커스텀 가구가 인테리어에서 왜 중요한지, 블랙라벨드의 제작 과정과 함께 알려드립니다.',
  NULL,
  '2026-02-20'
FROM public.tenants t WHERE t.slug = 'blacklabelled';
