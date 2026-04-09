import {
  getDisplayProducts,
  getProductBySlug,
  getRelatedProducts,
  getBeforeAfterPair,
} from "@/lib/data";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import ProjectDetail from "@/components/ProjectDetail";

interface PageProps {
  params: Promise<{ slug: string }>;
}

export async function generateStaticParams() {
  const products = getDisplayProducts();
  return products.map((p) => ({ slug: p.slug }));
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const product = getProductBySlug(decodeURIComponent(slug));
  if (!product) return { title: "Not Found" };

  return {
    title: `${product.name} | BLACKLABELLED`,
    description: product.description || `${product.name} — ${product.main_category_name} 인테리어 by 블랙라벨드`,
    openGraph: {
      title: product.name,
      description: product.description || `${product.name} 인테리어 프로젝트`,
      images: [`/api/images/${product.main_image}`],
    },
  };
}

export default async function ProjectDetailPage({ params }: PageProps) {
  const { slug } = await params;
  const product = getProductBySlug(decodeURIComponent(slug));
  if (!product) notFound();

  const related = getRelatedProducts(product, 3);
  const beforeAfter = getBeforeAfterPair(product);

  return (
    <ProjectDetail
      product={JSON.parse(JSON.stringify(product))}
      related={JSON.parse(JSON.stringify(related))}
      beforeAfter={beforeAfter ? JSON.parse(JSON.stringify(beforeAfter)) : null}
    />
  );
}
