# BlackLabelled

인테리어 디자인 스튜디오 앱. 포트폴리오 쇼케이스 + 상담 예약.

## 도메인 컨텍스트

- 타겟: 인테리어 디자인에 관심 있는 고객 (B2C) + 스튜디오 관리 (B2B)
- 핵심 가치: 프리미엄 포트폴리오 + 원클릭 상담 신청
- UX 원칙: 다크 프리미엄 테마 전용 (`BlackLabelledTheme.darkTheme`), 고급스러운 톤
- 듀얼 플랫폼: Flutter 앱 + Next.js 웹 (`apps/blacklabelled/web/`)

## 기능 구조

```
lib/features/
├── home/           # 메인 (포트폴리오 하이라이트)
├── portfolio/      # 포트폴리오 갤러리 (사진/영상)
├── furniture/      # 가구/자재 카탈로그
├── consult/        # 상담 예약/신청
├── mypage/         # 마이페이지
└── shell/          # 앱 셸 (네비게이션)
```

## 앱 고유 명령어

```bash
# Flutter 앱
flutter run apps/blacklabelled

# Next.js 웹 (별도)
cd apps/blacklabelled/web && npm run build
cd apps/blacklabelled/web && npx vitest run
```

## Supabase 스키마

- 스키마명: `blacklabelled`
- 주요 테이블: portfolios, portfolio_images, consultations, furniture_items
- 포트폴리오 이미지: Supabase Storage 사용

## 주의사항

- 다크 테마 전용 — `themeMode: ThemeMode.dark` 고정
- Next.js 웹은 독립 코드베이스 (`web/CLAUDE.md`에 별도 규칙)
- B2B 성격: 관리자 기능은 웹에서만 제공
