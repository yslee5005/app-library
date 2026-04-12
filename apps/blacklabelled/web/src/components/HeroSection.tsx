"use client";

import { useRef, useState, useCallback } from "react";
import { motion } from "framer-motion";

interface HeroSectionProps {
  backgroundImage?: string;
  title?: string;
  subtitle?: string;
}

export default function HeroSection({ backgroundImage, title, subtitle }: HeroSectionProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [mousePos, setMousePos] = useState({ x: 50, y: 50 });

  const handleMouseMove = useCallback(
    (e: React.MouseEvent<HTMLDivElement>) => {
      const rect = e.currentTarget.getBoundingClientRect();
      setMousePos({
        x: ((e.clientX - rect.left) / rect.width) * 100,
        y: ((e.clientY - rect.top) / rect.height) * 100,
      });
    },
    []
  );

  return (
    <section
      ref={containerRef}
      onMouseMove={handleMouseMove}
      className="relative h-screen w-full flex flex-col items-center justify-center overflow-hidden cursor-crosshair"
    >
      {/* Background image with flashlight mask */}
      <div
        className="absolute inset-0 bg-cover bg-center transition-[mask-position,_-webkit-mask-position] duration-100"
        style={{
          backgroundImage: backgroundImage ? `url(${backgroundImage})` : undefined,
          maskImage: `radial-gradient(circle 350px at ${mousePos.x}% ${mousePos.y}%, rgba(0,0,0,1) 0%, rgba(0,0,0,0.6) 50%, transparent 100%)`,
          WebkitMaskImage: `radial-gradient(circle 350px at ${mousePos.x}% ${mousePos.y}%, rgba(0,0,0,1) 0%, rgba(0,0,0,0.6) 50%, transparent 100%)`,
        }}
      />

      {/* Dark overlay */}
      <div className="absolute inset-0 bg-bg-primary/40" />

      {/* Content */}
      <div className="relative z-10 text-center">
        <motion.h1
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 0.5 }}
          className="font-heading text-white text-5xl md:text-7xl lg:text-8xl font-light tracking-[0.15em]"
        >
          {title ?? "BLACKLABELLED"}
        </motion.h1>
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 1, delay: 1 }}
          className="mt-6 font-body text-text-secondary text-base md:text-lg tracking-wider"
        >
          {subtitle ?? "Your space is 'black label'"}
        </motion.p>
      </div>

      {/* EXPLORE rotating circle — click to scroll down */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1.5, duration: 1 }}
        className="absolute bottom-16 z-10 cursor-pointer"
        onClick={() => {
          window.scrollTo({
            top: window.innerHeight,
            behavior: "smooth",
          });
        }}
      >
        <div className="relative w-[200px] h-[200px]">
          {/* Rotating circular text */}
          <svg
            className="w-full h-full animate-spin-slow"
            viewBox="0 0 200 200"
          >
            <defs>
              <path
                id="circlePath"
                d="M100,100 m-75,0 a75,75 0 1,1 150,0 a75,75 0 1,1 -150,0"
                fill="none"
              />
            </defs>
            <text
              className="fill-white"
              style={{
                fontSize: "12px",
                letterSpacing: "0.25em",
                textTransform: "uppercase",
              }}
            >
              <textPath href="#circlePath">
                BLACKLABELLED · DESIGN STUDIO · LIFE MAKES SENSE ·
              </textPath>
            </text>
          </svg>

          {/* Center EXPLORE + arrow */}
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <span className="text-white text-[13px] tracking-[0.2em] font-light">
              EXPLORE
            </span>
            <motion.span
              animate={{ y: [0, 4, 0] }}
              transition={{ duration: 1.5, repeat: Infinity }}
              className="text-white mt-1 text-lg"
            >
              ↓
            </motion.span>
          </div>
        </div>
      </motion.div>
    </section>
  );
}
