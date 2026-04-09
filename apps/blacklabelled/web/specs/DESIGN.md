# BlackLabelled 웹사이트 — DESIGN.md

> Version: 1.0 | Concept: "Dark Minimal Luxury"

---

## 1. 디자인 시스템

### 1.1 컬러

```css
:root {
  /* Background */
  --bg-primary: #0A0A0A;
  --bg-secondary: #111111;
  --bg-card: #141414;
  --bg-hover: #1A1A1A;

  /* Text */
  --text-primary: #F5F5F0;
  --text-secondary: #999999;
  --text-muted: #666666;

  /* Accent */
  --gold: #C5A46C;
  --gold-light: #D4B896;
  --gold-dark: #A68B5B;

  /* Functional */
  --border: #222222;
  --divider: #1A1A1A;
  --overlay: rgba(0, 0, 0, 0.7);
}
```

### 1.2 타이포그래피

```css
/* 브랜드 / 대형 헤딩 */
.heading-hero {
  font-family: 'Cormorant Garamond', serif;
  font-size: 72px;
  font-weight: 300;
  letter-spacing: 0.15em;
  color: var(--gold);
}

/* 섹션 타이틀 */
.heading-section {
  font-family: 'Cormorant Garamond', serif;
  font-size: 48px;
  font-weight: 400;
  letter-spacing: 0.1em;
  color: var(--text-primary);
}

/* 네비게이션 */
.nav-link {
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  font-weight: 400;
  letter-spacing: 0.25em;
  text-transform: uppercase;
  color: var(--text-secondary);
}

/* 본문 (한글) */
.body-text {
  font-family: 'Pretendard', 'Inter', sans-serif;
  font-size: 16px;
  line-height: 1.8;
  color: var(--text-primary);
}

/* 캡션 */
.caption {
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  letter-spacing: 0.1em;
  color: var(--text-muted);
}
```

### 1.3 간격

```
xs:  4px
sm:  8px
md:  16px
lg:  24px
xl:  48px
2xl: 80px
3xl: 120px
```

### 1.4 애니메이션 원칙

| 원칙 | 설명 |
|------|------|
| 느림 > 빠름 | 럭셔리 = 서두르지 않음 (duration: 0.6~1.2s) |
| 부드러움 | ease: cubic-bezier(0.25, 0.1, 0.25, 1) |
| 절제 | 한 번에 하나의 애니메이션만 |
| 의미 | 장식 아닌 목적 있는 움직임 |

---

## 2. 컴포넌트 명세

### 2.1 Navigation Bar

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  BLACKLABELLED          PROJECTS  MAP  ABOUT  CONTACT│
│                                                     │
└─────────────────────────────────────────────────────┘

- 위치: fixed top, transparent → 스크롤 시 bg: rgba(10,10,10,0.9) + blur
- 로고: Cormorant Garamond, 골드, letter-spacing: 0.3em
- 링크: Inter 13px, uppercase, hover → 골드 underline
- 모바일: 햄버거 → 풀스크린 오버레이 메뉴
```

### 2.2 Hero (Home)

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│              ■■■■■■■■■■■■■■■■■■■■■                  │
│            ■■■■■╭────────╮■■■■■■■■                  │
│            ■■■■■│ 인테리어 │■■■■■■■■  ← Flashlight   │
│            ■■■■■│  사진   │■■■■■■■■    커서 효과      │
│            ■■■■■╰────────╯■■■■■■■■                  │
│              ■■■■■■■■■■■■■■■■■■■■■                  │
│                                                     │
│         B L A C K L A B E L L E D                   │
│         Your space is 'black label'                 │
│                                                     │
│                    ↓                                │
└─────────────────────────────────────────────────────┘

- 배경: #0A0A0A
- Flashlight: CSS radial-gradient, 반경 200px, 마우스 따라감
- 로고: 페이드인 (delay 1s)
- 스크롤 화살표: opacity pulse
```

### 2.3 Before/After 슬라이더

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  ┌────────────────────┬────────────────────┐        │
│  │                    │                    │        │
│  │     도면 이미지      │◀══ 드래그 ▶│  사진 이미지     │
│  │     (clip-path:    │  슬라이더   │  (기본 보임)    │
│  │      left side)    │   라인      │               │
│  │                    │  + 골드 핸들 │               │
│  │                    │            │               │
│  └────────────────────┴────────────────────┘        │
│                                                     │
│      DESIGN                          REALITY        │
│      (골드, 좌측)                     (화이트, 우측)   │
│                                                     │
└─────────────────────────────────────────────────────┘

- 슬라이더 라인: 2px, 골드 (#C5A46C)
- 핸들: 원형, 40px, 골드 테두리, 좌우 화살표
- 라벨: uppercase, letter-spacing, 각 이미지 하단
- 모바일: 터치 드래그 지원
```

### 2.4 Project Card (Grid)

```
┌──────────────────┐
│                  │
│   메인 이미지     │  ← aspect-ratio: 4/3
│                  │     hover → scale(1.03) + 밝기 ↑
│                  │     3D tilt (마우스 위치 기반)
│                  │
├──────────────────┤
│ 잠실트리지움       │  ← Pretendard 18px, white
│ Residence · 40PY  │  ← Inter 12px, gold, uppercase
└──────────────────┘

- 카드 배경: transparent (이미지만)
- 간격: gap 4px (밀착 그리드)
- 호버: transform: perspective(600px) rotateX/Y + shadow
- 전환: 0.6s ease
```

### 2.5 3D Depth Gallery (Project Detail)

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│                     스크롤 ↓                         │
│                                                     │
│           ╱─────────╲                               │
│          ╱   사진 1   ╲    ← z: -200 (멀리)         │
│         ╱─────────────╲                             │
│        ╱    사진 2      ╲   ← z: -100               │
│       ╱─────────────────╲                           │
│             사진 3           ← z: 0 (가까이)         │
│                                                     │
│    배경: 이미지에서 추출한 무드 컬러 그라디언트          │
│    속도: 빠른 스크롤 → 이미지 기울기 + 밝기 변화        │
│                                                     │
└─────────────────────────────────────────────────────┘

- Three.js planes with image textures
- 스크롤 velocity → tilt + scale
- 배경: fragment shader (무드 컬러)
- 이미지 간격: z-axis 150px
```

### 2.6 Map View

```
┌─────────────────────────────────────────────────────┐
│  [Residence] [Kitchen] [Bath] [All]    ← 필터 (좌상) │
│                                                     │
│            ■ Mapbox Dark 풀스크린 ■                   │
│                                                     │
│                 ✦ 잠실                               │
│        ✦ 서현       ✦ 정자                           │
│              ✦ 야탑                                  │
│     ✦ 단대         ✦ 수내                            │
│                                                     │
│     ✦ = 골드 커스텀 핀 (#C5A46C)                      │
│                                                     │
│     핀 hover:                                       │
│     ┌──────────────┐                                │
│     │ [thumb] 잠실.. │  ← 미니 프리뷰 팝업             │
│     │ Residence     │                               │
│     └──────────────┘                                │
│                                                     │
└─────────────────────────────────────────────────────┘

- 배경: Mapbox Dark (도로 #1A1A1A, 라벨 최소화)
- 핀: 커스텀 SVG, 골드, hover → 확대
- 팝업: 다크 카드 (bg: #141414, border: #C5A46C)
- 클러스터: 숫자 표시 원형 (골드 배경)
```

### 2.7 Contact Form

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│     LET'S CREATE YOUR SPACE                         │
│                                                     │
│     ┌─────────────────────────────────┐             │
│     │ 이름                             │  ← 밑줄만   │
│     ├─────────────────────────────────┤     (골드)   │
│     │ 연락처                           │             │
│     ├─────────────────────────────────┤             │
│     │ 이메일                           │             │
│     ├─────────────────────────────────┤             │
│     │ 프로젝트 유형  [Residence ▼]      │             │
│     ├─────────────────────────────────┤             │
│     │ 메시지                           │             │
│     │                                 │             │
│     └─────────────────────────────────┘             │
│                                                     │
│     [ 문의하기 ]  ← 골드 배경, 블랙 텍스트             │
│                                                     │
└─────────────────────────────────────────────────────┘

- 입력 필드: 밑줄만 (border-bottom: 1px gold)
- 포커스: 밑줄 두께 증가 + 골드 glow
- 버튼: bg gold, text black, hover → 밝아짐
- 성공: "문의가 접수되었습니다" 페이드인
```

---

## 3. 모바일 설계

| 요소 | 데스크톱 | 모바일 |
|------|---------|--------|
| 네비 | 가로 링크 | 햄버거 → 풀스크린 오버레이 |
| 그리드 | 2~3열 | 1열 |
| Flashlight | 마우스 커서 | 터치 위치 (탭 → 밝아짐) |
| Before/After | 마우스 드래그 | 터치 드래그 |
| 3D Gallery | 스크롤 + 마우스 parallax | 스크롤만 (parallax 약하게) |
| 지도 | 풀스크린 | 풀스크린 (필터 하단) |

---

## 4. Stitch 디자인 요청 순서

| # | 화면 | 우선순위 |
|---|------|:---:|
| 1 | Home (Hero + Flashlight 효과 설명) | ⭐⭐⭐ |
| 2 | Projects Grid (카드 + 필터) | ⭐⭐⭐ |
| 3 | Project Detail (Before/After + Gallery) | ⭐⭐⭐ |
| 4 | Map View | ⭐⭐ |
| 5 | About | ⭐⭐ |
| 6 | Contact | ⭐⭐ |
| 7 | Process | ⭐ |
| 8 | Navigation (Desktop + Mobile) | ⭐⭐⭐ |
