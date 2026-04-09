"use client";

import { useState, useCallback, lazy, Suspense } from "react";
import Link from "next/link";
import { motion } from "framer-motion";
import type { Product, BeforeAfterPair } from "@/lib/data";
import BeforeAfterSlider from "./BeforeAfterSlider";
import Lightbox from "./Lightbox";
import ProjectCard from "./ProjectCard";

const DepthGallery = lazy(() => import("./DepthGallery"));

interface ProjectDetailProps {
  product: Product;
  related: Product[];
  beforeAfter: BeforeAfterPair | null;
}

export default function ProjectDetail({
  product,
  related,
  beforeAfter,
}: ProjectDetailProps) {
  const [lightboxOpen, setLightboxOpen] = useState(false);
  const [lightboxIndex, setLightboxIndex] = useState(0);
  const [galleryMode, setGalleryMode] = useState<"3d" | "grid">("3d");

  const galleryImages = product.images
    .filter((img) => img.type === "detail")
    .map((img) => `/api/images/${img.path}`);

  const openLightbox = useCallback((index: number) => {
    setLightboxIndex(index);
    setLightboxOpen(true);
  }, []);

  return (
    <>
      {/* Hero */}
      <section className="relative w-full h-[70vh] overflow-hidden">
        <div
          className="absolute inset-0 bg-cover bg-center"
          style={{
            backgroundImage: `url(/api/images/${product.main_image})`,
          }}
        />
        <div className="absolute inset-0 bg-gradient-to-t from-bg-primary via-bg-primary/30 to-transparent" />

        <div className="absolute bottom-0 left-0 right-0 p-6 md:p-12 max-w-7xl mx-auto">
          <Link
            href="/projects"
            className="inline-flex items-center gap-2 text-text-muted text-xs tracking-[0.15em] uppercase font-body hover:text-gold transition-colors mb-6"
          >
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
            >
              <path d="M15 18l-6-6 6-6" />
            </svg>
            PROJECTS
          </Link>

          <motion.h1
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            className="font-heading text-4xl md:text-5xl text-text-primary font-light tracking-wider"
          >
            {product.name}
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.1 }}
            className="text-gold text-xs tracking-[0.15em] uppercase font-body mt-3"
          >
            {product.main_category_name}
          </motion.p>
        </div>
      </section>

      {/* Before/After */}
      {beforeAfter && (
        <section className="py-16 md:py-24 px-6 md:px-10">
          <div className="max-w-4xl mx-auto">
            <h2 className="text-gold text-xs tracking-[0.2em] uppercase font-body mb-8 text-center">
              DESIGN → REALITY
            </h2>
            <BeforeAfterSlider
              beforeImage={`/api/images/${beforeAfter.designProduct.main_image}`}
              afterImage={`/api/images/${beforeAfter.realityProduct.main_image}`}
            />
          </div>
        </section>
      )}

      {/* Gallery */}
      {galleryImages.length > 0 && (
        <section className="py-16 md:py-24 px-6 md:px-10">
          <div className="max-w-7xl mx-auto">
            <div className="flex items-center justify-between mb-8">
              <h2 className="text-gold text-xs tracking-[0.2em] uppercase font-body">
                GALLERY · {galleryImages.length} IMAGES
              </h2>
              <div className="flex gap-2">
                <button
                  onClick={() => setGalleryMode("3d")}
                  className={`text-xs tracking-[0.15em] uppercase font-body px-3 py-1.5 border transition-colors duration-300 ${
                    galleryMode === "3d"
                      ? "border-gold text-gold"
                      : "border-border text-text-muted hover:text-text-secondary"
                  }`}
                >
                  3D
                </button>
                <button
                  onClick={() => setGalleryMode("grid")}
                  className={`text-xs tracking-[0.15em] uppercase font-body px-3 py-1.5 border transition-colors duration-300 ${
                    galleryMode === "grid"
                      ? "border-gold text-gold"
                      : "border-border text-text-muted hover:text-text-secondary"
                  }`}
                >
                  GRID
                </button>
              </div>
            </div>

            {galleryMode === "3d" ? (
              <Suspense
                fallback={
                  <div className="h-[50vh] flex items-center justify-center">
                    <div className="text-text-muted text-sm tracking-[0.15em] uppercase">
                      Loading 3D Gallery...
                    </div>
                  </div>
                }
              >
                <DepthGallery images={galleryImages} />
              </Suspense>
            ) : (
              <div className="grid grid-cols-2 lg:grid-cols-3 gap-1">
                {galleryImages.map((src, i) => (
                  <motion.div
                    key={i}
                    initial={{ opacity: 0 }}
                    whileInView={{ opacity: 1 }}
                    viewport={{ once: true, margin: "-50px" }}
                    transition={{ duration: 0.5, delay: i * 0.05 }}
                    className="relative aspect-[4/3] overflow-hidden cursor-pointer group bg-bg-card"
                    onClick={() => openLightbox(i)}
                  >
                    <div
                      className="absolute inset-0 bg-cover bg-center transition-all duration-500 group-hover:scale-105 group-hover:brightness-110"
                      style={{ backgroundImage: `url(${src})` }}
                    />
                  </motion.div>
                ))}
              </div>
            )}
          </div>
        </section>
      )}

      {/* Project Info */}
      {product.description && (
        <section className="py-16 md:py-24 px-6 md:px-10">
          <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-12">
            <div>
              <h2 className="font-heading text-2xl md:text-3xl text-text-primary font-light tracking-wider mb-6">
                About This Project
              </h2>
              <p className="text-text-secondary text-base leading-relaxed font-body">
                {product.description}
              </p>
            </div>
            <div className="bg-bg-card p-8 rounded-sm">
              <dl className="space-y-6">
                <div>
                  <dt className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                    Category
                  </dt>
                  <dd className="text-text-primary font-body mt-1">
                    {product.main_category_name}
                  </dd>
                </div>
                <div>
                  <dt className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                    Images
                  </dt>
                  <dd className="text-text-primary font-body mt-1">
                    {product.image_count}
                  </dd>
                </div>
                {product.category_names.length > 1 && (
                  <div>
                    <dt className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                      Tags
                    </dt>
                    <dd className="text-text-primary font-body mt-1">
                      {product.category_names.join(", ")}
                    </dd>
                  </div>
                )}
              </dl>
            </div>
          </div>
        </section>
      )}

      {/* Related Projects */}
      {related.length > 0 && (
        <section className="py-16 md:py-24 px-6 md:px-10 border-t border-border">
          <div className="max-w-7xl mx-auto">
            <h2 className="font-heading text-2xl md:text-3xl text-text-primary font-light tracking-wider mb-10 text-center">
              Related Projects
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-1">
              {related.map((p) => (
                <ProjectCard key={p.id} product={p} />
              ))}
            </div>
          </div>
        </section>
      )}

      {/* CTA */}
      <section className="py-20 md:py-28 px-6 md:px-10 text-center">
        <h2 className="font-heading text-2xl md:text-3xl text-text-primary font-light tracking-wider">
          이런 공간을 원하시나요?
        </h2>
        <Link
          href="/contact"
          className="inline-block mt-8 bg-gold text-bg-primary px-10 py-4 text-sm tracking-[0.2em] uppercase font-body font-medium hover:bg-gold-light transition-colors duration-300"
        >
          상담 문의
        </Link>
      </section>

      {/* Lightbox */}
      <Lightbox
        images={galleryImages}
        currentIndex={lightboxIndex}
        isOpen={lightboxOpen}
        onClose={() => setLightboxOpen(false)}
        onPrev={() => setLightboxIndex((i) => Math.max(0, i - 1))}
        onNext={() =>
          setLightboxIndex((i) => Math.min(galleryImages.length - 1, i + 1))
        }
      />
    </>
  );
}
