"use client";

import { useRef, useState, useEffect } from "react";
import Link from "next/link";
import type { Product } from "@/lib/data";
import { useScrollReveal } from "@/hooks/useScrollReveal";

interface LilsquareServicesProps {
  featured: Product[];
}

const REVEAL_STYLE = {
  transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
};

/* ───────────────── Service Categories Data ───────────────── */
const SERVICE_CATEGORIES = [
  {
    title: "주거 공간",
    subtitle: "Residential",
    description: "아파트, 빌라, 주택 — 일상을 담는 공간에 건축적 미학을 더합니다.",
  },
  {
    title: "상업 공간",
    subtitle: "Commercial",
    description: "사무실, 매장, 카페 — 브랜드의 정체성을 공간으로 구현합니다.",
  },
  {
    title: "부티크",
    subtitle: "Boutiques",
    description: "고급 매장, 쇼룸 — 극도의 절제미로 럭셔리를 설계합니다.",
  },
  {
    title: "코스메틱",
    subtitle: "Cosmetics",
    description: "뷰티 샵, 클리닉 — 청결과 감각이 공존하는 공간을 만듭니다.",
  },
];

/* ───────────────── Process Steps Data ───────────────── */
const PROCESS_STEPS = [
  {
    number: "01",
    title: "상담",
    description: "고객의 라이프스타일과 요구사항을 깊이 이해합니다.",
    icon: (
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
      </svg>
    ),
  },
  {
    number: "02",
    title: "설계",
    description: "정밀한 도면과 3D 렌더링으로 공간을 설계합니다.",
    icon: (
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" />
        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" />
      </svg>
    ),
  },
  {
    number: "03",
    title: "시공",
    description: "검증된 팀이 설계 의도를 정확하게 구현합니다.",
    icon: (
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
        <rect x="2" y="6" width="20" height="12" rx="2" />
        <path d="M12 12h.01" />
        <path d="M17 12h.01" />
        <path d="M7 12h.01" />
      </svg>
    ),
  },
  {
    number: "04",
    title: "입주",
    description: "최종 점검과 스타일링으로 공간을 완성합니다.",
    icon: (
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
        <polyline points="9 22 9 12 15 12 15 22" />
      </svg>
    ),
  },
];

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
            SERVICES
          </h1>
          <p
            className="text-white/80 text-lg md:text-2xl font-light tracking-[0.15em] mt-4 opacity-0 animate-heroTitle"
            style={{ animationDelay: "0.7s" }}
          >
            Interior Design &amp; Architecture
          </p>
        </div>
      </div>
    </section>
  );
}

/* ───────────────── Quote Section ───────────────── */
function QuoteSection() {
  const { ref, visible } = useScrollReveal(0.2);

  return (
    <section
      ref={ref}
      className="py-24 md:py-36 px-6 md:px-10"
    >
      <div
        className={`max-w-4xl mx-auto text-center transition-all duration-1000 ${
          visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[30px]"
        }`}
        style={REVEAL_STYLE}
      >
        <p className="text-text-primary text-xl md:text-3xl lg:text-4xl font-light italic leading-relaxed tracking-wide">
          &ldquo;단순한 인테리어를 넘어,
          <br className="hidden md:block" />
          건축적 미학과 극도의 절제미를 담은
          <br className="hidden md:block" />
          공간을 설계합니다.&rdquo;
        </p>
      </div>
    </section>
  );
}

/* ───────────────── Service Card ───────────────── */
function ServiceCard({
  category,
  product,
  index,
}: {
  category: (typeof SERVICE_CATEGORIES)[0];
  product?: Product;
  index: number;
}) {
  const { ref, visible } = useScrollReveal(0.15);

  return (
    <div
      ref={ref as React.RefObject<HTMLDivElement | null>}
      className={`group relative overflow-hidden cursor-pointer transition-all duration-1000 ${
        visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[50px]"
      }`}
      style={{
        ...REVEAL_STYLE,
        transitionDelay: `${index * 0.15}s`,
      }}
    >
      {/* Image */}
      <div className="aspect-[4/5] overflow-hidden bg-bg-card">
        {product ? (
          <div
            className="w-full h-full bg-cover bg-center transition-transform duration-700 group-hover:scale-110"
            style={{
              backgroundImage: `url(/api/images/${product.main_image})`,
            }}
          />
        ) : (
          <div className="w-full h-full bg-bg-card flex items-center justify-center">
            <span className="text-gold text-4xl font-light tracking-wider">
              {category.subtitle}
            </span>
          </div>
        )}
      </div>

      {/* Hover overlay */}
      <div className="absolute inset-0 bg-black/0 group-hover:bg-black/60 transition-all duration-500 flex items-center justify-center">
        <div className="opacity-0 group-hover:opacity-100 translate-y-4 group-hover:translate-y-0 transition-all duration-500 text-center px-6">
          <p className="text-gold text-xs tracking-[0.3em] uppercase">
            {category.subtitle}
          </p>
          <h3 className="text-white text-2xl md:text-3xl font-light tracking-wider mt-2">
            {category.title}
          </h3>
          <p className="text-white/80 text-sm mt-3 leading-relaxed max-w-xs mx-auto">
            {category.description}
          </p>
        </div>
      </div>

      {/* Bottom label (always visible) */}
      <div className="absolute bottom-0 left-0 right-0 p-5 bg-gradient-to-t from-black/80 to-transparent group-hover:opacity-0 transition-opacity duration-500">
        <p className="text-gold text-[10px] tracking-[0.3em] uppercase">
          {category.subtitle}
        </p>
        <h3 className="text-white text-lg font-light tracking-wider mt-1">
          {category.title}
        </h3>
      </div>
    </div>
  );
}

/* ───────────────── Categories Section ───────────────── */
function CategoriesSection({ products }: { products: Product[] }) {
  return (
    <section className="py-10 md:py-20 px-6 md:px-[60px]">
      <div className="max-w-6xl mx-auto grid grid-cols-1 sm:grid-cols-2 gap-6 md:gap-8">
        {SERVICE_CATEGORIES.map((cat, i) => (
          <ServiceCard
            key={cat.subtitle}
            category={cat}
            product={products[i]}
            index={i}
          />
        ))}
      </div>
    </section>
  );
}

/* ───────────────── Process Summary Section ───────────────── */
function ProcessSection() {
  const { ref, visible } = useScrollReveal(0.15);

  return (
    <section
      ref={ref}
      className="py-24 md:py-36 px-6 md:px-10 bg-bg-secondary"
    >
      <div
        className={`max-w-5xl mx-auto transition-all duration-1000 ${
          visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[40px]"
        }`}
        style={REVEAL_STYLE}
      >
        <h2 className="text-center text-3xl md:text-4xl font-light tracking-wider text-text-primary mb-16">
          PROCESS
        </h2>

        {/* Horizontal timeline */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 md:gap-4 relative">
          {/* Connecting line (desktop only) */}
          <div className="hidden md:block absolute top-[28px] left-[12%] right-[12%] h-[1px] bg-border" />

          {PROCESS_STEPS.map((step, i) => (
            <div key={step.number} className="relative text-center">
              {/* Icon circle */}
              <div className="w-14 h-14 mx-auto rounded-full border border-gold/40 flex items-center justify-center text-gold bg-bg-secondary relative z-10">
                {step.icon}
              </div>

              {/* Number */}
              <p className="text-gold text-xs tracking-[0.3em] mt-5">
                {step.number}
              </p>

              {/* Title */}
              <h3 className="text-text-primary text-lg font-light tracking-wider mt-2">
                {step.title}
              </h3>

              {/* Description */}
              <p className="text-text-muted text-xs leading-relaxed mt-2 max-w-[180px] mx-auto">
                {step.description}
              </p>
            </div>
          ))}
        </div>

        {/* Link to process page */}
        <div className="text-center mt-14">
          <Link
            href="/lilsquare/process"
            className="inline-block text-gold text-sm tracking-[0.15em] border-b border-gold/40 pb-1 hover:border-gold transition-colors duration-300"
          >
            자세히 보기 &rarr;
          </Link>
        </div>
      </div>
    </section>
  );
}

/* ───────────────── CTA Section ───────────────── */
function CTASection() {
  const { ref, visible } = useScrollReveal(0.2);

  return (
    <section
      ref={ref}
      className="py-24 md:py-36 px-6 md:px-10 text-center border-t border-border"
    >
      <div
        className={`transition-all duration-1000 ${
          visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[30px]"
        }`}
        style={REVEAL_STYLE}
      >
        <h2 className="font-heading text-2xl md:text-4xl text-text-primary font-light tracking-wider">
          프로젝트를 시작하세요
        </h2>
        <p className="text-text-secondary text-sm font-body mt-4">
          무료 상담을 통해 당신의 공간을 블랙라벨로 만들어 드립니다.
        </p>
        <div className="mt-10">
          <Link
            href="/lilsquare/contact"
            className="inline-block bg-gold text-bg-primary px-10 py-4 text-sm tracking-[0.2em] uppercase font-body font-medium hover:bg-gold-light transition-colors duration-300"
          >
            상담 신청하기
          </Link>
        </div>
      </div>
    </section>
  );
}

/* ───────────────── Main Component ───────────────── */
export default function LilsquareServices({ featured }: LilsquareServicesProps) {
  const heroProduct = featured[0];

  if (!heroProduct) {
    return (
      <div className="h-screen flex items-center justify-center text-text-muted">
        No projects found
      </div>
    );
  }

  return (
    <div>
      <HeroSection product={heroProduct} />
      <QuoteSection />
      <CategoriesSection products={featured.slice(1, 5)} />
      <ProcessSection />
      <CTASection />
    </div>
  );
}
