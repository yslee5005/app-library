# Phase 3: Lilsquare — Project 상세 페이지

> `/lilsquare/projects/[slug]` 페이지

## 필수 읽기
- `src/components/ProjectDetail.tsx` — 기존 상세 페이지
- `src/components/DepthGallery.tsx` — 3D 갤러리
- `src/components/Lightbox.tsx` — 이미지 라이트박스
- `src/components/BeforeAfterSlider.tsx` — Before/After
- `src/lib/data.ts`

## 생성할 파일

### `src/app/lilsquare/projects/[slug]/page.tsx`

Server Component — 프로젝트 데이터 + 관련 프로젝트 fetch.

### `src/components/lilsquare/LilsquareProjectDetail.tsx`

"use client" 컴포넌트.

섹션:

1. **Hero**: 대표 이미지 풀스크린 (100vh)
   - 하단 gradient 오버레이
   - 좌하단: PROJECT NO.XXX + 프로젝트 제목 (큰 텍스트)
   - 우하단: 위치 / 면적 / 연도

2. **프로젝트 정보**: 2열
   - 좌: 설명 텍스트 (leading-[1.8])
   - 우: 메타 정보 (카테고리, 면적, 위치, 연도) — 세로 리스트

3. **갤러리**: 3D 뷰 / Grid 뷰 토글 (기존 패턴 재사용)
   - "GALLERY · {N} IMAGES" 헤더 + [3D] [GRID] 토글
   - 3D: DepthGallery 컴포넌트
   - Grid: 2열 또는 3열 이미지 그리드 + 클릭 → Lightbox

4. **도면 섹션** (이미지가 plan 타입인 경우):
   - Layout Plan + ALT 뷰 2열
   - ImageCrossfade 사용

5. **관련 프로젝트**: 가로 스크롤 카드 4개
   - 같은 카테고리 필터
   - 클릭 → `/lilsquare/projects/[slug]`

6. **CTA**: "상담 신청하기" 풀너비 버튼 → `/lilsquare/contact`

모든 섹션에 스크롤 reveal 적용.

## 완료 조건
- [ ] `/lilsquare/projects/[slug]` 로드
- [ ] Hero 풀스크린 + 프로젝트 정보
- [ ] 3D/Grid 갤러리 토글
- [ ] 관련 프로젝트 표시
- [ ] 스크롤 reveal
- [ ] TypeScript 에러 0
