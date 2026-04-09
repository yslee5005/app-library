"use client";
import { useState, useEffect } from "react";

interface ImageCrossfadeProps {
  images: string[];
  interval?: number;
}

export default function ImageCrossfade({
  images,
  interval = 3000,
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
    <div className="relative aspect-[4/3] overflow-hidden bg-bg-card">
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
