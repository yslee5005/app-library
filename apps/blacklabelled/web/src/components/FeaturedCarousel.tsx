"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import type { Product } from "@/lib/data";

interface FeaturedCarouselProps {
  products: Product[];
}

export default function FeaturedCarousel({ products }: FeaturedCarouselProps) {
  const items = products.slice(0, 5);
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    if (items.length <= 1) return;
    const timer = setInterval(() => {
      setCurrent((prev) => (prev + 1) % items.length);
    }, 3000);
    return () => clearInterval(timer);
  }, [items.length]);

  const product = items[current];
  if (!product) return null;

  return (
    <section className="relative h-screen overflow-hidden">
      {/* Background images — crossfade */}
      {items.map((p, i) => (
        <div
          key={p.id}
          className="absolute inset-0 bg-cover bg-center transition-opacity duration-[1500ms]"
          style={{
            backgroundImage: `url(/api/images/${p.main_image})`,
            opacity: i === current ? 1 : 0,
          }}
        />
      ))}

      {/* Gradient overlay */}
      <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-black/30" />

      {/* Project info — bottom left */}
      <div className="absolute bottom-[80px] left-[40px] md:left-[60px] z-10">
        <p className="text-white/60 text-[11px] tracking-[0.15em] uppercase">
          PROJECT NO.{product.id}
        </p>
        <h2 className="text-white text-2xl md:text-4xl font-light mt-1">
          {product.name}
        </h2>
        {product.description && (
          <p className="text-white/50 mt-3 max-w-[400px] text-sm leading-[1.6]">
            {product.description.substring(0, 80)}
            {product.description.length > 80 ? "..." : ""}
          </p>
        )}
        <Link
          href={`/projects/${product.slug}`}
          className="inline-block mt-4 text-white text-[13px] border-b border-white pb-1 tracking-wider hover:text-text-secondary hover:border-text-secondary transition-colors"
        >
          VIEW PROJECT
        </Link>
      </div>

      {/* Carousel indicators — bottom center */}
      <div className="absolute bottom-[40px] left-1/2 -translate-x-1/2 z-10 flex gap-2">
        {items.map((_, i) => (
          <button
            key={i}
            onClick={() => setCurrent(i)}
            className={`w-8 h-[3px] transition-all duration-300 ${
              i === current ? "bg-white" : "bg-white/30"
            }`}
          />
        ))}
      </div>
    </section>
  );
}
