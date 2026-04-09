"use client";

import { useRef, useState, useCallback, useEffect } from "react";

interface BeforeAfterSliderProps {
  beforeImage: string;
  afterImage: string;
  beforeLabel?: string;
  afterLabel?: string;
}

export default function BeforeAfterSlider({
  beforeImage,
  afterImage,
  beforeLabel = "DESIGN",
  afterLabel = "REALITY",
}: BeforeAfterSliderProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [sliderPos, setSliderPos] = useState(50);
  const [isDragging, setIsDragging] = useState(false);

  const updatePosition = useCallback(
    (clientX: number) => {
      if (!containerRef.current) return;
      const rect = containerRef.current.getBoundingClientRect();
      const x = Math.max(0, Math.min(clientX - rect.left, rect.width));
      setSliderPos((x / rect.width) * 100);
    },
    []
  );

  const handlePointerDown = useCallback(
    (e: React.PointerEvent) => {
      setIsDragging(true);
      updatePosition(e.clientX);
      (e.target as HTMLElement).setPointerCapture(e.pointerId);
    },
    [updatePosition]
  );

  const handlePointerMove = useCallback(
    (e: React.PointerEvent) => {
      if (!isDragging) return;
      updatePosition(e.clientX);
    },
    [isDragging, updatePosition]
  );

  const handlePointerUp = useCallback(() => {
    setIsDragging(false);
  }, []);

  useEffect(() => {
    const handleGlobalUp = () => setIsDragging(false);
    window.addEventListener("pointerup", handleGlobalUp);
    return () => window.removeEventListener("pointerup", handleGlobalUp);
  }, []);

  return (
    <div className="w-full">
      <div
        ref={containerRef}
        className="relative w-full aspect-[4/3] overflow-hidden rounded-sm select-none cursor-col-resize"
        onPointerDown={handlePointerDown}
        onPointerMove={handlePointerMove}
        onPointerUp={handlePointerUp}
      >
        {/* After (reality) — full width background */}
        <div
          className="absolute inset-0 bg-cover bg-center"
          style={{ backgroundImage: `url(${afterImage})` }}
        />

        {/* Before (design) — clipped */}
        <div
          className="absolute inset-0 bg-cover bg-center"
          style={{
            backgroundImage: `url(${beforeImage})`,
            clipPath: `inset(0 ${100 - sliderPos}% 0 0)`,
          }}
        />

        {/* Slider line */}
        <div
          className="absolute top-0 bottom-0 w-[2px] bg-gold z-10"
          style={{ left: `${sliderPos}%` }}
        />

        {/* Handle */}
        <div
          className="absolute top-1/2 -translate-y-1/2 -translate-x-1/2 z-20 w-10 h-10 rounded-full border-2 border-gold bg-bg-primary/80 flex items-center justify-center"
          style={{ left: `${sliderPos}%` }}
        >
          <svg
            width="16"
            height="16"
            viewBox="0 0 16 16"
            fill="none"
            stroke="#C5A46C"
            strokeWidth="1.5"
          >
            <path d="M5 3L2 8l3 5" />
            <path d="M11 3l3 5-3 5" />
          </svg>
        </div>
      </div>

      {/* Labels */}
      <div className="flex justify-between mt-4 px-2">
        <span className="text-gold text-xs tracking-[0.2em] font-body uppercase">
          {beforeLabel}
        </span>
        <span className="text-text-primary text-xs tracking-[0.2em] font-body uppercase">
          {afterLabel}
        </span>
      </div>
    </div>
  );
}
