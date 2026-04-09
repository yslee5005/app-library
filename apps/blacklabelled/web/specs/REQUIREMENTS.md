# BlackLabelled 웹사이트 — REQUIREMENTS.md

> Version: 1.0 | Created: 2026-04-09

---

## 1. 프로젝트 비전

"설계에서 현실로" — 인테리어의 가능성을 체험하는 몰입형 웹사이트.

---

## 2. 기술 스택

| 항목 | 선택 |
|------|------|
| 프레임워크 | Next.js 15 (App Router) |
| 언어 | TypeScript |
| 스타일 | Tailwind CSS (다크 테마) |
| 3D/애니메이션 | Three.js + React Three Fiber |
| 스크롤 애니메이션 | GSAP + ScrollTrigger |
| 전환 효과 | Framer Motion |
| 지도 | Mapbox GL (Dark Style) |
| 데이터 | Supabase (나중에) / JSON (지금) |
| 이미지 | Supabase Storage (나중에) / 로컬 (지금) |
| 배포 | Vercel |

---

## 3. 디자인 컨셉: "Dark Minimal Luxury"

### 3.1 컬러 팔레트

| 용도 | 색상 | HEX |
|------|------|-----|
| 배경 | 순흑 | `#0A0A0A` |
| 텍스트 | 웜 화이트 | `#F5F5F0` |
| 악센트 | 골드/브론즈 | `#C5A46C` |
| 서브 텍스트 | 다크 그레이 | `#666666` |
| 디바이더 | 미세 그레이 | `#1A1A1A` |
| 호버 | 밝은 골드 | `#D4B896` |

### 3.2 타이포그래피

| 용도 | 폰트 | 크기 |
|------|------|------|
| 브랜드/헤딩 | Cormorant Garamond (세리프) | 48~72px |
| 본문 | Pretendard (한글) / Inter (영문) | 16~18px |
| 캡션 | Inter | 12~14px |
| 네비게이션 | Inter (letter-spacing: 0.2em) | 14px |

### 3.3 핵심 인터랙션

| 효과 | 설명 | 기술 |
|------|------|------|
| Flashlight 커서 | 마우스 주변만 밝게 (홈 히어로) | CSS radial-gradient + JS |
| Before/After 슬라이더 | 도면↔사진 드래그 비교 | CSS clip-path + pointer |
| 3D Depth Gallery | 스크롤로 이미지가 깊이감 있게 이동 | Three.js + ScrollTrigger |
| Card Tilt | 마우스 호버 시 카드 3D 기울어짐 | CSS perspective + transform |
| 지도 핀 팝업 | Mapbox 핀 호버 → 프로젝트 미리보기 | Mapbox GL Popup |
| 페이지 전환 | 페이드 + 슬라이드 전환 | Framer Motion |
| Parallax 스크롤 | 배경/전경 다른 속도 | GSAP ScrollTrigger |

---

## 4. 페이지 구조 (7개)

### 4.1 Home (`/`)

```
[HERO]
  - 풀스크린 다크 배경
  - Flashlight 커서 효과 (마우스 주변만 대표 이미지 보임)
  - "BLACKLABELLED" 로고 (Cormorant Garamond, 골드)
  - "Your space is 'black label'" 태그라인
  - 스크롤 유도 화살표 (↓)

[INTRO SECTION]
  - "설계에서 현실로" 텍스트 (스크롤 시 페이드인)
  - Before/After 슬라이더 하이라이트 (1개 대표 프로젝트)
  - 도면 → 드래그 → 실제 사진

[FEATURED PROJECTS]
  - 최근 프로젝트 6개 (2열 그리드)
  - 마우스 호버 → 3D 틸트 + 프로젝트명 오버레이
  - [VIEW ALL] → /projects

[MAP PREVIEW]
  - Mapbox Dark 미니 지도 (성남/분당 중심)
  - 대표 핀 5~10개
  - [EXPLORE MAP] → /map

[CONTACT CTA]
  - "당신의 공간을 변화시킬 준비가 되셨나요?"
  - [상담 문의] 버튼 → /contact
```

### 4.2 Projects (`/projects`)

```
[FILTER BAR]
  - [전체] [Residence] [Boutique] [Cosmetics] [Commercial] [Kitchen] [Bath]
  - 필터 전환 시 GSAP 애니메이션

[PROJECT GRID]
  - 2~3열 반응형 그리드
  - 각 카드:
    - 메인 이미지 (hover → 확대 + 오버레이)
    - 프로젝트명 + 카테고리
    - 이미지 수 표시
  - Infinite scroll (20개씩)
  - 클릭 → /projects/[slug]
```

### 4.3 Project Detail (`/projects/[slug]`)

```
[HERO]
  - 풀 너비 메인 이미지 (parallax)
  - 프로젝트명 + 카테고리 + 평수

[BEFORE/AFTER] (도면 매칭 있는 경우)
  - 드래그 슬라이더: 도면 ↔ 실제 사진
  - "설계" / "현실" 라벨

[3D DEPTH GALLERY]
  - Codrops 스타일 스크롤 갤러리
  - 이미지 20~40장 깊이감 있게 배치
  - 스크롤 속도에 따라 효과 변화
  - 무드 배경색 전환

[PROJECT INFO]
  - 설명 텍스트
  - 관련 프로젝트 3개 추천

[CONTACT CTA]
  - "이런 공간을 원하시나요?"
  - [상담 문의] → /contact
```

### 4.4 Map (`/map`)

```
[FULL MAP]
  - Mapbox Dark (풀스크린)
  - 커스텀 골드 핀 (427개)
  - 카테고리 필터 (좌측 오버레이)
  - 핀 hover → 미니 프리뷰 팝업 (사진 + 이름)
  - 핀 클릭 → /projects/[slug]
  - 줌 레벨에 따라 클러스터링
```

### 4.5 About (`/about`)

```
[HERO]
  - 사무실/팀 사진 (풀스크린, parallax)
  - "BLACKLABELLED DESIGN STUDIO"

[PHILOSOPHY]
  - 디자인 철학 텍스트 (스크롤 시 텍스트 페이드인)

[TEAM]
  - 팀 소개 (있는 경우)

[NUMBERS]
  - 427+ 프로젝트 / 10+ 년 / 성남 기반
  - 카운터 애니메이션 (스크롤 트리거)

[CONTACT]
  - 주소, 전화, 이메일, 영업시간
  - Mapbox 미니맵 (사무실 위치)
```

### 4.6 Process (`/process`)

```
[TIMELINE]
  - 상담 → 도면 설계 → 3D 렌더 → 시공 → 완공
  - 각 단계 스크롤 시 나타남
  - 아이콘 + 설명 + 예시 이미지

[CTA]
  - [상담 시작하기] → /contact
```

### 4.7 Contact (`/contact`)

```
[FORM]
  - 이름, 연락처, 이메일
  - 프로젝트 유형 (Residence / Commercial / Furniture)
  - 예산 범위
  - 메시지
  - [문의하기] 버튼

[INFO]
  - 주소: 경기도 성남시 중원구 양현로 411 시티오피스타워 605호
  - 전화: 010-9887-2826
  - 이메일: blacklabelled@naver.com
  - 카카오: 블랙라벨드
  - 영업시간: 월-금 9:30~18:30

[MAP]
  - Mapbox Dark (사무실 위치)
```

---

## 5. 데이터 연결

| 페이지 | 데이터 소스 |
|--------|-----------|
| Projects 리스트 | `products.json` → 427개 |
| Project 상세 | `products.json` + `product_images` |
| Before/After | Layout_Design ↔ Residence 매칭 (69쌍) |
| Map | 상품명에서 geocoding (주소 → 좌표) |
| About | `pages.json` (정적) |
| Process | `pages.json` (정적) |

---

## 6. 반응형 브레이크포인트

| 디바이스 | 폭 | 그리드 |
|---------|-----|-------|
| 모바일 | < 768px | 1열 |
| 태블릿 | 768~1024px | 2열 |
| 데스크톱 | > 1024px | 2~3열 |

---

## 7. SEO

- 모든 프로젝트 페이지 SSR (Next.js)
- Open Graph 메타 태그 (이미지 + 설명)
- JSON-LD Schema (LocalBusiness + Product)
- sitemap.xml 자동 생성
- robots.txt

---

## 8. 성능 목표

| 지표 | 목표 |
|------|------|
| LCP | < 2.5초 |
| FID | < 100ms |
| CLS | < 0.1 |
| Lighthouse | > 90 |
| 이미지 | WebP + lazy loading + blur placeholder |

---

## 9. 구현 Phase

### Phase 1: 정적 페이지 (MVP)
- Home, About, Process, Contact
- 다크 테마 + 기본 애니메이션
- 로컬 JSON 데이터

### Phase 2: 프로젝트 리스트 + 상세
- Projects 그리드 + 필터
- Project Detail (이미지 갤러리)
- Before/After 슬라이더

### Phase 3: 인터랙티브 기능
- 3D Depth Gallery (Three.js)
- Flashlight 커서
- Card Tilt 효과

### Phase 4: 지도
- Mapbox Dark 통합
- Geocoding (상품명 → 좌표)
- 핀 팝업 + 클러스터링

### Phase 5: Supabase 연동 + 배포
- 로컬 JSON → Supabase DB/Storage 이관
- Vercel 배포
- 도메인 연결 (blacklabelled.co.kr)
