# Phase 5: Lilsquare — Contact + Map 페이지

> `/lilsquare/contact`, `/lilsquare/map`

## 필수 읽기
- `src/components/ContactContent.tsx` — 기존 Contact
- `src/components/MapContent.tsx` — 기존 Map
- `src/lib/data.ts`

## 생성할 파일

### Contact: `src/app/lilsquare/contact/page.tsx` + `src/components/lilsquare/LilsquareContact.tsx`

섹션:

1. **Hero**: "CONTACT" 타이틀 + "공간의 시작은 대화에서부터" 서브텍스트

2. **연락 정보 카드**: 2열
   - 좌: 전화번호 (큰 gold 텍스트) + 이메일 + 주소
   - 우: 상담 시간 + 오시는 길 요약

3. **상담 폼**: 풀너비
   - 이름 / 연락처 (2열)
   - 주소 / 평형 (2열)
   - 예산 범위 (드롭다운)
   - 메시지 (textarea)
   - 개인정보 동의 체크박스
   - "상담 신청하기" 버튼 (gold, 풀너비)
   - 입력 필드: border-bottom 스타일 (Lilsquare처럼 밑줄만)

4. **마무리**: "편하게 연락주세요" 텍스트 + SNS 아이콘

### Map: `src/app/lilsquare/map/page.tsx` + `src/components/lilsquare/LilsquareMap.tsx`

섹션:

1. **Hero**: "LOCATION" 타이틀

2. **지도**:
   - Kakao Map 또는 iframe (기존 MapContent 패턴 참고)
   - 넓은 영역 (height: 60vh)

3. **오시는 길 정보**:
   - 주소 (큰 텍스트)
   - 지하철 / 버스 / 자가용 안내
   - 전화번호 + 이메일

4. **CTA**: "상담 신청하기" 버튼 → `/lilsquare/contact`

모든 섹션에 스크롤 reveal + `cubic-bezier(0.19, 1, 0.22, 1)`.

## 완료 조건
- [ ] `/lilsquare/contact` + `/lilsquare/map` 로드
- [ ] 상담 폼 렌더링 (submit은 기존 로직 또는 placeholder)
- [ ] 지도 표시
- [ ] 스크롤 reveal
- [ ] TypeScript 에러 0
