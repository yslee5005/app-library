"use client";

import Link from "next/link";
import { useScrollReveal } from "@/hooks/useScrollReveal";

const REVEAL_STYLE = {
  transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
};

/* ───────────────── Mock Data ───────────────── */
const MOCK_PROPOSALS = [
  {
    id: 1,
    project: "여수동 센트럴타운 356",
    location: "경기도 성남시",
    area: "34평",
    budget: "5,000만원~",
    duration: "8주",
    image: "project/layout_design/여수동_센트럴타운_34PY_Design_331/main.jpg",
  },
  {
    id: 2,
    project: "잠실 트리지움",
    location: "서울 송파구",
    area: "33평",
    budget: "6,000만원~",
    duration: "10주",
    image: "project/layout_design/잠실_트리지움_33PY_Design_505/main.png",
  },
  {
    id: 3,
    project: "정자동 상록우성",
    location: "경기도 성남시",
    area: "47평",
    budget: "8,500만원~",
    duration: "12주",
    image: "project/layout_design/정자동_상록우성_47PY_Design_360/main.png",
  },
  {
    id: 4,
    project: "이매동 동부코오롱",
    location: "경기도 성남시",
    area: "46평",
    budget: "7,800만원~",
    duration: "11주",
    image: "project/layout_design/이매동_동부코오롱_46PY_Design_431/main.png",
  },
  {
    id: 5,
    project: "서현 시범한양",
    location: "경기도 성남시",
    area: "47평",
    budget: "8,000만원~",
    duration: "10주",
    image: "project/layout_design/서현_시범한양_47PY_Design_349/main.png",
  },
  {
    id: 6,
    project: "삼성동 파크엘나인 펜트하우스",
    location: "서울 강남구",
    area: "90평",
    budget: "2억~",
    duration: "16주",
    image: "project/layout_design/삼성동_파크엘나인_펜트하우스_90PY_Design_217/main.png",
  },
];

const BUDGET_GUIDE = [
  {
    range: "20평대",
    basic: "3,000~4,000만원",
    premium: "4,000~5,500만원",
    luxury: "5,500만원~",
  },
  {
    range: "30평대",
    basic: "4,500~6,000만원",
    premium: "6,000~8,000만원",
    luxury: "8,000만원~",
  },
  {
    range: "40평대",
    basic: "6,000~8,000만원",
    premium: "8,000~1.2억",
    luxury: "1.2억~",
  },
  {
    range: "50평 이상",
    basic: "8,000만원~1억",
    premium: "1~1.5억",
    luxury: "1.5억~",
  },
];

/* ───────────────── Hero Section ───────────────── */
function HeroSection() {
  return (
    <section className="relative h-[60vh] md:h-[70vh] overflow-hidden bg-bg-primary flex items-center justify-center">
      <div className="absolute inset-0 bg-gradient-to-b from-bg-secondary to-bg-primary" />
      <div className="relative z-10 text-center px-6">
        <p
          className="text-gold text-xs tracking-[0.3em] uppercase mb-6 opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.2s" }}
        >
          Estimate &amp; Proposal
        </p>
        <h1
          className="text-white text-[10vw] md:text-[5vw] lg:text-[4vw] font-light tracking-[0.3em] opacity-0 animate-heroTitle"
          style={{
            fontFamily: "'Inter', sans-serif",
            animationDelay: "0.5s",
          }}
        >
          PROPOSALS
        </h1>
        <p
          className="text-text-secondary text-sm md:text-base tracking-wider mt-4 opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.8s" }}
        >
          공간의 가능성을 제안합니다
        </p>
      </div>
    </section>
  );
}

/* ───────────────── Proposal Card ───────────────── */
function ProposalCard({
  proposal,
  index,
  visible,
}: {
  proposal: (typeof MOCK_PROPOSALS)[0];
  index: number;
  visible: boolean;
}) {
  return (
    <div
      className={`group bg-[#f8f7f5] overflow-hidden transition-all duration-700 hover:scale-[1.02] hover:shadow-xl ${
        visible
          ? "opacity-100 translate-y-0"
          : "opacity-0 translate-y-[50px]"
      }`}
      style={{
        ...REVEAL_STYLE,
        transitionDelay: `${(index % 4) * 0.12}s`,
      }}
    >
      {/* Image */}
      <div className="aspect-[4/3] overflow-hidden">
        <div
          className="w-full h-full bg-cover bg-center transition-transform duration-700 group-hover:scale-110"
          style={{
            backgroundImage: `url(/api/images/${proposal.image})`,
          }}
        />
      </div>

      {/* Content */}
      <div className="p-6">
        <h3 className="text-gray-900 text-lg font-medium tracking-wide">
          {proposal.project}
        </h3>
        <p className="text-gray-500 text-sm mt-1">{proposal.location}</p>

        <div className="mt-4 grid grid-cols-3 gap-3">
          <div>
            <p className="text-gray-400 text-[10px] tracking-wider uppercase">
              평형
            </p>
            <p className="text-gray-700 text-sm font-medium mt-0.5">
              {proposal.area}
            </p>
          </div>
          <div>
            <p className="text-gray-400 text-[10px] tracking-wider uppercase">
              예산
            </p>
            <p className="text-gray-700 text-sm font-medium mt-0.5">
              {proposal.budget}
            </p>
          </div>
          <div>
            <p className="text-gray-400 text-[10px] tracking-wider uppercase">
              기간
            </p>
            <p className="text-gray-700 text-sm font-medium mt-0.5">
              {proposal.duration}
            </p>
          </div>
        </div>

        <Link
          href="/lilsquare/contact"
          className="inline-block mt-5 text-gold-dark text-xs tracking-[0.15em] border-b border-gold-dark/40 pb-0.5 hover:border-gold-dark transition-colors duration-300"
        >
          자세히 보기 &rarr;
        </Link>
      </div>
    </div>
  );
}

/* ───────────────── Proposal Grid ───────────────── */
function ProposalGrid() {
  const { ref, visible } = useScrollReveal(0.05);

  return (
    <section
      ref={ref}
      className="py-16 md:py-24 px-6 md:px-10 max-w-5xl mx-auto"
    >
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8">
        {MOCK_PROPOSALS.map((proposal, i) => (
          <ProposalCard
            key={proposal.id}
            proposal={proposal}
            index={i}
            visible={visible}
          />
        ))}
      </div>
    </section>
  );
}

/* ───────────────── Budget Guide ───────────────── */
function BudgetGuide() {
  const { ref, visible } = useScrollReveal(0.15);

  return (
    <section
      ref={ref}
      className="py-20 md:py-28 px-6 md:px-10 bg-bg-secondary"
    >
      <div
        className={`max-w-4xl mx-auto transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[40px]"
        }`}
        style={REVEAL_STYLE}
      >
        <h2 className="text-center text-2xl md:text-3xl font-light tracking-wider text-text-primary mb-3">
          예산 가이드
        </h2>
        <p className="text-center text-text-muted text-sm mb-12">
          평형별 예상 인테리어 비용 안내
        </p>

        {/* Table — desktop */}
        <div className="hidden md:block overflow-hidden border border-border">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-bg-card">
                <th className="text-left text-text-muted text-xs tracking-[0.15em] uppercase p-4 border-b border-border">
                  평형
                </th>
                <th className="text-center text-text-muted text-xs tracking-[0.15em] uppercase p-4 border-b border-border">
                  Basic
                </th>
                <th className="text-center text-text-muted text-xs tracking-[0.15em] uppercase p-4 border-b border-border">
                  Premium
                </th>
                <th className="text-center text-gold text-xs tracking-[0.15em] uppercase p-4 border-b border-border">
                  Luxury
                </th>
              </tr>
            </thead>
            <tbody>
              {BUDGET_GUIDE.map((row) => (
                <tr key={row.range} className="border-b border-border last:border-b-0">
                  <td className="p-4 text-text-primary font-medium">
                    {row.range}
                  </td>
                  <td className="p-4 text-center text-text-secondary">
                    {row.basic}
                  </td>
                  <td className="p-4 text-center text-text-secondary">
                    {row.premium}
                  </td>
                  <td className="p-4 text-center text-gold font-medium">
                    {row.luxury}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Cards — mobile */}
        <div className="md:hidden grid grid-cols-1 gap-4">
          {BUDGET_GUIDE.map((row) => (
            <div
              key={row.range}
              className="bg-bg-card border border-border p-5"
            >
              <p className="text-gold text-xs tracking-[0.2em] uppercase mb-3">
                {row.range}
              </p>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-text-muted">Basic</span>
                  <span className="text-text-secondary">{row.basic}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-text-muted">Premium</span>
                  <span className="text-text-secondary">{row.premium}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-text-muted">Luxury</span>
                  <span className="text-gold font-medium">{row.luxury}</span>
                </div>
              </div>
            </div>
          ))}
        </div>

        <p className="text-text-muted text-xs text-center mt-6">
          * 위 금액은 참고용이며, 정확한 견적은 현장 방문 후 안내드립니다.
        </p>
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
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[30px]"
        }`}
        style={REVEAL_STYLE}
      >
        <h2 className="font-heading text-2xl md:text-4xl text-text-primary font-light tracking-wider">
          맞춤 견적 받기
        </h2>
        <p className="text-text-secondary text-sm font-body mt-4">
          무료 상담을 통해 정확한 견적을 안내드립니다.
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
export default function LilsquareProposals() {
  return (
    <div>
      <HeroSection />
      <ProposalGrid />
      <BudgetGuide />
      <CTASection />
    </div>
  );
}
