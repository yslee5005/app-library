-- ============================================================================
-- 20260423000002: abba.prayers Pending/Retry 아키텍처 + prayer-audio Storage
-- ----------------------------------------------------------------------------
-- Adds ai_status lifecycle (pending/processing/completed/failed) + retry
-- tracking + transcript nullability so the client can save the raw prayer
-- BEFORE calling Gemini. Existing rows default to 'completed' (accurate —
-- they were all successfully analyzed before this migration).
--
-- Also creates the `prayer-audio` Storage bucket with per-user RLS so
-- recordings persist for user playback (REQUIREMENTS §11 Always — 유저
-- 회고 목적 + 삭제 권한).
--
-- See:
--   apps/abba/specs/REQUIREMENTS.md §11
--   apps/abba/specs/DESIGN.md §4.1, §7, §10
--   .claude/rules/learned-pitfalls.md §2-1
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. Columns on abba.prayers
-- ---------------------------------------------------------------------------

-- pending 상태 음성 모드에서는 transcript이 아직 없음 (Gemini가 transcribe
-- 하기 전). 저장 우선 원칙상 null 허용 필요. 기존 데이터는 모두 값이
-- 있으므로 런타임 영향 없음.
ALTER TABLE abba.prayers
  ALTER COLUMN transcript DROP NOT NULL;

-- AI 분석 생명주기 상태.
-- 기존 레코드는 'completed' (이미 분석 완료된 상태 — 정확한 기본값).
ALTER TABLE abba.prayers
  ADD COLUMN IF NOT EXISTS ai_status TEXT NOT NULL DEFAULT 'completed'
    CHECK (ai_status IN ('pending', 'processing', 'completed', 'failed'));

-- Edge Function 10분 cooldown 체크용. null = 한 번도 서버 재시도 안 됨.
ALTER TABLE abba.prayers
  ADD COLUMN IF NOT EXISTS last_retry_at TIMESTAMPTZ;

-- Edge Function 재시도 상한 (10회 초과 시 ai_status='failed').
-- Client 세션 카운터(앱 재시작 시 리셋, 최대 3회)와는 완전히 별개.
-- Client는 이 컬럼을 읽지 않는다.
ALTER TABLE abba.prayers
  ADD COLUMN IF NOT EXISTS server_retry_count INT NOT NULL DEFAULT 0;

COMMENT ON COLUMN abba.prayers.ai_status IS
  'AI analysis lifecycle: pending (saved, awaiting analysis), processing (Edge Function running), completed (result available), failed (permanent failure after 10 server retries)';
COMMENT ON COLUMN abba.prayers.last_retry_at IS
  'Last Edge Function retry attempt — used for 10-minute cooldown to prevent Edge Function spam on home re-entry';
COMMENT ON COLUMN abba.prayers.server_retry_count IS
  'Edge Function retry counter (server-side only). Independent from client session retries (which reset on app restart). Capped at 10 — beyond which ai_status is set to failed.';

-- ---------------------------------------------------------------------------
-- 2. Index for Home screen pending-prayer lookup
-- ---------------------------------------------------------------------------
-- Partial index: only covers pending/processing rows. Keeps the index tiny
-- even as completed rows grow to millions. Query pattern:
--   SELECT * FROM abba.prayers
--     WHERE user_id = $1
--       AND ai_status IN ('pending', 'processing')
--     ORDER BY last_retry_at NULLS FIRST
--     LIMIT 1;

CREATE INDEX IF NOT EXISTS idx_prayers_pending_per_user
  ON abba.prayers (user_id, ai_status, last_retry_at)
  WHERE ai_status IN ('pending', 'processing');

-- ---------------------------------------------------------------------------
-- 3. Storage bucket for audio recordings
-- ---------------------------------------------------------------------------
-- Private bucket (public=false). Access strictly via signed URL from RLS
-- policies below. File path convention: `{user_id}/{prayer_id}.m4a`.

INSERT INTO storage.buckets (id, name, public)
  VALUES ('prayer-audio', 'prayer-audio', false)
  ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 4. Storage RLS: per-user access via path prefix {user_id}/{prayer_id}.m4a
-- ---------------------------------------------------------------------------
-- storage.foldername(name) returns path segments as an array.
-- For "abc123/prayer-001.m4a" → ['abc123']
-- We enforce that the first segment equals auth.uid() (the caller).

DROP POLICY IF EXISTS prayer_audio_insert ON storage.objects;
CREATE POLICY prayer_audio_insert ON storage.objects
  FOR INSERT
  WITH CHECK (
    bucket_id = 'prayer-audio'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

DROP POLICY IF EXISTS prayer_audio_select ON storage.objects;
CREATE POLICY prayer_audio_select ON storage.objects
  FOR SELECT
  USING (
    bucket_id = 'prayer-audio'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

DROP POLICY IF EXISTS prayer_audio_delete ON storage.objects;
CREATE POLICY prayer_audio_delete ON storage.objects
  FOR DELETE
  USING (
    bucket_id = 'prayer-audio'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- Intentionally no UPDATE policy — audio files are immutable once uploaded.
-- Changes (e.g., re-recording) delete+insert a new object.
