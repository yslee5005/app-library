import { getMapProducts } from "@/lib/data";
import LilsquareMap from "@/components/lilsquare/LilsquareMap";

export const metadata = {
  title: "LOCATION | BLACKLABELLED",
  description: "블랙라벨드 오시는 길 및 프로젝트 지도",
};

export default function MapPage() {
  const products = getMapProducts();
  return <LilsquareMap products={products} />;
}
