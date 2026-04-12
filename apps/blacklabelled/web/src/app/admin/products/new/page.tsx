import ProductForm from "@/components/admin/ProductForm";
import { getAdminCategories } from "@/lib/admin-actions";

export default async function NewProductPage() {
  const categories = await getAdminCategories();

  return (
    <div>
      <h1 className="mb-6 text-2xl font-bold text-zinc-100">New Project</h1>
      <p className="mb-6 text-sm text-zinc-500">Images can be added after creating the project.</p>
      <div className="max-w-2xl">
        <ProductForm
          mode="create"
          categories={categories.map((c) => ({
            id: c.id,
            name: c.name,
            parent_name: c.parent_name,
          }))}
        />
      </div>
    </div>
  );
}
