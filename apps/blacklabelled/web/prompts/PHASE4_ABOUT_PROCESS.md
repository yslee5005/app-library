# Phase 4: Lilsquare — About + Process 페이지

> `/lilsquare/about`, `/lilsquare/process`

## 필수 읽기
- `src/components/AboutContent.tsx` — 기존 About
- `src/components/ProcessContent.tsx` — 기존 Process
- `src/lib/data.ts`
- `src/hooks/useScrollReveal.ts`

## 생성할 파일

### About: `src/app/lilsquare/about/page.tsx` + `src/components/lilsquare/LilsquareAbout.tsx`

섹션:

1. **Hero**: 풀스크린 인테리어 이미지 + "Residential Space Design Studio" 대형 타이틀
   - Ken Burns zoom + gradient overlay

2. **소개**: 3열 (Lilsquare 메인 sec02과 동일 패턴)
   - 좌: 철학 텍스트 (leading-[1.8]) + LEARN MORE 링크
   - 중/우: 프로젝트 이미지 카드 (ImageCrossfade)
   - 스크롤 reveal

3. **철학/비전**: 풀스크린 배경 이미지 + 인용문
   - "공백은 채우기 위한 공간이 아니라..."
   - 반투명 오버레이 + 큰 이탤릭 텍스트
   - 스크롤 시 parallax 효과

4. **숫자 통계**: 카운트업 애니메이션
   - 427+ Projects / 15+ Years / 98% 고객 만족
   - 스크롤 진입 시 0부터 카운트업
   - 큰 숫자 (gold color) + 레이블 (muted)

5. **팀/대표**: 사진 + 이름 + 직책 + 한 줄 소개

### Process: `src/app/lilsquare/process/page.tsx` + `src/components/lilsquare/LilsquareProcess.tsx`

섹션:

1. **Hero**: "PROCESS" 타이틀 + 서브텍스트

2. **프로세스 타임라인**: 번호 + 제목 + 설명 + 이미지
   - Step 01: 상담 및 현장방문
   - Step 02: 설계 및 디자인
   - Step 03: 시공
   - Step 04: 마감 및 입주
   - 각 단계: 좌우 교차 레이아웃 (홀수: 이미지 좌 + 텍스트 우, 짝수: 반대)
   - 가운데 세로 라인 (타임라인)
   - 스크롤 reveal 순차

3. **CTA**: "상담 신청하기" 섹션

## 완료 조건
- [ ] `/lilsquare/about` + `/lilsquare/process` 로드
- [ ] Hero + 소개 + 철학 + 통계 + 프로세스 타임라인
- [ ] 카운트업 애니메이션
- [ ] 스크롤 reveal
- [ ] TypeScript 에러 0
