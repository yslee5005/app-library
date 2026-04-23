-- ============================================================================
-- 20260423000004: Phase 4.1 — Section-based AI with cached rubrics
-- ----------------------------------------------------------------------------
-- Adds:
--   1. abba.prayers.section_status JSONB — tier completion tracking
--   2. public.system_config table — Gemini cache_id storage
--   3. abba.update_prayer_tier() RPC — atomic per-tier UPDATE (lost-update safe)
--
-- All changes are ADDITIVE. No existing columns/data modified.
-- Rollback: see §4 at bottom.
--
-- See:
--   apps/abba/specs/phase_4_1_section_based_ai/_details/data_model.md
--   apps/abba/specs/phase_4_1_section_based_ai/_details/cache_strategy.md
--   .claude/rules/learned-pitfalls.md §2-1, §3, §11
-- ============================================================================


-- ---------------------------------------------------------------------------
-- 1. abba.prayers — section_status column
-- ---------------------------------------------------------------------------

ALTER TABLE abba.prayers
  ADD COLUMN IF NOT EXISTS section_status JSONB NOT NULL DEFAULT '{}'::jsonb;

COMMENT ON COLUMN abba.prayers.section_status IS
  'Per-tier completion tracking for 3-tier lazy generation. '
  'Example: {"t1":"completed","t2":"pending","t3":"not_applicable"}. '
  'Used by client to decide which UI cards to render.';

-- Partial index for pending prayer queries (used by Edge Function retry flow)
CREATE INDEX IF NOT EXISTS idx_prayers_tier_pending
  ON abba.prayers (user_id, ai_status)
  WHERE ai_status IN ('pending', 'processing');


-- ---------------------------------------------------------------------------
-- 2. public.system_config — Gemini cache_id + rubric version storage
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.system_config (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.system_config IS
  'Key-value store for shared system configuration (Gemini cache IDs, rubric versions). '
  'Readable by all authenticated users; writable only by service_role.';

-- Seed initial values (all null until first cache creation)
INSERT INTO public.system_config (key, value) VALUES
  ('prayer_cache_id',         'null'::jsonb),
  ('prayer_cache_expires_at', 'null'::jsonb),
  ('prayer_rubrics_version',  '""'::jsonb),
  ('qt_cache_id',             'null'::jsonb),
  ('qt_cache_expires_at',     'null'::jsonb),
  ('qt_rubrics_version',      '""'::jsonb)
ON CONFLICT (key) DO NOTHING;

-- RLS: read allowed to all, write only via service_role (no policy = blocked)
ALTER TABLE public.system_config ENABLE ROW LEVEL SECURITY;

CREATE POLICY system_config_read
  ON public.system_config FOR SELECT USING (true);

-- No INSERT/UPDATE/DELETE policies = only service_role can write (bypasses RLS)


-- ---------------------------------------------------------------------------
-- 3. abba.update_prayer_tier — atomic tier UPDATE function
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION abba.update_prayer_tier(
  p_prayer_id UUID,
  p_tier TEXT,                   -- 't1' | 't2' | 't3'
  p_section_data JSONB
) RETURNS void AS $$
BEGIN
  -- Validate tier parameter
  IF p_tier NOT IN ('t1', 't2', 't3') THEN
    RAISE EXCEPTION 'Invalid tier: %. Must be t1, t2, or t3.', p_tier;
  END IF;

  -- Atomic UPDATE using JSONB || concat operator:
  -- result_new = existing_result || incoming_section_data
  -- section_status_new = existing_status || {tier: 'completed'}
  -- Postgres row-level lock ensures no lost updates under concurrent T1/T2 calls.
  UPDATE abba.prayers
  SET
    result = COALESCE(result, '{}'::jsonb) || p_section_data,
    section_status = COALESCE(section_status, '{}'::jsonb)
                     || jsonb_build_object(p_tier, 'completed'),
    -- Auto-promote ai_status='completed' when T1 + T2 both done
    ai_status = CASE
      WHEN (COALESCE(section_status, '{}'::jsonb)
            || jsonb_build_object(p_tier, 'completed'))
           @> '{"t1":"completed","t2":"completed"}'::jsonb
        THEN 'completed'
      ELSE ai_status
    END
  WHERE id = p_prayer_id
    AND user_id = auth.uid();  -- Implicit auth: only update own prayers

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Prayer % not found or not owned by current user', p_prayer_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Authenticated users can call this (function body enforces user_id match)
GRANT EXECUTE ON FUNCTION abba.update_prayer_tier(UUID, TEXT, JSONB) TO authenticated;

COMMENT ON FUNCTION abba.update_prayer_tier IS
  '3-tier lazy generation: atomic UPDATE of result JSONB + section_status. '
  'Uses || operator for safe concurrent updates (no lost-update risk). '
  'Auto-promotes ai_status to completed when both T1 and T2 done. '
  'SECURITY DEFINER + WHERE user_id=auth.uid() ensures users only update own prayers.';


-- ---------------------------------------------------------------------------
-- 4. Rollback (for reference — do not execute unless explicitly needed)
-- ---------------------------------------------------------------------------
-- DROP FUNCTION IF EXISTS abba.update_prayer_tier(UUID, TEXT, JSONB);
-- ALTER TABLE abba.prayers DROP COLUMN IF EXISTS section_status;
-- DROP INDEX IF EXISTS abba.idx_prayers_tier_pending;
-- DROP POLICY IF EXISTS system_config_read ON public.system_config;
-- DROP TABLE IF EXISTS public.system_config;
--
-- No existing data is modified; rollback loses only the Phase 4.1 metadata.
