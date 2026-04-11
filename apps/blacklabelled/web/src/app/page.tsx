import HeroSection from "@/components/HeroSection";
import StudioIntro from "@/components/StudioIntro";
import FeaturedCarousel from "@/components/FeaturedCarousel";
import FeaturedProjects from "@/components/FeaturedProjects";
import { getFeaturedProducts, getProducts, getProductBySlug, getPageContent, getImageUrl } from "@/lib/data";

export default async function Home() {
  const [featured, allProducts, pageContent] = await Promise.all([
    getFeaturedProducts(8),
    getProducts(),
    getPageContent("home"),
  ]);

  const hero = pageContent?.hero;
  const intro = pageContent?.intro;
  const grid = pageContent?.grid;

  // Hero 배경: slug 지정 시 해당 상품, 없으면 Residence 첫 번째
  let heroProduct = hero?.product_slug
    ? await getProductBySlug(hero.product_slug)
    : undefined;
  if (!heroProduct) {
    heroProduct = allProducts.find((p) => p.main_category_name === "Residence");
  }
  const heroImageUrl = heroProduct ? getImageUrl(heroProduct.main_image) : "";

  // Intro 프로젝트: slug 지정 시 해당 상품, 없으면 allProducts[0]/[1]
  const p1 = intro?.project1_slug
    ? await getProductBySlug(intro.project1_slug) ?? allProducts[0]
    : allProducts[0];
  const p2 = intro?.project2_slug
    ? await getProductBySlug(intro.project2_slug) ?? allProducts[1]
    : allProducts[1];

  const project1 = p1 ? {
    id: p1.id,
    name: p1.name,
    images: [getImageUrl(p1.main_image)],
  } : undefined;

  const project2 = p2 ? {
    id: p2.id,
    name: p2.name,
    images: [getImageUrl(p2.main_image)],
  } : undefined;

  // Grid count
  const gridMaxCount = grid?.max_count ?? 12;

  return (
    <>
      <HeroSection
        backgroundImage={heroImageUrl}
        title={hero?.title}
        subtitle={hero?.subtitle}
      />
      <StudioIntro
        project1={project1}
        project2={project2}
        heading={intro?.heading}
        description={intro?.description}
        linkText={intro?.link_text}
        linkUrl={intro?.link_url}
      />
      <FeaturedCarousel products={allProducts} />
      <FeaturedProjects products={allProducts.slice(0, gridMaxCount)} />
    </>
  );
}
