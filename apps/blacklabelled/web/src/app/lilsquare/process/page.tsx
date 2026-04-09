import { getFeaturedProducts } from "@/lib/data";
import LilsquareProcess from "@/components/lilsquare/LilsquareProcess";

export const metadata = {
  title: "PROCESS | BLACKLABELLED",
  description: "블랙라벨드 디자인 프로세스",
};

export default function ProcessPage() {
  const featured = getFeaturedProducts(4);
  return <LilsquareProcess featured={featured} />;
}
