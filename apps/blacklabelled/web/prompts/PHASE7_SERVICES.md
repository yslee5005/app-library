# Phase 7: Lilsquare — Services 페이지

> `/lilsquare/services` — 인테리어 서비스 소개

## 필수 읽기
- `src/components/lilsquare/LilsquareAbout.tsx` — 비슷한 패턴 참고
- `src/hooks/useScrollReveal.ts`
- `src/lib/data.ts`

## 생성할 파일

### `src/app/lilsquare/services/page.tsx` + `src/components/lilsquare/LilsquareServices.tsx`

Blacklabelled의 서비스 범위를 Lilsquare 디자인으로 소개.

섹션:

1. **Hero**: 풀스크린 이미지 + "Services" 대형 타이틀
   - Ken Burns zoom + gradient overlay

2. **서비스 개요**: 큰 인용문
   - "단순한 인테리어를 넘어, 건축적 미학과 극도의 절제미를 담은 공간을 설계합니다."
   - 센터 정렬, 이탤릭, 큰 텍스트

3. **서비스 카테고리**: 4개 카드 (2x2 그리드)
   - **주거 공간** (Residential) — 아파트, 빌라, 주택
   - **상업 공간** (Commercial) — 사무실, 매장, 카페
   - **부티크** (Boutiques) — 고급 매장, 쇼룸
   - **코스메틱** (Cosmetics) — 뷰티 샵, 클리닉
   - 각 카드: 대형 이미지 + 호버 시 텍스트 오버레이 + 카테고리명 + 간단 설명
   - 스크롤 reveal 순차

4. **프로세스 요약**: 4단계 가로 타임라인
   - 상담 → 설계 → 시공 → 입주
   - 각 단계: 번호 + 아이콘 + 제목 + 한 줄 설명
   - "자세히 보기 →" → `/lilsquare/process`

5. **CTA**: "프로젝트를 시작하세요" + 상담신청 버튼

## 완료 조건
- [ ] `/lilsquare/services` 로드
- [ ] Hero + 서비스 카테고리 4개 + 프로세스 요약 + CTA
- [ ] 스크롤 reveal + 호버 효과
- [ ] TypeScript 에러 0
