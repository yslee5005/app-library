"use client";

import { useState, useMemo } from "react";
import { motion, AnimatePresence } from "framer-motion";
import type { Product, Category } from "@/lib/data";
import ProjectCard from "./ProjectCard";

const ITEMS_PER_PAGE = 20;

interface ProjectsGridProps {
  products: Product[];
  categories: Category[];
}

export default function ProjectsGrid({
  products,
  categories,
}: ProjectsGridProps) {
  const [activeFilter, setActiveFilter] = useState<string | null>(null);
  const [visibleCount, setVisibleCount] = useState(ITEMS_PER_PAGE);

  // 3 카테고리만 표시: Residence, Layout Design, Commercial
  const ALLOWED_CATEGORIES = ["residence", "layout_design", "commercial"];
  const filters = useMemo(() => {
    const filtered = categories.filter((c) =>
      ALLOWED_CATEGORIES.includes(c.name.toLowerCase().replace(/ /g, "_"))
    );
    const sorted = filtered.sort((a, b) => b.product_count - a.product_count);
    return [
      { id: null, name: "ALL" },
      ...sorted.map((c) => ({
        id: c.id,
        name: c.name.toUpperCase().replace(/_/g, " "),
      })),
    ];
  }, [categories]);

  // furniture 제외 — 허용된 카테고리만
  const allowedCategoryIds = useMemo(() => {
    return categories
      .filter((c) => ALLOWED_CATEGORIES.includes(c.name.toLowerCase().replace(/ /g, "_")))
      .map((c) => c.id);
  }, [categories]);

  const filtered = useMemo(() => {
    const base = products.filter((p) =>
      p.categories.some((cid) => allowedCategoryIds.includes(cid))
    );
    if (!activeFilter) return base;
    return base.filter((p) => p.categories.includes(activeFilter));
  }, [products, activeFilter, allowedCategoryIds]);

  const visible = filtered.slice(0, visibleCount);
  const hasMore = visibleCount < filtered.length;

  const handleFilter = (id: string | null) => {
    setActiveFilter(id);
    setVisibleCount(ITEMS_PER_PAGE);
  };

  return (
    <>
      {/* Filter bar */}
      <div className="mt-10 flex flex-wrap justify-center gap-x-6 gap-y-3">
        {filters.map((f) => (
          <button
            key={f.id ?? "all"}
            onClick={() => handleFilter(f.id)}
            className={`text-xs tracking-[0.15em] font-body pb-2 border-b-2 transition-all duration-300 ${
              activeFilter === f.id
                ? "text-gold border-gold"
                : "text-text-muted border-transparent hover:text-text-primary"
            }`}
          >
            {f.name}
          </button>
        ))}
      </div>

      {/* Grid */}
      <motion.div
        layout
        className="mt-10 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6"
      >
        <AnimatePresence mode="popLayout">
          {visible.map((product) => (
            <motion.div
              key={product.id}
              layout
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              transition={{ duration: 0.3 }}
            >
              <ProjectCard product={product} showTitle />
            </motion.div>
          ))}
        </AnimatePresence>
      </motion.div>

      {/* Load more */}
      {hasMore && (
        <div className="mt-12 text-center">
          <button
            onClick={() => setVisibleCount((c) => c + ITEMS_PER_PAGE)}
            className="inline-block border border-gold text-gold px-10 py-3 text-xs tracking-[0.2em] uppercase font-body hover:bg-gold hover:text-bg-primary transition-all duration-300"
          >
            LOAD MORE
          </button>
        </div>
      )}
    </>
  );
}
