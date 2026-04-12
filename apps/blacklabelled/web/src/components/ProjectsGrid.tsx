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

  // 카테고리를 parent_name별로 그룹핑
  const PARENT_GROUPS = ["PROJECT", "FURNITURE"];
  const groupedFilters = useMemo(() => {
    const groups: { parent: string; children: { id: string; name: string }[] }[] = [];
    for (const parent of PARENT_GROUPS) {
      const children = categories
        .filter(
          (c) =>
            c.parent_name === parent &&
            c.is_visible !== false &&
            c.name !== "DEVELOPMENT"
        )
        .map((c) => ({
          id: c.id,
          name: c.name.replace(/_/g, " "),
        }));
      if (children.length > 0) {
        groups.push({ parent, children });
      }
    }
    return groups;
  }, [categories]);

  // 모든 표시 카테고리 ID
  const allowedCategoryIds = useMemo(() => {
    return groupedFilters.flatMap((g) => g.children.map((c) => c.id));
  }, [groupedFilters]);

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
      {/* Filter bar — hierarchy */}
      <div className="mt-10 flex flex-wrap justify-center gap-x-4 gap-y-3 items-center">
        <button
          onClick={() => handleFilter(null)}
          className={`text-xs tracking-[0.15em] font-body pb-2 border-b-2 transition-all duration-300 ${
            activeFilter === null
              ? "text-gold border-gold"
              : "text-text-muted border-transparent hover:text-text-primary"
          }`}
        >
          ALL
        </button>

        {groupedFilters.map((group) => (
          <div key={group.parent} className="flex items-center gap-x-3">
            <span className="text-[10px] tracking-[0.2em] text-zinc-600 uppercase select-none px-1">
              {group.parent}
            </span>
            {group.children.map((c) => (
              <button
                key={c.id}
                onClick={() => handleFilter(c.id)}
                className={`text-xs tracking-[0.15em] font-body pb-2 border-b-2 transition-all duration-300 ${
                  activeFilter === c.id
                    ? "text-gold border-gold"
                    : "text-text-muted border-transparent hover:text-text-primary"
                }`}
              >
                {c.name.toUpperCase()}
              </button>
            ))}
          </div>
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
