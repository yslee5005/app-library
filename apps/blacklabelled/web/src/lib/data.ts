/**
 * Supabase-backed data layer for BlackLabelled
 * Drop-in replacement for data.ts — same function signatures, Supabase backend
 *
 * Migration: rename this file to data.ts when ready to switch
 */
import { supabase } from "./supabase";

// ── Interfaces (unchanged from data.ts) ─────────────────

export interface ProductImage {
  order: number;
  type: string;
  path: string;
  original_url: string;
  original_filename: string;
  width: number;
  height: number;
}

export interface Product {
  id: string;
  name: string;
  slug: string;
  description: string;
  price: number;
  categories: string[];
  category_names: string[];
  main_category: string;
  main_category_name: string;
  image_folder: string;
  main_image: string;
  image_count: number;
  images: ProductImage[];
}

export interface Category {
  id: string;
  name: string;
  parent_id: string | null;
  parent_name: string | null;
  folder_path: string;
  product_count: number;
  product_ids: string[];
  is_visible?: boolean;
}

// ── Supabase Storage URL helper ─────────────────────────

const STORAGE_URL = `${process.env.NEXT_PUBLIC_SUPABASE_URL}/storage/v1/object/public/blacklabelled`;

function storageUrl(path: string): string {
  return `${STORAGE_URL}/${path}`;
}

// ── DB row → Product 변환 ───────────────────────────────

interface DbProduct {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  status: string;
  main_category_id: string | null;
  source_url: string | null;
  deleted_at: string | null;
  product_categories: { category_id: string }[];
  product_images: DbProductImage[];
  categories: { id: string; name: string; parent_id: string | null } | null;
}

interface DbProductImage {
  sort_order: number;
  type: string;
  storage_path: string;
  original_url: string | null;
  original_filename: string | null;
  width: number | null;
  height: number | null;
  deleted_at: string | null;
}

// Category map type
type CategoryMap = Map<string, { name: string; parent_name: string | null }>;

// 캐시 없음 — Admin에서 변경 시 즉시 반영
async function getCategoryMap(): Promise<CategoryMap> {
  const { data } = await supabase
    .from("categories")
    .select("id, name, parent_id, is_visible");

  const map: CategoryMap = new Map();
  if (data) {
    const nameById = new Map(data.map((c) => [c.id, c.name]));
    for (const c of data) {
      if (c.is_visible === false) continue;
      map.set(c.id, {
        name: c.name,
        parent_name: c.parent_id ? nameById.get(c.parent_id) ?? null : null,
      });
    }
  }
  return map;
}

// Sync — catMap must be pre-loaded and passed in
function dbToProduct(row: any, catMap: CategoryMap): Product {
  const catIds = (row.product_categories || []).map((pc: any) => pc.category_id);
  const catNames = catIds.map((id: string) => catMap.get(id)?.name ?? "");
  const mainCatInfo = row.main_category_id ? catMap.get(row.main_category_id) : null;

  const images: ProductImage[] = (row.product_images || [])
    .filter((img: DbProductImage) => !img.deleted_at)
    .sort((a: DbProductImage, b: DbProductImage) => a.sort_order - b.sort_order)
    .map((img: DbProductImage) => ({
      order: img.sort_order,
      type: img.type,
      path: img.storage_path,
      original_url: img.original_url ?? "",
      original_filename: img.original_filename ?? "",
      width: img.width ?? 0,
      height: img.height ?? 0,
    }));

  const mainImage = images.find((i) => i.type === "main")?.path ?? images[0]?.path ?? "";

  return {
    id: row.id,
    name: row.name,
    slug: row.slug,
    description: row.description ?? "",
    price: row.price ?? 0,
    categories: catIds,
    category_names: catNames,
    main_category: row.main_category_id ?? "",
    main_category_name: mainCatInfo?.name ?? "",
    image_folder: "",
    main_image: mainImage,
    image_count: images.length,
    images,
  };
}

// ── Query helpers ───────────────────────────────────────

// 목록용: 이미지 제외 (427개 한번에 로드 시 stack overflow 방지)
const PRODUCT_LIST_SELECT = `
  id, name, slug, description, price, status, main_category_id, source_url,
  deleted_at,
  product_categories(category_id)
`;

// 상세용: 이미지 포함
const PRODUCT_DETAIL_SELECT = `
  id, name, slug, description, price, status, main_category_id, source_url,
  deleted_at,
  product_categories(category_id),
  product_images(sort_order, type, storage_path, original_url, original_filename, width, height, deleted_at)
`;

// ── Public API (same signatures as data.ts) ──────────────

export async function getProducts(): Promise<Product[]> {
  const { data } = await supabase
    .from("products")
    .select(PRODUCT_LIST_SELECT)
    .is("deleted_at", null)
    .eq("status", "published")
    .order("id", { ascending: false });

  if (!data) return [];

  // Pre-load category map ONCE
  const catMap = await getCategoryMap();

  // main 이미지 전체 조회 (type=main만, IN 절 없이)
  const { data: mainImages } = await supabase
    .from("product_images")
    .select("product_id, storage_path")
    .eq("type", "main")
    .is("deleted_at", null);

  const mainImageMap = new Map<string, string>();
  if (mainImages) {
    for (const img of mainImages) {
      mainImageMap.set(img.product_id, img.storage_path);
    }
  }

  // main이 없는 상품은 첫 번째 이미지로 폴백
  if (mainImages && mainImageMap.size < data.length) {
    const { data: firstImages } = await supabase
      .from("product_images")
      .select("product_id, storage_path")
      .is("deleted_at", null)
      .order("sort_order", { ascending: true });

    if (firstImages) {
      for (const img of firstImages) {
        if (!mainImageMap.has(img.product_id)) {
          mainImageMap.set(img.product_id, img.storage_path);
        }
      }
    }
  }

  // Sync map — no Promise.all needed
  return data.map((row: any) => {
    const product = dbToProduct(row, catMap);
    product.main_image = mainImageMap.get(row.id) ?? "";
    return product;
  });
}

export async function getProduct(id: string): Promise<Product | undefined> {
  const [{ data }, catMap] = await Promise.all([
    supabase
      .from("products")
      .select(PRODUCT_DETAIL_SELECT)
      .eq("id", id)
      .is("deleted_at", null)
      .single(),
    getCategoryMap(),
  ]);

  if (!data) return undefined;
  return dbToProduct(data, catMap);
}

export async function getCategories(): Promise<Category[]> {
  const { data } = await supabase
    .from("categories")
    .select("id, name, parent_id, is_visible, sort_order")
    .order("sort_order");

  if (!data) return [];

  // Build parent name map
  const nameMap = new Map(data.map((c) => [c.id, c.name]));

  return data.map((c) => ({
    id: c.id,
    name: c.name,
    parent_id: c.parent_id,
    parent_name: c.parent_id ? nameMap.get(c.parent_id) ?? null : null,
    folder_path: "",
    product_count: 0,
    product_ids: [],
    is_visible: c.is_visible ?? true,
  }));
}

export async function getProjectCategories(): Promise<Category[]> {
  const cats = await getCategories();
  return cats.filter(
    (c) => c.parent_name === "PROJECT" && c.name !== "Layout_Design"
  );
}

export async function getFeaturedProducts(count = 6): Promise<Product[]> {
  const catMap = await getCategoryMap();

  // Find category IDs to exclude
  const excludeCatIds = [...catMap.entries()]
    .filter(([, v]) => v.name === "Layout_Design" || v.name === "DEVELOPMENT")
    .map(([id]) => id);

  let query = supabase
    .from("products")
    .select(PRODUCT_LIST_SELECT)
    .is("deleted_at", null)
    .eq("status", "published")
    .order("id", { ascending: false });

  // Exclude unwanted categories
  for (const catId of excludeCatIds) {
    query = query.neq("main_category_id", catId);
  }

  const { data } = await query.limit(count);
  if (!data || data.length === 0) return [];

  // Get main images
  const ids = data.map((r: any) => r.id);
  const { data: mainImgs } = await supabase
    .from("product_images")
    .select("product_id, storage_path")
    .eq("type", "main")
    .in("product_id", ids)
    .is("deleted_at", null);

  const imgMap = new Map<string, string>();
  if (mainImgs) {
    for (const img of mainImgs) imgMap.set(img.product_id, img.storage_path);
  }

  return data.map((row: any) => {
    const p = dbToProduct(row, catMap);
    p.main_image = imgMap.get(row.id) ?? "";
    return p;
  });
}

export async function getProductBySlug(slug: string): Promise<Product | undefined> {
  const [{ data }, catMap] = await Promise.all([
    supabase
      .from("products")
      .select(PRODUCT_DETAIL_SELECT)
      .eq("slug", slug)
      .is("deleted_at", null)
      .eq("status", "published")
      .single(),
    getCategoryMap(),
  ]);

  if (!data) return undefined;
  return dbToProduct(data, catMap);
}

export async function getDisplayProducts(): Promise<Product[]> {
  const catMap = await getCategoryMap();

  // Find DEVELOPMENT category ID to exclude
  const devCatId = [...catMap.entries()]
    .find(([, v]) => v.name === "DEVELOPMENT")?.[0];

  let query = supabase
    .from("products")
    .select(PRODUCT_LIST_SELECT)
    .is("deleted_at", null)
    .eq("status", "published")
    .order("id", { ascending: false });

  if (devCatId) {
    query = query.neq("main_category_id", devCatId);
  }

  const { data } = await query;
  if (!data) return [];

  // main 이미지 전체 조회
  const { data: mainImages } = await supabase
    .from("product_images")
    .select("product_id, storage_path")
    .eq("type", "main")
    .is("deleted_at", null);

  const mainImageMap = new Map<string, string>();
  if (mainImages) {
    for (const img of mainImages) mainImageMap.set(img.product_id, img.storage_path);
  }

  // main이 없는 상품은 첫 번째 이미지로 폴백
  if (mainImages && mainImageMap.size < data.length) {
    const { data: firstImages } = await supabase
      .from("product_images")
      .select("product_id, storage_path")
      .is("deleted_at", null)
      .order("sort_order", { ascending: true });

    if (firstImages) {
      for (const img of firstImages) {
        if (!mainImageMap.has(img.product_id)) {
          mainImageMap.set(img.product_id, img.storage_path);
        }
      }
    }
  }

  return data.map((row: any) => {
    const p = dbToProduct(row, catMap);
    p.main_image = mainImageMap.get(row.id) ?? "";
    return p;
  });
}

export async function getFilterCategories(): Promise<Category[]> {
  const cats = await getCategories();
  return cats.filter(
    (c) =>
      (c.parent_name === "PROJECT" || c.parent_name === "FURNITURE") &&
      c.name !== "DEVELOPMENT" &&
      c.is_visible !== false
  );
}

export async function getRelatedProducts(product: Product, count = 3): Promise<Product[]> {
  // Query directly with limit instead of loading ALL products
  const catMap = await getCategoryMap();

  // Find category IDs that are NOT "DEVELOPMENT"
  const devCatIds = [...catMap.entries()]
    .filter(([, v]) => v.name === "DEVELOPMENT")
    .map(([id]) => id);

  let query = supabase
    .from("products")
    .select(PRODUCT_LIST_SELECT)
    .is("deleted_at", null)
    .eq("status", "published")
    .neq("id", product.id);

  if (product.main_category) {
    query = query.eq("main_category_id", product.main_category);
  }

  const { data } = await query.order("id", { ascending: false }).limit(count);
  if (!data || data.length === 0) return [];

  // Get main images for these few products
  const ids = data.map((r: any) => r.id);
  const { data: mainImgs } = await supabase
    .from("product_images")
    .select("product_id, storage_path")
    .eq("type", "main")
    .in("product_id", ids)
    .is("deleted_at", null);

  const imgMap = new Map<string, string>();
  if (mainImgs) {
    for (const img of mainImgs) imgMap.set(img.product_id, img.storage_path);
  }

  return data
    .map((row: any) => {
      const p = dbToProduct(row, catMap);
      p.main_image = imgMap.get(row.id) ?? "";
      return p;
    })
    .filter((p) => p.main_category_name !== "DEVELOPMENT");
}

export async function getResidenceProducts(count?: number): Promise<Product[]> {
  const catMap = await getCategoryMap();

  // Find the Residence category ID
  const residenceCatId = [...catMap.entries()]
    .find(([, v]) => v.name === "Residence")?.[0];

  if (!residenceCatId) return [];

  let query = supabase
    .from("products")
    .select(PRODUCT_LIST_SELECT)
    .is("deleted_at", null)
    .eq("status", "published")
    .eq("main_category_id", residenceCatId)
    .order("id", { ascending: false });

  if (count) {
    query = query.limit(count);
  }

  const { data } = await query;
  if (!data) return [];

  // Get main images
  const ids = data.map((r: any) => r.id);
  const { data: mainImgs } = ids.length > 0
    ? await supabase
        .from("product_images")
        .select("product_id, storage_path")
        .eq("type", "main")
        .in("product_id", ids)
        .is("deleted_at", null)
    : { data: [] };

  const imgMap = new Map<string, string>();
  if (mainImgs) {
    for (const img of mainImgs) imgMap.set(img.product_id, img.storage_path);
  }

  return data.map((row: any) => {
    const p = dbToProduct(row, catMap);
    p.main_image = imgMap.get(row.id) ?? "";
    return p;
  });
}

export async function getLayoutDesignProducts(): Promise<Product[]> {
  const catMap = await getCategoryMap();

  // Find the Layout_Design category ID
  const layoutCatId = [...catMap.entries()]
    .find(([, v]) => v.name === "Layout_Design")?.[0];

  if (!layoutCatId) return [];

  const { data } = await supabase
    .from("products")
    .select(PRODUCT_LIST_SELECT)
    .is("deleted_at", null)
    .eq("status", "published")
    .eq("main_category_id", layoutCatId)
    .order("id", { ascending: false });

  if (!data) return [];

  // Get main images
  const ids = data.map((r: any) => r.id);
  const { data: mainImgs } = ids.length > 0
    ? await supabase
        .from("product_images")
        .select("product_id, storage_path")
        .eq("type", "main")
        .in("product_id", ids)
        .is("deleted_at", null)
    : { data: [] };

  const imgMap = new Map<string, string>();
  if (mainImgs) {
    for (const img of mainImgs) imgMap.set(img.product_id, img.storage_path);
  }

  return data.map((row: any) => {
    const p = dbToProduct(row, catMap);
    p.main_image = imgMap.get(row.id) ?? "";
    return p;
  });
}

// ── Page Content (CMS) ───────────────────────────────────

export async function getPageContent(pageKey: string): Promise<Record<string, any> | null> {
  const { data } = await supabase
    .from("page_content")
    .select("content")
    .eq("page_key", pageKey)
    .single();
  return data?.content ?? null;
}

// ── Image URL helpers ────────────────────────────────────

/**
 * Convert storage_path to public CDN URL
 * Use this in components: <Image src={getImageUrl(product.main_image)} />
 */
export function getImageUrl(storagePath: string): string {
  if (!storagePath) return "";
  // If already a full URL, return as-is
  if (storagePath.startsWith("http")) return storagePath;
  return storageUrl(storagePath);
}

// ── Map/Location (unchanged logic) ──────────────────────

const LOCATION_MAP: Record<string, [number, number]> = {
  잠실: [127.0862, 37.5133],
  서현: [127.0549, 37.3843],
  야탑: [127.1273, 37.4116],
  정자: [127.1115, 37.3658],
  수내: [127.1148, 37.3768],
  단대: [127.1587, 37.4483],
  구미: [127.1066, 37.35],
  이매: [127.125, 37.395],
  분당: [127.12, 37.38],
  성남: [127.14, 37.42],
  강남: [127.0276, 37.4979],
  서울: [126.978, 37.5665],
  용인: [127.1775, 37.241],
  동탄: [127.0736, 37.2],
  판교: [127.1112, 37.3947],
  위례: [127.1433, 37.4783],
  광교: [127.0587, 37.2849],
  수원: [127.0286, 37.2636],
  인천: [126.7052, 37.4563],
  대구: [128.6014, 35.8714],
  부산: [129.0756, 35.1796],
  제주: [126.5312, 33.4996],
  김포: [126.715, 37.6152],
  일산: [126.7748, 37.6584],
  파주: [126.78, 37.76],
  하남: [127.2146, 37.5394],
  과천: [126.9876, 37.4292],
  안양: [126.9519, 37.3943],
  송파: [127.1058, 37.5048],
  마포: [126.9083, 37.5538],
  천안: [127.1135, 36.8151],
};

const DEFAULT_CENTER: [number, number] = [127.14, 37.42];

export interface MapProduct {
  id: string;
  name: string;
  slug: string;
  category: string;
  mainImage: string;
  coordinates: [number, number];
}

export async function getMapProducts(): Promise<MapProduct[]> {
  const PROJECT_CATEGORY_NAMES = ["Residence", "Commercial", "Layout_Design"];
  const products = await getDisplayProducts();
  const projectOnly = products.filter((p) =>
    PROJECT_CATEGORY_NAMES.includes(p.main_category_name)
  );

  return projectOnly.map((p) => {
    let coords: [number, number] | null = null;
    for (const [location, lngLat] of Object.entries(LOCATION_MAP)) {
      if (p.name.includes(location)) {
        coords = lngLat;
        break;
      }
    }
    if (!coords) {
      // Hash the UUID string to get a deterministic numeric offset
      let hash = 0;
      for (let i = 0; i < p.id.length; i++) {
        hash = ((hash << 5) - hash + p.id.charCodeAt(i)) | 0;
      }
      const offsetLng = ((Math.abs(hash * 7919)) % 1000) / 100000 - 0.005;
      const offsetLat = ((Math.abs(hash * 6271)) % 1000) / 100000 - 0.005;
      coords = [DEFAULT_CENTER[0] + offsetLng, DEFAULT_CENTER[1] + offsetLat];
    }
    return {
      id: p.id,
      name: p.name,
      slug: p.slug,
      category: p.main_category_name,
      mainImage: getImageUrl(p.main_image),
      coordinates: coords,
    };
  });
}

export interface BeforeAfterPair {
  designProduct: Product;
  realityProduct: Product;
}

export async function getFloorPlanImage(product: Product): Promise<string | null> {
  if (product.main_category_name !== "Residence") return null;
  const layoutProducts = await getLayoutDesignProducts();
  const nameParts = product.name.replace(/[_\s]+/g, " ").toLowerCase();

  for (const lp of layoutProducts) {
    const lpName = lp.name.replace(/[_\s]+/g, " ").toLowerCase();
    const residenceWords = nameParts.split(" ").filter((w) => w.length > 1);
    const matchCount = residenceWords.filter((w) => lpName.includes(w)).length;
    if (matchCount >= Math.max(1, residenceWords.length * 0.5)) {
      return getImageUrl(lp.main_image);
    }
  }
  return null;
}

export async function getBeforeAfterPair(product: Product): Promise<BeforeAfterPair | null> {
  if (product.main_category_name !== "Residence") return null;
  const layoutProducts = await getLayoutDesignProducts();
  const nameParts = product.name.replace(/[_\s]+/g, " ").toLowerCase();

  for (const lp of layoutProducts) {
    const lpName = lp.name.replace(/[_\s]+/g, " ").toLowerCase();
    const residenceWords = nameParts.split(" ").filter((w) => w.length > 1);
    const matchCount = residenceWords.filter((w) => lpName.includes(w)).length;
    if (matchCount >= Math.max(1, residenceWords.length * 0.5)) {
      return { designProduct: lp, realityProduct: product };
    }
  }
  return null;
}

// ── Magazines (public) ──────────────────────────────────

export interface Magazine {
  id: string;
  title: string;
  summary: string | null;
  html_content: string | null;
  slug: string | null;
  date: string | null;
  thumbnail_path: string | null;
  tags: string[] | null;
}

export async function getMagazines(): Promise<Magazine[]> {
  const { data } = await supabase
    .from("magazines")
    .select("id, title, summary, html_content, slug, date, thumbnail_path, tags")
    .eq("status", "published")
    .order("date", { ascending: false });
  return data ?? [];
}

// ── Magazines with resolved images ──────────────────────

export interface MagazineWithImage {
  id: string;
  title: string;
  summary: string | null;
  slug: string | null;
  date: string | null;
  tags: string[] | null;
  imageUrl: string; // resolved image URL
}

export async function getMagazinesWithImages(): Promise<MagazineWithImage[]> {
  const { data: magazines } = await supabase
    .from("magazines")
    .select("id, title, summary, slug, date, tags, thumbnail_path, project_id")
    .eq("status", "published")
    .order("date", { ascending: false });

  if (!magazines || magazines.length === 0) return [];

  // Collect project_ids that need image resolution
  const projectIds = magazines
    .map((m: any) => m.project_id)
    .filter(Boolean) as string[];

  // Batch-fetch main images for all referenced projects
  const projectImageMap = new Map<string, string>();
  if (projectIds.length > 0) {
    const { data: mainImgs } = await supabase
      .from("product_images")
      .select("product_id, storage_path, type, sort_order")
      .in("product_id", projectIds)
      .is("deleted_at", null)
      .order("sort_order", { ascending: true });

    if (mainImgs) {
      // For each project, prefer type='main', fallback to first by sort_order
      const mainByProject = new Map<string, string>();
      const firstByProject = new Map<string, string>();
      for (const img of mainImgs) {
        if (img.type === "main" && !mainByProject.has(img.product_id)) {
          mainByProject.set(img.product_id, img.storage_path);
        }
        if (!firstByProject.has(img.product_id)) {
          firstByProject.set(img.product_id, img.storage_path);
        }
      }
      for (const pid of projectIds) {
        const path = mainByProject.get(pid) ?? firstByProject.get(pid);
        if (path) projectImageMap.set(pid, path);
      }
    }
  }

  return magazines.map((m: any) => {
    let imageUrl = "";
    if (m.project_id && projectImageMap.has(m.project_id)) {
      imageUrl = getImageUrl(projectImageMap.get(m.project_id)!);
    } else if (m.thumbnail_path) {
      imageUrl = getImageUrl(m.thumbnail_path);
    }
    return {
      id: m.id,
      title: m.title,
      summary: m.summary,
      slug: m.slug,
      date: m.date,
      tags: m.tags,
      imageUrl,
    };
  });
}

export async function getMagazineBySlug(slug: string): Promise<Magazine | null> {
  const { data } = await supabase
    .from("magazines")
    .select("id, title, summary, html_content, slug, date, thumbnail_path, tags")
    .eq("slug", slug)
    .eq("status", "published")
    .single();
  return data ?? null;
}
