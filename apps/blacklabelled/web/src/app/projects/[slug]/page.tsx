import {
  getDisplayProducts,
  getProductBySlug,
  getRelatedProducts,
  getBeforeAfterPair,
  getFloorPlanImage,
  getImageUrl,
} from "@/lib/data";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import ProjectDetail from "@/components/ProjectDetail";

interface PageProps {
  params: Promise<{ slug: string }>;
}

export async function generateStaticParams() {
  const products = await getDisplayProducts();
  return products.map((p) => ({ slug: p.slug }));
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const product = await getProductBySlug(decodeURIComponent(slug));
  if (!product) return { title: "Not Found" };

  return {
    title: `${product.name} | BLACKLABELLED`,
    description: product.description || `${product.name} — ${product.main_category_name} 인테리어 by 블랙라벨드`,
    openGraph: {
      title: product.name,
      description: product.description || `${product.name} 인테리어 프로젝트`,
      images: [getImageUrl(product.main_image)],
    },
  };
}

export default async function ProjectDetailPage({ params }: PageProps) {
  const { slug } = await params;
  const product = await getProductBySlug(decodeURIComponent(slug));
  if (!product) notFound();

  const related = await getRelatedProducts(product, 3);
  const beforeAfter = await getBeforeAfterPair(product);
  const floorPlanImage = await getFloorPlanImage(product);

  return (
    <ProjectDetail
      product={JSON.parse(JSON.stringify(product))}
      related={JSON.parse(JSON.stringify(related))}
      beforeAfter={beforeAfter ? JSON.parse(JSON.stringify(beforeAfter)) : null}
      floorPlanImage={floorPlanImage}
    />
  );
}
