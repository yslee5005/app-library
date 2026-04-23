-- Drop overly-broad SELECT policy on storage.objects for the `blacklabelled` bucket.
--
-- Rationale:
--   The existing `storage_public_read` policy allowed any client to list/download
--   every file in the bucket via the Storage API (e.g. supabase.storage.from('blacklabelled').list()).
--   For public buckets, individual files are served through the unauthenticated
--   `/object/public/{bucket}/{path}` endpoint which bypasses RLS entirely, so this
--   policy was not needed for normal rendering.
--
-- Impact:
--   - Public URL access (`<Image src={getImageUrl(path)}>`) → unchanged
--   - Admin upload (`INSERT`)  → unchanged (storage_admin_insert policy)
--   - Admin delete (`DELETE`)  → unchanged (storage_admin_delete policy)
--   - Admin update (`UPDATE`)  → unchanged (storage_admin_update policy)
--   - Anonymous `.list()` / `.download()` on the bucket → blocked (intended)

DROP POLICY IF EXISTS storage_public_read ON storage.objects;
