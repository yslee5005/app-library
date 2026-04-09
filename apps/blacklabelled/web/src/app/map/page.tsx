import type { Metadata } from "next";
import { getMapProducts, getFilterCategories } from "@/lib/data";
import MapContent from "@/components/MapContent";

export const metadata: Metadata = {
  title: "MAP | BLACKLABELLED",
  description:
    "블랙라벨드 프로젝트 위치를 지도에서 확인하세요. 성남, 분당, 강남 등 수도권 인테리어 포트폴리오.",
  openGraph: {
    title: "BLACKLABELLED — Project Map",
    description: "427+ 인테리어 프로젝트를 지도에서 탐색하세요.",
  },
};

export default function MapPage() {
  const products = getMapProducts();
  const categories = getFilterCategories();
  const categoryNames = [...new Set(products.map((p) => p.category))].sort();

  return (
    <MapContent
      products={JSON.parse(JSON.stringify(products))}
      categories={categoryNames}
    />
  );
}
