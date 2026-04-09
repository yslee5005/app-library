"use client";

import { useScrollReveal } from "@/hooks/useScrollReveal";

const REVEAL_STYLE = {
  transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
};

/* ───────────────── Mock Data ───────────────── */
const MOCK_EPISODES = [
  {
    id: 1,
    number: "01",
    title: "빛이 만드는 공간의 온도",
    subtitle:
      "여수동 센트럴타운 시공 비하인드. 남향의 풍부한 자연광을 살리면서도 눈부심을 제어하는 조명 설계 과정을 담았습니다.",
    date: "2025.10",
    image: "/api/images/products/59/59_01.jpg",
  },
  {
    id: 2,
    number: "02",
    title: "대리석, 자연을 담다",
    subtitle:
      "분당 파크뷰 마감재 선정 과정. 이탈리아산 대리석부터 국내산 화강암까지, 공간에 맞는 석재를 찾아가는 여정을 공유합니다.",
    date: "2025.08",
    image: "/api/images/products/58/58_01.jpg",
  },
  {
    id: 3,
    number: "03",
    title: "2bay의 새로운 패러다임",
    subtitle:
      "30평대 2베이의 공간 혁신 이야기. 한정된 구조 안에서 개방감과 수납을 동시에 잡은 설계 비결을 풀어봅니다.",
    date: "2025.06",
    image: "/api/images/products/57/57_01.jpg",
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
          Behind the Scenes
        </p>
        <h1
          className="text-white text-[10vw] md:text-[5vw] lg:text-[4vw] font-light tracking-[0.3em] opacity-0 animate-heroTitle"
          style={{
            fontFamily: "'Inter', sans-serif",
            animationDelay: "0.5s",
          }}
        >
          EPISODES
        </h1>
        <p
          className="text-text-secondary text-sm md:text-base tracking-wider mt-4 opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.8s" }}
        >
          시공의 이면, 디자인의 여정
        </p>
      </div>
    </section>
  );
}

/* ───────────────── Episode Card ───────────────── */
function EpisodeCard({
  episode,
  index,
}: {
  episode: (typeof MOCK_EPISODES)[0];
  index: number;
}) {
  const { ref, visible } = useScrollReveal(0.15);
  const isEven = index % 2 === 1;

  return (
    <article
      ref={ref as React.RefObject<HTMLElement | null>}
      className={`transition-all duration-1000 ${
        visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-[60px]"
      }`}
      style={{
        ...REVEAL_STYLE,
        transitionDelay: `${index * 0.1}s`,
      }}
    >
      <div
        className={`flex flex-col ${
          isEven ? "md:flex-row-reverse" : "md:flex-row"
        } gap-8 md:gap-12 items-center`}
      >
        {/* Image */}
        <div className="w-full md:w-1/2">
          <div className="aspect-[16/9] overflow-hidden bg-bg-card group">
            <div
              className="w-full h-full bg-cover bg-center transition-transform duration-700 group-hover:scale-105"
              style={{ backgroundImage: `url(${episode.image})` }}
            />
          </div>
        </div>

        {/* Text */}
        <div className="w-full md:w-1/2">
          <p className="text-gold text-xs tracking-[0.3em] uppercase">
            EPISODE {episode.number}
          </p>
          <h2 className="text-text-primary text-2xl md:text-3xl lg:text-4xl font-light tracking-wider mt-3 leading-tight">
            {episode.title}
          </h2>
          <p className="text-text-secondary text-sm md:text-base leading-relaxed mt-4">
            {episode.subtitle}
          </p>
          <p className="text-text-muted text-xs tracking-wider mt-6">
            {episode.date}
          </p>
        </div>
      </div>
    </article>
  );
}

/* ───────────────── Episodes List ───────────────── */
function EpisodesList() {
  return (
    <section className="py-16 md:py-24 px-6 md:px-10 max-w-6xl mx-auto">
      <div className="flex flex-col gap-20 md:gap-28">
        {MOCK_EPISODES.map((episode, i) => (
          <EpisodeCard key={episode.id} episode={episode} index={i} />
        ))}
      </div>
    </section>
  );
}

/* ───────────────── Main Component ───────────────── */
export default function LilsquareEpisodes() {
  return (
    <div>
      <HeroSection />
      <EpisodesList />
    </div>
  );
}
