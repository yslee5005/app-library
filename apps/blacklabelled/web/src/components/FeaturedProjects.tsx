"use client";

import { useRef, useState, useEffect } from "react";
import { motion } from "framer-motion";
import Link from "next/link";
import ProjectCard from "./ProjectCard";
import type { Product } from "@/lib/data";

interface FeaturedProjectsProps {
  products: Product[];
}

export default function FeaturedProjects({ products }: FeaturedProjectsProps) {
  const scrollRef = useRef<HTMLDivElement>(null);
  const [activeIndex, setActiveIndex] = useState(0);
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    const check = () => setIsMobile(window.innerWidth < 640);
    check();
    window.addEventListener("resize", check);
    return () => window.removeEventListener("resize", check);
  }, []);

  // Track scroll position for carousel indicators
  useEffect(() => {
    const el = scrollRef.current;
    if (!el || !isMobile) return;
    const onScroll = () => {
      const cardWidth = el.scrollWidth / products.length;
      const index = Math.round(el.scrollLeft / cardWidth);
      setActiveIndex(index);
    };
    el.addEventListener("scroll", onScroll, { passive: true });
    return () => el.removeEventListener("scroll", onScroll);
  }, [isMobile, products.length]);

  return (
    <section className="py-24 md:py-32 max-w-7xl mx-auto">
      <motion.h2
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, margin: "-100px" }}
        transition={{ duration: 0.8 }}
        className="font-heading text-3xl md:text-4xl text-text-primary text-center tracking-[0.1em] font-light mb-16 px-6 md:px-10"
      >
        PROJECTS
      </motion.h2>

      {/* Mobile: horizontal scroll carousel */}
      <div className="sm:hidden">
        <div
          ref={scrollRef}
          className="flex gap-4 overflow-x-auto snap-x snap-mandatory scroll-smooth px-6 pb-4"
          style={{ scrollbarWidth: "none", msOverflowStyle: "none", WebkitOverflowScrolling: "touch" }}
        >
          <style>{`div::-webkit-scrollbar { display: none; }`}</style>
          {products.map((product) => (
            <div
              key={product.id}
              className="flex-none w-[75vw] snap-center"
            >
              <ProjectCard product={product} showTitle />
            </div>
          ))}
        </div>

        {/* Carousel indicators */}
        <div className="flex justify-center gap-1.5 mt-4">
          {products.map((_, i) => (
            <button
              key={i}
              onClick={() => {
                const el = scrollRef.current;
                if (!el) return;
                const cardWidth = el.scrollWidth / products.length;
                el.scrollTo({ left: cardWidth * i, behavior: "smooth" });
              }}
              className={`h-[3px] rounded-full transition-all duration-300 ${
                i === activeIndex
                  ? "w-6 bg-white"
                  : "w-3 bg-white/30"
              }`}
            />
          ))}
        </div>
      </div>

      {/* Desktop: grid */}
      <div className="hidden sm:grid sm:grid-cols-2 lg:grid-cols-4 gap-6 px-6 md:px-10">
        {products.map((product, i) => (
          <motion.div
            key={product.id}
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-50px" }}
            transition={{ duration: 0.6, delay: (i % 4) * 0.05 }}
          >
            <ProjectCard product={product} showTitle />
          </motion.div>
        ))}
      </div>

      <motion.div
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6, delay: 0.3 }}
        className="text-center mt-16 px-6 md:px-10"
      >
        <Link
          href="/projects"
          className="inline-block text-gold text-sm tracking-[0.2em] uppercase hover:text-gold-light transition-colors duration-300 group"
        >
          VIEW ALL PROJECTS
          <span className="inline-block ml-2 transition-transform duration-300 group-hover:translate-x-1">
            →
          </span>
        </Link>
      </motion.div>
    </section>
  );
}
