import CategoriesEditor from "@/components/admin/CategoriesEditor";
import { getAdminCategories } from "@/lib/admin-actions";

export default async function CategoriesPage() {
  const categories = await getAdminCategories();

  return (
    <div>
      <h1 className="mb-6 text-2xl font-bold text-zinc-100">Categories</h1>
      <CategoriesEditor initialCategories={categories} />
    </div>
  );
}
