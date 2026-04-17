"use client";

import { useRef, useState, useEffect } from "react";
import { motion } from "framer-motion";
import Link from "next/link";
import type { MagazineWithImage } from "@/lib/data";

interface FeaturedMagazinesProps {
  magazines: MagazineWithImage[];
}

function formatDate(dateStr: string | null): string {
  if (!dateStr) return "";
  const d = new Date(dateStr);
  return d.toLocaleDateString("ko-KR", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

function MagazineCard({ magazine }: { magazine: MagazineWithImage }) {
  if (!magazine.slug) return null;
  return (
    <Link href={`/magazines/${magazine.slug}`}>
      <div className="group overflow-hidden transition-transform duration-500 ease-out">
        {/* Thumbnail */}
        <div className="relative aspect-[4/3] overflow-hidden bg-bg-card">
          {magazine.imageUrl ? (
            <>
              <div
                className="absolute inset-0 bg-cover bg-center transition-all duration-600 group-hover:brightness-110"
                style={{ backgroundImage: `url(${magazine.imageUrl})` }}
              />
              <div className="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-all duration-500" />
            </>
          ) : (
            <div className="absolute inset-0 flex items-center justify-center bg-zinc-800">
              <span className="text-3xl font-heading tracking-[0.2em] text-zinc-500">
                BL
              </span>
            </div>
          )}
        </div>
        {/* Info */}
        <div className="mt-3">
          <p className="text-[11px] text-text-muted tracking-[0.12em] uppercase">
            {formatDate(magazine.date)}
          </p>
          <p className="text-text-primary text-[15px] mt-1 font-light line-clamp-2">
            {magazine.title}
          </p>
        </div>
      </div>
    </Link>
  );
}

export default function FeaturedMagazines({ magazines }: FeaturedMagazinesProps) {
  const scrollRef = useRef<HTMLDivElement>(null);
  const [activeIndex, setActiveIndex] = useState(0);
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    const check = () => setIsMobile(window.innerWidth < 640);
    check();
    window.addEventListener("resize", check);
    return () => window.removeEventListener("resize", check);
  }, []);

  useEffect(() => {
    const el = scrollRef.current;
    if (!el || !isMobile) return;
    const onScroll = () => {
      const cardWidth = el.scrollWidth / magazines.length;
      const index = Math.round(el.scrollLeft / cardWidth);
      setActiveIndex(index);
    };
    el.addEventListener("scroll", onScroll, { passive: true });
    return () => el.removeEventListener("scroll", onScroll);
  }, [isMobile, magazines.length]);

  if (magazines.length === 0) return null;

  return (
    <section className="py-24 md:py-32 max-w-7xl mx-auto">
      <motion.h2
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, margin: "-100px" }}
        transition={{ duration: 0.8 }}
        className="font-heading text-3xl md:text-4xl text-text-primary text-center tracking-[0.1em] font-light mb-16 px-6 md:px-10"
      >
        MAGAZINE
      </motion.h2>

      {/* Mobile: horizontal scroll carousel */}
      <div className="sm:hidden">
        <div
          ref={scrollRef}
          className="flex gap-4 overflow-x-auto snap-x snap-mandatory scroll-smooth px-6 pb-4"
          style={{ scrollbarWidth: "none", msOverflowStyle: "none", WebkitOverflowScrolling: "touch" }}
        >
          <style>{`div::-webkit-scrollbar { display: none; }`}</style>
          {magazines.map((magazine) => (
            <div
              key={magazine.id}
              className="flex-none w-[75vw] snap-center"
            >
              <MagazineCard magazine={magazine} />
            </div>
          ))}
        </div>

        {/* Carousel indicators */}
        <div className="flex justify-center gap-1.5 mt-4">
          {magazines.map((_, i) => (
            <button
              key={i}
              onClick={() => {
                const el = scrollRef.current;
                if (!el) return;
                const cardWidth = el.scrollWidth / magazines.length;
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
        {magazines.map((magazine, i) => (
          <motion.div
            key={magazine.id}
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-50px" }}
            transition={{ duration: 0.6, delay: (i % 4) * 0.05 }}
          >
            <MagazineCard magazine={magazine} />
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
          href="/magazines"
          className="inline-block text-gold text-sm tracking-[0.2em] uppercase hover:text-gold-light transition-colors duration-300 group"
        >
          VIEW ALL MAGAZINES
          <span className="inline-block ml-2 transition-transform duration-300 group-hover:translate-x-1">
            →
          </span>
        </Link>
      </motion.div>
    </section>
  );
}
