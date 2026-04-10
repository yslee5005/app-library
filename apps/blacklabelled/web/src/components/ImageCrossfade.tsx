"use client";
import { useState, useEffect } from "react";

interface ImageCrossfadeProps {
  images: string[];
  interval?: number;
  aspectRatio?: string;
}

export default function ImageCrossfade({
  images,
  interval = 3000,
  aspectRatio = "4/3",
}: ImageCrossfadeProps) {
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    if (images.length <= 1) return;
    const timer = setInterval(() => {
      setCurrent((prev) => (prev + 1) % images.length);
    }, interval);
    return () => clearInterval(timer);
  }, [images, interval]);

  return (
    <div
      className="relative overflow-hidden bg-bg-card"
      style={{ aspectRatio }}
    >
      {images.map((src, i) => (
        <div
          key={i}
          className="absolute inset-0 bg-cover bg-center transition-opacity duration-[2000ms]"
          style={{
            backgroundImage: `url(${src})`,
            opacity: i === current ? 1 : 0,
          }}
        />
      ))}
    </div>
  );
}
