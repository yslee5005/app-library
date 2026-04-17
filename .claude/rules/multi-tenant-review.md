---
paths: ["supabase/**", "packages/**", "apps/**"]
---

# Multi-Tenant Review Checklist

Review the following items whenever DB schema, RLS, Edge Functions, or Dart code changes.

## 1. Table Classification

Every table falls into one of 3 categories:

| Category | Location | Examples |
|----------|----------|----------|
| Shared (all apps) | `public.*` | profiles, user_devices, notification_settings |
| App-specific (single app) | `public.{app}_*` | abba_user_settings, abba_notification_settings |
| Separate schema | `{app}.*` | blacklabelled.products |

**Review:** When adding a table → Could other apps use this data? YES → shared, NO → app-specific.

## 2. Schema Changes

- [ ] Not adding app-specific columns to shared tables?
- [ ] `CREATE TABLE IF NOT EXISTS` vs `ALTER TABLE` — does the table already exist?
- [ ] PK changes won't break existing FK references?
- [ ] Includes existing data migration (INSERT INTO ... SELECT)?
- [ ] DROP COLUMN — no Edge Functions/Dart code referencing that column?

## 3. RLS Policies

- [ ] All tables have `ENABLE ROW LEVEL SECURITY`?
- [ ] Shared tables: `auth.uid() = id` (no app hardcoding)
- [ ] App-specific tables: `auth.uid() = user_id AND COALESCE(app_id, '') = '{app}'`
- [ ] Not using `USING(true)` on SELECT? (data exposure risk)
- [ ] INSERT has `WITH CHECK`?

## 4. Triggers (handle_new_user)

- [ ] Reads `raw_user_meta_data` first, `raw_app_meta_data` as fallback?
- [ ] App-specific row creation is conditional: `IF app_id = '{app}' THEN`?
- [ ] Added branch for new app in the trigger?
- [ ] `ON CONFLICT DO NOTHING` for duplicate prevention?

## 5. Dart Code (packages/auth)

- [ ] `signInAnonymously(data: {'app_id': appId})` — passing app_id?
- [ ] Using `AppSupabaseClient.from()` for automatic app_id scoping?
- [ ] When using `_client.raw.from()`, manually added `.eq('app_id', appId)`?
- [ ] `UserProfile` name conflict between packages/auth and app → handled with `hide`?

## 6. Edge Functions

- [ ] Table names correctly reference post-separation tables? (notification_settings → abba_notification_settings)
- [ ] `app_id` filter included in queries?
- [ ] Accessing with service_role key only? (client key usage forbidden)

## 7. Multi-App Provider Setup (Supabase Dashboard)

When changing social login providers:
- [ ] All app bundle IDs listed comma-separated in Apple Client IDs?
- [ ] Web (first) + all iOS Client IDs listed in Google Client IDs?
- [ ] "Enable Manual Linking" is activated?
- [ ] "Skip Nonce Check" (Google) is activated?

## 8. Schema Separation Rules

- Shared tables: `public.*` (`profiles`, `user_devices`, `notification_settings`)
- App-specific tables: `{app}.*` schema (`abba.prayers`, `abba.user_settings`, `blacklabelled.products`)
- No prefix needed — schema serves as namespace
- Dart: use `_client.schema('abba').from('prayers')`
- Edge Function: use `supabase.schema("abba").from("prayers")`
- `public.*` tables use `.from()` directly (default schema)
- Migration files: `{timestamp}_{description}.sql`
