import NewProjectClient from "./NewProjectClient";
import { getAdminCategories } from "@/lib/admin-actions";

export default async function NewProductPage() {
  const categories = await getAdminCategories();

  return (
    <NewProjectClient
      categories={categories.map((c) => ({
        id: c.id,
        name: c.name,
        parent_name: c.parent_name,
      }))}
    />
  );
}
