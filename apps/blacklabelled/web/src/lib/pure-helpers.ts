/**
 * Pure helper functions extracted from data.ts and admin-actions.ts
 * These have zero side-effects and no Supabase dependency — safe to test.
 */

// ── Image URL helpers ────────────────────────────────────

/**
 * Build a Supabase Storage public URL from a base URL and storage path.
 */
export function buildStorageUrl(supabaseUrl: string, path: string): string {
  return `${supabaseUrl}/storage/v1/object/public/blacklabelled/${path}`;
}

/**
 * Convert a storage_path to a full public URL.
 * - Empty/falsy → ""
 * - Already a full URL (http...) → return as-is
 * - Otherwise → build CDN URL from supabaseUrl
 */
export function resolveImageUrl(storagePath: string | undefined | null, supabaseUrl: string): string {
  if (!storagePath) return "";
  if (storagePath.startsWith("http")) return storagePath;
  return buildStorageUrl(supabaseUrl, storagePath);
}

// ── Slug generation ──────────────────────────────────────

/**
 * Generate a URL-safe slug from a product name.
 * - Trims whitespace
 * - Replaces spaces with underscores
 * - Keeps word chars, Korean (가-힣), and hyphens
 * - Appends a random 4-char suffix
 *
 * The `randomSuffix` parameter is optional; pass it to make tests deterministic.
 */
export function generateSlug(name: string, randomSuffix?: string): string {
  const suffix = randomSuffix ?? Math.random().toString(36).substring(2, 6);
  const base = name
    .trim()
    .replace(/\s+/g, "_")
    .replace(/[^\w가-힣\-]/g, "");
  return `${base}_${suffix}`;
}

// ── Image transform helpers (from dbToProduct) ───────────

export interface RawDbImage {
  sort_order: number;
  type: string;
  storage_path: string;
  original_url: string | null;
  original_filename: string | null;
  width: number | null;
  height: number | null;
  deleted_at: string | null;
}

export interface TransformedImage {
  order: number;
  type: string;
  path: string;
  original_url: string;
  original_filename: string;
  width: number;
  height: number;
}

/**
 * Filter out soft-deleted images, sort by sort_order, and normalise nulls.
 */
export function transformImages(raw: RawDbImage[]): TransformedImage[] {
  return raw
    .filter((img) => !img.deleted_at)
    .sort((a, b) => a.sort_order - b.sort_order)
    .map((img) => ({
      order: img.sort_order,
      type: img.type,
      path: img.storage_path,
      original_url: img.original_url ?? "",
      original_filename: img.original_filename ?? "",
      width: img.width ?? 0,
      height: img.height ?? 0,
    }));
}

/**
 * Find the main image path from a list of transformed images.
 * Priority: image with type "main" → first image → empty string.
 */
export function findMainImage(images: TransformedImage[]): string {
  return images.find((i) => i.type === "main")?.path ?? images[0]?.path ?? "";
}

// ── Location map helpers ─────────────────────────────────

export const LOCATION_MAP: Record<string, [number, number]> = {
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

export const DEFAULT_CENTER: [number, number] = [127.14, 37.42];

/**
 * Look up coordinates for a product name from the location map.
 * Returns null if no known location keyword is found in the name.
 */
export function lookupCoordinates(productName: string): [number, number] | null {
  for (const [location, lngLat] of Object.entries(LOCATION_MAP)) {
    if (productName.includes(location)) {
      return lngLat;
    }
  }
  return null;
}

// ── Zod product schema (re-exported for testing) ─────────

// Note: The actual Zod schema lives in ProductForm.tsx (client component).
// We re-define it here as a pure value so it can be tested without React.
import { z } from "zod";

export const productSchema = z.object({
  name: z.string().min(1, "Name is required"),
  slug: z.string().min(1, "Slug is required"),
  description: z.string(),
  price: z.number().min(0),
  status: z.enum(["published", "draft"]),
  main_category_id: z.string(),
});

export type ProductFormValues = z.infer<typeof productSchema>;
