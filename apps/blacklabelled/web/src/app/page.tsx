import HeroSection from "@/components/HeroSection";
import FeaturedCarousel from "@/components/FeaturedCarousel";
import FeaturedProjects from "@/components/FeaturedProjects";
import FeaturedMagazines from "@/components/FeaturedMagazines";
import { getFeaturedProducts, getResidenceProducts, getMagazinesWithImages, getProductBySlug, getPageContent, getImageUrl } from "@/lib/data";

// Admin에서 page_content 변경 시 즉시 반영
export const dynamic = "force-dynamic";

export default async function Home() {
  const [featured, residenceProducts, magazinesWithImages, pageContent] = await Promise.all([
    getFeaturedProducts(30),
    getResidenceProducts(),
    getMagazinesWithImages(),
    getPageContent("home"),
  ]);

  const hero = pageContent?.hero;
  const grid = pageContent?.grid;
  const magazineConfig = pageContent?.magazine;

  // Hero 배경: image_path 직접 지정 > slug 상품의 main_image > Residence 첫 번째
  let heroImageUrl = "";
  if (hero?.image_path) {
    heroImageUrl = getImageUrl(hero.image_path);
  } else {
    let heroProduct = hero?.product_slug
      ? await getProductBySlug(hero.product_slug)
      : undefined;
    if (!heroProduct) {
      heroProduct = featured.find((p) => p.main_category_name === "Residence");
    }
    heroImageUrl = heroProduct ? getImageUrl(heroProduct.main_image) : "";
  }

  // Carousel: slug 지정 시 해당 상품들, 없으면 featured 5개
  const carouselSlugs: string[] = pageContent?.carousel?.product_slugs ?? [];
  const carouselImagePaths: string[] = pageContent?.carousel?.image_paths ?? [];
  let carouselProducts = featured.slice(0, 5);
  if (carouselSlugs.length > 0) {
    const resolved = await Promise.all(
      carouselSlugs.map((slug) => getProductBySlug(slug))
    );
    const valid = resolved.filter(Boolean) as typeof featured;
    if (valid.length > 0) {
      // Override main_image with selected carousel image
      carouselProducts = valid.map((p, i) => ({
        ...p,
        main_image: carouselImagePaths[i] || p.main_image,
      }));
    }
  }

  // Grid count
  const gridMaxCount = grid?.max_count ?? 12;

  // Magazine count
  const magazineMaxCount = magazineConfig?.max_count ?? 4;
  const displayMagazines = magazinesWithImages.slice(0, magazineMaxCount);

  return (
    <>
      <HeroSection
        backgroundImage={heroImageUrl}
        title={hero?.title}
        subtitle={hero?.subtitle}
      />
      <FeaturedProjects products={residenceProducts.slice(0, gridMaxCount)} />
      <FeaturedCarousel products={carouselProducts} />
      <FeaturedMagazines magazines={displayMagazines} />
    </>
  );
}
