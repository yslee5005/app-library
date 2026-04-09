"use client";

import { useRef, useState, useCallback } from "react";
import Link from "next/link";
import type { Product } from "@/lib/data";

interface ProjectCardProps {
  product: Product;
  showInfo?: boolean;
}

export default function ProjectCard({ product, showInfo }: ProjectCardProps) {
  const cardRef = useRef<HTMLDivElement>(null);
  const [transform, setTransform] = useState("");

  const handleMouseMove = useCallback((e: React.MouseEvent<HTMLDivElement>) => {
    if (!cardRef.current) return;
    const rect = cardRef.current.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width - 0.5;
    const y = (e.clientY - rect.top) / rect.height - 0.5;
    setTransform(
      `perspective(600px) rotateX(${-y * 6}deg) rotateY(${x * 6}deg) scale(1.02)`
    );
  }, []);

  const handleMouseLeave = useCallback(() => {
    setTransform("");
  }, []);

  return (
    <Link href={`/projects/${product.slug}`}>
      <div
        ref={cardRef}
        onMouseMove={handleMouseMove}
        onMouseLeave={handleMouseLeave}
        className="group overflow-hidden transition-transform duration-500 ease-out"
        style={{ transform: transform || undefined }}
      >
        {/* Image */}
        <div className="relative aspect-[4/3] overflow-hidden bg-bg-card">
          <div
            className="absolute inset-0 bg-cover bg-center transition-all duration-600 group-hover:brightness-110"
            style={{
              backgroundImage: `url(/api/images/${product.main_image})`,
            }}
          />
          {/* Hover overlay */}
          <div className="absolute inset-0 bg-black/0 group-hover:bg-black/30 transition-all duration-500 flex items-end p-5 opacity-0 group-hover:opacity-100">
            <div>
              <p className="text-text-primary text-lg font-body">
                {product.name}
              </p>
              <p className="text-gold text-xs tracking-[0.15em] uppercase mt-1 font-body">
                {product.main_category_name}
                {showInfo && product.image_count > 0 && (
                  <span className="text-text-muted ml-2">
                    · {product.image_count} images
                  </span>
                )}
              </p>
            </div>
          </div>
        </div>
      </div>
    </Link>
  );
}
