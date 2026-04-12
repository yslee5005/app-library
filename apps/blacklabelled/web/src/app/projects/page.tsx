import { getDisplayProducts, getFilterCategories } from "@/lib/data";
import type { Metadata } from "next";
import ProjectsGrid from "@/components/ProjectsGrid";

// Admin에서 카테고리 변경 시 즉시 반영
export const dynamic = "force-dynamic";

export const metadata: Metadata = {
  title: "PROJECTS | BLACKLABELLED",
  description:
    "블랙라벨드 427+ 인테리어 프로젝트 포트폴리오. Residence, Boutique, Kitchen, Bath 등.",
  openGraph: {
    title: "BLACKLABELLED — Projects",
    description: "427개의 완성된 인테리어 프로젝트를 살펴보세요.",
  },
};

export default async function ProjectsPage() {
  const products = await getDisplayProducts();
  const categories = await getFilterCategories();

  return (
    <section className="pt-32 pb-20 px-6 md:px-10">
      <div className="max-w-7xl mx-auto">
        <h1 className="font-heading text-5xl md:text-[60px] text-text-primary font-light tracking-wider text-center">
          PROJECTS
        </h1>
        <p className="text-text-muted text-sm tracking-wider text-center mt-3 font-body">
          {products.length} completed spaces
        </p>

        <ProjectsGrid
          products={JSON.parse(JSON.stringify(products))}
          categories={JSON.parse(JSON.stringify(categories))}
        />
      </div>
    </section>
  );
}
