-- Add admin-only SELECT policy on storage.objects for the `blacklabelled` bucket.
--
-- Why:
--   The previous `storage_public_read` policy (dropped in 20260423000001) was the
--   only SELECT policy on this bucket, which meant:
--     1. Supabase Dashboard Storage UI could not list files for the bucket.
--     2. `storage.from('blacklabelled').remove([path])` silently failed because
--        Supabase Storage internally requires SELECT visibility on the object
--        row before deleting it. As a result, admin image deletion removed the
--        DB record but left the file orphaned in the bucket.
--
-- Scope:
--   Only authenticated users whose user_tenants row has role = 'owner' | 'admin'
--   can list/read the bucket contents via the Storage API. Anonymous clients
--   remain blocked from listing (Public URL access is unaffected — that endpoint
--   bypasses RLS).

CREATE POLICY "storage_admin_select" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'blacklabelled'
    AND EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.role IN ('owner', 'admin')
    )
  );
