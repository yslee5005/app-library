# Data Model

## Entities

| Entity | Fields | Relations | Notes |
|---|---|---|---|
| `<EntityName>` | `id: uuid`, `<field>: <type>` | `user_id → auth.users` | <설명> |

## Supabase Schema

- **Schema**: `<app>` (예: `abba`, `blacklabelled`) — 절대 `public` 사용 금지 (앱별 분리)
- **Tables**: `<table_name>`
- **RLS**: `auth.uid() = user_id AND COALESCE(app_id, '') = '<app>'`
- **Indexes**: <복합 인덱스 명시>

## Migration

- **File**: `supabase/migrations/<timestamp>_<descriptive_name>.sql`
- **Status**: pending | applied
- **Rollback 전략**: <필요 시>

## 참조
- `.claude/rules/multi-tenant-review.md`
- `.claude/rules/supabase.md`
