"use client";

import { useState, useRef, useEffect, useCallback } from "react";

interface ImageCarouselProps {
  images: string[];
  onImageClick?: (index: number) => void;
}

export default function ImageCarousel({
  images,
  onImageClick,
}: ImageCarouselProps) {
  const [current, setCurrent] = useState(0);
  const thumbRef = useRef<HTMLDivElement>(null);

  const goTo = useCallback(
    (index: number) => {
      setCurrent(Math.max(0, Math.min(index, images.length - 1)));
    },
    [images.length]
  );

  const prev = () => goTo(current - 1);
  const next = () => goTo(current + 1);

  // Keyboard navigation
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.key === "ArrowLeft") prev();
      if (e.key === "ArrowRight") next();
    };
    window.addEventListener("keydown", handler);
    return () => window.removeEventListener("keydown", handler);
  });

  // Scroll thumbnail into view
  useEffect(() => {
    if (!thumbRef.current) return;
    const thumb = thumbRef.current.children[current] as HTMLElement;
    if (thumb) {
      thumb.scrollIntoView({
        behavior: "smooth",
        inline: "center",
        block: "nearest",
      });
    }
  }, [current]);

  if (images.length === 0) return null;

  return (
    <div className="w-full">
      {/* Main image */}
      <div className="relative aspect-[16/10] overflow-hidden bg-bg-card group">
        {/* Crossfade images */}
        {images.map((src, i) => (
          <div
            key={i}
            className="absolute inset-0 bg-contain bg-center bg-no-repeat transition-opacity duration-500 cursor-pointer"
            style={{
              backgroundImage: `url(${src})`,
              opacity: i === current ? 1 : 0,
            }}
            onClick={() => onImageClick?.(current)}
          />
        ))}

        {/* Left arrow */}
        {current > 0 && (
          <button
            onClick={prev}
            className="absolute left-4 top-1/2 -translate-y-1/2 w-10 h-10 bg-black/50 hover:bg-black/70 rounded-full flex items-center justify-center text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300 z-10"
          >
            ‹
          </button>
        )}

        {/* Right arrow */}
        {current < images.length - 1 && (
          <button
            onClick={next}
            className="absolute right-4 top-1/2 -translate-y-1/2 w-10 h-10 bg-black/50 hover:bg-black/70 rounded-full flex items-center justify-center text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300 z-10"
          >
            ›
          </button>
        )}

        {/* Counter */}
        <div className="absolute bottom-4 right-4 bg-black/60 text-white text-xs px-3 py-1.5 rounded-full tracking-wider z-10">
          {current + 1} / {images.length}
        </div>
      </div>

      {/* Thumbnail strip */}
      <div
        ref={thumbRef}
        className="mt-3 flex gap-2 overflow-x-auto scrollbar-hide pb-2"
        style={{ scrollbarWidth: "none" }}
      >
        {images.map((src, i) => (
          <button
            key={i}
            onClick={() => goTo(i)}
            className={`flex-shrink-0 w-20 h-14 bg-cover bg-center rounded-sm transition-all duration-200 ${
              i === current
                ? "ring-2 ring-white opacity-100"
                : "opacity-40 hover:opacity-70"
            }`}
            style={{ backgroundImage: `url(${src})` }}
          />
        ))}
      </div>
    </div>
  );
}
