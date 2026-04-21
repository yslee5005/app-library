-- Abba · bible_text_i18n · Phase 1
-- Allow ANYONE (anon + authenticated) to SELECT files from `abba/bibles/`.
-- Rationale: bundles are Public Domain Bible translations with ZERO
-- sensitive data. Any restriction on reads only introduces edge cases
-- (e.g., anonymous signIn network failure → 403 on Bible download).
-- UPDATE/INSERT/DELETE remain service_role only (only we upload).
--
-- Apply: push this migration via Supabase Dashboard or
-- `supabase db push --linked`.

-- NOTE: Storage bucket `abba` must already exist. If it does not, create
-- it first in the Supabase dashboard (Storage > New bucket > name: abba,
-- public: false). The bucket can remain private — this RLS policy lets
-- both anon and authenticated roles read only the bibles/ subfolder.

-- Drop legacy policy names (re-runnable)
DROP POLICY IF EXISTS "bibles_read_authenticated" ON storage.objects;
DROP POLICY IF EXISTS "bibles_read_public" ON storage.objects;

-- SELECT policy — grant read on bibles/* to both anon and authenticated.
-- (Using `TO public` which is the Postgres role meaning "every role".)
CREATE POLICY "bibles_read_public" ON storage.objects
  FOR SELECT
  TO public
  USING (
    bucket_id = 'abba'
    AND (storage.foldername(name))[1] = 'bibles'
  );

-- Verification query (run manually after apply):
--   SELECT * FROM storage.objects
--   WHERE bucket_id = 'abba' AND name LIKE 'bibles/%'
--   LIMIT 5;
--
-- Test from client (should succeed even without login):
--   const { data } = await supabase.storage
--     .from('abba').download('bibles/ko_krv.json');
