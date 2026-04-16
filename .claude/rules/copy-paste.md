---
paths: ["apps/**"]
---

# 복붙 가이드 (마스터 → 앱)

| 기능 | 마스터 소스 | 앱에서 커스텀 |
|------|-----------|-------------|
| 인증 | `packages/auth/` | provider, UI |
| DB 연결 | `packages/supabase_client/` | APP_ID, .env |
| 에러 로깅 | `packages/error_logging/` | DSN, 필터 |
| 환경 분기 | `packages/core/` environment/ | AppEnvironment enum |
| 캐시 | `packages/cache/` | TTL, 키 |
| 페이지네이션 | `packages/pagination/` | 위젯 UI |
| 댓글 | `packages/comments/` | content_type |
| 알림 | `packages/notifications/` | 알림 내용 |
| UI 위젯 | `packages/ui_kit/` | 디자인 전체 |
| 테마 | `packages/theme/` | 시드 컬러, 폰트 |

**원칙: 복붙 후 자유 수정. 마스터와 동기화 강제 없음.**
