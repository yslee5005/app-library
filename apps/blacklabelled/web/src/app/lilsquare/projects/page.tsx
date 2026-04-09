import LilsquareProjects from "@/components/lilsquare/LilsquareProjects";
import { getDisplayProducts, getFilterCategories } from "@/lib/data";

export const metadata = {
  title: "PROJECTS | BLACKLABELLED",
};

export default function ProjectsPage() {
  const products = getDisplayProducts();
  const categories = getFilterCategories();

  return <LilsquareProjects products={products} categories={categories} />;
}
