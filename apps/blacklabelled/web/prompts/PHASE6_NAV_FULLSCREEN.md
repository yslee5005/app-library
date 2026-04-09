# Phase 6: Lilsquare — 풀스크린 네비게이션 메뉴 리디자인

> LilsquareNav의 모바일 메뉴를 Lilsquare 스타일 풀스크린 오버레이로 변경

## 필수 읽기
- `src/components/lilsquare/LilsquareNav.tsx` — 현재 네비게이션
- `src/lib/data.ts` — 데이터 (프로젝트 수 등)

## 변경할 파일

### `src/components/lilsquare/LilsquareNav.tsx` 수정

현재 모바일 메뉴를 Lilsquare 스타일 **풀스크린 화이트 오버레이**로 변경. 데스크톱에서도 그리드 아이콘(⋮⋮⋮) 클릭 시 열리도록.

레이아웃:
```
┌──────────────────────────────────────────────────────┐
│ BLACKLABELLED                    [상담신청] [✕]      │
│                                                       │
│ About            Projects ^427    Proposals ^6        │
│ Services         Reviews ^168     Episodes ^3         │
│                  Layouts ^124                          │
│                                                       │
│ ──────────────────────────────────────────────────── │
│                                                       │
│ Instagram ↗    Life Makes Sense    Youtube ↗         │
│ Blog ↗                             Pinterest ↗       │
└──────────────────────────────────────────────────────┘
```

구현 상세:
1. **배경**: 흰색 (bg-white) 풀스크린 오버레이, `z-[100]`
2. **좌측**: About / Services — 매우 큰 볼드 텍스트 (text-5xl md:text-7xl, font-black, 검정)
3. **중앙**: Projects / Reviews / Layouts — 큰 텍스트 (text-3xl md:text-5xl, font-bold) + 빨간 카운트 뱃지 (bg-red-500, 작은 원, superscript)
4. **우측**: Proposals / Episodes — 큰 텍스트 + 카운트 뱃지
5. **하단 구분선** 아래: SNS 링크 (Instagram ↗ / Blog ↗ / Youtube ↗ / Pinterest ↗) + 중앙에 "Life Makes Sense" 워터마크 (text-text-muted, tracking-[0.3em])
6. **열기/닫기 애니메이션**: fadeIn 0.3s
7. **열릴 때 body scroll lock**
8. **카운트 뱃지**: 실제 데이터에서 프로젝트 수 가져오기 (또는 하드코딩 가능)

네비게이션 링크 업데이트:
```tsx
const MENU_LEFT = [
  { href: "/lilsquare/about", label: "About" },
  { href: "/lilsquare/services", label: "Services" },
];

const MENU_RIGHT = [
  { href: "/lilsquare/projects", label: "Projects", count: 427 },
  { href: "/lilsquare/proposals", label: "Proposals", count: 6 },
  { href: "/lilsquare/reviews", label: "Reviews", count: 168 },
  { href: "/lilsquare/episodes", label: "Episodes", count: 3 },
  { href: "/lilsquare/layouts", label: "Layouts", count: 124 },
];
```

데스크톱 상단 바도 업데이트:
- 좌: BLACKLABELLED 로고
- 우: PROJECTS / MAP / ABOUT / PROCESS / CONTACT 링크 + 상담신청 버튼 (gold) + 그리드 아이콘 (클릭 → 풀스크린 메뉴)

## 완료 조건
- [ ] 그리드 아이콘 클릭 → 풀스크린 화이트 오버레이 열림
- [ ] 좌측 대형 텍스트 + 우측 카운트 뱃지 메뉴
- [ ] SNS 링크 + 워터마크
- [ ] X 닫기 + body scroll lock
- [ ] 모든 링크 동작
- [ ] TypeScript 에러 0
