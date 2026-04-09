import { readFileSync } from "fs";
import path from "path";

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
  id: number;
  name: string;
  slug: string;
  description: string;
  price: number;
  categories: number[];
  category_names: string[];
  main_category: number;
  main_category_name: string;
  image_folder: string;
  main_image: string;
  image_count: number;
  images: ProductImage[];
}

export interface Category {
  id: number;
  name: string;
  parent_id: number | null;
  parent_name: string | null;
  folder_path: string;
  product_count: number;
  product_ids: number[];
}

const DATA_DIR = path.resolve(process.cwd(), "..", "data", "db");

function loadJSON<T>(filename: string): T {
  const filePath = path.join(DATA_DIR, filename);
  const raw = readFileSync(filePath, "utf-8");
  return JSON.parse(raw) as T;
}

let _products: Record<string, Product> | null = null;
let _categories: Record<string, Category> | null = null;

function getProductsMap(): Record<string, Product> {
  if (!_products) {
    _products = loadJSON<Record<string, Product>>("products.json");
  }
  return _products;
}

function getCategoriesMap(): Record<string, Category> {
  if (!_categories) {
    _categories = loadJSON<Record<string, Category>>("categories.json");
  }
  return _categories;
}

export function getProducts(): Product[] {
  return Object.values(getProductsMap()).sort((a, b) => b.id - a.id);
}

export function getProduct(id: number): Product | undefined {
  return getProductsMap()[String(id)];
}

export function getCategories(): Category[] {
  return Object.values(getCategoriesMap());
}

export function getProjectCategories(): Category[] {
  return Object.values(getCategoriesMap()).filter(
    (c) =>
      c.parent_name === "PROJECT" && c.name !== "Layout_Design"
  );
}

export function getFeaturedProducts(count = 6): Product[] {
  return getProducts()
    .filter(
      (p) =>
        p.main_category_name !== "Layout_Design" &&
        p.main_category_name !== "DEVELOPMENT"
    )
    .slice(0, count);
}

export function getProductBySlug(slug: string): Product | undefined {
  return Object.values(getProductsMap()).find((p) => p.slug === slug);
}

export function getDisplayProducts(): Product[] {
  return getProducts().filter(
    (p) =>
      p.main_category_name !== "Layout_Design" &&
      p.main_category_name !== "DEVELOPMENT"
  );
}

export function getFilterCategories(): Category[] {
  const cats = Object.values(getCategoriesMap());
  return cats.filter(
    (c) =>
      (c.parent_name === "PROJECT" || c.parent_name === "FURNITURE") &&
      c.name !== "Layout_Design" &&
      c.name !== "DEVELOPMENT" &&
      c.product_count > 0
  );
}

export function getRelatedProducts(product: Product, count = 3): Product[] {
  return getDisplayProducts()
    .filter(
      (p) => p.id !== product.id && p.main_category === product.main_category
    )
    .slice(0, count);
}

export interface BeforeAfterPair {
  designProduct: Product;
  realityProduct: Product;
}

// Location mapping for map pins
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

const DEFAULT_CENTER: [number, number] = [127.14, 37.42]; // 성남

export interface MapProduct {
  id: number;
  name: string;
  slug: string;
  category: string;
  mainImage: string;
  coordinates: [number, number];
}

export function getMapProducts(): MapProduct[] {
  // 지도에는 PROJECT만 (Furniture, Layout_Design, Development 제외)
  const PROJECT_CATEGORIES = [42, 43, 44, 49]; // Boutiques, Cosmetics, Residence, Commercial
  const projectOnly = getDisplayProducts().filter((p) =>
    PROJECT_CATEGORIES.includes(p.main_category)
  );
  return projectOnly.map((p) => {
    let coords: [number, number] | null = null;

    // Try to match location from product name
    for (const [location, lngLat] of Object.entries(LOCATION_MAP)) {
      if (p.name.includes(location)) {
        coords = lngLat;
        break;
      }
    }

    // Default: 성남 center with small random offset (seeded by id)
    if (!coords) {
      const offsetLng = ((p.id * 7919) % 1000) / 100000 - 0.005;
      const offsetLat = ((p.id * 6271) % 1000) / 100000 - 0.005;
      coords = [
        DEFAULT_CENTER[0] + offsetLng,
        DEFAULT_CENTER[1] + offsetLat,
      ];
    }

    return {
      id: p.id,
      name: p.name,
      slug: p.slug,
      category: p.main_category_name,
      mainImage: p.main_image,
      coordinates: coords,
    };
  });
}

export function getBeforeAfterPair(product: Product): BeforeAfterPair | null {
  if (product.main_category_name !== "Residence") return null;

  const nameParts = product.name.replace(/[_\s]+/g, " ").toLowerCase();
  const layoutProducts = Object.values(getProductsMap()).filter(
    (p) => p.main_category_name === "Layout_Design"
  );

  for (const lp of layoutProducts) {
    const lpName = lp.name.replace(/[_\s]+/g, " ").toLowerCase();
    // Match if the layout design name contains a significant portion of the residence name
    const residenceWords = nameParts.split(" ").filter((w) => w.length > 1);
    const matchCount = residenceWords.filter((w) => lpName.includes(w)).length;
    if (matchCount >= Math.max(1, residenceWords.length * 0.5)) {
      return { designProduct: lp, realityProduct: product };
    }
  }
  return null;
}
