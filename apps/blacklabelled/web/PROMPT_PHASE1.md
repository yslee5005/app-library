# PROMPT — BlackLabelled Web Phase 1: 프로젝트 셋업 + Home

> Ralph 자율 실행용 프롬프트

---

## 목표

Next.js 15 프로젝트 셋업 + 다크 럭셔리 테마 + 네비게이션 + Home 페이지

## 기술 스택

- Next.js 15 (App Router, TypeScript)
- Tailwind CSS v4
- Framer Motion (애니메이션)
- GSAP + ScrollTrigger (스크롤 애니메이션)
- Google Fonts: Cormorant Garamond + Inter

## 프로젝트 위치

`/Users/yonghunjeong/Documents/ys/app-library/apps/blacklabelled/web`

## 실행 순서

### 1. Next.js 프로젝트 생성

```bash
cd /Users/yonghunjeong/Documents/ys/app-library/apps/blacklabelled/web
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
```

### 2. 패키지 설치

```bash
npm install framer-motion gsap @gsap/react
npm install next-themes
```

### 3. Tailwind 다크 테마 설정

tailwind.config.ts에 커스텀 컬러:
```
colors: {
  bg: { primary: '#0A0A0A', secondary: '#111111', card: '#141414', hover: '#1A1A1A' },
  text: { primary: '#F5F5F0', secondary: '#999999', muted: '#666666' },
  gold: { DEFAULT: '#C5A46C', light: '#D4B896', dark: '#A68B5B' },
  border: '#222222',
  divider: '#1A1A1A',
}
```

### 4. 글로벌 CSS

```css
body { background: #0A0A0A; color: #F5F5F0; }
```

Google Fonts 연결: Cormorant Garamond (300, 400), Inter (400, 500)

### 5. 레이아웃 (app/layout.tsx)

- `<html>` dark 클래스
- 폰트 로드
- 네비게이션 포함

### 6. 네비게이션 컴포넌트 (components/Navigation.tsx)

```
fixed top, transparent → 스크롤 시 bg blur
좌측: "BLACKLABELLED" (Cormorant Garamond, 골드, letter-spacing 0.3em)
우측: PROJECTS  MAP  ABOUT  CONTACT (Inter 13px, uppercase, #999)
hover → 골드 underline
모바일: 햄버거 → 풀스크린 오버레이 (다크 배경, 중앙 링크)
```

### 7. Home 페이지 (app/page.tsx)

4개 섹션:

**Section 1: Hero (100vh)**
- 풀스크린 #0A0A0A
- 중앙: radial-gradient로 원형 밝은 영역 (Flashlight 효과 시뮬레이션)
  - 마우스 위치에 따라 gradient 중심 이동 (onMouseMove)
  - 원 안에 대표 인테리어 사진 (public/images/hero.jpg — 없으면 placeholder)
- "BLACKLABELLED" Cormorant Garamond 72px, 골드, letter-spacing
- "Your space is 'black label'" Inter 16px, #999
- 하단: ↓ 화살표 (opacity pulse animation)

**Section 2: Intro (Before/After 미리보기)**
- 좌측: "From Design to Reality" (Cormorant Garamond 48px, white)
- 우측: Before/After 슬라이더 컴포넌트
  - 2개 이미지 겹침 (도면 + 사진)
  - CSS clip-path로 분할
  - 마우스 드래그로 분할선 이동
  - 골드 라인 + 원형 핸들
  - 하단 라벨: "DESIGN" (골드) / "REALITY" (white)

**Section 3: Featured Projects (6개)**
- "SELECTED WORKS" Cormorant Garamond 36px, center
- 2x3 그리드 (반응형: 모바일 1열, 태블릿 2열)
- 각 카드: 이미지 + 호버 시 오버레이 (이름 + 카테고리)
- 호버: scale(1.02) + brightness 증가
- "VIEW ALL PROJECTS →" 링크 (골드)
- 데이터: /data/db/products.json에서 첫 6개 로드

**Section 4: Contact CTA**
- "당신의 공간을 변화시킬 준비가 되셨나요?" (Cormorant 36px, center)
- [상담 문의] 버튼 (골드 bg, 블랙 text)
- Link → /contact

### 8. Footer 컴포넌트

- "© 2026 BLACKLABELLED" (#666)
- Instagram + Blog 아이콘 (골드)
- 상단 divider (1px #222)

### 9. 데이터 로딩

`lib/data.ts`:
```typescript
import productsData from '../../data/db/products.json';
import categoriesData from '../../data/db/categories.json';

export function getProducts() { return Object.values(productsData); }
export function getProduct(id: number) { return productsData[id]; }
export function getCategories() { return Object.values(categoriesData); }
export function getFeaturedProducts(count = 6) { return getProducts().slice(0, count); }
```

이미지 경로: `/data/images/` → Next.js public 심볼릭 링크 또는 API route로 serve

### 10. 이미지 서빙

`next.config.ts`에서 이미지 도메인 설정 또는:
`app/api/images/[...path]/route.ts` — static file serving from data/images/

---

## 완료 조건

- [ ] `npm run dev` → localhost:3000 접속 가능
- [ ] 다크 배경 + 골드 텍스트 테마 적용
- [ ] 네비게이션 (데스크톱 + 모바일 햄버거)
- [ ] Home Hero (Flashlight 마우스 효과)
- [ ] Before/After 슬라이더 동작
- [ ] Featured Projects 6개 그리드 (이미지 로딩)
- [ ] Contact CTA 섹션
- [ ] Footer
- [ ] `npm run build` 에러 없음
