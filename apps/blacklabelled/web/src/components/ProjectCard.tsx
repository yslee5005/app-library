"use client";

import { useRef, useState, useCallback } from "react";
import Link from "next/link";
import type { Product } from "@/lib/data";

interface ProjectCardProps {
  product: Product;
  showInfo?: boolean;
  showTitle?: boolean;
}

export default function ProjectCard({ product, showInfo, showTitle }: ProjectCardProps) {
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
        {/* Image — Layout Design uses first detail image */}
        <div className="relative aspect-[4/3] overflow-hidden bg-bg-card">
          <div
            className="absolute inset-0 bg-cover bg-center transition-all duration-600 group-hover:brightness-110"
            style={{
              backgroundImage: `url(/api/images/${
                product.main_category_name === "Layout_Design" && product.images.length > 0
                  ? product.images.filter(i => i.type === "detail").sort((a, b) => a.path.localeCompare(b.path))[0]?.path || product.main_image
                  : product.main_image
              })`,
            }}
          />
          {/* Hover overlay */}
          <div className="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-all duration-500" />
        </div>
        {/* Title below image */}
        {showTitle && (
          <div className="mt-3">
            <p className="text-[11px] text-text-muted tracking-[0.12em] uppercase">
              PROJECT NO.{product.id}
            </p>
            <p className="text-text-primary text-[15px] mt-1 font-light">
              {product.name}
            </p>
          </div>
        )}
      </div>
    </Link>
  );
}
