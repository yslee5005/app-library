"use client";

import { useState, useCallback, lazy, Suspense } from "react";
import Link from "next/link";
import type { Product, BeforeAfterPair } from "@/lib/data";
import { useScrollReveal } from "@/hooks/useScrollReveal";
import Lightbox from "@/components/Lightbox";
import ImageCrossfade from "@/components/ImageCrossfade";

const DepthGallery = lazy(() => import("@/components/DepthGallery"));

interface LilsquareProjectDetailProps {
  product: Product;
  related: Product[];
  beforeAfter: BeforeAfterPair | null;
}

/* ─────────────────────── 1. Hero ──────────────────────── */
function HeroSection({ product }: { product: Product }) {
  return (
    <section className="relative h-screen overflow-hidden">
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{
          backgroundImage: `url(/api/images/${product.main_image})`,
          animation: "kenBurns 20s ease-out forwards",
        }}
      />
      <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent" />

      {/* 좌하단: 프로젝트 번호 + 제목 */}
      <div className="absolute bottom-12 left-6 md:left-12 z-10">
        <p
          className="text-[11px] tracking-[0.25em] text-text-muted uppercase opacity-0"
          style={{ animation: "heroTitleFade 1s ease forwards 0.3s" }}
        >
          PROJECT NO.{product.id}
        </p>
        <h1
          className="text-3xl md:text-5xl lg:text-6xl font-light text-white tracking-wider mt-2 opacity-0"
          style={{ animation: "heroTitleFade 1s ease forwards 0.5s" }}
        >
          {product.name}
        </h1>
      </div>

      {/* 우하단: 메타 정보 */}
      <div className="absolute bottom-12 right-6 md:right-12 z-10 text-right">
        <div
          className="flex flex-col gap-1 opacity-0"
          style={{ animation: "heroTitleFade 1s ease forwards 0.7s" }}
        >
          <span className="text-[11px] tracking-[0.2em] text-text-secondary uppercase">
            {product.main_category_name}
          </span>
          <span className="text-[11px] tracking-[0.2em] text-text-muted uppercase">
            {product.image_count} IMAGES
          </span>
        </div>
      </div>
    </section>
  );
}

/* ─────────────────── 2. 프로젝트 정보 ──────────────────── */
function InfoSection({ product }: { product: Product }) {
  const { ref, visible } = useScrollReveal(0.15);

  return (
    <section
      ref={ref}
      className="py-[80px] md:py-[120px] px-6 md:px-10 max-w-7xl mx-auto"
    >
      <div
        className={`grid grid-cols-1 md:grid-cols-2 gap-12 md:gap-20 transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[40px]"
        }`}
      >
        {/* 좌: 설명 텍스트 */}
        <div>
          <h2 className="text-gold text-[11px] tracking-[0.25em] uppercase mb-6">
            ABOUT THIS PROJECT
          </h2>
          {product.description ? (
            <p className="text-text-secondary text-base leading-[1.8] font-body">
              {product.description}
            </p>
          ) : (
            <p className="text-text-muted text-base leading-[1.8] font-body italic">
              {product.name} — {product.main_category_name} 프로젝트
            </p>
          )}
        </div>

        {/* 우: 메타 정보 */}
        <div className="border-l border-border pl-8 md:pl-12">
          <dl className="space-y-6">
            <MetaItem label="CATEGORY" value={product.main_category_name} />
            <MetaItem
              label="IMAGES"
              value={String(product.image_count)}
            />
            {product.category_names.length > 1 && (
              <MetaItem
                label="TAGS"
                value={product.category_names.join(", ")}
              />
            )}
            <MetaItem label="PROJECT NO." value={String(product.id)} />
          </dl>
        </div>
      </div>
    </section>
  );
}

function MetaItem({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <dt className="text-text-muted text-[11px] tracking-[0.2em] uppercase">
        {label}
      </dt>
      <dd className="text-text-primary font-body mt-1 text-sm">{value}</dd>
    </div>
  );
}

/* ──────────────────── 3. 갤러리 섹션 ───────────────────── */
function GallerySection({
  images,
  onOpenLightbox,
}: {
  images: string[];
  onOpenLightbox: (index: number) => void;
}) {
  const [mode, setMode] = useState<"3d" | "grid">("3d");
  const { ref, visible } = useScrollReveal(0.05);

  if (images.length === 0) return null;

  return (
    <section ref={ref} className="py-[60px] md:py-[80px] px-6 md:px-10">
      <div className="max-w-7xl mx-auto">
        {/* 헤더 + 토글 */}
        <div
          className={`flex items-center justify-between mb-8 transition-all duration-700 ${
            visible
              ? "opacity-100 translate-y-0"
              : "opacity-0 translate-y-[20px]"
          }`}
        >
          <h2 className="text-gold text-[11px] tracking-[0.25em] uppercase">
            GALLERY · {images.length} IMAGES
          </h2>
          <div className="flex gap-2">
            {(["3d", "grid"] as const).map((m) => (
              <button
                key={m}
                onClick={() => setMode(m)}
                className={`text-[11px] tracking-[0.2em] uppercase px-3 py-1.5 border transition-colors duration-300 ${
                  mode === m
                    ? "border-gold text-gold"
                    : "border-border text-text-muted hover:text-text-secondary"
                }`}
              >
                {m === "3d" ? "3D" : "GRID"}
              </button>
            ))}
          </div>
        </div>

        {/* 갤러리 본체 */}
        {mode === "3d" ? (
          <Suspense
            fallback={
              <div className="h-[50vh] flex items-center justify-center">
                <div className="text-text-muted text-sm tracking-[0.15em] uppercase">
                  Loading 3D Gallery...
                </div>
              </div>
            }
          >
            <DepthGallery images={images} />
          </Suspense>
        ) : (
          <div className="grid grid-cols-2 lg:grid-cols-3 gap-1">
            {images.map((src, i) => (
              <div
                key={i}
                className={`relative aspect-[4/3] overflow-hidden cursor-pointer group bg-bg-card transition-all duration-700 ${
                  visible
                    ? "opacity-100 translate-y-0"
                    : "opacity-0 translate-y-[30px]"
                }`}
                style={{ transitionDelay: `${Math.min(i * 0.05, 0.5)}s` }}
                onClick={() => onOpenLightbox(i)}
              >
                <div
                  className="absolute inset-0 bg-cover bg-center transition-all duration-500 group-hover:scale-105 group-hover:brightness-110"
                  style={{ backgroundImage: `url(${src})` }}
                />
              </div>
            ))}
          </div>
        )}
      </div>
    </section>
  );
}

/* ──────────────────── 4. 도면 섹션 ─────────────────────── */
function PlanSection({ planImages }: { planImages: string[] }) {
  const { ref, visible } = useScrollReveal(0.15);

  if (planImages.length === 0) return null;

  return (
    <section
      ref={ref}
      className="py-[60px] md:py-[80px] px-6 md:px-10 max-w-7xl mx-auto"
    >
      <div
        className={`transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[40px]"
        }`}
      >
        <h2 className="text-gold text-[11px] tracking-[0.25em] uppercase mb-8">
          LAYOUT PLAN
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {planImages.length >= 2 ? (
            <>
              <ImageCrossfade images={planImages.slice(0, 2)} interval={4000} />
              {planImages.length > 2 && (
                <ImageCrossfade
                  images={planImages.slice(2)}
                  interval={4000}
                />
              )}
              {planImages.length === 2 && (
                <div
                  className="relative aspect-[4/3] overflow-hidden bg-bg-card"
                >
                  <div
                    className="absolute inset-0 bg-cover bg-center"
                    style={{
                      backgroundImage: `url(${planImages[1]})`,
                    }}
                  />
                </div>
              )}
            </>
          ) : (
            <div className="md:col-span-2">
              <div className="relative aspect-[4/3] max-w-2xl mx-auto overflow-hidden bg-bg-card">
                <div
                  className="absolute inset-0 bg-cover bg-center"
                  style={{ backgroundImage: `url(${planImages[0]})` }}
                />
              </div>
            </div>
          )}
        </div>
      </div>
    </section>
  );
}

/* ──────────────── 5. 관련 프로젝트 (가로 스크롤) ──────────── */
function RelatedSection({ products }: { products: Product[] }) {
  const { ref, visible } = useScrollReveal(0.1);

  if (products.length === 0) return null;

  return (
    <section
      ref={ref}
      className="py-[80px] md:py-[120px] px-6 md:px-10 border-t border-border"
    >
      <div className="max-w-7xl mx-auto">
        <h2
          className={`text-gold text-[11px] tracking-[0.25em] uppercase mb-10 transition-all duration-700 ${
            visible
              ? "opacity-100 translate-y-0"
              : "opacity-0 translate-y-[20px]"
          }`}
        >
          RELATED PROJECTS
        </h2>
        <div className="flex gap-6 overflow-x-auto scrollbar-none pb-4">
          {products.map((p, i) => (
            <Link
              key={p.id}
              href={`/lilsquare/projects/${p.slug}`}
              className={`flex-none w-[280px] md:w-[320px] group transition-all duration-700 ${
                visible
                  ? "opacity-100 translate-y-0"
                  : "opacity-0 translate-y-[40px]"
              }`}
              style={{
                transitionDelay: `${i * 0.15}s`,
                transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
              }}
            >
              <div className="aspect-[4/3] overflow-hidden bg-bg-card">
                <div
                  className="w-full h-full bg-cover bg-center transition-all duration-700 group-hover:scale-[1.03] group-hover:brightness-75"
                  style={{
                    backgroundImage: `url(/api/images/${p.main_image})`,
                  }}
                />
              </div>
              <div className="mt-3">
                <p className="text-[11px] tracking-[0.2em] text-text-muted">
                  PROJECT NO.{p.id}
                </p>
                <h3 className="text-sm font-light text-text-primary mt-1 leading-tight">
                  {p.name}
                </h3>
                <p className="text-[11px] text-text-muted mt-1">
                  {p.main_category_name}
                </p>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ────────────────────── 6. CTA ─────────────────────────── */
function CTASection() {
  const { ref, visible } = useScrollReveal(0.2);

  return (
    <section
      ref={ref}
      className="py-[80px] md:py-[120px] px-6 md:px-10 text-center"
    >
      <div
        className={`transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[30px]"
        }`}
      >
        <h2 className="text-2xl md:text-3xl font-light text-text-primary tracking-wider">
          이런 공간을 원하시나요?
        </h2>
        <Link
          href="/lilsquare/contact"
          className="inline-block mt-8 bg-gold text-bg-primary px-12 py-4 text-[12px] tracking-[0.25em] uppercase font-medium hover:bg-gold-light transition-colors duration-300"
        >
          상담 신청하기
        </Link>
      </div>
    </section>
  );
}

/* ──────────────────── Main Component ───────────────────── */
export default function LilsquareProjectDetail({
  product,
  related,
  beforeAfter,
}: LilsquareProjectDetailProps) {
  const [lightboxOpen, setLightboxOpen] = useState(false);
  const [lightboxIndex, setLightboxIndex] = useState(0);

  const galleryImages = product.images
    .filter((img) => img.type === "detail")
    .map((img) => `/api/images/${img.path}`);

  const planImages = product.images
    .filter((img) => img.type === "plan")
    .map((img) => `/api/images/${img.path}`);

  const openLightbox = useCallback((index: number) => {
    setLightboxIndex(index);
    setLightboxOpen(true);
  }, []);

  return (
    <>
      {/* 1. Hero */}
      <HeroSection product={product} />

      {/* 2. 프로젝트 정보 */}
      <InfoSection product={product} />

      {/* 3. 갤러리 */}
      <GallerySection images={galleryImages} onOpenLightbox={openLightbox} />

      {/* 4. 도면 */}
      <PlanSection planImages={planImages} />

      {/* 5. 관련 프로젝트 */}
      <RelatedSection products={related} />

      {/* 6. CTA */}
      <CTASection />

      {/* Lightbox */}
      <Lightbox
        images={galleryImages}
        currentIndex={lightboxIndex}
        isOpen={lightboxOpen}
        onClose={() => setLightboxOpen(false)}
        onPrev={() => setLightboxIndex((i) => Math.max(0, i - 1))}
        onNext={() =>
          setLightboxIndex((i) =>
            Math.min(galleryImages.length - 1, i + 1)
          )
        }
      />
    </>
  );
}
