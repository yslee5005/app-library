"use client";

import Link from "next/link";
import { useState } from "react";
import { useScrollReveal } from "@/hooks/useScrollReveal";

const REVEAL_STYLE = {
  transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
};

/* ───────────────── Mock Data ───────────────── */
const MOCK_REVIEWS = [
  {
    id: 1,
    rating: 5,
    text: "처음부터 끝까지 소통이 정말 좋았습니다. 디자인 시안부터 시공 완료까지 매 단계마다 꼼꼼하게 설명해주셔서 불안한 마음 없이 진행할 수 있었어요. 결과물도 기대 이상이었습니다.",
    author: "김O현",
    project: "잠실 리센츠",
    date: "2025.12",
  },
  {
    id: 2,
    rating: 5,
    text: "기대 이상의 결과물이었습니다. 특히 조명 설계가 공간의 분위기를 완전히 바꿔놨어요. 친구들이 집에 오면 호텔 같다고 할 정도로 만족스럽습니다.",
    author: "이O수",
    project: "분당 센트럴타운",
    date: "2025.11",
  },
  {
    id: 3,
    rating: 5,
    text: "2베이 구조라 걱정이 많았는데, 공간 활용을 정말 잘 해주셨어요. 수납 공간도 넉넉하고 동선도 편해서 매일 감탄하고 있습니다.",
    author: "박O영",
    project: "서현 래미안",
    date: "2025.09",
  },
  {
    id: 4,
    rating: 5,
    text: "마감재 선정 과정이 인상적이었습니다. 단순히 비싼 자재가 아니라 공간에 어울리는 자재를 추천해주셔서 통일감 있는 인테리어가 완성됐어요.",
    author: "최O진",
    project: "야탑 두산위브",
    date: "2025.08",
  },
  {
    id: 5,
    rating: 5,
    text: "시공 기간 동안 현장 관리가 정말 철저했습니다. 매일 사진으로 진행 상황을 보내주시고, 변경 사항도 즉시 반영해주셔서 신뢰가 갔습니다.",
    author: "정O미",
    project: "정자 아이파크",
    date: "2025.07",
  },
  {
    id: 6,
    rating: 5,
    text: "상업 공간 인테리어를 맡겼는데, 브랜드 아이덴티티를 완벽하게 이해하고 공간에 녹여주셨어요. 고객들 반응이 확실히 달라졌습니다.",
    author: "한O우",
    project: "강남 코스메틱 매장",
    date: "2025.06",
  },
  {
    id: 7,
    rating: 4,
    text: "디자인 감각이 정말 뛰어납니다. 제가 막연하게 원했던 느낌을 정확히 캐치해서 제안해주셨어요. 다음에도 꼭 다시 의뢰하고 싶습니다.",
    author: "윤O서",
    project: "수내 푸르지오",
    date: "2025.05",
  },
  {
    id: 8,
    rating: 5,
    text: "가격 대비 퀄리티가 정말 좋습니다. 합리적인 예산 안에서 최대한의 결과를 뽑아주셨어요. 주변에 적극 추천하고 있습니다.",
    author: "송O빈",
    project: "판교 알파리움",
    date: "2025.04",
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
          Client Reviews
        </p>
        <h1
          className="text-white text-[10vw] md:text-[5vw] lg:text-[4vw] font-light tracking-[0.3em] opacity-0 animate-heroTitle"
          style={{
            fontFamily: "'Inter', sans-serif",
            animationDelay: "0.5s",
          }}
        >
          REVIEWS
        </h1>
        <p
          className="text-text-secondary text-sm md:text-base tracking-wider mt-4 opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.8s" }}
        >
          168건의 고객 후기
        </p>
      </div>
    </section>
  );
}

/* ───────────────── Stats Bar ───────────────── */
function StatsBar() {
  const { ref, visible } = useScrollReveal(0.2);

  const stats = [
    { value: "4.9", label: "평균 평점" },
    { value: "168", label: "총 후기" },
    { value: "42%", label: "재시공률" },
  ];

  return (
    <section
      ref={ref}
      className="py-12 md:py-16 border-y border-border bg-bg-secondary"
    >
      <div
        className={`max-w-4xl mx-auto grid grid-cols-3 gap-6 px-6 transition-all duration-1000 ${
          visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[30px]"
        }`}
        style={REVEAL_STYLE}
      >
        {stats.map((stat) => (
          <div key={stat.label} className="text-center">
            <p className="text-gold text-3xl md:text-5xl font-light tracking-wider">
              {stat.value}
            </p>
            <p className="text-text-muted text-xs md:text-sm tracking-[0.15em] mt-2">
              {stat.label}
            </p>
          </div>
        ))}
      </div>
    </section>
  );
}

/* ───────────────── Review Card ───────────────── */
function ReviewCard({
  review,
  index,
  visible,
}: {
  review: (typeof MOCK_REVIEWS)[0];
  index: number;
  visible: boolean;
}) {
  const [expanded, setExpanded] = useState(false);

  const stars = Array.from({ length: 5 }, (_, i) => (
    <span
      key={i}
      className={i < review.rating ? "text-gold" : "text-text-muted"}
    >
      ★
    </span>
  ));

  return (
    <div
      className={`bg-[#f8f7f5] p-6 md:p-8 transition-all duration-700 ${
        visible
          ? "opacity-100 translate-y-0"
          : "opacity-0 translate-y-[50px]"
      }`}
      style={{
        ...REVEAL_STYLE,
        transitionDelay: `${(index % 4) * 0.12}s`,
      }}
    >
      {/* Stars */}
      <div className="flex gap-1 text-lg">{stars}</div>

      {/* Text */}
      <p
        className={`text-gray-700 text-sm md:text-base leading-relaxed mt-4 ${
          !expanded ? "line-clamp-3" : ""
        }`}
      >
        {review.text}
      </p>
      {review.text.length > 80 && (
        <button
          onClick={() => setExpanded(!expanded)}
          className="text-gold-dark text-xs tracking-wider mt-2 hover:text-gold transition-colors"
        >
          {expanded ? "접기" : "더 보기"}
        </button>
      )}

      {/* Author info */}
      <div className="mt-5 pt-4 border-t border-gray-200 flex items-center gap-3">
        {/* Avatar placeholder */}
        <div className="w-10 h-10 rounded-full bg-gray-300 flex items-center justify-center text-gray-500 text-xs font-bold">
          {review.author.charAt(0)}
        </div>
        <div>
          <p className="text-gray-800 text-sm font-medium">{review.author}</p>
          <p className="text-gray-400 text-xs">
            {review.project} · {review.date}
          </p>
        </div>
      </div>
    </div>
  );
}

/* ───────────────── Review Grid ───────────────── */
function ReviewGrid() {
  const { ref, visible } = useScrollReveal(0.05);

  return (
    <section
      ref={ref}
      className="py-16 md:py-24 px-6 md:px-10 max-w-5xl mx-auto"
    >
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8">
        {MOCK_REVIEWS.map((review, i) => (
          <ReviewCard
            key={review.id}
            review={review}
            index={i}
            visible={visible}
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
      className="py-24 md:py-36 px-6 md:px-10 text-center border-t border-border"
    >
      <div
        className={`transition-all duration-1000 ${
          visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[30px]"
        }`}
        style={REVEAL_STYLE}
      >
        <h2 className="font-heading text-2xl md:text-4xl text-text-primary font-light tracking-wider">
          당신의 공간도 바꿔보세요
        </h2>
        <p className="text-text-secondary text-sm font-body mt-4">
          무료 상담을 통해 새로운 공간을 만나보세요.
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
export default function LilsquareReviews() {
  return (
    <div>
      <HeroSection />
      <StatsBar />
      <ReviewGrid />
      <CTASection />
    </div>
  );
}
