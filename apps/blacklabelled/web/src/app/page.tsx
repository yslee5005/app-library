import HeroSection from "@/components/HeroSection";
import StudioIntro from "@/components/StudioIntro";
import FeaturedCarousel from "@/components/FeaturedCarousel";
import FeaturedProjects from "@/components/FeaturedProjects";
import { getFeaturedProducts, getProducts, getImageUrl } from "@/lib/data";

export default async function Home() {
  const featured = await getFeaturedProducts(8);
  const allProducts = await getProducts();
  const p1 = allProducts[0];
  const p2 = allProducts[1];

  // Hero 배경: Residence 카테고리 첫 번째 상품의 메인 이미지
  const heroProduct = allProducts.find((p) => p.main_category_name === "Residence");
  const heroImageUrl = heroProduct ? getImageUrl(heroProduct.main_image) : "";

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

  return (
    <>
      <HeroSection backgroundImage={heroImageUrl} />
      <StudioIntro project1={project1} project2={project2} />
      <FeaturedCarousel products={allProducts} />
      <FeaturedProjects products={allProducts.slice(0, 12)} />
    </>
  );
}
