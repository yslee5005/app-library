# Claude Code Learn

Claude Code 사용법을 인터랙티브하게 학습하는 앱.

## 도메인 컨텍스트

- 목적: Claude Code의 기능/워크플로우를 단계별로 배우는 학습 앱
- 타겟: Claude Code를 처음 쓰는 개발자
- 콘텐츠: 마크다운 기반 학습 자료 + 실습 가이드

## 기능 구조

```
lib/
├── main.dart
├── app.dart
├── config/         # 앱 설정
├── router/         # go_router
└── features/       # 학습 콘텐츠 화면
```

## 주의사항

- workspace resolution 사용 (monorepo packages 참조)
- 마크다운 렌더링: `markdown_widget` 패키지 사용
- 학습 진도: `shared_preferences`로 로컬 저장
- Supabase 미사용
