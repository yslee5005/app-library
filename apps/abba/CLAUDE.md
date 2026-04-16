# Abba

기도/QT AI 동반자 앱. 50-70대 시니어 기독교인이 매일 기도 습관을 만들도록 돕는다.

## 도메인 컨텍스트

- 타겟: 50-70대 기독교인 (전세계), 2차 타겟 전 연령 기독교인
- 핵심 가치: 기도하면 AI가 성경으로 응답 + 개인 맞춤 피드백
- UX 원칙: 버튼 하나로 시작, 3탭으로 완료. 시니어 친화 (큰 글씨, 단순 동선)
- 다국어: 35개 언어 지원 (l10n). 영어 기본, 한국어 동시 지원
- 톤: 따뜻하고 경건한 언어. 기술 용어 최소화

## 기능 구조

```
lib/features/
├── welcome/        # 온보딩 (Anonymous-First → 바로 Home)
├── home/           # 메인 대시보드
├── qt/             # QT(Quiet Time) 기능 — AI 성경 묵상
├── recording/      # 기도 녹음/입력
├── ai_loading/     # AI 응답 생성 중 로딩 UX (lazy loading)
├── calendar/       # 기도 캘린더 (스트릭, 히스토리)
├── history/        # 기도 히스토리
├── dashboard/      # 통계/성장 대시보드
├── community/      # Instagram 스타일 커뮤니티 + 신고 이메일
├── my_page/        # 프로필, 계정 연결
├── settings/       # 알림 설정, 언어 변경
└── login/          # 계정 연결 전용 (필수 아님)
```

## Supabase 스키마

- 스키마명: `abba`
- 주요 테이블: prayers, qt_sessions, prayer_responses, community_posts, reports
- AI 응답은 Supabase Edge Function으로 생성

## 주의사항

- AI 로딩은 lazy loading 패턴 — 사용자 경험상 즉시 응답처럼 느끼게
- 프리미엄 UX: 구독 없이도 핵심 기능 사용 가능, 프리미엄은 AI 횟수 확장
- 커뮤니티 신고: 이메일 기반 (in-app 관리자 패널 없음)
- 캘린더 리디자인 완료 (v1.0 기준)

## 참고 문서

@specs/REQUIREMENTS.md
@specs/DESIGN.md
