import { describe, it, expect } from "vitest";
import { productSchema } from "@/lib/pure-helpers";

describe("productSchema", () => {
  const validData = {
    name: "Test Product",
    slug: "test_product_ab12",
    description: "A nice product",
    price: 100,
    status: "published" as const,
    main_category_id: "cat-1",
  };

  it("passes with valid data", () => {
    const result = productSchema.safeParse(validData);
    expect(result.success).toBe(true);
  });

  it("passes with draft status", () => {
    const result = productSchema.safeParse({ ...validData, status: "draft" });
    expect(result.success).toBe(true);
  });

  it("passes with zero price", () => {
    const result = productSchema.safeParse({ ...validData, price: 0 });
    expect(result.success).toBe(true);
  });

  it("passes with empty description", () => {
    const result = productSchema.safeParse({ ...validData, description: "" });
    expect(result.success).toBe(true);
  });

  it("passes with empty main_category_id", () => {
    const result = productSchema.safeParse({
      ...validData,
      main_category_id: "",
    });
    expect(result.success).toBe(true);
  });

  // ── Failure cases ──────────────────────────────────────

  it("fails when name is missing", () => {
    const result = productSchema.safeParse({ ...validData, name: "" });
    expect(result.success).toBe(false);
  });

  it("fails when name is not a string", () => {
    const result = productSchema.safeParse({ ...validData, name: 123 });
    expect(result.success).toBe(false);
  });

  it("fails when slug is empty", () => {
    const result = productSchema.safeParse({ ...validData, slug: "" });
    expect(result.success).toBe(false);
  });

  it("fails when price is negative", () => {
    const result = productSchema.safeParse({ ...validData, price: -1 });
    expect(result.success).toBe(false);
  });

  it("fails when price is not a number", () => {
    const result = productSchema.safeParse({ ...validData, price: "abc" });
    expect(result.success).toBe(false);
  });

  it("fails with invalid status value", () => {
    const result = productSchema.safeParse({
      ...validData,
      status: "archived",
    });
    expect(result.success).toBe(false);
  });

  it("fails when required fields are completely missing", () => {
    const result = productSchema.safeParse({});
    expect(result.success).toBe(false);
  });
});
