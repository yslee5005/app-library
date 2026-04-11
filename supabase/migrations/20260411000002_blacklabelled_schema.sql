-- ============================================================
-- BlackLabelled Schema — Interior Design Portfolio
-- ============================================================

-- 0. Create Schema + Grants
CREATE SCHEMA IF NOT EXISTS blacklabelled;

GRANT USAGE ON SCHEMA blacklabelled TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA blacklabelled TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA blacklabelled TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA blacklabelled
  GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA blacklabelled
  GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;

-- 1. Categories
CREATE TABLE blacklabelled.categories (
  id INTEGER PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  parent_id INTEGER REFERENCES blacklabelled.categories(id) ON DELETE SET NULL,
  description TEXT,
  is_visible BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (tenant_id, slug)
);

ALTER TABLE blacklabelled.categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "categories_select" ON blacklabelled.categories FOR SELECT USING (true);

CREATE INDEX idx_bl_categories_tenant ON blacklabelled.categories(tenant_id);

CREATE TRIGGER categories_updated_at
  BEFORE UPDATE ON blacklabelled.categories
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- 2. Products
CREATE TABLE blacklabelled.products (
  id INTEGER PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,
  price NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'published',
  main_category_id INTEGER REFERENCES blacklabelled.categories(id) ON DELETE SET NULL,
  source_url TEXT,
  published_at TIMESTAMPTZ DEFAULT now(),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

ALTER TABLE blacklabelled.products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "products_select" ON blacklabelled.products
  FOR SELECT USING (deleted_at IS NULL);

CREATE INDEX idx_bl_products_tenant ON blacklabelled.products(tenant_id);
CREATE INDEX idx_bl_products_tenant_created
  ON blacklabelled.products(tenant_id, created_at DESC)
  WHERE deleted_at IS NULL;

CREATE TRIGGER products_updated_at
  BEFORE UPDATE ON blacklabelled.products
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- 3. Product Categories (M:N)
CREATE TABLE blacklabelled.product_categories (
  product_id INTEGER NOT NULL REFERENCES blacklabelled.products(id) ON DELETE CASCADE,
  category_id INTEGER NOT NULL REFERENCES blacklabelled.categories(id) ON DELETE CASCADE,
  PRIMARY KEY (product_id, category_id)
);

ALTER TABLE blacklabelled.product_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "product_categories_select" ON blacklabelled.product_categories
  FOR SELECT USING (true);

-- 4. Product Images
CREATE TABLE blacklabelled.product_images (
  id SERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL REFERENCES blacklabelled.products(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('main', 'detail')),
  sort_order INTEGER DEFAULT 0,
  storage_path TEXT NOT NULL,
  original_filename TEXT,
  width INTEGER,
  height INTEGER,
  file_size BIGINT,
  created_at TIMESTAMPTZ DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

ALTER TABLE blacklabelled.product_images ENABLE ROW LEVEL SECURITY;
CREATE POLICY "product_images_select" ON blacklabelled.product_images
  FOR SELECT USING (deleted_at IS NULL);

CREATE INDEX idx_bl_product_images_product
  ON blacklabelled.product_images(product_id, sort_order)
  WHERE deleted_at IS NULL;
