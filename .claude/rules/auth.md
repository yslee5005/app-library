---
paths: ["apps/**", "**/auth*"]
---

# Anonymous-First 인증

모든 앱은 로그인 없이 시작. 클라우드 저장은 Supabase 익명 계정으로 자동 처리.

## 원칙
1. 로그인 화면 없음 — Welcome → 바로 Home
2. `signInAnonymously()` 앱 시작 시 자동 호출
3. 익명 UUID로 Supabase 저장 (RLS 정상)
4. 구독: RevenueCat anonymous ID (앱 계정 불필요)
5. Settings에서 Apple/Google/Email 연결 (선택)
6. `linkIdentityWithIdToken()` 사용 — 네이티브 + 익명 UUID 보존
7. 브라우저 기반 `signInWithOAuth` / `linkIdentity` 사용 금지

## 로그인이 필요한 유일한 순간
- 기기 변경 시 데이터 이전

## 네이티브 로그인 (packages/auth)

### Sign In (신규 로그인)
- Google: `google_sign_in` → `signInWithIdToken`
- Apple: `sign_in_with_apple` + nonce(crypto) → `signInWithIdToken`
- Email: `signInWithPassword`

### Link (Anonymous → 계정 연결)
- Google: `google_sign_in` → `linkIdentityWithIdToken`
- Apple: `sign_in_with_apple` + nonce → `linkIdentityWithIdToken`
- Email: `updateUser(email, password)`
- `identity_already_exists` 에러 시 → `signInWithIdToken` fallback (기존 계정 복구)

### Supabase Dashboard 필수 설정
- Authentication > Providers > **"Enable Manual Linking"** 활성화

## 멀티앱 Provider 설정

Supabase 1개 프로젝트에서 여러 앱이 소셜 로그인을 공유하는 방법:

### Apple Provider
Client IDs 필드에 콤마로 모든 bundle ID 나열:
```
com.ystech.abba, com.ystech.blacklabelled, com.ystech.babyletter
```
Apple Developer Console에서 App Grouping 권장 (동일 sub 보장).

### Google Provider
Client IDs 필드에 Web 먼저, 나머지 콤마:
```
WEB_CLIENT_ID, ABBA_IOS_ID, BL_IOS_ID, BABYLETTER_IOS_ID
```
"Skip Nonce Check" 활성화 필수.

### 앱별 .env.client
```
GOOGLE_WEB_CLIENT_ID=공유-web-client-id     (모든 앱 동일)
GOOGLE_IOS_CLIENT_ID=앱별-ios-client-id     (앱마다 다름)
```
Apple은 bundle ID를 자동 사용하므로 별도 설정 불필요.
