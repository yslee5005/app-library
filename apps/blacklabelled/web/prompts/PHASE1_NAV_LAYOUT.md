# Phase 1: Lilsquare — Navigation + Layout Shell

> 모든 /lilsquare 페이지에 공통 적용되는 네비게이션 + 레이아웃

## 필수 읽기
- `src/app/layout.tsx` — 루트 레이아웃
- `src/components/Navigation.tsx` — 기존 네비게이션
- `src/components/Footer.tsx` — 기존 푸터
- `src/app/globals.css` — 테마
- `src/hooks/useScrollReveal.ts` — 스크롤 훅
- `AGENTS.md` — Next.js 주의사항

## 생성할 파일

### 1. `src/app/lilsquare/layout.tsx` — Lilsquare 전용 레이아웃

기존 RootLayout 아래에 중첩 레이아웃. Navigation과 Footer를 Lilsquare 스타일로 교체.

```tsx
import LilsquareNav from "@/components/lilsquare/LilsquareNav";
import LilsquareFooter from "@/components/lilsquare/LilsquareFooter";

export default function LilsquareLayout({ children }) {
  return (
    <>
      <LilsquareNav />
      <main>{children}</main>
      <LilsquareFooter />
    </>
  );
}
```

주의: 루트 layout.tsx의 Navigation과 Footer가 이미 있으므로 중복되지 않게 처리. 방법:
- 옵션 A: `/lilsquare` 라우트 그룹으로 분리하여 별도 layout
- 옵션 B: 루트 layout에서 pathname 체크하여 조건부 렌더링
- 옵션 C: `/lilsquare`를 route group `(lilsquare)`로 만들어 독립 layout

가장 깔끔한 방법 선택.

### 2. `src/components/lilsquare/LilsquareNav.tsx`

Lilsquare 스타일 네비게이션:
- 고정 헤더 (스크롤 시 배경 어두워짐)
- 좌: "BLACKLABELLED" 로고 (흰색, tracking-[0.15em])
- 우: PROJECTS / ABOUT / PROCESS / CONTACT 링크 + 상담신청 버튼(gold bg) + 그리드 아이콘
- 모바일: 햄버거 → 풀스크린 오버레이 메뉴

```tsx
"use client";
// fixed header + scroll 시 bg-black/80 backdrop-blur
// 링크: /lilsquare/projects, /lilsquare/about, /lilsquare/process, /lilsquare/contact
// 상담신청 버튼: gold 배경, 흰색 텍스트
// 모바일 메뉴: fadeIn 풀스크린 오버레이
```

스크롤 감지:
```tsx
const [scrolled, setScrolled] = useState(false);
useEffect(() => {
  const handler = () => setScrolled(window.scrollY > 50);
  window.addEventListener("scroll", handler, { passive: true });
  return () => window.removeEventListener("scroll", handler);
}, []);
```

### 3. `src/components/lilsquare/LilsquareFooter.tsx`

3열 푸터:
- 좌: 로고 + 회전 텍스트 (optional)
- 중좌: SNS (Instagram, YouTube, Blog 링크)
- 중우: INFO (주소, 전화, 이메일)
- 우: CONTACT (상담시간, 상담신청 링크)

배경: dark (#0A0A0A), 텍스트: muted

## 완료 조건
- [ ] `/lilsquare` 하위 모든 페이지에 LilsquareNav + LilsquareFooter 적용
- [ ] 기존 `/` 페이지에는 영향 없음
- [ ] 스크롤 시 헤더 배경 전환
- [ ] 모바일 메뉴 동작
- [ ] TypeScript 에러 0
