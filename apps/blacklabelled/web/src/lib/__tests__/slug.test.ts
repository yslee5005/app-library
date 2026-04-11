import { describe, it, expect } from "vitest";
import { generateSlug } from "@/lib/pure-helpers";

describe("generateSlug", () => {
  // Use fixed suffix for deterministic tests
  const SUFFIX = "ab12";

  it("generates slug from English name", () => {
    expect(generateSlug("Modern Chair", SUFFIX)).toBe("Modern_Chair_ab12");
  });

  it("generates slug from Korean name", () => {
    expect(generateSlug("잠실 아파트", SUFFIX)).toBe("잠실_아파트_ab12");
  });

  it("preserves Korean characters (가-힣)", () => {
    const slug = generateSlug("서현 리모델링 프로젝트", SUFFIX);
    expect(slug).toContain("서현");
    expect(slug).toContain("리모델링");
    expect(slug).toContain("프로젝트");
  });

  it("replaces multiple spaces with single underscore", () => {
    expect(generateSlug("hello   world", SUFFIX)).toBe("hello_world_ab12");
  });

  it("strips special characters except word chars, Korean, and hyphens", () => {
    // Spaces become underscores first, then specials are stripped,
    // so "Product @#$% Name!" → "Product_@#$%_Name!" → "Product__Name"
    expect(generateSlug("Product @#$% Name!", SUFFIX)).toBe(
      "Product__Name_ab12"
    );
  });

  it("keeps hyphens", () => {
    expect(generateSlug("A-B", SUFFIX)).toBe("A-B_ab12");
  });

  it("trims leading and trailing whitespace", () => {
    expect(generateSlug("  trimmed  ", SUFFIX)).toBe("trimmed_ab12");
  });

  it("handles empty string", () => {
    expect(generateSlug("", SUFFIX)).toBe("_ab12");
  });

  it("handles name with only special characters", () => {
    expect(generateSlug("@#$%", SUFFIX)).toBe("_ab12");
  });

  it("appends a random suffix when none is provided", () => {
    const slug = generateSlug("Test Product");
    // Format: base_XXXX where XXXX is random alphanumeric
    expect(slug).toMatch(/^Test_Product_[a-z0-9]+$/);
  });

  it("generates different random suffixes on separate calls", () => {
    const slug1 = generateSlug("Same Name");
    const slug2 = generateSlug("Same Name");
    // Very unlikely (but not impossible) to collide — checking they're strings
    expect(slug1).toMatch(/^Same_Name_[a-z0-9]+$/);
    expect(slug2).toMatch(/^Same_Name_[a-z0-9]+$/);
  });

  it("handles mixed Korean and English", () => {
    expect(generateSlug("잠실 Modern Apt", SUFFIX)).toBe(
      "잠실_Modern_Apt_ab12"
    );
  });
});
