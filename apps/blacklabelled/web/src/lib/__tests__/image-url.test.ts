import { describe, it, expect } from "vitest";
import { resolveImageUrl, buildStorageUrl } from "@/lib/pure-helpers";

const SUPABASE_URL = "https://abc123.supabase.co";

describe("buildStorageUrl", () => {
  it("builds correct CDN URL from base URL and path", () => {
    expect(buildStorageUrl(SUPABASE_URL, "products/img.jpg")).toBe(
      "https://abc123.supabase.co/storage/v1/object/public/blacklabelled/products/img.jpg"
    );
  });

  it("handles paths with nested folders", () => {
    expect(buildStorageUrl(SUPABASE_URL, "a/b/c/d.png")).toBe(
      "https://abc123.supabase.co/storage/v1/object/public/blacklabelled/a/b/c/d.png"
    );
  });
});

describe("resolveImageUrl", () => {
  it('returns "" for empty string', () => {
    expect(resolveImageUrl("", SUPABASE_URL)).toBe("");
  });

  it('returns "" for null', () => {
    expect(resolveImageUrl(null, SUPABASE_URL)).toBe("");
  });

  it('returns "" for undefined', () => {
    expect(resolveImageUrl(undefined, SUPABASE_URL)).toBe("");
  });

  it("returns full URL as-is when it starts with http", () => {
    const url = "https://example.com/photo.jpg";
    expect(resolveImageUrl(url, SUPABASE_URL)).toBe(url);
  });

  it("returns full URL as-is for http (non-https)", () => {
    const url = "http://cdn.example.com/photo.jpg";
    expect(resolveImageUrl(url, SUPABASE_URL)).toBe(url);
  });

  it("converts storage path to CDN URL", () => {
    expect(resolveImageUrl("products/abc/main.jpg", SUPABASE_URL)).toBe(
      "https://abc123.supabase.co/storage/v1/object/public/blacklabelled/products/abc/main.jpg"
    );
  });

  it("handles path without leading slash", () => {
    expect(resolveImageUrl("img.png", SUPABASE_URL)).toBe(
      "https://abc123.supabase.co/storage/v1/object/public/blacklabelled/img.png"
    );
  });
});
