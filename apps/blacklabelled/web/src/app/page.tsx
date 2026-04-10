import HeroSection from "@/components/HeroSection";
import StudioIntro from "@/components/StudioIntro";
import FeaturedCarousel from "@/components/FeaturedCarousel";
import FeaturedProjects from "@/components/FeaturedProjects";
import { getFeaturedProducts, getProducts } from "@/lib/data";

export default function Home() {
  const featured = getFeaturedProducts(8);
  const allProducts = getProducts();
  const p1 = allProducts[0];
  const p2 = allProducts[1];

  const project1 = p1 ? {
    id: p1.id,
    name: p1.name,
    images: [`/api/images/${p1.main_image}`],
  } : undefined;

  const project2 = p2 ? {
    id: p2.id,
    name: p2.name,
    images: [`/api/images/${p2.main_image}`],
  } : undefined;

  return (
    <>
      <HeroSection />
      <StudioIntro project1={project1} project2={project2} />
      <FeaturedCarousel products={allProducts} />
      <FeaturedProjects products={allProducts.slice(0, 12)} />
    </>
  );
}
