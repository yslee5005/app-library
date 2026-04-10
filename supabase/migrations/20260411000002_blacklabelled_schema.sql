-- ============================================================
-- BlackLabelled Schema — Interior Design Portfolio
-- Separate schema for table isolation in Supabase Dashboard
-- ============================================================

-- =====================
-- 0. Create Schema + Grants
-- =====================
CREATE SCHEMA IF NOT EXISTS blacklabelled;

GRANT USAGE ON SCHEMA blacklabelled TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA blacklabelled TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA blacklabelled TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA blacklabelled
  GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA blacklabelled
  GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;

-- =====================
-- 1. Categories (카테고리 — 셀프참조 트리)
-- =====================
CREATE TABLE blacklabelled.categories (
  id INTEGER PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  parent_id INTEGER REFERENCES blacklabelled.categories(id) ON DELETE SET NULL,
  description TEXT,
  is_visible BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0 CHECK (sort_order >= 0),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (tenant_id, slug),
  CHECK (parent_id != id)
);

ALTER TABLE blacklabelled.categories ENABLE ROW LEVEL SECURITY;

-- anon: 보이는 카테고리만 조회
CREATE POLICY "categories_select_public" ON blacklabelled.categories
  FOR SELECT TO anon
  USING (is_visible = true);

-- authenticated: 소속 테넌트 카테고리 조회
CREATE POLICY "categories_select_auth" ON blacklabelled.categories
  FOR SELECT TO authenticated
  USING (tenant_id IN (SELECT auth.user_tenant_ids()));

-- editor 이상: 카테고리 생성
CREATE POLICY "categories_insert" ON blacklabelled.categories
  FOR INSERT TO authenticated
  WITH CHECK (
    tenant_id IN (SELECT auth.user_tenant_ids())
    AND auth.user_role_in_tenant(tenant_id) IN ('owner', 'editor')
  );

-- editor 이상: 카테고리 수정
CREATE POLICY "categories_update" ON blacklabelled.categories
  FOR UPDATE TO authenticated
  USING (
    tenant_id IN (SELECT auth.user_tenant_ids())
    AND auth.user_role_in_tenant(tenant_id) IN ('owner', 'editor')
  );

-- owner만: 카테고리 삭제
CREATE POLICY "categories_delete" ON blacklabelled.categories
  FOR DELETE TO authenticated
  USING (
    tenant_id IN (SELECT auth.user_tenant_ids())
    AND auth.user_role_in_tenant(tenant_id) = 'owner'
  );

CREATE INDEX idx_bl_categories_tenant ON blacklabelled.categories(tenant_id);
CREATE INDEX idx_bl_categories_parent ON blacklabelled.categories(tenant_id, parent_id);
CREATE INDEX idx_bl_categories_slug ON blacklabelled.categories(tenant_id, slug);
CREATE INDEX idx_bl_categories_sort ON blacklabelled.categories(tenant_id, parent_id, sort_order);

CREATE TRIGGER categories_updated_at
  BEFORE UPDATE ON blacklabelled.categories
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- =====================
-- 2. Products (상품)
-- =====================
CREATE TABLE blacklabelled.products (
  id INTEGER PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,
  price NUMERIC DEFAULT 0 CHECK (price >= 0),
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  main_category_id INTEGER REFERENCES blacklabelled.categories(id) ON DELETE SET NULL,
  source_url TEXT,
  meta_title VARCHAR(70),
  meta_description VARCHAR(160),
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  updated_by UUID,
  deleted_at TIMESTAMPTZ
);

-- Partial unique: 활성 상품만 slug 유일성 보장
CREATE UNIQUE INDEX idx_bl_products_tenant_slug_active
  ON blacklabelled.products(tenant_id, slug)
  WHERE deleted_at IS NULL;

ALTER TABLE blacklabelled.products ENABLE ROW LEVEL SECURITY;

-- anon: published + 활성 상품만 조회
CREATE POLICY "products_select_public" ON blacklabelled.products
  FOR SELECT TO anon
  USING (status = 'published' AND deleted_at IS NULL);

-- authenticated: 소속 테넌트 전체 상품 조회 (soft deleted 포함)
CREATE POLICY "products_select_auth" ON blacklabelled.products
  FOR SELECT TO authenticated
  USING (tenant_id IN (SELECT auth.user_tenant_ids()));

-- editor 이상: 상품 생성
CREATE POLICY "products_insert" ON blacklabelled.products
  FOR INSERT TO authenticated
  WITH CHECK (
    tenant_id IN (SELECT auth.user_tenant_ids())
    AND auth.user_role_in_tenant(tenant_id) IN ('owner', 'editor')
  );

-- editor 이상: 상품 수정 (soft delete 포함)
CREATE POLICY "products_update" ON blacklabelled.products
  FOR UPDATE TO authenticated
  USING (
    tenant_id IN (SELECT auth.user_tenant_ids())
    AND auth.user_role_in_tenant(tenant_id) IN ('owner', 'editor')
  );

-- owner만: 상품 hard delete
CREATE POLICY "products_delete" ON blacklabelled.products
  FOR DELETE TO authenticated
  USING (
    tenant_id IN (SELECT auth.user_tenant_ids())
    AND auth.user_role_in_tenant(tenant_id) = 'owner'
  );

CREATE INDEX idx_bl_products_tenant ON blacklabelled.products(tenant_id);
CREATE INDEX idx_bl_products_tenant_active
  ON blacklabelled.products(tenant_id)
  WHERE deleted_at IS NULL;
CREATE INDEX idx_bl_products_main_category
  ON blacklabelled.products(main_category_id)
  WHERE deleted_at IS NULL;
CREATE INDEX idx_bl_products_tenant_created
  ON blacklabelled.products(tenant_id, created_at DESC)
  WHERE deleted_at IS NULL;

CREATE TRIGGER products_updated_at
  BEFORE UPDATE ON blacklabelled.products
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- =====================
-- 3. Product Categories (M:N)
-- =====================
CREATE TABLE blacklabelled.product_categories (
  product_id INTEGER NOT NULL REFERENCES blacklabelled.products(id) ON DELETE CASCADE,
  category_id INTEGER NOT NULL REFERENCES blacklabelled.categories(id) ON DELETE CASCADE,
  PRIMARY KEY (product_id, category_id)
);

ALTER TABLE blacklabelled.product_categories ENABLE ROW LEVEL SECURITY;

-- anon: published 상품의 카테고리만
CREATE POLICY "product_categories_select_public" ON blacklabelled.product_categories
  FOR SELECT TO anon
  USING (
    EXISTS (
      SELECT 1 FROM blacklabelled.products p
      WHERE p.id = product_id
        AND p.status = 'published'
        AND p.deleted_at IS NULL
    )
  );

-- authenticated: 소속 테넌트 상품의 카테고리
CREATE POLICY "product_categories_select_auth" ON blacklabelled.product_categories
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM blacklabelled.products p
      WHERE p.id = product_id
        AND p.tenant_id IN (SELECT auth.user_tenant_ids())
    )
  );

-- editor 이상: 카테고리 연결
CREATE POLICY "product_categories_insert" ON blacklabelled.product_categories
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM blacklabelled.products p
      WHERE p.id = product_id
        AND p.tenant_id IN (SELECT auth.user_tenant_ids())
        AND auth.user_role_in_tenant(p.tenant_id) IN ('owner', 'editor')
    )
  );

-- editor 이상: 카테고리 연결 해제
CREATE POLICY "product_categories_delete" ON blacklabelled.product_categories
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM blacklabelled.products p
      WHERE p.id = product_id
        AND p.tenant_id IN (SELECT auth.user_tenant_ids())
        AND auth.user_role_in_tenant(p.tenant_id) IN ('owner', 'editor')
    )
  );

-- =====================
-- 4. Product Images (상품 이미지)
-- =====================
CREATE TABLE blacklabelled.product_images (
  id SERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL REFERENCES blacklabelled.products(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('main', 'detail')),
  sort_order INTEGER DEFAULT 0 CHECK (sort_order >= 0),
  storage_path TEXT NOT NULL,
  original_url TEXT,
  original_filename TEXT,
  alt_text TEXT,
  width INTEGER,
  height INTEGER,
  file_size BIGINT,
  created_at TIMESTAMPTZ DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

ALTER TABLE blacklabelled.product_images ENABLE ROW LEVEL SECURITY;

-- anon: published 상품의 활성 이미지만
CREATE POLICY "product_images_select_public" ON blacklabelled.product_images
  FOR SELECT TO anon
  USING (
    deleted_at IS NULL
    AND EXISTS (
      SELECT 1 FROM blacklabelled.products p
      WHERE p.id = product_id
        AND p.status = 'published'
        AND p.deleted_at IS NULL
    )
  );

-- authenticated: 소속 테넌트 이미지 전체
CREATE POLICY "product_images_select_auth" ON blacklabelled.product_images
  FOR SELECT TO authenticated
  USING (tenant_id IN (SELECT auth.user_tenant_ids()));

-- editor 이상: 이미지 추가
CREATE POLICY "product_images_insert" ON blacklabelled.product_images
  FOR INSERT TO authenticated
  WITH CHECK (
    tenant_id IN (SELECT auth.user_tenant_ids())
    AND auth.user_role_in_tenant(tenant_id) IN ('owner', 'editor')
  );

-- editor 이상: 이미지 수정 (순서 변경, soft delete 등)
CREATE POLICY "product_images_update" ON blacklabelled.product_images
  FOR UPDATE TO authenticated
  USING (
    tenant_id IN (SELECT auth.user_tenant_ids())
    AND auth.user_role_in_tenant(tenant_id) IN ('owner', 'editor')
  );

-- owner만: 이미지 hard delete
CREATE POLICY "product_images_delete" ON blacklabelled.product_images
  FOR DELETE TO authenticated
  USING (
    tenant_id IN (SELECT auth.user_tenant_ids())
    AND auth.user_role_in_tenant(tenant_id) = 'owner'
  );

CREATE INDEX idx_bl_product_images_tenant ON blacklabelled.product_images(tenant_id);
CREATE INDEX idx_bl_product_images_product_sort
  ON blacklabelled.product_images(product_id, sort_order)
  WHERE deleted_at IS NULL;
