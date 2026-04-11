-- ============================================================
-- Page Content — Admin CMS Table
-- ============================================================

CREATE TABLE blacklabelled.page_content (
  page_key TEXT PRIMARY KEY,
  content JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE blacklabelled.page_content ENABLE ROW LEVEL SECURITY;
CREATE POLICY "page_content_select" ON blacklabelled.page_content
  FOR SELECT USING (true);

-- ── Seed: Home ──
INSERT INTO blacklabelled.page_content (page_key, content) VALUES
('home', '{
  "hero": {
    "product_slug": null,
    "title": "BLACKLABELLED",
    "subtitle": "Your space is ''black label''"
  },
  "intro": {
    "heading": "Residential Space\nDesign Studio",
    "description": "공간과 사용자 사이에는 보이지 않는 수많은 이야기가 혼재합니다. 블랙라벨드는 그 이야기를 읽어내고, 설계를 통해 공간에 생명을 부여합니다. 427개 이상의 프로젝트를 통해 쌓아온 경험으로, 당신만의 공간을 블랙라벨로 만들어 드립니다.",
    "link_text": "LEARN MORE",
    "link_url": "/about",
    "project1_slug": null,
    "project2_slug": null
  },
  "carousel": {
    "mode": "all",
    "max_count": null
  },
  "grid": {
    "mode": "latest",
    "max_count": 12
  }
}'::jsonb);
