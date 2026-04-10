"use client";

import { useRef, useState, useEffect } from "react";
import Link from "next/link";
import type { Product } from "@/lib/data";
import ImageCrossfade from "./ImageCrossfade";
import { useScrollReveal } from "@/hooks/useScrollReveal";

interface LilsquareHomeProps {
  products: Product[];
  featured: Product[];
}

/* ───────────────────────── Hero (5-project carousel) ───────────────────────── */
function HeroSection({ products }: { products: Product[] }) {
  const heroProducts = products.slice(0, 5);
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    if (heroProducts.length <= 1) return;
    const timer = setInterval(() => {
      setCurrent((prev) => (prev + 1) % heroProducts.length);
    }, 3000);
    return () => clearInterval(timer);
  }, [heroProducts.length]);

  const product = heroProducts[current] || heroProducts[0];
  if (!product) return null;

  return (
    <section className="relative h-screen overflow-hidden">
      {/* Background images — crossfade */}
      {heroProducts.map((p, i) => (
        <div
          key={p.id}
          className="absolute inset-0 bg-cover bg-center transition-opacity duration-[1500ms]"
          style={{
            backgroundImage: `url(/api/images/${p.main_image})`,
            opacity: i === current ? 1 : 0,
          }}
        />
      ))}

      {/* Dark overlay */}
      <div className="absolute inset-0 bg-black/30" />

      {/* Project info — bottom left */}
      <div className="absolute bottom-[140px] left-[40px] md:left-[60px] z-10">
        <p
          className="text-white/70 text-[11px] tracking-[0.15em] uppercase transition-opacity duration-500"
          key={`no-${current}`}
        >
          PROJECT NO.{product.id}
        </p>
        <h2
          className="text-white text-2xl md:text-4xl font-light mt-1 transition-opacity duration-500"
          key={`name-${current}`}
        >
          {product.name}
        </h2>
        {product.description && (
          <p className="text-white/60 mt-3 max-w-[400px] text-sm leading-[1.6]">
            {product.description.substring(0, 80)}
            {product.description.length > 80 ? "..." : ""}
          </p>
        )}
        <Link
          href={`/lilsquare/projects/${product.slug}`}
          className="inline-block mt-4 text-white text-[13px] border-b border-white pb-1 tracking-wider hover:text-text-secondary hover:border-text-secondary transition-colors"
        >
          VIEW PROJECT
        </Link>
      </div>

      {/* Carousel indicators — bottom center */}
      <div className="absolute bottom-[110px] left-1/2 -translate-x-1/2 z-10 flex gap-2">
        {heroProducts.map((_, i) => (
          <button
            key={i}
            onClick={() => setCurrent(i)}
            className={`w-8 h-[3px] transition-all duration-300 ${
              i === current ? "bg-white" : "bg-white/30"
            }`}
          />
        ))}
      </div>

      {/* Title — center */}
      <div className="absolute inset-0 flex items-center justify-center z-10 pointer-events-none">
        <h1
          className="text-white text-[6vw] md:text-[3vw] font-light tracking-[0.25em] text-center"
        >
          {["Your", "space", "is", "'black", "label'"].map((word, i) => (
            <span
              key={i}
              className="inline-block opacity-0 animate-title-fade"
              style={{ animationDelay: `${0.1 + i * 0.4}s` }}
            >
              {word}&nbsp;
            </span>
          ))}
        </h1>
      </div>

      {/* EXPLORE spinning circle — click to scroll */}
      <div
        className="absolute bottom-4 left-1/2 -translate-x-1/2 z-10 text-center cursor-pointer"
        onClick={() => window.scrollTo({ top: window.innerHeight, behavior: "smooth" })}
      >
        <div className="relative w-[140px] h-[140px] md:w-[160px] md:h-[160px]">
          <svg
            className="w-full h-full animate-spin-slow"
            viewBox="0 0 200 200"
          >
            <path
              id="circlePath"
              d="M100,100 m-75,0 a75,75 0 1,1 150,0 a75,75 0 1,1 -150,0"
              fill="none"
            />
            <text className="fill-white text-[11px] tracking-[0.25em] uppercase">
              <textPath href="#circlePath">
                BLACKLABELLED · DESIGN STUDIO · LIFE MAKES SENSE ·
              </textPath>
            </text>
          </svg>
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <span className="text-white text-[12px] tracking-[0.2em]">EXPLORE</span>
            <span className="text-white mt-1 text-sm">↓</span>
          </div>
        </div>
      </div>
    </section>
  );
}

/* ───────────────────── Intro Section ──────────────────── */
function IntroSection({
  project1,
  project2,
}: {
  project1: Product;
  project2: Product;
}) {
  const { ref, visible } = useScrollReveal(0.15);

  const img1 = project1.images
    .filter((img) => img.type === "detail")
    .slice(0, 2)
    .map((img) => `/api/images/${img.path}`);
  const img2 = project2.images
    .filter((img) => img.type === "detail")
    .slice(0, 2)
    .map((img) => `/api/images/${img.path}`);

  // Fallback to main_image if no detail images
  const images1 =
    img1.length > 0 ? img1 : [`/api/images/${project1.main_image}`];
  const images2 =
    img2.length > 0 ? img2 : [`/api/images/${project2.main_image}`];

  return (
    <section className="py-[60px] md:py-[100px] px-6 md:px-[60px]" ref={ref}>
      <div
        className={`flex flex-col md:flex-row gap-8 transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[50px]"
        }`}
        style={{
          transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
        }}
      >
        {/* Left: text */}
        <div className="w-full md:w-1/3">
          <h1 className="text-3xl md:text-4xl font-light tracking-wider text-text-primary">
            Residential Space
            <br />
            Design Studio
          </h1>
          <p className="mt-8 text-text-secondary leading-[1.8] text-sm">
            공간과 사용자 사이에는 보이지 않는 수많은 이야기가 혼재합니다.
            블랙라벨드는 그 이야기를 읽어내고, 설계를 통해 공간에 생명을
            부여합니다. 427개 이상의 프로젝트를 통해 쌓아온 경험으로, 당신만의
            공간을 블랙라벨로 만들어 드립니다.
          </p>
          <Link
            href="/about"
            className="inline-block mt-12 text-lg md:text-[22px] font-medium text-gold border-b-2 border-gold pb-1"
          >
            LEARN MORE
          </Link>
        </div>

        {/* Center: project card 1 */}
        <div className="w-full md:w-1/3">
          <ImageCrossfade images={images1} interval={2000} />
          <h3 className="mt-5 text-xs tracking-wider text-text-muted">
            PROJECT NO.{project1.id}
          </h3>
          <h2 className="text-xl md:text-2xl font-light leading-[1.2] text-text-primary">
            {project1.name}
          </h2>
        </div>

        {/* Right: project card 2 */}
        <div className="w-full md:w-1/3 md:mt-4">
          <ImageCrossfade images={images2} interval={2000} />
          <h3 className="mt-5 text-xs tracking-wider text-text-muted">
            PROJECT NO.{project2.id}
          </h3>
          <h2 className="text-xl md:text-2xl font-light leading-[1.2] text-text-primary">
            {project2.name}
          </h2>
        </div>
      </div>
    </section>
  );
}

/* ────────────────── Fullscreen Project ────────────────── */
function FullscreenProject({ product }: { product: Product }) {
  const { ref, visible } = useScrollReveal(0.15);

  return (
    <section className="relative h-screen overflow-hidden" ref={ref}>
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{
          backgroundImage: `url(/api/images/${product.main_image})`,
        }}
      />
      <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-transparent" />
      <div
        className={`absolute bottom-[60px] md:bottom-[80px] left-6 md:left-[60px] z-10 transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[50px]"
        }`}
        style={{
          transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
        }}
      >
        <h3 className="text-white text-sm tracking-wider">
          PROJECT NO.{product.id}
        </h3>
        <h1 className="text-white text-3xl md:text-5xl font-light mt-2">
          {product.name}
        </h1>
        {product.description && (
          <p className="text-white/70 mt-4 max-w-[500px] leading-[1.8] text-sm md:text-base">
            {product.description.substring(0, 100)}
            {product.description.length > 100 ? "..." : ""}
          </p>
        )}
        <Link
          href={`/projects/${product.slug}`}
          className="inline-block mt-6 text-white border-b border-white pb-1 tracking-wider text-sm"
        >
          VIEW PROJECT
        </Link>
      </div>
    </section>
  );
}

/* ─────────────────── Project Grid ─────────────────────── */
function ProjectGrid({ products }: { products: Product[] }) {
  const { ref, visible } = useScrollReveal(0.1);

  return (
    <section
      className="py-[60px] md:py-[100px] px-6 md:px-[60px]"
      ref={ref}
    >
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {products.slice(0, 6).map((product, i) => (
          <Link href={`/projects/${product.slug}`} key={product.id}>
            <div
              className={`transition-all duration-700 ${
                visible
                  ? "opacity-100 translate-y-0"
                  : "opacity-0 translate-y-[50px]"
              }`}
              style={{
                transitionDelay: `${i * 0.15}s`,
                transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
              }}
            >
              <div className="aspect-[4/3] overflow-hidden bg-bg-card">
                <div
                  className="w-full h-full bg-cover bg-center hover:scale-105 transition-transform duration-700"
                  style={{
                    backgroundImage: `url(/api/images/${product.main_image})`,
                  }}
                />
              </div>
              <h3 className="mt-4 text-xs tracking-wider text-text-muted">
                PROJECT NO.{product.id}
              </h3>
              <h2 className="text-lg md:text-xl font-light text-text-primary">
                {product.name}
              </h2>
            </div>
          </Link>
        ))}
      </div>
      <div className="text-right mt-12">
        <Link
          href="/projects"
          className="text-2xl md:text-3xl font-light text-text-muted hover:text-text-primary transition-colors"
        >
          More →
        </Link>
      </div>
    </section>
  );
}

/* ─────────────────── Main Component ───────────────────── */
export default function LilsquareHome({
  products,
  featured,
}: LilsquareHomeProps) {
  const project1 = featured[0] ?? products[0];
  const project2 = featured[1] ?? products[1];
  const fullscreenProject = featured[2] ?? products[2];
  const scrollRef = useRef<HTMLDivElement>(null);

  if (products.length === 0) {
    return <div className="h-screen flex items-center justify-center text-text-muted">No projects found</div>;
  }

  return (
    <div ref={scrollRef}>
      <HeroSection products={products} />
      <IntroSection project1={project1} project2={project2} />
      {fullscreenProject && (
        <FullscreenProject product={fullscreenProject} />
      )}
      <ProjectGrid products={products} />
    </div>
  );
}
