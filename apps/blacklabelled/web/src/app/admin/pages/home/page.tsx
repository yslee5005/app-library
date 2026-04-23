import HomePageEditor from "@/components/admin/HomePageEditor";
import { getPageContentAdmin } from "@/lib/admin-actions";
import { getResidenceProducts } from "@/lib/data";

export default async function HomePageSettingsPage() {
  const [content, residenceProducts] = await Promise.all([
    getPageContentAdmin("home"),
    getResidenceProducts(),
  ]);

  const productOptions = residenceProducts.map((p) => ({
    id: p.id,
    slug: p.slug,
    name: p.name,
    main_image: p.main_image,
  }));

  return (
    <div>
      <h1 className="mb-6 text-2xl font-bold text-zinc-100">
        Home Page Settings
      </h1>
      <div className="max-w-2xl">
        <HomePageEditor
          initialContent={content}
          products={productOptions}
        />
      </div>
    </div>
  );
}
