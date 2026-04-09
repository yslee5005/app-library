# PROMPT — Lilsquare 디자인 적용

> Ralph 자율 실행용 프롬프트
> 목표: /lilsquare 라우트에 Lilsquare.com 디자인 + Blacklabelled 데이터 결합

---

## 실행 규칙

1. 각 파일 생성/수정 전 기존 파일 구조 확인
2. Blacklabelled 데이터 (projects, furniture 등) 기존 provider 활용
3. TypeScript 에러 0 확인
4. AGENTS.md 확인 — Next.js 버전 주의

---

## 필수 읽기

- `apps/blacklabelled/web/src/app/layout.tsx` — 레이아웃 구조
- `apps/blacklabelled/web/src/components/ProjectDetail.tsx` — 데이터 구조 참고
- `apps/blacklabelled/web/src/components/HeroSection.tsx` — 기존 Hero
- `apps/blacklabelled/web/src/components/FeaturedProjects.tsx` — 프로젝트 데이터
- `apps/blacklabelled/web/src/components/ProjectCard.tsx` — 카드 구조
- `apps/blacklabelled/web/AGENTS.md` — Next.js 주의사항
- `apps/blacklabelled/web/src/app/globals.css` — 테마 변수

---

## 생성할 파일

### 1. `app/lilsquare/page.tsx` — 라우트 페이지

```tsx
import LilsquareHome from "@/components/LilsquareHome";

export const metadata = {
  title: "BLACKLABELLED | Lilsquare Style",
};

export default function LilsquarePage() {
  return <LilsquareHome />;
}
```

### 2. `components/LilsquareHome.tsx` — 메인 컴포넌트

"use client" 컴포넌트. Blacklabelled 데이터를 가져와서 Lilsquare 디자인으로 렌더링.

구조:
```
<main>
  <HeroSection />        — 풀스크린 이미지 + 순차 fade 타이틀 + EXPLORE circle
  <IntroSection />       — 3열: 텍스트 소개 + 프로젝트 카드 2개 (Swiper fade)
  <FullscreenProject />  — 풀스크린 이미지 + 텍스트 오버레이
  <PlanSection />        — 도면/이미지 비교 섹션
  <ProjectGrid />        — 3열 프로젝트 그리드 + More →
  <Footer />             — 기존 Footer 재사용 가능
</main>
```

---

## 섹션별 구현 상세

### Section 1: Hero — 풀스크린 이미지 + 순차 타이틀

Blacklabelled에는 Vimeo 영상이 없으므로 **첫 번째 featured project의 대표 이미지**를 풀스크린 배경으로 사용.

```tsx
// 풀스크린 배경 이미지
<section className="relative h-screen overflow-hidden">
  {/* 배경 이미지 — Ken Burns subtle zoom */}
  <div
    className="absolute inset-0 bg-cover bg-center animate-slow-zoom"
    style={{ backgroundImage: `url(${firstProject.images[0]})` }}
  />

  {/* 어두운 오버레이 */}
  <div className="absolute inset-0 bg-black/30" />

  {/* 타이틀 — 순차 fade */}
  <div className="absolute inset-0 flex items-center justify-center z-10">
    <h1 className="text-white text-[3vw] font-light tracking-[0.25em] text-center"
        style={{ fontFamily: "'Inter', sans-serif" }}>
      {["Your", "space", "is", "'black", "label'"].map((word, i) => (
        <span
          key={i}
          className="inline-block opacity-0 animate-title-fade"
          style={{ animationDelay: `${0.1 + i * 0.4}s` }}
        >
          {word}{" "}
        </span>
      ))}
    </h1>
  </div>

  {/* EXPLORE 회전 circle */}
  <div className="absolute bottom-[110px] left-1/2 -translate-x-1/2 z-10 text-center">
    <div className="relative">
      {/* 회전하는 원형 텍스트 — SVG */}
      <svg className="w-[200px] h-[200px] animate-spin-slow" viewBox="0 0 200 200">
        <path id="circlePath" d="M100,100 m-80,0 a80,80 0 1,1 160,0 a80,80 0 1,1 -160,0" fill="none" />
        <text className="fill-white text-[11px] tracking-[0.3em] uppercase">
          <textPath href="#circlePath">
            Blacklabelled · Design Studio · Life Makes Sense ·
          </textPath>
        </text>
      </svg>
      {/* 중앙 EXPLORE */}
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="text-white text-sm tracking-[0.2em]">EXPLORE</span>
        <span className="text-white mt-2">↓</span>
      </div>
    </div>
  </div>
</section>
```

CSS 키프레임 (globals.css 또는 인라인 style 태그):
```css
@keyframes title-fade {
  0% { opacity: 0 }
  100% { opacity: 1 }
}
.animate-title-fade {
  animation: title-fade 1s ease forwards;
}

@keyframes slow-zoom {
  0% { transform: scale(1) }
  100% { transform: scale(1.05) }
}
.animate-slow-zoom {
  animation: slow-zoom 8s ease-out forwards;
}

@keyframes spin-slow {
  100% { transform: rotate(360deg) }
}
.animate-spin-slow {
  animation: spin-slow 20s linear infinite;
}
```

### Section 2: Intro — 3열 (텍스트 + 프로젝트 카드 2개)

스크롤 reveal 적용. IntersectionObserver로 뷰포트 진입 시 `.on` 클래스 토글.

```tsx
<section className="py-[100px] px-[60px]" ref={sec02Ref}>
  <div className={`flex gap-8 transition-all duration-1000 ${sec02Visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-[50px]'}`}
       style={{ transitionTimingFunction: 'cubic-bezier(0.19, 1, 0.22, 1)' }}>

    {/* 좌: 텍스트 소개 */}
    <div className="w-1/3">
      <h1 className="text-4xl font-light tracking-wider">
        Residential Space<br/>Design Studio
      </h1>
      <p className="mt-8 text-text-secondary leading-[1.8] text-sm">
        공간과 사용자 사이에는 보이지 않는 수많은 이야기가 혼재합니다...
        (Blacklabelled 소개 텍스트)
      </p>
      <a href="/about" className="inline-block mt-12 text-[22px] font-medium text-gold border-b-2 border-gold pb-1">
        LEARN MORE
      </a>
    </div>

    {/* 중: 프로젝트 카드 1 — 이미지 크로스페이드 */}
    <div className="w-1/3">
      <ImageCrossfade images={project1.images.slice(0, 2)} interval={2000} />
      <h3 className="mt-5 text-xs tracking-wider text-text-muted">PROJECT NO.{project1.id}</h3>
      <h2 className="text-2xl font-light leading-[1.2]">{project1.title}</h2>
    </div>

    {/* 우: 프로젝트 카드 2 */}
    <div className="w-1/3 mt-4">
      <ImageCrossfade images={project2.images.slice(0, 2)} interval={2000} />
      <h3 className="mt-5 text-xs tracking-wider text-text-muted">PROJECT NO.{project2.id}</h3>
      <h2 className="text-2xl font-light leading-[1.2]">{project2.title}</h2>
    </div>
  </div>
</section>
```

### Section 3: Fullscreen Project — 풀스크린 이미지 + 텍스트 오버레이

Featured project의 대표 이미지를 풀스크린으로. 텍스트가 왼쪽 하단.

```tsx
<section className="relative h-screen overflow-hidden" ref={sec05Ref}>
  <div
    className="absolute inset-0 bg-cover bg-center"
    style={{ backgroundImage: `url(${featuredProject.images[0]})` }}
  />
  <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-transparent" />
  <div className={`absolute bottom-[80px] left-[60px] z-10 transition-all duration-1000 ${sec05Visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-[50px]'}`}
       style={{ transitionTimingFunction: 'cubic-bezier(0.19, 1, 0.22, 1)' }}>
    <h3 className="text-white text-sm tracking-wider">PROJECT NO.{featuredProject.id}</h3>
    <h1 className="text-white text-5xl font-light mt-2">{featuredProject.title}</h1>
    <p className="text-white/70 mt-4 max-w-[500px] leading-[1.8]">
      {featuredProject.description?.substring(0, 100)}...
    </p>
    <a href={`/projects/${featuredProject.slug}`} className="inline-block mt-6 text-white border-b border-white pb-1 tracking-wider">
      VIEW PROJECT
    </a>
  </div>
</section>
```

### Section 4: Project Grid — 3열 카드

```tsx
<section className="py-[100px] px-[60px]" ref={sec03Ref}>
  <div className="grid grid-cols-3 gap-6">
    {projects.slice(0, 6).map((project, i) => (
      <div
        key={project.id}
        className={`transition-all duration-700 ${sec03Visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-[50px]'}`}
        style={{
          transitionDelay: `${i * 0.15}s`,
          transitionTimingFunction: 'cubic-bezier(0.19, 1, 0.22, 1)'
        }}
      >
        <div className="aspect-[4/3] overflow-hidden">
          <img src={project.images[0]} className="w-full h-full object-cover hover:scale-105 transition-transform duration-700" />
        </div>
        <h3 className="mt-4 text-xs tracking-wider text-text-muted">PROJECT NO.{project.id}</h3>
        <h2 className="text-xl font-light">{project.title}</h2>
      </div>
    ))}
  </div>
  <div className="text-right mt-12">
    <a href="/projects" className="text-3xl font-light text-text-muted hover:text-text-primary transition-colors">
      More →
    </a>
  </div>
</section>
```

### 3. `components/ImageCrossfade.tsx` — 이미지 크로스페이드 컴포넌트

```tsx
"use client";
import { useState, useEffect } from "react";

interface Props {
  images: string[];
  interval?: number; // ms
}

export default function ImageCrossfade({ images, interval = 3000 }: Props) {
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    if (images.length <= 1) return;
    const timer = setInterval(() => {
      setCurrent(prev => (prev + 1) % images.length);
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
```

### 4. `hooks/useScrollReveal.ts` — 스크롤 reveal 커스텀 훅

```tsx
"use client";
import { useRef, useState, useEffect } from "react";

export function useScrollReveal(threshold = 0.2) {
  const ref = useRef<HTMLElement>(null);
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setVisible(true);
          observer.unobserve(el); // 한 번 활성화 → 유지
        }
      },
      { threshold }
    );

    observer.observe(el);
    return () => observer.disconnect();
  }, [threshold]);

  return { ref, visible };
}
```

---

## CSS 추가 (globals.css 또는 별도 lilsquare.css)

```css
/* Lilsquare style animations */
@keyframes title-fade {
  0% { opacity: 0 }
  100% { opacity: 1 }
}

@keyframes slow-zoom {
  0% { transform: scale(1) }
  100% { transform: scale(1.05) }
}

@keyframes spin-slow {
  100% { transform: rotate(360deg) }
}

.animate-title-fade {
  animation: title-fade 1s ease forwards;
}

.animate-slow-zoom {
  animation: slow-zoom 8s ease-out forwards;
}

.animate-spin-slow {
  animation: spin-slow 20s linear infinite;
}
```

---

## 데이터 연결

Blacklabelled의 기존 데이터 로딩 방식 확인 필요. `getProducts()` 또는 `getProjects()` 함수가 있을 것.

- Hero: `featuredProjects[0]` 의 첫 이미지
- Intro: `projects[0]`, `projects[1]` 의 이미지 + 타이틀
- Fullscreen: `featuredProjects[1]` 또는 `projects[2]`
- Grid: `projects.slice(0, 6)`

기존 데이터 fetching 패턴을 따라야 함. Server Component면 직접 fetch, Client면 SWR/provider.

---

## 완료 조건

- [ ] `localhost:3000/lilsquare` 에서 페이지 로드
- [ ] Hero: 풀스크린 이미지 + 순차 fade 타이틀 + 회전 EXPLORE
- [ ] Sec02: 3열 (텍스트 + 크로스페이드 카드 2개) + 스크롤 reveal
- [ ] Sec05: 풀스크린 프로젝트 + 텍스트 오버레이 + 스크롤 reveal
- [ ] Sec03: 3열 프로젝트 그리드 + 순차 reveal + More →
- [ ] TypeScript 에러 0
- [ ] 모든 애니메이션 `cubic-bezier(0.19, 1, 0.22, 1)`
- [ ] 반응형 (모바일 1열, 태블릿 2열, 데스크톱 3열)
