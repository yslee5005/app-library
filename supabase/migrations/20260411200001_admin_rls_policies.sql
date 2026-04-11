-- ============================================================
-- Admin RLS Policies — Write Access for owner/admin roles
-- ============================================================
-- 공통 패턴: user_tenants에서 role = 'owner' 또는 'admin'인지 확인
-- SELECT 정책은 기존 유지 (public read)

-- ── 1. Products ──────────────────────────────────────────

CREATE POLICY "products_insert_admin" ON blacklabelled.products
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

CREATE POLICY "products_update_admin" ON blacklabelled.products
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = products.tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

CREATE POLICY "products_delete_admin" ON blacklabelled.products
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = products.tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

-- ── 2. Product Images ────────────────────────────────────

CREATE POLICY "product_images_insert_admin" ON blacklabelled.product_images
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

CREATE POLICY "product_images_update_admin" ON blacklabelled.product_images
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = product_images.tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

CREATE POLICY "product_images_delete_admin" ON blacklabelled.product_images
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = product_images.tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

-- ── 3. Product Categories (M:N) ─────────────────────────
-- tenant_id 없음 → product의 tenant_id로 확인

CREATE POLICY "product_categories_insert_admin" ON blacklabelled.product_categories
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM blacklabelled.products p
      JOIN public.user_tenants ut ON ut.tenant_id = p.tenant_id
      WHERE p.id = product_id
        AND ut.user_id = auth.uid()
        AND ut.role IN ('owner', 'admin')
    )
  );

CREATE POLICY "product_categories_delete_admin" ON blacklabelled.product_categories
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM blacklabelled.products p
      JOIN public.user_tenants ut ON ut.tenant_id = p.tenant_id
      WHERE p.id = product_categories.product_id
        AND ut.user_id = auth.uid()
        AND ut.role IN ('owner', 'admin')
    )
  );

-- ── 4. Categories ────────────────────────────────────────

CREATE POLICY "categories_update_admin" ON blacklabelled.categories
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = categories.tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

-- ── 5. Page Content ──────────────────────────────────────
-- tenant_id 없음 → admin 여부만 확인

CREATE POLICY "page_content_update_admin" ON blacklabelled.page_content
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.role IN ('owner', 'admin')
    )
  );

-- ── 6. Magazines ─────────────────────────────────────────

CREATE POLICY "magazines_insert_admin" ON blacklabelled.magazines
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

CREATE POLICY "magazines_update_admin" ON blacklabelled.magazines
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = magazines.tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

CREATE POLICY "magazines_delete_admin" ON blacklabelled.magazines
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.tenant_id = magazines.tenant_id
        AND ut.role IN ('owner', 'admin')
    )
  );

-- ── 7. Storage Bucket Policies ───────────────────────────
-- blacklabelled 버킷: public read, admin write

CREATE POLICY "storage_public_read"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'blacklabelled');

CREATE POLICY "storage_admin_insert"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'blacklabelled'
    AND EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.role IN ('owner', 'admin')
    )
  );

CREATE POLICY "storage_admin_update"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'blacklabelled'
    AND EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.role IN ('owner', 'admin')
    )
  );

CREATE POLICY "storage_admin_delete"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'blacklabelled'
    AND EXISTS (
      SELECT 1 FROM public.user_tenants ut
      WHERE ut.user_id = auth.uid()
        AND ut.role IN ('owner', 'admin')
    )
  );
