"use client";

import Link from "next/link";
import type { Product } from "@/lib/data";
import { useScrollReveal } from "@/hooks/useScrollReveal";

interface LilsquareProcessProps {
  featured: Product[];
}

const STEPS = [
  {
    number: "01",
    title: "상담 및 현장방문",
    description:
      "고객의 라이프스타일과 취향을 깊이 이해하는 것에서 시작합니다. 현장을 직접 방문하여 공간의 구조, 채광, 동선을 꼼꼼히 파악하고, 최적의 디자인 방향을 함께 찾아갑니다.",
    detail: "무료 상담 · 현장 실측 · 요구사항 분석",
  },
  {
    number: "02",
    title: "설계 및 디자인",
    description:
      "정밀한 실측을 바탕으로 공간의 가능성을 극대화합니다. 동선, 수납, 조명 — 삶의 모든 디테일을 도면 위에 담아내고, 사실적인 3D 렌더링으로 완성될 공간을 미리 경험합니다.",
    detail: "평면 설계 · 3D 렌더링 · 자재 선정",
  },
  {
    number: "03",
    title: "시공",
    description:
      "검증된 시공팀이 설계의 의도를 정확하게 구현합니다. 자재 선정부터 마감까지, 모든 과정을 직접 관리하고 품질을 보증합니다. 공정별 진행 상황을 투명하게 공유합니다.",
    detail: "철거 · 목공 · 전기 · 타일 · 도배 · 마감",
  },
  {
    number: "04",
    title: "마감 및 입주",
    description:
      "최종 점검과 스타일링으로 공간에 생명을 불어넣습니다. 도면 위의 설계가 현실의 블랙라벨 공간으로 완성되는 순간, 당신의 새로운 일상이 시작됩니다.",
    detail: "최종 점검 · 클리닝 · 스타일링 · 입주",
  },
];

/* ───────────────── Hero Section ───────────────── */
function HeroSection() {
  return (
    <section className="relative pt-40 pb-20 md:pt-52 md:pb-32 px-6 md:px-10 text-center overflow-hidden">
      <div className="absolute inset-0 bg-bg-primary" />
      <div className="relative z-10">
        <h1
          className="font-heading text-5xl md:text-[80px] text-text-primary font-light tracking-[0.3em] opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.2s" }}
        >
          PROCESS
        </h1>
        <p
          className="text-text-muted text-sm md:text-base tracking-wider font-body mt-4 opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.5s" }}
        >
          설계에서 현실까지, 블랙라벨드의 프로세스
        </p>
      </div>
    </section>
  );
}

/* ───────────────── Timeline Step ───────────────── */
function TimelineStep({
  step,
  index,
  product,
}: {
  step: (typeof STEPS)[0];
  index: number;
  product?: Product;
}) {
  const { ref, visible } = useScrollReveal(0.15);
  const isEven = index % 2 === 0;

  return (
    <div
      ref={ref as React.RefObject<HTMLDivElement | null>}
      className={`relative flex flex-col md:flex-row items-center gap-8 md:gap-0 mb-24 last:mb-0 ${
        visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[50px]"
      } transition-all duration-1000`}
      style={{
        transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
        transitionDelay: `${index * 0.1}s`,
      }}
    >
      {/* Center dot on timeline */}
      <div className="hidden md:block absolute left-1/2 -translate-x-1/2 z-10">
        <div className="w-4 h-4 rounded-full bg-gold border-[3px] border-bg-primary" />
      </div>

      {/* Image side */}
      <div
        className={`w-full md:w-1/2 ${
          isEven ? "md:order-1 md:pr-16" : "md:order-2 md:pl-16"
        }`}
      >
        {product ? (
          <div className="aspect-[4/3] overflow-hidden bg-bg-card">
            <div
              className="w-full h-full bg-cover bg-center hover:scale-105 transition-transform duration-700"
              style={{
                backgroundImage: `url(/api/images/${product.main_image})`,
              }}
            />
          </div>
        ) : (
          <div className="aspect-[4/3] bg-bg-card flex items-center justify-center">
            <span className="text-gold text-6xl font-light">{step.number}</span>
          </div>
        )}
      </div>

      {/* Text side */}
      <div
        className={`w-full md:w-1/2 ${
          isEven
            ? "md:order-2 md:pl-16"
            : "md:order-1 md:pr-16 md:text-right"
        }`}
      >
        <span className="text-gold text-xs tracking-[0.3em] font-body uppercase">
          Step {step.number}
        </span>
        <h3 className="font-heading text-2xl md:text-3xl text-text-primary font-light tracking-wider mt-3">
          {step.title}
        </h3>
        <p className="text-text-secondary text-sm leading-[1.8] font-body mt-4">
          {step.description}
        </p>
        <p className="text-text-muted text-xs tracking-[0.15em] font-body mt-4">
          {step.detail}
        </p>
      </div>
    </div>
  );
}

/* ───────────────── Timeline Section ───────────────── */
function TimelineSection({ products }: { products: Product[] }) {
  return (
    <section className="py-10 md:py-20 px-6 md:px-[60px]">
      <div className="max-w-5xl mx-auto relative">
        {/* Vertical timeline line (desktop only) */}
        <div className="hidden md:block absolute left-1/2 top-0 bottom-0 w-[1px] bg-border -translate-x-[0.5px]" />

        {STEPS.map((step, i) => (
          <TimelineStep
            key={step.number}
            step={step}
            index={i}
            product={products[i]}
          />
        ))}
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
      className="py-24 md:py-36 px-6 md:px-10 text-center border-t border-border bg-bg-secondary"
    >
      <div
        className={`transition-all duration-1000 ${
          visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[30px]"
        }`}
        style={{
          transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
        }}
      >
        <h2 className="font-heading text-2xl md:text-4xl text-text-primary font-light tracking-wider">
          프로젝트를 시작할 준비가 되셨나요?
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
export default function LilsquareProcess({ featured }: LilsquareProcessProps) {
  return (
    <div>
      <HeroSection />
      <TimelineSection products={featured} />
      <CTASection />
    </div>
  );
}
