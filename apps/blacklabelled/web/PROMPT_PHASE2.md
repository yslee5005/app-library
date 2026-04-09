# PROMPT — BlackLabelled Web Phase 2: Projects + Detail + Before/After

> Ralph 자율 실행용 프롬프트
> 선행: Phase 1 완료

---

## 목표

Projects 리스트 + Project Detail + Before/After 슬라이더 + About + Process + Contact

## 필수 읽기

- `apps/blacklabelled/web/specs/REQUIREMENTS.md`
- `apps/blacklabelled/web/specs/DESIGN.md`
- `apps/blacklabelled/data/db/products.json` — 상품 데이터
- `apps/blacklabelled/data/db/categories.json` — 카테고리
- `apps/blacklabelled/data/db/manifest.json` — 이미지 메타

---

## 체크리스트

### 1. Projects 리스트 (app/projects/page.tsx)

- 페이지 헤더: "PROJECTS" Cormorant Garamond 60px, center
- 서브텍스트: "427 completed spaces" Inter 14px, #666
- 필터 바:
  - [ALL] [RESIDENCE] [BOUTIQUE] [COSMETICS] [COMMERCIAL] [KITCHEN] [BATH] [DESIGN FURNITURE] [SYSTEM]
  - selected: 골드 text + 골드 bottom border
  - unselected: #666, hover → white
  - useState로 필터 관리
- 프로젝트 그리드:
  - 3열 (모바일 1열, 태블릿 2열)
  - 각 카드: 이미지 + hover 오버레이 (이름 + 카테고리 + 이미지 수)
  - hover: brightness 증가 + scale(1.02)
  - gap: 4px (타이트한 갤러리)
  - Link → /projects/[slug]
- 페이지네이션 또는 "LOAD MORE" 버튼 (20개씩)
- 데이터: products.json에서 로드, 카테고리 필터링

### 2. Project Detail (app/projects/[slug]/page.tsx)

- Next.js generateStaticParams로 427개 정적 생성
- slug = products.json의 slug 필드

**Hero:**
- 메인 이미지 풀 너비 (100vw, 70vh)
- 하단 gradient overlay (#0A0A0A)
- 프로젝트명: Cormorant 48px, white
- 카테고리 + 평수: Inter 12px, 골드, uppercase
- "← PROJECTS" 뒤로가기 링크

**Before/After 섹션 (도면 매칭 있는 경우만):**
- products.json에서 같은 이름의 Layout_Design(45) ↔ Residence(44) 매칭
- 매칭 로직: 상품명에서 공통 키워드 추출 → 같은 프로젝트 찾기
- 컴포넌트: BeforeAfterSlider
  - 좌: 도면 이미지 (Layout_Design의 첫 번째 이미지)
  - 우: 실제 사진 (Residence의 첫 번째 이미지)
  - 가운데: 골드 세로선 + 원형 핸들 (드래그 가능)
  - CSS clip-path: inset(0 {100-percent}% 0 0) → 마우스 X 위치
  - 하단 라벨: "DESIGN" / "REALITY"
  - 터치 지원

**이미지 갤러리 (기본 — Phase 3에서 3D로 업그레이드):**
- 제목: "GALLERY · {N} IMAGES" Inter 12px, 골드
- 이미지 그리드: 3열 (모바일 2열)
- 라이트박스: 이미지 클릭 → 풀스크린 오버레이 + 좌우 네비게이션
- Framer Motion으로 페이드인/아웃

**프로젝트 정보:**
- 2열: 좌측 설명 + 우측 정보 카드 (bg #141414)

**관련 프로젝트:**
- 같은 카테고리 상품 3개 카드

**CTA:**
- "이런 공간을 원하시나요?" + [상담 문의] 버튼

### 3. About (app/about/page.tsx)

- Hero: 풀스크린 이미지 또는 다크 배경
- "BLACKLABELLED DESIGN STUDIO" Cormorant 48px
- 디자인 철학 텍스트 (간단)
- 숫자 섹션: 427+ 프로젝트 / 10+ Years / 성남 기반 (카운터 애니메이션)
- 연락처 정보
- pages.json에서 about 데이터 로드 (있으면)

### 4. Process (app/process/page.tsx)

- 타임라인 레이아웃:
  1. 상담 → 2. 도면 설계 → 3. 3D 렌더 → 4. 시공 → 5. 완공
- 각 단계: 아이콘 + 제목 + 설명
- 스크롤 시 순차 나타남 (Framer Motion)
- CTA: [상담 시작하기]

### 5. Contact (app/contact/page.tsx)

- 2열: 좌측 폼 + 우측 정보
- 폼: 이름, 연락처, 이메일, 프로젝트 유형 (드롭다운), 메시지
- 입력 필드: 밑줄 스타일 (border-bottom only), 포커스 → 골드
- 제출 버튼: 골드 bg, 블랙 text
- 폼 제출: 로컬에서는 console.log (나중에 Supabase)
- 우측: 주소, 전화, 이메일, 카카오, 영업시간

---

## 이미지 서빙

Phase 1에서 설정한 이미지 API route 사용:
- `/api/images/project/residence/잠실트리지움_532/main.jpg`
- 또는 public/ 심볼릭 링크

## 완료 조건

- [ ] /projects — 427개 상품 그리드 + 카테고리 필터
- [ ] /projects/[slug] — 상세 페이지 + 이미지 갤러리 + 라이트박스
- [ ] Before/After 슬라이더 동작 (드래그 가능)
- [ ] /about — 회사 소개
- [ ] /process — 프로세스 타임라인
- [ ] /contact — 문의 폼
- [ ] 모바일 반응형
- [ ] `npm run build` 에러 없음
