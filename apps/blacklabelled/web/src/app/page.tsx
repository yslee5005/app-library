import HeroSection from "@/components/HeroSection";
import IntroSection from "@/components/IntroSection";
import FeaturedProjects from "@/components/FeaturedProjects";
import ContactCTA from "@/components/ContactCTA";
import { getFeaturedProducts } from "@/lib/data";

export default function Home() {
  const featured = getFeaturedProducts(6);

  return (
    <>
      <HeroSection />
      <IntroSection />
      <FeaturedProjects products={featured} />
      <ContactCTA />
    </>
  );
}
