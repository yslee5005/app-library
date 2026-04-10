"use client";

import { useRef, useState, useEffect } from "react";
import Link from "next/link";
import type { Product } from "@/lib/data";
import ImageCrossfade from "../ImageCrossfade";
import { useScrollReveal } from "@/hooks/useScrollReveal";

interface LilsquareAboutProps {
  featured: Product[];
}

/* ───────────────── Counter (카운트업) ───────────────── */
function Counter({
  target,
  suffix,
  label,
}: {
  target: number;
  suffix: string;
  label: string;
}) {
  const [count, setCount] = useState(0);
  const ref = useRef<HTMLDivElement>(null);
  const started = useRef(false);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting && !started.current) {
          started.current = true;
          const duration = 2000;
          const start = performance.now();
          const animate = (now: number) => {
            const progress = Math.min((now - start) / duration, 1);
            const eased = 1 - Math.pow(1 - progress, 3);
            setCount(Math.floor(eased * target));
            if (progress < 1) requestAnimationFrame(animate);
          };
          requestAnimationFrame(animate);
        }
      },
      { threshold: 0.5 },
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, [target]);

  return (
    <div ref={ref} className="text-center">
      <p className="font-heading text-5xl md:text-7xl text-gold font-light">
        {count}
        {suffix}
      </p>
      <p className="text-text-muted text-sm tracking-[0.15em] uppercase font-body mt-3">
        {label}
      </p>
    </div>
  );
}

/* ───────────────── Hero Section ───────────────── */
function HeroSection({ product }: { product: Product }) {
  return (
    <section className="relative h-screen overflow-hidden">
      <div
        className="absolute inset-0 bg-cover bg-center animate-kenburns"
        style={{
          backgroundImage: `url(/api/images/${product.main_image})`,
        }}
      />
      <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/30 to-black/50" />
      <div className="absolute inset-0 flex items-center justify-center z-10">
        <div className="text-center px-6">
          <h1
            className="text-white text-[8vw] md:text-[4vw] font-light tracking-[0.3em] opacity-0 animate-heroTitle"
            style={{ animationDelay: "0.3s" }}
          >
            ABOUT
          </h1>
          <p
            className="text-white/80 text-lg md:text-2xl font-light tracking-[0.15em] mt-4 opacity-0 animate-heroTitle"
            style={{ animationDelay: "0.7s" }}
          >
            Residential Space Design Studio
          </p>
        </div>
      </div>
    </section>
  );
}

/* ───────────────── Intro Section (3열) ───────────────── */
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
          <h2 className="text-3xl md:text-4xl font-light tracking-wider text-text-primary">
            Residential Space
            <br />
            Design Studio
          </h2>
          <p className="mt-8 text-text-secondary leading-[1.8] text-sm">
            공간과 사용자 사이에는 보이지 않는 수많은 이야기가 혼재합니다.
            블랙라벨드는 그 이야기를 읽어내고, 설계를 통해 공간에 생명을
            부여합니다. 427개 이상의 프로젝트를 통해 쌓아온 경험으로, 당신만의
            공간을 블랙라벨로 만들어 드립니다.
          </p>
          <Link
            href="/lilsquare/projects"
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

/* ───────────────── Philosophy Section ───────────────── */
function PhilosophySection({ product }: { product: Product }) {
  const sectionRef = useRef<HTMLElement>(null);
  const [offset, setOffset] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      const el = sectionRef.current;
      if (!el) return;
      const rect = el.getBoundingClientRect();
      const progress = -rect.top / el.offsetHeight;
      setOffset(progress * 60);
    };
    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const { ref, visible } = useScrollReveal(0.2);

  return (
    <section
      ref={(node) => {
        sectionRef.current = node;
        (ref as React.MutableRefObject<HTMLElement | null>).current = node;
      }}
      className="relative h-screen overflow-hidden"
    >
      <div
        className="absolute inset-0 bg-cover bg-center will-change-transform"
        style={{
          backgroundImage: `url(/api/images/${product.main_image})`,
          transform: `translateY(${offset}px) scale(1.1)`,
        }}
      />
      <div className="absolute inset-0 bg-black/60" />
      <div
        className={`absolute inset-0 flex items-center justify-center z-10 px-6 transition-all duration-1000 ${
          visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[30px]"
        }`}
        style={{
          transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
        }}
      >
        <blockquote className="max-w-3xl text-center">
          <p className="text-white text-xl md:text-3xl lg:text-4xl font-light italic leading-relaxed tracking-wide">
            &ldquo;공백은 채우기 위한 공간이 아니라,
            <br className="hidden md:block" />
            삶이 숨 쉴 수 있도록 비워둔 여백입니다.&rdquo;
          </p>
          <footer className="mt-8 text-gold text-sm tracking-[0.2em] uppercase">
            — BLACKLABELLED Design Philosophy
          </footer>
        </blockquote>
      </div>
    </section>
  );
}

/* ───────────────── Stats Section ───────────────── */
function StatsSection() {
  const { ref, visible } = useScrollReveal(0.2);

  return (
    <section
      ref={ref}
      className="py-24 md:py-36 px-6 md:px-10 bg-bg-secondary"
    >
      <div
        className={`max-w-5xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-16 md:gap-8 transition-all duration-1000 ${
          visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[40px]"
        }`}
        style={{
          transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
        }}
      >
        <Counter target={427} suffix="+" label="Projects Completed" />
        <Counter target={15} suffix="+" label="Years of Experience" />
        <Counter target={98} suffix="%" label="Client Satisfaction" />
      </div>
    </section>
  );
}

/* ───────────────── Team Section ───────────────── */
function TeamSection() {
  const { ref, visible } = useScrollReveal(0.15);

  return (
    <section
      ref={ref}
      className="py-20 md:py-32 px-6 md:px-[60px]"
    >
      <div
        className={`max-w-4xl mx-auto transition-all duration-1000 ${
          visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[40px]"
        }`}
        style={{
          transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
        }}
      >
        <h2 className="text-center text-3xl md:text-4xl font-light tracking-wider text-text-primary mb-16">
          TEAM
        </h2>
        <div className="flex flex-col md:flex-row items-center md:items-start gap-10 md:gap-16">
          {/* Photo placeholder */}
          <div className="w-48 h-48 md:w-56 md:h-56 rounded-full bg-bg-card border border-border flex items-center justify-center shrink-0">
            <span className="text-text-muted text-5xl font-light">B</span>
          </div>
          {/* Info */}
          <div className="text-center md:text-left">
            <p className="text-gold text-xs tracking-[0.2em] uppercase font-body">
              대표 디자이너
            </p>
            <h3 className="font-heading text-2xl md:text-3xl text-text-primary font-light tracking-wider mt-2">
              BLACKLABELLED
            </h3>
            <p className="text-text-secondary text-sm leading-[1.8] font-body mt-6 max-w-lg">
              &ldquo;Your space is black label&rdquo; — 10년 이상의 경험을 바탕으로
              주거 공간 설계의 본질을 탐구합니다. 도면 위의 한 줄이 현실의 공간이
              되기까지, 디자인과 시공 전 과정을 직접 책임지며, 고객의 삶에 가장
              어울리는 블랙라벨 공간을 만들어갑니다.
            </p>
            <div className="mt-8 flex flex-wrap gap-6 justify-center md:justify-start">
              <div>
                <p className="text-text-muted text-xs tracking-[0.15em] uppercase">
                  전화
                </p>
                <p className="text-text-primary text-sm mt-1">010-9887-2826(TR)</p>
              </div>
              <div>
                <p className="text-text-muted text-xs tracking-[0.15em] uppercase">
                  이메일
                </p>
                <p className="text-text-primary text-sm mt-1">
                  blacklabelled@naver.com
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

/* ───────────────── Main Component ───────────────── */
export default function LilsquareAbout({ featured }: LilsquareAboutProps) {
  const heroProduct = featured[0];
  const project1 = featured[0];
  const project2 = featured[1];
  const philosophyProduct = featured[2] ?? featured[0];

  if (!heroProduct || !project1 || !project2) {
    return (
      <div className="h-screen flex items-center justify-center text-text-muted">
        No projects found
      </div>
    );
  }

  return (
    <div>
      <HeroSection product={heroProduct} />
      <IntroSection project1={project1} project2={project2} />
      <PhilosophySection product={philosophyProduct} />
      <StatsSection />
      <TeamSection />
    </div>
  );
}
