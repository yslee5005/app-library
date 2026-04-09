import LilsquareHome from "@/components/LilsquareHome";
import { getFeaturedProducts, getDisplayProducts } from "@/lib/data";

export const metadata = {
  title: "BLACKLABELLED | Lilsquare Style",
};

export default function LilsquarePage() {
  const featured = getFeaturedProducts(6);
  const products = getDisplayProducts();

  return <LilsquareHome products={products} featured={featured} />;
}
