# Phase 9: Lilsquare — Proposals + Layouts 페이지

> `/lilsquare/proposals` — 제안서/견적 사례
> `/lilsquare/layouts` — 도면 모음

## 필수 읽기
- `src/components/lilsquare/LilsquareProjects.tsx` — 그리드 패턴
- `src/lib/data.ts` — 프로젝트 데이터 (도면 이미지 포함 여부 확인)

## 생성할 파일

### Proposals: `src/app/lilsquare/proposals/page.tsx` + `src/components/lilsquare/LilsquareProposals.tsx`

제안서/견적 사례. 프로젝트 데이터의 제안서 정보 활용 (없으면 mock).

섹션:

1. **Hero**: "Proposals" 타이틀 + "공간의 가능성을 제안합니다"

2. **제안서 카드 그리드**: 2열 (모바일 1열)
   - 각 카드:
     - 프로젝트 이미지 (before 또는 3D 렌더링)
     - 프로젝트명 + 위치
     - 평형 / 예산 범위 / 공사 기간
     - "자세히 보기 →" 링크
   - 배경: 밝은 크림 (#f8f7f5)
   - 호버: scale 1.02 + shadow

3. **예산 가이드**: 평형별 예상 비용 테이블
   - 20평대 / 30평대 / 40평대 / 50평 이상
   - 기본 / 고급 / 프리미엄 3단계
   - 깔끔한 테이블 or 카드 형태

4. **CTA**: "맞춤 견적 받기" → `/lilsquare/contact`

mock 제안서 데이터 (4-6개):
```tsx
const MOCK_PROPOSALS = [
  { id: 1, project: "여수동 센트럴타운 356", location: "경기도 성남시", area: "34평", budget: "5,000만원~", duration: "8주", image: "..." },
  // ...
];
```

### Layouts: `src/app/lilsquare/layouts/page.tsx` + `src/components/lilsquare/LilsquareLayouts.tsx`

도면 모음 갤러리. 프로젝트별 도면 이미지를 모아서 보여줌.

섹션:

1. **Hero**: "Layouts" 타이틀 + "124개의 공간 설계도"

2. **필터**: 평형별 필터 (20평대 / 30평대 / 40평대 / 전체)

3. **도면 그리드**: 3열 (모바일 1열, 태블릿 2열)
   - 각 카드:
     - 도면 이미지 (aspect-[4/3], 흰 배경)
     - 프로젝트명
     - 평형 / 위치
     - 클릭 → Lightbox로 크게 보기
   - 스크롤 reveal 순차

4. **도면 설명**: "우리의 도면은 단순한 선이 아닙니다..." 철학 텍스트

프로젝트 데이터에서 plan 타입 이미지 추출. 없으면 mock.

## 완료 조건
- [ ] `/lilsquare/proposals` + `/lilsquare/layouts` 로드
- [ ] 제안서 카드 + 예산 가이드
- [ ] 도면 그리드 + 필터 + Lightbox
- [ ] 스크롤 reveal
- [ ] TypeScript 에러 0
