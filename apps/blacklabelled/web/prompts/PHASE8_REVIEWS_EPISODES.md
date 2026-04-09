# Phase 8: Lilsquare — Reviews + Episodes 페이지

> `/lilsquare/reviews` — 고객 후기
> `/lilsquare/episodes` — 시공 에피소드/비하인드

## 필수 읽기
- `src/components/lilsquare/LilsquareProjects.tsx` — 그리드 패턴 참고
- `src/lib/data.ts` — 데이터 구조

## 생성할 파일

### Reviews: `src/app/lilsquare/reviews/page.tsx` + `src/components/lilsquare/LilsquareReviews.tsx`

고객 후기 페이지. 데이터가 없으면 mock 데이터 사용.

섹션:

1. **Hero**: "Reviews" 타이틀 + "168건의 고객 후기" 서브텍스트

2. **통계 바**: 평균 평점 4.9 / 총 168건 / 재시공률 42%
   - 가로 3열, 큰 숫자 (gold) + 레이블

3. **후기 카드 그리드**: 2열 (모바일 1열)
   - 각 카드:
     - ⭐⭐⭐⭐⭐ 별점
     - 후기 텍스트 (2-3줄, 더 보기)
     - 프로젝트 이미지 썸네일 (작게)
     - 고객명 (이니셜 또는 익명) + 프로젝트명 + 날짜
     - 배경: 밝은 카드 (bg-[#f8f7f5])
   - 스크롤 reveal 순차

4. **CTA**: "상담 신청하기"

mock 후기 데이터 (5-8개):
```tsx
const MOCK_REVIEWS = [
  { id: 1, rating: 5, text: "처음부터 끝까지 소통이 정말 좋았습니다...", author: "김O현", project: "잠실 리센츠", date: "2025.12" },
  { id: 2, rating: 5, text: "기대 이상의 결과물이었습니다...", author: "이O수", project: "분당 센트럴타운", date: "2025.11" },
  // ...
];
```

### Episodes: `src/app/lilsquare/episodes/page.tsx` + `src/components/lilsquare/LilsquareEpisodes.tsx`

시공 에피소드/비하인드 스토리. 블로그 스타일.

섹션:

1. **Hero**: "Episodes" 타이틀 + "시공의 이면, 디자인의 여정"

2. **에피소드 카드**: 1열 풀너비 (블로그 포스트 스타일)
   - 각 카드:
     - 대형 이미지 (aspect-[16/9])
     - EPISODE 01 / 02 / 03 번호
     - 제목 (큰 텍스트)
     - 서브텍스트 (1-2줄 요약)
     - 날짜
   - 교차 레이아웃: 홀수 = 이미지 좌 + 텍스트 우, 짝수 = 반대
   - 스크롤 reveal

mock 에피소드 데이터 (3개):
```tsx
const MOCK_EPISODES = [
  { id: 1, title: "빛이 만드는 공간의 온도", subtitle: "여수동 센트럴타운 시공 비하인드", date: "2025.10", image: "..." },
  { id: 2, title: "대리석, 자연을 담다", subtitle: "분당 파크뷰 마감재 선정 과정", date: "2025.08", image: "..." },
  { id: 3, title: "2bay의 새로운 패러다임", subtitle: "30평대 2베이의 공간 혁신 이야기", date: "2025.06", image: "..." },
];
```

## 완료 조건
- [ ] `/lilsquare/reviews` + `/lilsquare/episodes` 로드
- [ ] 후기 카드 + 에피소드 카드
- [ ] mock 데이터로 렌더링
- [ ] 스크롤 reveal
- [ ] TypeScript 에러 0
