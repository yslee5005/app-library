"use server";

import { createSupabaseServerClient } from "./supabase-server";
import { createSupabaseServerClientPublic } from "./supabase-server";
import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";

// ── Auth ─────────────────────────────────────────────────

export async function loginWithPassword(formData: FormData) {
  const email = formData.get("email") as string;
  const password = formData.get("password") as string;

  if (!email || !password) {
    return { error: "Email and password are required" };
  }

  const supabase = await createSupabaseServerClientPublic();
  const { error } = await supabase.auth.signInWithPassword({ email, password });

  if (error) {
    return { error: error.message };
  }

  // Check admin role
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return { error: "User not found" };
  }

  const { data: tenantData } = await supabase
    .from("user_tenants")
    .select("role")
    .eq("user_id", user.id)
    .in("role", ["owner", "admin"])
    .limit(1)
    .single();

  if (!tenantData) {
    await supabase.auth.signOut();
    return { error: "You do not have admin access." };
  }

  redirect("/admin/dashboard");
}

export async function loginWithMagicLink(formData: FormData) {
  const email = formData.get("email") as string;
  const origin = formData.get("origin") as string;

  if (!email) {
    return { error: "Email is required" };
  }

  const supabase = await createSupabaseServerClientPublic();
  const { error } = await supabase.auth.signInWithOtp({
    email,
    options: {
      emailRedirectTo: `${origin}/admin/auth/callback`,
    },
  });

  if (error) {
    return { error: error.message };
  }

  return { success: true };
}

export async function logout() {
  const supabase = await createSupabaseServerClientPublic();
  await supabase.auth.signOut();
  redirect("/admin/login");
}

export async function getSessionUser() {
  const supabase = await createSupabaseServerClientPublic();
  const { data: { user } } = await supabase.auth.getUser();
  return user;
}

// ── Tenant helper ────────────────────────────────────────

async function getTenantId(): Promise<string> {
  const supabasePublic = await createSupabaseServerClientPublic();
  const { data, error } = await supabasePublic
    .from("tenants")
    .select("id")
    .eq("slug", "blacklabelled")
    .single();

  if (error || !data) {
    throw new Error("Tenant not found");
  }
  return data.id;
}

// ── Types ────────────────────────────────────────────────

export interface AdminProduct {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  status: string;
  main_category_id: string | null;
  main_category_name: string | null;
  source_url: string | null;
  image_count: number;
  main_image: string | null;
  created_at: string;
  updated_at: string;
}

export interface AdminProductDetail {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  status: string;
  main_category_id: string | null;
  source_url: string | null;
  published_at: string | null;
  created_at: string;
  updated_at: string;
  images: AdminProductImage[];
  categories: { category_id: string }[];
}

export interface AdminProductImage {
  id: string;
  type: string;
  sort_order: number;
  storage_path: string;
  original_url: string | null;
  original_filename: string | null;
  width: number | null;
  height: number | null;
  file_size: number | null;
  created_at: string;
}

export interface AdminCategory {
  id: string;
  name: string;
  slug: string;
  parent_id: string | null;
  parent_name: string | null;
  description: string | null;
  is_visible: boolean;
  sort_order: number;
  product_count: number;
}

export interface AdminStats {
  products: number;
  categories: number;
  images: number;
  magazines: number;
}

// ── Stats ────────────────────────────────────────────────

export async function getAdminStats(): Promise<AdminStats> {
  const supabase = await createSupabaseServerClient();
  const tenantId = await getTenantId();

  const [productsRes, categoriesRes, imagesRes, magazinesRes] =
    await Promise.all([
      supabase
        .from("products")
        .select("id", { count: "exact", head: true })
        .eq("tenant_id", tenantId)
        .is("deleted_at", null),
      supabase
        .from("categories")
        .select("id", { count: "exact", head: true })
        .eq("tenant_id", tenantId),
      supabase
        .from("product_images")
        .select("id", { count: "exact", head: true })
        .eq("tenant_id", tenantId)
        .is("deleted_at", null),
      supabase
        .from("magazines")
        .select("id", { count: "exact", head: true })
        .eq("tenant_id", tenantId),
    ]);

  return {
    products: productsRes.count ?? 0,
    categories: categoriesRes.count ?? 0,
    images: imagesRes.count ?? 0,
    magazines: magazinesRes.count ?? 0,
  };
}

// ── Products - List ──────────────────────────────────────

export async function getAdminProducts(params: {
  page?: number;
  search?: string;
  categoryId?: string;
  limit?: number;
}): Promise<{ products: AdminProduct[]; total: number }> {
  const supabase = await createSupabaseServerClient();
  const tenantId = await getTenantId();

  const page = params.page ?? 1;
  const limit = params.limit ?? 10;
  const offset = (page - 1) * limit;

  // Build product query
  let query = supabase
    .from("products")
    .select(
      `
      id, name, slug, description, price, status,
      main_category_id, source_url, created_at, updated_at,
      categories!products_main_category_id_fkey(name),
      product_images(id, type, storage_path, deleted_at)
    `,
      { count: "exact" }
    )
    .eq("tenant_id", tenantId)
    .is("deleted_at", null)
    .order("created_at", { ascending: false })
    .range(offset, offset + limit - 1);

  if (params.search) {
    query = query.ilike("name", `%${params.search}%`);
  }

  if (params.categoryId) {
    query = query.eq("main_category_id", params.categoryId);
  }

  const { data, count, error } = await query;

  if (error) {
    console.error("getAdminProducts error:", error);
    return { products: [], total: 0 };
  }

  const products: AdminProduct[] = (data ?? []).map((row: any) => {
    const activeImages = (row.product_images ?? []).filter(
      (img: any) => !img.deleted_at
    );
    const mainImage =
      activeImages.find((img: any) => img.type === "main")?.storage_path ??
      activeImages[0]?.storage_path ??
      null;

    return {
      id: row.id,
      name: row.name,
      slug: row.slug,
      description: row.description,
      price: row.price ?? 0,
      status: row.status ?? "draft",
      main_category_id: row.main_category_id,
      main_category_name: row.categories?.name ?? null,
      source_url: row.source_url,
      image_count: activeImages.length,
      main_image: mainImage,
      created_at: row.created_at,
      updated_at: row.updated_at,
    };
  });

  return { products, total: count ?? 0 };
}

// ── Products - Single ────────────────────────────────────

export async function getAdminProduct(
  id: string
): Promise<AdminProductDetail | null> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase
    .from("products")
    .select(
      `
      id, name, slug, description, price, status,
      main_category_id, source_url, published_at, created_at, updated_at,
      product_images(id, type, sort_order, storage_path, original_url, original_filename, width, height, file_size, created_at, deleted_at),
      product_categories(category_id)
    `
    )
    .eq("id", id)
    .is("deleted_at", null)
    .single();

  if (error || !data) return null;

  return {
    id: data.id,
    name: data.name,
    slug: data.slug,
    description: data.description,
    price: data.price ?? 0,
    status: data.status ?? "draft",
    main_category_id: data.main_category_id,
    source_url: data.source_url,
    published_at: data.published_at,
    created_at: data.created_at,
    updated_at: data.updated_at,
    images: ((data as any).product_images ?? [])
      .filter((img: any) => !img.deleted_at)
      .sort((a: any, b: any) => a.sort_order - b.sort_order)
      .map((img: any) => ({
        id: img.id,
        type: img.type,
        sort_order: img.sort_order,
        storage_path: img.storage_path,
        original_url: img.original_url,
        original_filename: img.original_filename,
        width: img.width,
        height: img.height,
        file_size: img.file_size,
        created_at: img.created_at,
      })),
    categories: ((data as any).product_categories ?? []).map((pc: any) => ({
      category_id: pc.category_id,
    })),
  };
}

// ── Products - Create ────────────────────────────────────

function generateSlug(name: string): string {
  const randomSuffix = Math.random().toString(36).substring(2, 6);
  const base = name
    .trim()
    .replace(/\s+/g, "_")
    .replace(/[^\w가-힣\-]/g, "");
  return `${base}_${randomSuffix}`;
}

export async function createProduct(
  formData: FormData
): Promise<{ id: string } | { error: string }> {
  const supabase = await createSupabaseServerClient();
  const tenantId = await getTenantId();

  const name = formData.get("name") as string;
  const slug = (formData.get("slug") as string) || generateSlug(name);
  const description = (formData.get("description") as string) || null;
  const price = parseFloat((formData.get("price") as string) || "0");
  const status = (formData.get("status") as string) || "draft";
  const mainCategoryId =
    (formData.get("main_category_id") as string) || null;

  if (!name) {
    return { error: "Name is required" };
  }

  const { data, error } = await supabase
    .from("products")
    .insert({
      tenant_id: tenantId,
      name,
      slug,
      description,
      price,
      status,
      main_category_id: mainCategoryId,
      published_at: status === "published" ? new Date().toISOString() : null,
    })
    .select("id")
    .single();

  if (error) {
    if (error.code === "23505" || error.message?.includes("unique")) {
      return { error: "이 slug는 이미 사용 중입니다. 다른 slug를 입력해주세요." };
    }
    console.error("createProduct error:", error);
    return { error: error.message };
  }

  revalidatePath("/");
  revalidatePath("/projects");
  revalidatePath("/map");
  return { id: data.id };
}

// ── Products - Update ────────────────────────────────────

export async function updateProduct(
  id: string,
  formData: FormData
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  const name = formData.get("name") as string;
  const slug = formData.get("slug") as string;
  const description = (formData.get("description") as string) || null;
  const price = parseFloat((formData.get("price") as string) || "0");
  const status = (formData.get("status") as string) || "draft";
  const mainCategoryId =
    (formData.get("main_category_id") as string) || null;

  if (!name) {
    return { error: "Name is required" };
  }

  const { error } = await supabase
    .from("products")
    .update({
      name,
      slug,
      description,
      price,
      status,
      main_category_id: mainCategoryId,
      published_at: status === "published" ? new Date().toISOString() : null,
      updated_at: new Date().toISOString(),
    })
    .eq("id", id);

  if (error) {
    console.error("updateProduct error:", error);
    return { error: error.message };
  }

  revalidatePath("/");
  revalidatePath("/projects");
  revalidatePath("/map");
  return { success: true };
}

// ── Products - Delete (soft) ─────────────────────────────

export async function deleteProduct(
  id: string
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  const { error } = await supabase
    .from("products")
    .update({ deleted_at: new Date().toISOString() })
    .eq("id", id);

  if (error) {
    console.error("deleteProduct error:", error);
    return { error: error.message };
  }

  // After product soft delete, also soft-delete its images
  await supabase
    .from("product_images")
    .update({ deleted_at: new Date().toISOString() })
    .eq("product_id", id)
    .is("deleted_at", null);

  revalidatePath("/");
  revalidatePath("/projects");
  revalidatePath("/map");
  return { success: true };
}

// ── Categories - List ────────────────────────────────────

// ── Images - Upload ──────────────────────────────────────

export async function uploadProductImage(
  productId: string,
  formData: FormData
): Promise<AdminProductImage | { error: string }> {
  const supabase = await createSupabaseServerClient();
  const tenantId = await getTenantId();

  const file = formData.get("file") as File;
  if (!file || !(file instanceof File)) {
    return { error: "No file provided" };
  }

  const type = (formData.get("type") as string) || "detail";

  // Generate unique filename
  const timestamp = Date.now();
  const safeName = file.name.replace(/[^a-zA-Z0-9._-]/g, "_");
  const storagePath = `${productId}/${timestamp}_${safeName}`;

  // Upload to Supabase Storage
  const arrayBuffer = await file.arrayBuffer();
  const { error: uploadError } = await supabase.storage
    .from("blacklabelled")
    .upload(storagePath, arrayBuffer, {
      contentType: file.type,
      upsert: false,
    });

  if (uploadError) {
    console.error("Storage upload error:", uploadError);
    return { error: uploadError.message };
  }

  // Get current max sort_order for this product
  const { data: existingImages } = await supabase
    .from("product_images")
    .select("sort_order")
    .eq("product_id", productId)
    .is("deleted_at", null)
    .order("sort_order", { ascending: false })
    .limit(1);

  const nextOrder = (existingImages?.[0]?.sort_order ?? -1) + 1;

  // If setting as main, unset other mains
  if (type === "main") {
    await supabase
      .from("product_images")
      .update({ type: "detail" })
      .eq("product_id", productId)
      .eq("type", "main")
      .is("deleted_at", null);
  }

  // Insert product_images record
  const { data, error: insertError } = await supabase
    .from("product_images")
    .insert({
      product_id: productId,
      tenant_id: tenantId,
      type,
      sort_order: nextOrder,
      storage_path: storagePath,
      original_filename: file.name,
      file_size: file.size,
    })
    .select(
      "id, type, sort_order, storage_path, original_url, original_filename, width, height, file_size, created_at"
    )
    .single();

  if (insertError || !data) {
    console.error("Insert product_image error:", insertError);
    return { error: insertError?.message ?? "Failed to save image record" };
  }

  revalidatePath("/");
  revalidatePath("/projects");
  return data as AdminProductImage;
}

// ── Images - Reorder ─────────────────────────────────────

export async function reorderProductImages(
  productId: string,
  imageIds: string[]
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  for (let i = 0; i < imageIds.length; i++) {
    const { error } = await supabase
      .from("product_images")
      .update({ sort_order: i })
      .eq("id", imageIds[i])
      .eq("product_id", productId);

    if (error) {
      console.error("reorderProductImages error:", error);
      return { error: error.message };
    }
  }

  revalidatePath("/projects");
  return { success: true };
}

// ── Images - Delete (soft) ───────────────────────────────

export async function deleteProductImage(
  imageId: string
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  const { error } = await supabase
    .from("product_images")
    .update({ deleted_at: new Date().toISOString() })
    .eq("id", imageId);

  if (error) {
    console.error("deleteProductImage error:", error);
    return { error: error.message };
  }

  revalidatePath("/");
  revalidatePath("/projects");
  return { success: true };
}

// ── Images - Set Type ────────────────────────────────────

export async function setImageType(
  imageId: string,
  type: "main" | "detail"
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  // If setting to main, first get the product_id
  if (type === "main") {
    const { data: img } = await supabase
      .from("product_images")
      .select("product_id")
      .eq("id", imageId)
      .single();

    if (img) {
      // Unset all other mains for this product
      await supabase
        .from("product_images")
        .update({ type: "detail" })
        .eq("product_id", img.product_id)
        .eq("type", "main")
        .is("deleted_at", null);
    }
  }

  const { error } = await supabase
    .from("product_images")
    .update({ type })
    .eq("id", imageId);

  if (error) {
    console.error("setImageType error:", error);
    return { error: error.message };
  }

  revalidatePath("/");
  revalidatePath("/projects");
  return { success: true };
}

// ── Categories - List ────────────────────────────────────

export async function getAdminCategories(): Promise<AdminCategory[]> {
  const supabase = await createSupabaseServerClient();
  const tenantId = await getTenantId();

  const { data: categories, error } = await supabase
    .from("categories")
    .select("id, name, slug, parent_id, description, is_visible, sort_order")
    .eq("tenant_id", tenantId)
    .order("sort_order");

  if (error || !categories) return [];

  // Build parent name map
  const nameMap = new Map(categories.map((c: any) => [c.id, c.name]));

  // Count products per category
  const { data: productCats } = await supabase
    .from("products")
    .select("main_category_id")
    .eq("tenant_id", tenantId)
    .is("deleted_at", null);

  const countMap = new Map<string, number>();
  for (const pc of productCats ?? []) {
    if (pc.main_category_id) {
      countMap.set(
        pc.main_category_id,
        (countMap.get(pc.main_category_id) ?? 0) + 1
      );
    }
  }

  return categories.map((c: any) => ({
    id: c.id,
    name: c.name,
    slug: c.slug ?? "",
    parent_id: c.parent_id,
    parent_name: c.parent_id ? nameMap.get(c.parent_id) ?? null : null,
    description: c.description,
    is_visible: c.is_visible ?? true,
    sort_order: c.sort_order ?? 0,
    product_count: countMap.get(c.id) ?? 0,
  }));
}

// ── Categories - Update ──────────────────────────────────

export async function updateCategory(
  id: string,
  formData: FormData
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  const name = formData.get("name") as string | null;
  const description = formData.get("description") as string | null;
  const isVisible = formData.get("is_visible") === "true";
  const sortOrder = parseInt(formData.get("sort_order") as string, 10);

  const updateData: Record<string, unknown> = {
    is_visible: isVisible,
    sort_order: isNaN(sortOrder) ? 0 : sortOrder,
  };
  if (name) updateData.name = name;
  if (description !== null) updateData.description = description;

  const { error } = await supabase
    .from("categories")
    .update(updateData)
    .eq("id", id);

  if (error) {
    console.error("updateCategory error:", error);
    return { error: error.message };
  }

  revalidatePath("/");
  revalidatePath("/projects");
  revalidatePath("/map");
  return { success: true };
}

// ── Categories - Batch Update ────────────────────────────

export async function batchUpdateCategories(
  updates: { id: string; is_visible: boolean; sort_order: number }[]
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  for (const u of updates) {
    const { error } = await supabase
      .from("categories")
      .update({ is_visible: u.is_visible, sort_order: u.sort_order })
      .eq("id", u.id);

    if (error) {
      console.error("batchUpdateCategories error:", error);
      return { error: error.message };
    }
  }

  revalidatePath("/");
  revalidatePath("/projects");
  revalidatePath("/map");
  return { success: true };
}

// ── Page Content ─────────────────────────────────────────

export async function getPageContentAdmin(
  pageKey: string
): Promise<Record<string, any> | null> {
  const supabase = await createSupabaseServerClient();

  const { data } = await supabase
    .from("page_content")
    .select("content")
    .eq("page_key", pageKey)
    .single();

  return data?.content ?? null;
}

export async function updatePageContent(
  pageKey: string,
  content: Record<string, any>
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  // Debug: check if server has authenticated session
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return { error: "Not authenticated. Please log in again." };
  }

  const { error } = await supabase
    .from("page_content")
    .update({
      content,
      updated_at: new Date().toISOString(),
    })
    .eq("page_key", pageKey);

  if (error) {
    console.error("updatePageContent error:", error);
    return { error: error.message };
  }

  revalidatePath("/");
  return { success: true };
}

// ── Magazines ────────────────────────────────────────────

export interface AdminMagazine {
  id: string;
  title: string;
  summary: string | null;
  thumbnail_path: string | null;
  date: string;
  created_at: string;
  updated_at: string;
}

export async function getAdminMagazines(): Promise<AdminMagazine[]> {
  const supabase = await createSupabaseServerClient();
  const tenantId = await getTenantId();

  const { data, error } = await supabase
    .from("magazines")
    .select("id, title, summary, thumbnail_path, date, created_at, updated_at")
    .eq("tenant_id", tenantId)
    .order("date", { ascending: false });

  if (error || !data) return [];

  return data as AdminMagazine[];
}

export async function createMagazine(
  formData: FormData
): Promise<{ id: string } | { error: string }> {
  const supabase = await createSupabaseServerClient();
  const tenantId = await getTenantId();

  const title = formData.get("title") as string;
  const summary = (formData.get("summary") as string) || null;
  const date = (formData.get("date") as string) || new Date().toISOString().split("T")[0];

  if (!title) {
    return { error: "Title is required" };
  }

  const { data, error } = await supabase
    .from("magazines")
    .insert({
      tenant_id: tenantId,
      title,
      summary,
      date,
    })
    .select("id")
    .single();

  if (error) {
    console.error("createMagazine error:", error);
    return { error: error.message };
  }

  return { id: data.id };
}

export async function updateMagazine(
  id: string,
  formData: FormData
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  const title = formData.get("title") as string;
  const summary = (formData.get("summary") as string) || null;
  const date = formData.get("date") as string;

  if (!title) {
    return { error: "Title is required" };
  }

  const updateData: Record<string, unknown> = {
    title,
    summary,
    updated_at: new Date().toISOString(),
  };
  if (date) updateData.date = date;

  const { error } = await supabase
    .from("magazines")
    .update(updateData)
    .eq("id", id);

  if (error) {
    console.error("updateMagazine error:", error);
    return { error: error.message };
  }

  return { success: true };
}

export async function deleteMagazine(
  id: string
): Promise<{ success: true } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  // Get magazine first to check thumbnail
  const { data: mag } = await supabase
    .from("magazines")
    .select("thumbnail_path")
    .eq("id", id)
    .single();

  if (mag?.thumbnail_path) {
    await supabase.storage.from("blacklabelled").remove([mag.thumbnail_path]);
  }

  // Then delete the DB record
  const { error } = await supabase
    .from("magazines")
    .delete()
    .eq("id", id);

  if (error) {
    console.error("deleteMagazine error:", error);
    return { error: error.message };
  }

  return { success: true };
}

// ── Product Images - By Product ID ──────────────────────

export async function getProductImages(
  productId: string,
  offset = 0,
  limit = 4
): Promise<{ images: { id: string; storage_path: string; type: string; sort_order: number }[]; total: number }> {
  const supabase = await createSupabaseServerClient();
  const { data, count } = await supabase
    .from("product_images")
    .select("id, storage_path, type, sort_order", { count: "exact" })
    .eq("product_id", productId)
    .is("deleted_at", null)
    .order("sort_order")
    .range(offset, offset + limit - 1);
  return { images: data ?? [], total: count ?? 0 };
}

export async function uploadMagazineThumbnail(
  magazineId: string,
  formData: FormData
): Promise<{ path: string } | { error: string }> {
  const supabase = await createSupabaseServerClient();

  const file = formData.get("file") as File;
  if (!file || !(file instanceof File)) {
    return { error: "No file provided" };
  }

  const timestamp = Date.now();
  const safeName = file.name.replace(/[^a-zA-Z0-9._-]/g, "_");
  const storagePath = `magazines/${magazineId}/${timestamp}_${safeName}`;

  const arrayBuffer = await file.arrayBuffer();
  const { error: uploadError } = await supabase.storage
    .from("blacklabelled")
    .upload(storagePath, arrayBuffer, {
      contentType: file.type,
      upsert: false,
    });

  if (uploadError) {
    console.error("Magazine thumbnail upload error:", uploadError);
    return { error: uploadError.message };
  }

  // Update magazine record
  const { error: updateError } = await supabase
    .from("magazines")
    .update({
      thumbnail_path: storagePath,
      updated_at: new Date().toISOString(),
    })
    .eq("id", magazineId);

  if (updateError) {
    console.error("Magazine thumbnail update error:", updateError);
    return { error: updateError.message };
  }

  return { path: storagePath };
}
