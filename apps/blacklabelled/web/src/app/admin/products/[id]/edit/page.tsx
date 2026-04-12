import { notFound } from "next/navigation";
import ProductForm from "@/components/admin/ProductForm";
import ImageManager from "@/components/admin/ImageManager";
import {
  getAdminProduct,
  getAdminCategories,
} from "@/lib/admin-actions";

export default async function EditProductPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  const [product, categories] = await Promise.all([
    getAdminProduct(id),
    getAdminCategories(),
  ]);

  if (!product) {
    notFound();
  }

  return (
    <div>
      <h1 className="mb-6 text-2xl font-bold text-zinc-100">
        Edit Project:{" "}
        <span className="text-zinc-400">{product.name}</span>
      </h1>
      <div className="max-w-2xl space-y-6">
        <ProductForm
          mode="edit"
          productId={product.id}
          defaultValues={{
            name: product.name,
            slug: product.slug,
            description: product.description ?? "",
            price: product.price,
            status: product.status as "published" | "draft",
            main_category_id: product.main_category_id ?? "",
          }}
          categories={categories.map((c) => ({
            id: c.id,
            name: c.name,
            parent_name: c.parent_name,
          }))}
        />
        <ImageManager
          productId={product.id}
          initialImages={product.images}
        />
      </div>
    </div>
  );
}
