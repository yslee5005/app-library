"use client";

import { useState, useRef, useEffect, useCallback } from "react";
import Link from "next/link";
import type { Product, Category } from "@/lib/data";
import { useScrollReveal } from "@/hooks/useScrollReveal";

interface LilsquareProjectsProps {
  products: Product[];
  categories: Category[];
}

/* ───────────────────────── Hero ───────────────────────── */
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
      <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-black/20 to-black/60" />
      <div className="absolute inset-0 flex items-center justify-center z-10">
        <h1
          className="text-white text-[14vw] md:text-[8vw] lg:text-[6vw] font-light tracking-[0.3em] opacity-0"
          style={{
            fontFamily: "'Inter', sans-serif",
            animation: "heroTitleFade 1.2s ease forwards 0.5s",
          }}
        >
          PROJECTS
        </h1>
      </div>
    </section>
  );
}

/* ─────────────── Category Filter (sticky) ────────────── */
const FILTER_ALL = "ALL";

function CategoryFilter({
  categories,
  active,
  onSelect,
}: {
  categories: Category[];
  active: string;
  onSelect: (name: string) => void;
}) {
  return (
    <div className="sticky top-20 z-30 bg-bg-primary/90 backdrop-blur-md border-b border-border">
      <div className="max-w-7xl mx-auto px-6 md:px-10 overflow-x-auto scrollbar-none">
        <div className="flex gap-8 py-4 min-w-max">
          {[FILTER_ALL, ...categories.map((c) => c.name)].map((name) => (
            <button
              key={name}
              onClick={() => onSelect(name)}
              className={`relative text-[13px] tracking-[0.2em] uppercase transition-colors duration-300 pb-2 whitespace-nowrap ${
                active === name
                  ? "text-text-primary"
                  : "text-text-muted hover:text-text-secondary"
              }`}
            >
              {name}
              {active === name && (
                <span className="absolute bottom-0 left-0 right-0 h-[2px] bg-gold" />
              )}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

/* ───────────────────── Project Card ──────────────────── */
function ProjectCard({
  product,
  index,
  visible,
}: {
  product: Product;
  index: number;
  visible: boolean;
}) {
  return (
    <Link href={`/lilsquare/projects/${product.slug}`}>
      <div
        className={`transition-all duration-700 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[50px]"
        }`}
        style={{
          transitionDelay: `${index * 0.15}s`,
          transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
        }}
      >
        <div className="aspect-[4/3] overflow-hidden bg-bg-card group">
          <div
            className="w-full h-full bg-cover bg-center transition-all duration-700 group-hover:scale-[1.03] group-hover:brightness-75"
            style={{
              backgroundImage: `url(/api/images/${product.main_image})`,
            }}
          />
        </div>
        <div className="mt-4">
          <p className="text-[11px] tracking-[0.2em] text-text-muted">
            PROJECT NO.{product.id}
          </p>
          <h2 className="text-lg md:text-xl font-light text-text-primary mt-1 leading-tight">
            {product.name}
          </h2>
          <p className="text-[12px] text-text-muted mt-1">
            {product.main_category_name}
          </p>
        </div>
      </div>
    </Link>
  );
}

/* ─────────────────── Project Grid ─────────────────────── */
function ProjectGrid({ products }: { products: Product[] }) {
  const { ref, visible } = useScrollReveal(0.05);

  return (
    <section
      className="py-[60px] md:py-[80px] px-6 md:px-10 max-w-7xl mx-auto"
      ref={ref}
    >
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-x-6 gap-y-12">
        {products.map((product, i) => (
          <ProjectCard
            key={product.id}
            product={product}
            index={i % 6}
            visible={visible}
          />
        ))}
      </div>
    </section>
  );
}

/* ─────────────────── Main Component ───────────────────── */
export default function LilsquareProjects({
  products,
  categories,
}: LilsquareProjectsProps) {
  const [activeFilter, setActiveFilter] = useState(FILTER_ALL);
  const [displayed, setDisplayed] = useState(products);
  const [fading, setFading] = useState(false);

  const handleFilter = useCallback(
    (name: string) => {
      if (name === activeFilter) return;
      setFading(true);
      setTimeout(() => {
        setActiveFilter(name);
        if (name === FILTER_ALL) {
          setDisplayed(products);
        } else {
          const cat = categories.find((c) => c.name === name);
          if (cat) {
            const idSet = new Set(cat.product_ids);
            setDisplayed(products.filter((p) => idSet.has(p.id)));
          }
        }
        setFading(false);
      }, 300);
    },
    [activeFilter, products, categories]
  );

  const heroProduct = products[0];

  if (!heroProduct) {
    return (
      <div className="h-screen flex items-center justify-center text-text-muted">
        No projects found
      </div>
    );
  }

  return (
    <div>
      <HeroSection product={heroProduct} />
      <CategoryFilter
        categories={categories}
        active={activeFilter}
        onSelect={handleFilter}
      />
      <div
        className={`transition-opacity duration-300 ${
          fading ? "opacity-0" : "opacity-100"
        }`}
      >
        <ProjectGrid products={displayed} />
      </div>
    </div>
  );
}
