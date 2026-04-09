import { getLayoutDesignProducts } from "@/lib/data";
import LilsquareLayouts from "@/components/lilsquare/LilsquareLayouts";

export const metadata = {
  title: "LAYOUTS | BLACKLABELLED",
  description: "블랙라벨드 인테리어 도면 갤러리",
};

export default function LayoutsPage() {
  const layouts = getLayoutDesignProducts();
  return <LilsquareLayouts layouts={layouts} />;
}
