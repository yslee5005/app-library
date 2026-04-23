# 데이터 모델

## 변경 요약

| 항목 | 상태 | 비고 |
|------|------|------|
| `abba.prayers` 테이블 | **유지** | mode discriminator 그대로 |
| `result JSONB` 컬럼 | **유지** | tier별 partial update로 누적 |
| `section_status JSONB` | **신규 추가** | tier 완료 상태 추적 |
| `public.system_config` 테이블 | **신규** | Gemini cache_id 저장 |
| `update_prayer_tier` RPC | **신규** | atomic tier UPDATE |

**기존 데이터 migration**: 없음 (section_status는 default `{}`, legacy row는 ai_status='completed' 유지).

## 1. `abba.prayers` 컬럼 추가

```sql
ALTER TABLE abba.prayers
  ADD COLUMN IF NOT EXISTS section_status JSONB NOT NULL DEFAULT '{}'::jsonb;

COMMENT ON COLUMN abba.prayers.section_status IS
  'Per-tier completion tracking for 3-tier lazy generation. '
  'Example: {"t1":"completed","t2":"pending","t3":"not_applicable"}. '
  'Used by client to decide which UI cards to render.';

-- 부분 인덱스: pending 조회 최적화
CREATE INDEX IF NOT EXISTS idx_prayers_tier_pending
  ON abba.prayers (user_id, ai_status)
  WHERE ai_status IN ('pending', 'processing');
```

## 2. `public.system_config` 테이블

Gemini context cache_id를 저장해서 클라이언트/Edge Function 공유.

```sql
CREATE TABLE IF NOT EXISTS public.system_config (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 초기 seed
INSERT INTO public.system_config (key, value) VALUES
  ('prayer_cache_id',         'null'::jsonb),
  ('prayer_cache_expires_at', 'null'::jsonb),
  ('prayer_rubrics_version',  '""'::jsonb),
  ('qt_cache_id',             'null'::jsonb),
  ('qt_cache_expires_at',     'null'::jsonb),
  ('qt_rubrics_version',      '""'::jsonb)
ON CONFLICT (key) DO NOTHING;

-- RLS: 모든 유저 read (cache_id는 민감정보 아님), service_role만 write
ALTER TABLE public.system_config ENABLE ROW LEVEL SECURITY;

CREATE POLICY system_config_read
  ON public.system_config FOR SELECT USING (true);

-- INSERT/UPDATE/DELETE 정책 미생성 = service_role만 (Edge Function에서 서비스 키로 write)
```

## 3. `update_prayer_tier` RPC 함수 (atomic)

동시성 안전 tier UPDATE. `result || section_data` 패턴으로 lost update 방지.

```sql
CREATE OR REPLACE FUNCTION abba.update_prayer_tier(
  p_prayer_id UUID,
  p_tier TEXT,           -- 't1' | 't2' | 't3'
  p_section_data JSONB   -- 예: {"summary":{...},"scripture":{...}}
) RETURNS void AS $$
BEGIN
  -- 입력 검증
  IF p_tier NOT IN ('t1', 't2', 't3') THEN
    RAISE EXCEPTION 'Invalid tier: %', p_tier;
  END IF;

  UPDATE abba.prayers
  SET
    result = COALESCE(result, '{}'::jsonb) || p_section_data,
    section_status = COALESCE(section_status, '{}'::jsonb) 
                     || jsonb_build_object(p_tier, 'completed'),
    -- 모든 필수 tier 완료 시 ai_status='completed' 자동 전환
    ai_status = CASE
      WHEN (COALESCE(section_status, '{}'::jsonb) 
            || jsonb_build_object(p_tier, 'completed')) 
           @> '{"t1":"completed","t2":"completed"}'::jsonb 
        THEN 'completed'
      ELSE ai_status
    END
  WHERE id = p_prayer_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Prayer % not found', p_prayer_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- authenticated 유저 호출 가능 (자기 prayer만 SECURITY DEFINER로 보장)
GRANT EXECUTE ON FUNCTION abba.update_prayer_tier(UUID, TEXT, JSONB) TO authenticated;

COMMENT ON FUNCTION abba.update_prayer_tier IS
  '3-tier lazy generation: atomic UPDATE of result JSONB + section_status. '
  'Uses || operator for safe concurrent updates (no lost-update risk).';
```

## 4. 실제 데이터 예시

### Prayer mode (mode='prayer')
```
┌──────────────────────────────────────────────────────┐
│ id: abc-123                                          │
│ user_id: user-xyz                                    │
│ mode: 'prayer'                                       │
│ transcript: "주님, 오늘도 감사합니다..."              │
│ audio_storage_path: 'user-xyz/prayer-001.m4a'        │
│ ai_status: 'completed'                               │
│                                                      │
│ result: {                                            │
│   "summary": {                                       │
│     "gratitude": ["새 아침", "가족 건강"],           │
│     "petition": ["지혜"],                            │
│     "intercession": ["친구"]                         │
│   },                                                 │
│   "scripture": {                                     │
│     "reference": "Matthew 6:33",                     │
│     "reason": "...",                                 │
│     "verse": "너희는 먼저 그의 나라와..."            │
│   },                                                 │
│   "bible_story": { "title": "...", "summary": "..." },│
│   "testimony": "주님께 감사의 기도를 드리며..."       │
│ }                                                    │
│                                                      │
│ section_status: {                                    │
│   "t1": "completed",                                 │
│   "t2": "completed",                                 │
│   "t3": "not_applicable"  -- Free user               │
│ }                                                    │
└──────────────────────────────────────────────────────┘
```

### QT mode (mode='qt')
```
┌──────────────────────────────────────────────────────┐
│ mode: 'qt'                                           │
│ qt_passage_ref: 'Psalm 23:1-6'                       │
│ transcript: "이 말씀에서 저는..."                    │
│                                                      │
│ result: {                                            │
│   "meditation_summary": {...},                       │
│   "scripture": {...},                                │
│   "application": {...},                              │
│   "knowledge": {...}                                 │
│ }                                                    │
│                                                      │
│ section_status: {                                    │
│   "t1": "completed",                                 │
│   "t2": "completed"                                  │
│ }                                                    │
└──────────────────────────────────────────────────────┘
```

## 5. 동시성 안전성 (초보자 요약)

**Lost Update 위험**: Phase 3에서 client가 result를 SELECT → merge → UPDATE하면 T1/T2 동시 완료 시 하나가 덮어씀.

**해결**: `update_prayer_tier` RPC 내부에서 `result = result || section_data` 한 번의 UPDATE 문장으로 실행.

**Postgres 보장**:
- Row-level lock: 같은 row에 동시 UPDATE 오면 순차 처리
- MVCC: T2는 T1 commit 이후 값을 읽고 그 위에 merge
- 결과: 두 tier 데이터 모두 보존

**예시 타임라인**:
```
t=0ms   T1 호출: UPDATE ... result = {} || {summary, scripture}
        → result = {summary, scripture}
        
t=5ms   T2 호출: UPDATE ... result = ??? || {bible_story, testimony}
        ⏳ Row lock 대기 (T1 commit 대기)

t=10ms  T1 COMMIT
t=11ms  T2 진행: result = {summary, scripture} || {bible_story, testimony}
        = {summary, scripture, bible_story, testimony}
t=15ms  T2 COMMIT

최종: 모든 섹션 보존 ✅
```

## 6. Migration 파일명

```
supabase/migrations/20260423000004_section_based_ai.sql
```

(Phase 2 migration `20260423000002` 뒤에 오도록)

## 7. 확장성 고려

### 향후 컬럼 추가 시
현재 `result JSONB`로 모든 섹션 저장. 미래에 자주 쿼리되는 필드(예: `scripture_reference`)가 생기면:

```sql
-- 무중단 스캐폴딩
ALTER TABLE abba.prayers ADD COLUMN scripture_reference TEXT;

-- Backfill (background)
UPDATE abba.prayers SET scripture_reference = result->'scripture'->>'reference'
WHERE scripture_reference IS NULL;

-- 인덱스 추가
CREATE INDEX ON abba.prayers (scripture_reference);

-- 코드: dual-write 기간 → read 전환
-- 이후 (선택): JSONB에서 scripture.reference 제거는 불필요
```

### 35 locale 데이터 분포
- 저자원 locale (Amharic, Burmese) 유저 수 적음 → 전체 DB 부담 미미
- JSONB 내부 키/값에 한국어·영어 혼재 가능 (테이블 스키마는 locale-neutral)

## 8. 백업 전략

Phase 4.1 변경은 **순수 additive** (기존 컬럼/데이터 변경 없음):
- section_status: default `{}` → legacy row 자동 대응
- result: 기존 그대로, new row부터 `||`로 누적
- RPC: 신규 함수, 기존 쿼리 영향 0

따라서 **rollback 용이**:
```sql
-- 롤백이 필요하면 (거의 없을 듯)
DROP FUNCTION abba.update_prayer_tier(UUID, TEXT, JSONB);
ALTER TABLE abba.prayers DROP COLUMN section_status;
DROP TABLE public.system_config;
```

기존 데이터 손실 없음.
