"use client";

import { useState, useCallback } from "react";
import type { Product } from "@/lib/data";
import { useScrollReveal } from "@/hooks/useScrollReveal";

const REVEAL_STYLE = {
  transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
};

/* ───────────────── Area Filter Helper ───────────────── */
function extractPY(name: string): number | null {
  const match = name.match(/(\d+)\s*PY/i);
  return match ? parseInt(match[1], 10) : null;
}

type FilterKey = "ALL" | "20" | "30" | "40";

const FILTER_OPTIONS: { key: FilterKey; label: string }[] = [
  { key: "ALL", label: "전체" },
  { key: "20", label: "20평대" },
  { key: "30", label: "30평대" },
  { key: "40", label: "40평 이상" },
];

function matchesFilter(product: Product, filter: FilterKey): boolean {
  if (filter === "ALL") return true;
  const py = extractPY(product.name);
  if (py === null) return filter === "40"; // no PY → group with large
  if (filter === "20") return py >= 18 && py < 30;
  if (filter === "30") return py >= 30 && py < 40;
  return py >= 40; // "40"
}

/* ───────────────── Hero Section ───────────────── */
function HeroSection({ count }: { count: number }) {
  return (
    <section className="relative h-[60vh] md:h-[70vh] overflow-hidden bg-bg-primary flex items-center justify-center">
      <div className="absolute inset-0 bg-gradient-to-b from-bg-secondary to-bg-primary" />
      <div className="relative z-10 text-center px-6">
        <p
          className="text-gold text-xs tracking-[0.3em] uppercase mb-6 opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.2s" }}
        >
          Layout Design
        </p>
        <h1
          className="text-white text-[10vw] md:text-[5vw] lg:text-[4vw] font-light tracking-[0.3em] opacity-0 animate-heroTitle"
          style={{
            fontFamily: "'Inter', sans-serif",
            animationDelay: "0.5s",
          }}
        >
          LAYOUTS
        </h1>
        <p
          className="text-text-secondary text-sm md:text-base tracking-wider mt-4 opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.8s" }}
        >
          {count}개의 공간 설계도
        </p>
      </div>
    </section>
  );
}

/* ───────────────── Filter Bar ───────────────── */
function FilterBar({
  active,
  onSelect,
  counts,
}: {
  active: FilterKey;
  onSelect: (key: FilterKey) => void;
  counts: Record<FilterKey, number>;
}) {
  return (
    <div className="sticky top-20 z-30 bg-bg-primary/90 backdrop-blur-md border-b border-border">
      <div className="max-w-7xl mx-auto px-6 md:px-10 overflow-x-auto scrollbar-none">
        <div className="flex gap-8 py-4 min-w-max">
          {FILTER_OPTIONS.map(({ key, label }) => (
            <button
              key={key}
              onClick={() => onSelect(key)}
              className={`relative text-[13px] tracking-[0.2em] uppercase transition-colors duration-300 pb-2 whitespace-nowrap ${
                active === key
                  ? "text-text-primary"
                  : "text-text-muted hover:text-text-secondary"
              }`}
            >
              {label}
              <span className="ml-1 text-text-muted text-[11px]">
                ({counts[key]})
              </span>
              {active === key && (
                <span className="absolute bottom-0 left-0 right-0 h-[2px] bg-gold" />
              )}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

/* ───────────────── Layout Card ───────────────── */
function LayoutCard({
  product,
  index,
  visible,
  onOpen,
}: {
  product: Product;
  index: number;
  visible: boolean;
  onOpen: (product: Product) => void;
}) {
  const py = extractPY(product.name);
  const displayName = product.name
    .replace(/_/g, " ")
    .replace(/\s*Design$/i, "")
    .trim();

  return (
    <div
      className={`cursor-pointer group transition-all duration-700 ${
        visible
          ? "opacity-100 translate-y-0"
          : "opacity-0 translate-y-[50px]"
      }`}
      style={{
        ...REVEAL_STYLE,
        transitionDelay: `${(index % 6) * 0.1}s`,
      }}
      onClick={() => onOpen(product)}
    >
      <div className="aspect-[4/3] overflow-hidden bg-white border border-border">
        <div
          className="w-full h-full bg-contain bg-center bg-no-repeat bg-white transition-transform duration-700 group-hover:scale-[1.05]"
          style={{
            backgroundImage: `url(/api/images/${product.main_image})`,
          }}
        />
      </div>
      <div className="mt-3">
        <h3 className="text-text-primary text-sm font-light tracking-wide leading-tight line-clamp-1">
          {displayName}
        </h3>
        <p className="text-text-muted text-xs mt-1">
          {py ? `${py}평` : "—"}
        </p>
      </div>
    </div>
  );
}

/* ───────────────── Layout Grid ───────────────── */
function LayoutGrid({
  products,
  onOpen,
}: {
  products: Product[];
  onOpen: (product: Product) => void;
}) {
  const { ref, visible } = useScrollReveal(0.05);

  return (
    <section
      ref={ref}
      className="py-12 md:py-16 px-6 md:px-10 max-w-7xl mx-auto"
    >
      {products.length === 0 ? (
        <p className="text-center text-text-muted py-20">
          해당 평형의 도면이 없습니다.
        </p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-x-6 gap-y-10">
          {products.map((product, i) => (
            <LayoutCard
              key={product.id}
              product={product}
              index={i}
              visible={visible}
              onOpen={onOpen}
            />
          ))}
        </div>
      )}
    </section>
  );
}

/* ───────────────── Lightbox ───────────────── */
function Lightbox({
  product,
  onClose,
}: {
  product: Product;
  onClose: () => void;
}) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const images = product.images.length > 0
    ? product.images.map((img) => img.path)
    : [product.main_image];

  const displayName = product.name
    .replace(/_/g, " ")
    .replace(/\s*Design$/i, "")
    .trim();

  const prev = () =>
    setCurrentIndex((i) => (i === 0 ? images.length - 1 : i - 1));
  const next = () =>
    setCurrentIndex((i) => (i === images.length - 1 ? 0 : i + 1));

  return (
    <div
      className="fixed inset-0 z-[200] bg-black/95 flex items-center justify-center animate-[fadeIn_0.2s_ease]"
      onClick={onClose}
    >
      <div
        className="relative w-full max-w-5xl mx-4"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Close button */}
        <button
          onClick={onClose}
          className="absolute -top-12 right-0 text-white/70 hover:text-white transition-colors"
          aria-label="닫기"
        >
          <svg
            width="28"
            height="28"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.5"
          >
            <path d="M18 6L6 18M6 6l12 12" />
          </svg>
        </button>

        {/* Image */}
        <div className="aspect-[4/3] bg-white flex items-center justify-center">
          <div
            className="w-full h-full bg-contain bg-center bg-no-repeat bg-white"
            style={{
              backgroundImage: `url(/api/images/${images[currentIndex]})`,
            }}
          />
        </div>

        {/* Nav arrows */}
        {images.length > 1 && (
          <>
            <button
              onClick={prev}
              className="absolute left-2 top-1/2 -translate-y-1/2 w-10 h-10 bg-black/50 text-white flex items-center justify-center hover:bg-black/80 transition-colors"
              aria-label="이전"
            >
              <svg
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
              >
                <path d="M15 18l-6-6 6-6" />
              </svg>
            </button>
            <button
              onClick={next}
              className="absolute right-2 top-1/2 -translate-y-1/2 w-10 h-10 bg-black/50 text-white flex items-center justify-center hover:bg-black/80 transition-colors"
              aria-label="다음"
            >
              <svg
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
              >
                <path d="M9 18l6-6-6-6" />
              </svg>
            </button>
          </>
        )}

        {/* Caption */}
        <div className="mt-4 text-center">
          <p className="text-white text-sm font-light tracking-wide">
            {displayName}
          </p>
          {images.length > 1 && (
            <p className="text-white/50 text-xs mt-1">
              {currentIndex + 1} / {images.length}
            </p>
          )}
        </div>
      </div>
    </div>
  );
}

/* ───────────────── Philosophy Section ───────────────── */
function PhilosophySection() {
  const { ref, visible } = useScrollReveal(0.2);

  return (
    <section
      ref={ref}
      className="py-24 md:py-36 px-6 md:px-10 bg-bg-secondary"
    >
      <div
        className={`max-w-3xl mx-auto text-center transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[30px]"
        }`}
        style={REVEAL_STYLE}
      >
        <p className="text-text-primary text-xl md:text-2xl lg:text-3xl font-light italic leading-relaxed tracking-wide">
          &ldquo;우리의 도면은 단순한 선이 아닙니다.
          <br className="hidden md:block" />
          공간을 살아가는 사람의 동선과 감정,
          <br className="hidden md:block" />
          빛과 그림자까지 설계합니다.&rdquo;
        </p>
        <p className="text-text-muted text-sm mt-8 tracking-wider">
          BLACKLABELLED DESIGN PHILOSOPHY
        </p>
      </div>
    </section>
  );
}

/* ───────────────── Main Component ───────────────── */
interface LilsquareLayoutsProps {
  layouts: Product[];
}

export default function LilsquareLayouts({ layouts }: LilsquareLayoutsProps) {
  const [activeFilter, setActiveFilter] = useState<FilterKey>("ALL");
  const [displayed, setDisplayed] = useState(layouts);
  const [fading, setFading] = useState(false);
  const [lightboxProduct, setLightboxProduct] = useState<Product | null>(null);

  const counts: Record<FilterKey, number> = {
    ALL: layouts.length,
    "20": layouts.filter((p) => matchesFilter(p, "20")).length,
    "30": layouts.filter((p) => matchesFilter(p, "30")).length,
    "40": layouts.filter((p) => matchesFilter(p, "40")).length,
  };

  const handleFilter = useCallback(
    (key: FilterKey) => {
      if (key === activeFilter) return;
      setFading(true);
      setTimeout(() => {
        setActiveFilter(key);
        setDisplayed(layouts.filter((p) => matchesFilter(p, key)));
        setFading(false);
      }, 300);
    },
    [activeFilter, layouts]
  );

  return (
    <div>
      <HeroSection count={layouts.length} />
      <FilterBar active={activeFilter} onSelect={handleFilter} counts={counts} />
      <div
        className={`transition-opacity duration-300 ${
          fading ? "opacity-0" : "opacity-100"
        }`}
      >
        <LayoutGrid products={displayed} onOpen={setLightboxProduct} />
      </div>
      <PhilosophySection />

      {/* Lightbox overlay */}
      {lightboxProduct && (
        <Lightbox
          product={lightboxProduct}
          onClose={() => setLightboxProduct(null)}
        />
      )}
    </div>
  );
}
