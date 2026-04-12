import NewMagazineClient from "./NewMagazineClient";
import { getAdminProducts } from "@/lib/admin-actions";

export default async function NewMagazinePage() {
  const { products } = await getAdminProducts({ limit: 100 });

  return (
    <NewMagazineClient
      products={products.map((p) => ({
        id: p.id,
        name: p.name,
        slug: p.slug,
        description: p.description,
      }))}
    />
  );
}
