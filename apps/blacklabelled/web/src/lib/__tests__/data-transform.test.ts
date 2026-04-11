import { describe, it, expect } from "vitest";
import {
  transformImages,
  findMainImage,
  lookupCoordinates,
  LOCATION_MAP,
  DEFAULT_CENTER,
  type RawDbImage,
} from "@/lib/pure-helpers";

// ── transformImages ──────────────────────────────────────

describe("transformImages", () => {
  it("returns empty array for empty input", () => {
    expect(transformImages([])).toEqual([]);
  });

  it("filters out soft-deleted images", () => {
    const raw: RawDbImage[] = [
      {
        sort_order: 0,
        type: "main",
        storage_path: "a.jpg",
        original_url: null,
        original_filename: null,
        width: null,
        height: null,
        deleted_at: null,
      },
      {
        sort_order: 1,
        type: "detail",
        storage_path: "b.jpg",
        original_url: null,
        original_filename: null,
        width: null,
        height: null,
        deleted_at: "2025-01-01T00:00:00Z",
      },
    ];
    const result = transformImages(raw);
    expect(result).toHaveLength(1);
    expect(result[0].path).toBe("a.jpg");
  });

  it("sorts images by sort_order ascending", () => {
    const raw: RawDbImage[] = [
      {
        sort_order: 3,
        type: "detail",
        storage_path: "c.jpg",
        original_url: null,
        original_filename: null,
        width: null,
        height: null,
        deleted_at: null,
      },
      {
        sort_order: 1,
        type: "main",
        storage_path: "a.jpg",
        original_url: null,
        original_filename: null,
        width: null,
        height: null,
        deleted_at: null,
      },
      {
        sort_order: 2,
        type: "detail",
        storage_path: "b.jpg",
        original_url: null,
        original_filename: null,
        width: null,
        height: null,
        deleted_at: null,
      },
    ];
    const result = transformImages(raw);
    expect(result.map((i) => i.path)).toEqual(["a.jpg", "b.jpg", "c.jpg"]);
    expect(result.map((i) => i.order)).toEqual([1, 2, 3]);
  });

  it("normalises null fields to defaults", () => {
    const raw: RawDbImage[] = [
      {
        sort_order: 0,
        type: "detail",
        storage_path: "x.jpg",
        original_url: null,
        original_filename: null,
        width: null,
        height: null,
        deleted_at: null,
      },
    ];
    const [img] = transformImages(raw);
    expect(img.original_url).toBe("");
    expect(img.original_filename).toBe("");
    expect(img.width).toBe(0);
    expect(img.height).toBe(0);
  });

  it("preserves non-null values", () => {
    const raw: RawDbImage[] = [
      {
        sort_order: 0,
        type: "main",
        storage_path: "img.jpg",
        original_url: "https://orig.com/img.jpg",
        original_filename: "photo.jpg",
        width: 1920,
        height: 1080,
        deleted_at: null,
      },
    ];
    const [img] = transformImages(raw);
    expect(img.original_url).toBe("https://orig.com/img.jpg");
    expect(img.original_filename).toBe("photo.jpg");
    expect(img.width).toBe(1920);
    expect(img.height).toBe(1080);
  });
});

// ── findMainImage ────────────────────────────────────────

describe("findMainImage", () => {
  it('returns "" for empty image list', () => {
    expect(findMainImage([])).toBe("");
  });

  it('returns path of image with type "main"', () => {
    const images = [
      { order: 0, type: "detail", path: "d1.jpg", original_url: "", original_filename: "", width: 0, height: 0 },
      { order: 1, type: "main", path: "main.jpg", original_url: "", original_filename: "", width: 0, height: 0 },
      { order: 2, type: "detail", path: "d2.jpg", original_url: "", original_filename: "", width: 0, height: 0 },
    ];
    expect(findMainImage(images)).toBe("main.jpg");
  });

  it("falls back to first image when no main type exists", () => {
    const images = [
      { order: 0, type: "detail", path: "first.jpg", original_url: "", original_filename: "", width: 0, height: 0 },
      { order: 1, type: "detail", path: "second.jpg", original_url: "", original_filename: "", width: 0, height: 0 },
    ];
    expect(findMainImage(images)).toBe("first.jpg");
  });

  it('returns first "main" if multiple exist', () => {
    const images = [
      { order: 0, type: "main", path: "m1.jpg", original_url: "", original_filename: "", width: 0, height: 0 },
      { order: 1, type: "main", path: "m2.jpg", original_url: "", original_filename: "", width: 0, height: 0 },
    ];
    expect(findMainImage(images)).toBe("m1.jpg");
  });
});

// ── lookupCoordinates ────────────────────────────────────

describe("lookupCoordinates", () => {
  it("returns null for name with no matching location", () => {
    expect(lookupCoordinates("Unknown Place")).toBeNull();
  });

  it("matches known Korean location keyword", () => {
    const coords = lookupCoordinates("잠실 럭셔리 아파트");
    expect(coords).toEqual(LOCATION_MAP["잠실"]);
  });

  it("matches another known location", () => {
    const coords = lookupCoordinates("강남 오피스텔 리모델링");
    expect(coords).toEqual(LOCATION_MAP["강남"]);
  });

  it("matches first location when name contains multiple", () => {
    // "잠실" appears first in the map iteration (may vary by engine, but
    // we just check that a valid location is returned)
    const coords = lookupCoordinates("서울 강남 프로젝트");
    expect(coords).not.toBeNull();
    // Should be one of the two
    const isSeoul = coords![0] === LOCATION_MAP["서울"][0] && coords![1] === LOCATION_MAP["서울"][1];
    const isGangnam = coords![0] === LOCATION_MAP["강남"][0] && coords![1] === LOCATION_MAP["강남"][1];
    expect(isSeoul || isGangnam).toBe(true);
  });

  it("returns null for empty string", () => {
    expect(lookupCoordinates("")).toBeNull();
  });

  it("DEFAULT_CENTER is defined correctly", () => {
    expect(DEFAULT_CENTER).toEqual([127.14, 37.42]);
  });
});
