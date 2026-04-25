-- ============================================================================
-- 20260425000001: Phase A1 — section_status 'failed' state support
-- ----------------------------------------------------------------------------
-- Adds:
--   1. abba.mark_tier_failed() RPC — record per-tier partial failure
--      (T2/T3) in section_status JSONB without flipping ai_status.
--
-- Rationale:
--   Today, when T2 or T3 streaming fails after T1 success, the client only
--   tracks `failedTiers` in notifier memory. ai_status is already 'completed'
--   (flipped on T1 arrival via completePrayer), so the row appears finished
--   on calendar but renders empty cards on dashboard.
--
--   This RPC lets the client persist the partial-failed state so:
--     - Dashboard can show inline "분석 일부를 불러오지 못했어요" indicator
--       (Phase A2 reads section_status->'tx' == 'failed').
--     - Future Edge partial retry (Phase A.5+) can SELECT rows where
--       section_status @> '{"t2":"failed"}'.
--
-- Recovery semantics:
--   On successful T2 retry, update_prayer_tier(p_tier='t2') runs:
--     section_status || {t2:'completed'}
--   The `||` operator overwrites the prior 'failed' value. No guard required.
--
-- All changes are ADDITIVE. No existing columns/data modified.
-- Rollback: see §3 at bottom.
--
-- See:
--   apps/abba/specs/REQUIREMENTS.md §11
--   .claude/rules/learned-pitfalls.md §2-1
-- ============================================================================


-- ---------------------------------------------------------------------------
-- 1. abba.mark_tier_failed — atomic per-tier failure recording
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION abba.mark_tier_failed(
  p_prayer_id UUID,
  p_tier TEXT,                   -- 't1' | 't2' | 't3'
  p_error_kind TEXT              -- opaque tag (e.g., 'apiError', 'parseError')
) RETURNS void AS $$
BEGIN
  -- Validate tier parameter
  IF p_tier NOT IN ('t1', 't2', 't3') THEN
    RAISE EXCEPTION 'Invalid tier: %. Must be t1, t2, or t3.', p_tier;
  END IF;

  -- Atomic UPDATE: section_status || {tier: 'failed'}.
  -- ai_status is intentionally NOT touched — partial-failed rows keep their
  -- existing ai_status (typically 'completed' after T1 success). The dashboard
  -- inline indicator reads section_status to render the partial state.
  --
  -- p_error_kind is intentionally not stored; logs already capture it via
  -- prayerLog/Sentry. Storing it here adds no value and would require a
  -- nested JSONB structure that update_prayer_tier could not safely overwrite.
  UPDATE abba.prayers
  SET section_status = COALESCE(section_status, '{}'::jsonb)
                       || jsonb_build_object(p_tier, 'failed')
  WHERE id = p_prayer_id
    AND user_id = auth.uid();

  -- IF NOT FOUND: silently no-op. Client persistence is best-effort —
  -- in-memory failedTiers state already reflects the failure for the
  -- current session. Examples of legitimate misses:
  --   - prayerId stale after re-login (different auth.uid())
  --   - row deleted by user during failure handling
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Authenticated users can call this (function body enforces user_id match)
GRANT EXECUTE ON FUNCTION abba.mark_tier_failed(UUID, TEXT, TEXT) TO authenticated;

COMMENT ON FUNCTION abba.mark_tier_failed IS
  'Phase A1 — record partial-failed tier (T2/T3) in section_status JSONB. '
  'ai_status is intentionally untouched. Subsequent successful '
  'update_prayer_tier(p_tier) overwrites ''failed'' via || operator. '
  'SECURITY DEFINER + WHERE user_id=auth.uid() restricts to own rows.';


-- ---------------------------------------------------------------------------
-- 2. Update column comment to document the 'failed' value
-- ---------------------------------------------------------------------------

COMMENT ON COLUMN abba.prayers.section_status IS
  'Per-tier completion tracking for 3-tier lazy generation. '
  'Values: ''pending'' | ''completed'' | ''failed'' | ''not_applicable''. '
  'Example: {"t1":"completed","t2":"failed"} (T2 streaming failed after T1 OK). '
  'Used by client to render dashboard inline state and (Phase A.5+) by Edge '
  'Function partial-retry queries.';


-- ---------------------------------------------------------------------------
-- 3. Rollback (for reference — do not execute unless explicitly needed)
-- ---------------------------------------------------------------------------
-- DROP FUNCTION IF EXISTS abba.mark_tier_failed(UUID, TEXT, TEXT);
-- COMMENT ON COLUMN abba.prayers.section_status IS
--   'Per-tier completion tracking for 3-tier lazy generation. '
--   'Example: {"t1":"completed","t2":"pending","t3":"not_applicable"}. '
--   'Used by client to decide which UI cards to render.';
--
-- No existing data is modified; rollback only removes the new function.
