---
paths: ["apps/**"]
---

# Copy-Paste Guide (Master → App)

| Feature | Master Source | Customize in App |
|---------|-------------|-----------------|
| Auth | `packages/auth/` | provider, UI |
| DB Connection | `packages/supabase_client/` | APP_ID, .env |
| Error Logging | `packages/error_logging/` | DSN, filters |
| Environment Branching | `packages/core/` environment/ | AppEnvironment enum |
| Cache | `packages/cache/` | TTL, keys |
| Pagination | `packages/pagination/` | widget UI |
| Comments | `packages/comments/` | content_type |
| Notifications | `packages/notifications/` | notification content |
| UI Widgets | `packages/ui_kit/` | entire design |
| Theme | `packages/theme/` | seed color, fonts |

**Principle: Freely modify after copy-paste. No forced sync with master.**
