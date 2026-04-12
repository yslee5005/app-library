import HeroSection from "@/components/HeroSection";
import StudioIntro from "@/components/StudioIntro";
import FeaturedCarousel from "@/components/FeaturedCarousel";
import FeaturedProjects from "@/components/FeaturedProjects";
import { getFeaturedProducts, getProductBySlug, getPageContent, getImageUrl } from "@/lib/data";

// Admin에서 page_content 변경 시 즉시 반영
export const dynamic = "force-dynamic";

export default async function Home() {
  // 홈에 필요한 만큼만 가져오기 (427개 전부 X)
  const [featured, pageContent] = await Promise.all([
    getFeaturedProducts(30),
    getPageContent("home"),
  ]);

  const hero = pageContent?.hero;
  const intro = pageContent?.intro;
  const grid = pageContent?.grid;

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

  // Intro 프로젝트: slug 지정 시 해당 상품, 없으면 featured[0]/[1]
  const p1 = intro?.project1_slug
    ? await getProductBySlug(intro.project1_slug) ?? featured[0]
    : featured[0];
  const p2 = intro?.project2_slug
    ? await getProductBySlug(intro.project2_slug) ?? featured[1]
    : featured[1];

  const project1 = p1 ? {
    id: p1.id,
    slug: p1.slug,
    name: p1.name,
    images: [getImageUrl(intro?.project1_image_path || p1.main_image)],
  } : undefined;

  const project2 = p2 ? {
    id: p2.id,
    slug: p2.slug,
    name: p2.name,
    images: [getImageUrl(intro?.project2_image_path || p2.main_image)],
  } : undefined;

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
      <FeaturedCarousel products={carouselProducts} />
      <FeaturedProjects products={featured.slice(0, gridMaxCount)} />
    </>
  );
}
