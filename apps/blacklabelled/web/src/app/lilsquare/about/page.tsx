import { getFeaturedProducts } from "@/lib/data";
import LilsquareAbout from "@/components/lilsquare/LilsquareAbout";

export const metadata = {
  title: "ABOUT | BLACKLABELLED",
  description: "블랙라벨드 디자인 스튜디오 소개",
};

export default function AboutPage() {
  const featured = getFeaturedProducts(6);
  return <LilsquareAbout featured={featured} />;
}
