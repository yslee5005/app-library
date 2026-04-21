-- Abba · bible_text_i18n · Phase 1
-- Allow authenticated users (including anonymous) to SELECT files from
-- the `abba/bibles/` folder. Bundles are Public Domain Bible translations
-- uploaded via Supabase Dashboard. UPDATE/INSERT/DELETE remain service_role only.
--
-- Apply: push this migration via Supabase Dashboard or `supabase db push --linked`.

-- NOTE: Storage bucket `abba` must already exist. If it does not, create
-- it first in the Supabase dashboard (Storage > New bucket > name: abba,
-- public: false).

-- Drop policy if it already exists (re-runnable)
DROP POLICY IF EXISTS "bibles_read_authenticated" ON storage.objects;

-- SELECT policy — any authenticated user (anonymous-auth included) can
-- read files under bibles/* in the abba bucket.
CREATE POLICY "bibles_read_authenticated" ON storage.objects
  FOR SELECT
  TO authenticated
  USING (
    bucket_id = 'abba'
    AND (storage.foldername(name))[1] = 'bibles'
    -- COALESCE NULL defense (learned-pitfalls §3)
    AND COALESCE(auth.uid()::text, '') <> ''
  );

-- Verification query (run manually after apply):
--   SELECT * FROM storage.objects
--   WHERE bucket_id = 'abba' AND name LIKE 'bibles/%'
--   LIMIT 5;
