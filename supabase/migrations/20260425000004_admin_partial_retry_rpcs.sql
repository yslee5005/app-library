-- ============================================================================
-- 20260425000004: Phase B4 — Admin RPCs for Edge Function partial-tier retry
-- ----------------------------------------------------------------------------
-- Adds three SECURITY DEFINER functions callable ONLY by service_role from
-- the `process_pending_prayer` Edge Function. These let the Edge Function:
--
--   1. claim_failed_tier()       — atomically lock a partial-failed OR
--                                  stale-processing tier into 'processing'
--   2. complete_tier_admin()     — merge result JSONB + flip section_status
--                                  to 'completed' (with optional ai_status
--                                  auto-promotion mirroring the client RPC)
--   3. revert_tier_processing()  — undo a claim back to 'failed' when the
--                                  Gemini call throws after lock; atomically
--                                  bumps server_retry_count by default so
--                                  the shared MAX_SERVER_RETRIES budget
--                                  covers both pending and partial paths
--
-- §0. Pre-push amendment (B4 contract bug found during B2 design)
--   Original B4 wrote revert_tier_processing without touching
--   server_retry_count, which would have forced the B2 Edge code into a
--   second non-atomic UPDATE to bump the counter. Since the migration was
--   not yet pushed, the contract was corrected in place: revert_tier_processing
--   now takes p_increment_retry_count BOOLEAN DEFAULT TRUE and increments
--   the counter atomically. claim_failed_tier intentionally still does NOT
--   look at server_retry_count — gating belongs in the Edge candidate SELECT
--   (cheaper, avoids burning a claim attempt on a row that's already capped).
--
-- Why separate from the existing client RPCs:
--   - update_prayer_tier / mark_tier_failed use auth.uid() to enforce
--     ownership. They are correct for client calls but unusable from
--     service_role context (auth.uid() returns NULL). Phase B4 adds a
--     parallel admin surface that takes p_user_id explicitly.
--   - Race-safety: claim_failed_tier's WHERE clause makes the claim
--     atomic. A second concurrent caller sees 'processing' just set and
--     last_retry_at = NOW(), so the staleness predicate fails — no double
--     claim possible.
--   - Stale-processing recovery: a previous Edge invocation that crashed
--     between claim and complete leaves a row stuck on 'processing'. The
--     `p_stale_after_minutes` parameter lets a future invocation re-claim
--     it once enough time has passed (caller decides the threshold; no
--     default to keep B2/B3 policy explicit).
--
-- Adds the value 'processing' to the `section_status` per-tier value
-- domain (was: 'pending' | 'completed' | 'failed' | 'not_applicable').
-- Verified safe vs. existing client code:
--   - Prayer.fromJson coerces all values to String via Map.toString() —
--     no enum gate; new values pass through.
--   - prayer_dashboard_view / qt_dashboard_view branch on
--     `sectionStatus['t*'] == 'failed'` only — 'processing' falls into
--     the no-indicator branch (semantically correct: work in progress).
--
-- All changes are ADDITIVE. Existing client RPCs (update_prayer_tier,
-- mark_tier_failed) are NOT modified. Rollback: see §5 at bottom.
--
-- See:
--   apps/abba/specs/REQUIREMENTS.md §11
--   supabase/migrations/20260423000004_section_based_ai.sql      (client RPC)
--   supabase/migrations/20260425000001_section_status_failed.sql (client RPC)
--   supabase/functions/abba-process-pending-prayer/index.ts       (B2 caller)
--   .claude/rules/learned-pitfalls.md §2-1, §3
-- ============================================================================


-- ---------------------------------------------------------------------------
-- 1. abba.claim_failed_tier — atomic claim of a tier for retry
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION abba.claim_failed_tier(
  p_prayer_id UUID,
  p_user_id UUID,
  p_tier TEXT,                   -- 't1' | 't2' | 't3'
  p_stale_after_minutes INT      -- recover stuck 'processing' older than this
) RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = abba, public
AS $$
DECLARE
  v_row_count INTEGER := 0;
BEGIN
  -- Validate tier parameter
  IF p_tier NOT IN ('t1', 't2', 't3') THEN
    RAISE EXCEPTION 'Invalid tier: %. Must be t1, t2, or t3.', p_tier;
  END IF;

  IF p_stale_after_minutes IS NULL OR p_stale_after_minutes < 0 THEN
    RAISE EXCEPTION 'p_stale_after_minutes must be >= 0, got %.', p_stale_after_minutes;
  END IF;

  -- Atomic claim: lock the row only if the tier is currently 'failed', OR
  -- it is 'processing' but stuck (last_retry_at is NULL or older than the
  -- caller-supplied stale window). The matching predicate is in WHERE so
  -- two concurrent callers cannot both succeed — the second one sees the
  -- row already in 'processing' with a fresh last_retry_at and bails.
  UPDATE abba.prayers
  SET
    section_status = COALESCE(section_status, '{}'::jsonb)
                     || jsonb_build_object(p_tier, 'processing'),
    last_retry_at = now()
  WHERE id = p_prayer_id
    AND user_id = p_user_id
    AND (
      section_status->>p_tier = 'failed'
      OR (
        section_status->>p_tier = 'processing'
        AND (
          last_retry_at IS NULL
          OR last_retry_at < now() - make_interval(mins => p_stale_after_minutes)
        )
      )
    );

  GET DIAGNOSTICS v_row_count = ROW_COUNT;
  RETURN v_row_count > 0;
END;
$$;

COMMENT ON FUNCTION abba.claim_failed_tier(UUID, UUID, TEXT, INT) IS
  'Phase B4 — atomically claim a partial-failed OR stale-processing tier '
  'into ''processing''. Returns TRUE if the claim won, FALSE if the row '
  'was not in a claimable state (already completed, fresh ''processing'', '
  'wrong user, or row missing). SECURITY DEFINER + p_user_id arg — caller '
  '(service_role from Edge) is responsible for the ownership match.';


-- ---------------------------------------------------------------------------
-- 2. abba.complete_tier_admin — merge result + flip to 'completed'
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION abba.complete_tier_admin(
  p_prayer_id UUID,
  p_user_id UUID,
  p_tier TEXT,                   -- 't1' | 't2' | 't3'
  p_section_data JSONB
) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = abba, public
AS $$
BEGIN
  -- Validate tier parameter
  IF p_tier NOT IN ('t1', 't2', 't3') THEN
    RAISE EXCEPTION 'Invalid tier: %. Must be t1, t2, or t3.', p_tier;
  END IF;

  -- Mirrors abba.update_prayer_tier semantics, with two differences:
  --   (a) p_user_id explicit (no auth.uid() — admin context)
  --   (b) WHERE section_status->>p_tier = 'processing' guard prevents a
  --       stale Edge worker from overwriting a row that has since been
  --       reverted, re-claimed, or completed by another path.
  -- Auto-promotion of ai_status to 'completed' triggers when both T1 and
  -- T2 land — same rule as the client RPC.
  UPDATE abba.prayers
  SET
    result = COALESCE(result, '{}'::jsonb) || p_section_data,
    section_status = COALESCE(section_status, '{}'::jsonb)
                     || jsonb_build_object(p_tier, 'completed'),
    last_retry_at = now(),
    ai_status = CASE
      WHEN (COALESCE(section_status, '{}'::jsonb)
            || jsonb_build_object(p_tier, 'completed'))
           @> '{"t1":"completed","t2":"completed"}'::jsonb
        THEN 'completed'
      ELSE ai_status
    END
  WHERE id = p_prayer_id
    AND user_id = p_user_id
    AND section_status->>p_tier = 'processing';

  -- IF NOT FOUND: silent noop. The Edge worker's claim has been invalidated
  -- (row deleted, user mismatch, or another path already moved the tier
  -- out of 'processing'). The caller should treat this as "lost the race"
  -- and not retry the same payload.
END;
$$;

COMMENT ON FUNCTION abba.complete_tier_admin(UUID, UUID, TEXT, JSONB) IS
  'Phase B4 — merge p_section_data into result JSONB and flip the tier to '
  '''completed'', but only if the tier is currently ''processing''. Auto-'
  'promotes ai_status to ''completed'' when T1+T2 both done (same rule as '
  'update_prayer_tier). Silent noop if the processing guard fails — the '
  'Edge caller has lost the race and should not retry.';


-- ---------------------------------------------------------------------------
-- 3. abba.revert_tier_processing — undo a claim back to 'failed'
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION abba.revert_tier_processing(
  p_prayer_id UUID,
  p_user_id UUID,
  p_tier TEXT,                              -- 't1' | 't2' | 't3'
  p_increment_retry_count BOOLEAN DEFAULT TRUE  -- pre-push amendment: see §0
) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = abba, public
AS $$
BEGIN
  -- Validate tier parameter
  IF p_tier NOT IN ('t1', 't2', 't3') THEN
    RAISE EXCEPTION 'Invalid tier: %. Must be t1, t2, or t3.', p_tier;
  END IF;

  -- Only revert if we still own the 'processing' lock. Atomic with the
  -- failure-counter increment so the Edge caller does not need a separate
  -- UPDATE (which would split responsibility and create a partial-failure
  -- race window). last_retry_at is refreshed to drive the cooldown the
  -- Edge caller's policy applies (B2/B3 stale window).
  --
  -- p_increment_retry_count default TRUE — the canonical revert path is
  -- "Gemini failed, count this attempt". Pass FALSE only for niche cases
  -- (operator manual revert, deliberate non-quota-burning recovery).
  UPDATE abba.prayers
  SET
    section_status = COALESCE(section_status, '{}'::jsonb)
                     || jsonb_build_object(p_tier, 'failed'),
    last_retry_at = now(),
    server_retry_count = server_retry_count
                         + CASE WHEN p_increment_retry_count THEN 1 ELSE 0 END
  WHERE id = p_prayer_id
    AND user_id = p_user_id
    AND section_status->>p_tier = 'processing';

  -- IF NOT FOUND: silent noop (lock no longer ours / row gone).
END;
$$;

COMMENT ON FUNCTION abba.revert_tier_processing(UUID, UUID, TEXT, BOOLEAN) IS
  'Phase B4 — revert a tier from ''processing'' back to ''failed'' when '
  'the Gemini call after claim_failed_tier throws. Atomically increments '
  'server_retry_count when p_increment_retry_count=TRUE (default), so the '
  'shared retry budget covers both pending full-retry and partial T2/T3 '
  'failures. Refreshes last_retry_at to drive the cooldown window. The '
  'Edge candidate SELECT must filter server_retry_count < MAX_SERVER_RETRIES '
  '(currently 10) to gate this counter. Silent noop if the processing '
  'guard fails.';


-- ---------------------------------------------------------------------------
-- 4. Permissions — service_role only, never PUBLIC / anon / authenticated
-- ---------------------------------------------------------------------------

REVOKE EXECUTE ON FUNCTION abba.claim_failed_tier(UUID, UUID, TEXT, INT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION abba.claim_failed_tier(UUID, UUID, TEXT, INT) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION abba.claim_failed_tier(UUID, UUID, TEXT, INT) TO service_role;

REVOKE EXECUTE ON FUNCTION abba.complete_tier_admin(UUID, UUID, TEXT, JSONB) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION abba.complete_tier_admin(UUID, UUID, TEXT, JSONB) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION abba.complete_tier_admin(UUID, UUID, TEXT, JSONB) TO service_role;

REVOKE EXECUTE ON FUNCTION abba.revert_tier_processing(UUID, UUID, TEXT, BOOLEAN) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION abba.revert_tier_processing(UUID, UUID, TEXT, BOOLEAN) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION abba.revert_tier_processing(UUID, UUID, TEXT, BOOLEAN) TO service_role;


-- ---------------------------------------------------------------------------
-- 5. Document the new section_status value 'processing'
-- ---------------------------------------------------------------------------

COMMENT ON COLUMN abba.prayers.section_status IS
  'Per-tier completion tracking for 3-tier lazy generation. '
  'Values: ''pending'' | ''processing'' | ''completed'' | ''failed'' | ''not_applicable''. '
  '''processing'' is set by abba.claim_failed_tier (Phase B4 admin RPC) '
  'while the Edge Function holds a retry lock; cleared to ''completed'' by '
  'complete_tier_admin or back to ''failed'' by revert_tier_processing. '
  'Example: {"t1":"completed","t2":"failed"} (T2 streaming failed after T1 OK). '
  'Used by client to render dashboard inline state and by Edge Function '
  'partial-retry queries.';


-- ---------------------------------------------------------------------------
-- 6. Rollback (for reference — do not execute unless explicitly needed)
-- ---------------------------------------------------------------------------
-- DROP FUNCTION IF EXISTS abba.claim_failed_tier(UUID, UUID, TEXT, INT);
-- DROP FUNCTION IF EXISTS abba.complete_tier_admin(UUID, UUID, TEXT, JSONB);
-- DROP FUNCTION IF EXISTS abba.revert_tier_processing(UUID, UUID, TEXT, BOOLEAN);
-- COMMENT ON COLUMN abba.prayers.section_status IS
--   'Per-tier completion tracking for 3-tier lazy generation. '
--   'Values: ''pending'' | ''completed'' | ''failed'' | ''not_applicable''. '
--   'Example: {"t1":"completed","t2":"failed"} (T2 streaming failed after T1 OK). '
--   'Used by client to render dashboard inline state and (Phase A.5+) by Edge '
--   'Function partial-retry queries.';
--
-- No existing data is modified; rollback only removes the new admin
-- functions and rolls back the section_status comment.
