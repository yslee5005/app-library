---
paths: ["supabase/**", "packages/**", "apps/**"]
---

# 멀티테넌트 리뷰 체크리스트

DB 스키마, RLS, Edge Function, Dart 코드 변경 시 반드시 아래 항목 검토.

## 1. 테이블 분류

모든 테이블은 3가지 중 하나:

| 분류 | 위치 | 예시 |
|------|------|------|
| 공통 (모든 앱 공유) | `public.*` | profiles, user_devices, notification_settings |
| 앱 전용 (한 앱만 사용) | `public.{app}_*` | abba_user_settings, abba_notification_settings |
| 별도 스키마 | `{app}.*` | blacklabelled.products |

**검토:** �� 테이블 추가 시 → 다른 앱에서도 쓸 수 있는 데이터인가? YES → 공통, NO → 앱 전용.

## 2. 스키마 변경 시

- [ ] 공통 테이블에 앱 특화 컬럼 추가하고 있지 않은가?
- [ ] `CREATE TABLE IF NOT EXISTS` vs `ALTER TABLE` — 이미 존재하는 테이블인가?
- [ ] PK 변경 시 기존 FK 참조가 깨지지 않는가?
- [ ] 기존 데이터 마이그레이션 (INSERT INTO ... SELECT) 포함했는가?
- [ ] DROP COLUMN 시 해당 컬럼을 참조하는 Edge Function/Dart 코드 없는가?

## 3. RLS 정책

- [ ] 모든 테이블에 `ENABLE ROW LEVEL SECURITY` 있는가?
- [ ] 공통 테이블: `auth.uid() = id` (앱 하드코딩 없이)
- [ ] 앱 전용 테이블: `auth.uid() = user_id AND COALESCE(app_id, '') = '{app}'`
- [ ] SELECT에 `USING(true)` 사용하고 있지 않은가? (���이터 노출 위험)
- [ ] INSERT에 `WITH CHECK` 있는가?

## 4. 트리거 (handle_new_user)

- [ ] `raw_user_meta_data` 우선, `raw_app_meta_data` fallback으로 읽는가?
- [ ] 앱 전용 행 생성은 `IF app_id = '{app}' THEN` 조건부인가?
- [ ] 새 앱 추가 시 트리거에 해당 앱 분기 추가했는가?
- [ ] `ON CONFLICT DO NOTHING`으로 중복 방지했는가?

## 5. Dart 코드 (packages/auth)

- [ ] `signInAnonymously(data: {'app_id': appId})` — app_id 전달하고 있는가?
- [ ] `AppSupabaseClient.from()` 사용으로 app_id 자동 스코핑 되는가?
- [ ] `_client.raw.from()` 사용 시 수동으로 `.eq('app_id', appId)` 추가했는가?
- [ ] packages/auth의 `UserProfile` vs 앱의 `UserProfile` 이름 충돌 → `hide` 처리했는가?

## 6. Edge Function

- [ ] 테이블명이 분리 후 테이블을 정확히 참조하는가? (notification_settings → abba_notification_settings)
- [ ] `app_id` 필터가 쿼리에 포함되어 있는가?
- [ ] service_role 키로만 접근하고 있는가? (클라이언트 키 사용 금지)

## 7. 멀티앱 Provider 설정 (Supabase Dashboard)

소셜 로그인 Provider 변경 시:
- [ ] Apple Client IDs에 모든 앱 bundle ID가 콤마로 나열되어 있는가?
- [ ] Google Client IDs에 Web(첫 번째) + 모든 iOS Client ID가 나열되어 있는가?
- [ ] "Enable Manual Linking" 활성화되어 있는가?
- [ ] "Skip Nonce Check" (Google) 활성화되어 있는가?

## 8. 스키마 분리 규칙

- 공통 테이블: `public.*` (`profiles`, `user_devices`, `notification_settings`)
- 앱 전용 테이블: `{app}.*` 스키마 (`abba.prayers`, `abba.user_settings`, `blacklabelled.products`)
- 접두사 불필요 — 스키마가 네임스페이스 역할
- Dart: `_client.schema('abba').from('prayers')` 사용
- Edge Function: `supabase.schema("abba").from("prayers")` 사용
- `public.*` 테이블은 `.from()` 직접 사용 (기본 스키마)
- 마이그레이션 파일: `{timestamp}_{설명}.sql`
