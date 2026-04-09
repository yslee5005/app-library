import { getFeaturedProducts } from "@/lib/data";
import LilsquareServices from "@/components/lilsquare/LilsquareServices";

export const metadata = {
  title: "SERVICES | BLACKLABELLED",
  description: "블랙라벨드 인테리어 서비스 소개",
};

export default function ServicesPage() {
  const featured = getFeaturedProducts(6);
  return <LilsquareServices featured={featured} />;
}
