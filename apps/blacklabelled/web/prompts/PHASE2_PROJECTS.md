# Phase 2: Lilsquare — Projects 목록 + 카테고리 필터

> `/lilsquare/projects` 페이지

## 필수 읽기
- `src/components/LilsquareHome.tsx` — 메인 컴포넌트 (데이터 fetching 패턴)
- `src/lib/data.ts` — 데이터 로딩
- `src/components/lilsquare/LilsquareNav.tsx` — Phase 1에서 생성
- `src/hooks/useScrollReveal.ts`

## 생성할 파일

### `src/app/lilsquare/projects/page.tsx`

Server Component에서 프로젝트 데이터 fetch → Client Component에 전달.

### `src/components/lilsquare/LilsquareProjects.tsx`

"use client" 컴포넌트.

섹션:

1. **Hero**: 풀스크린 첫 프로젝트 이미지 + "PROJECTS" 대형 타이틀 (center)
   - 배경: Ken Burns slow zoom
   - 오버레이: gradient top→bottom

2. **카테고리 필터**: 수평 탭 바
   - ALL / Residence / Commercial / Boutiques / Cosmetics
   - 선택 시 underline 금색 + 텍스트 primary color
   - sticky (스크롤 시 상단 고정)

3. **프로젝트 그리드**: 3열 (반응형: 모바일 1열, 태블릿 2열)
   - 각 카드:
     - 이미지 aspect-[4/3] + hover: scale(1.03) + 어두워짐
     - "PROJECT NO.{id}" 작은 텍스트 (muted)
     - 프로젝트 제목 (큰 텍스트)
     - 위치 (muted)
   - 스크롤 reveal: 순차 transUp (0.15s 간격)
   - `cubic-bezier(0.19, 1, 0.22, 1)`

4. **카테고리 변경 시**: 부드러운 fade out → 새 목록 fade in

5. **링크**: 카드 클릭 → `/lilsquare/projects/[slug]`

## 완료 조건
- [ ] `/lilsquare/projects` 로드 + 프로젝트 그리드 표시
- [ ] 카테고리 필터 동작
- [ ] 스크롤 reveal 애니메이션
- [ ] 호버 효과
- [ ] 반응형 (1/2/3열)
- [ ] TypeScript 에러 0
