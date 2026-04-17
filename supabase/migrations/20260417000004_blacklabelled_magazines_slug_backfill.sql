-- ============================================================
-- BlackLabelled — Magazines slug backfill
-- ============================================================
-- Purpose: 기존 slug IS NULL 매거진 4건에 slug 채움
-- - seed 3건: 의미 있는 영문 slug
-- - 수동 테스트 1건: 제목 + UUID 접두사 fallback
--
-- 멱등성: slug가 이미 있거나 값이 설정된 row는 변경하지 않음

UPDATE blacklabelled.magazines
SET slug = '2026-interior-trends'
WHERE id = 'b794c621-e56e-46c0-874f-980994f63d10'
  AND (slug IS NULL OR slug = '');

UPDATE blacklabelled.magazines
SET slug = 'minimal-living-space'
WHERE id = 'c9e64582-d7d6-47f7-80fd-2fe96825696f'
  AND (slug IS NULL OR slug = '');

UPDATE blacklabelled.magazines
SET slug = 'custom-furniture-value'
WHERE id = '3c48894d-316a-4350-bbc9-62cbf0ec81ec'
  AND (slug IS NULL OR slug = '');

UPDATE blacklabelled.magazines
SET slug = 'test-magazine-b651'
WHERE id = 'b651c1c8-2b2f-42fb-bd45-868fe3964408'
  AND (slug IS NULL OR slug = '');
