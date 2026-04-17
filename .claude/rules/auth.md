---
paths: ["apps/**", "**/auth*"]
---

# Anonymous-First Authentication (익명 우선 인증)

All apps start without login. Cloud storage is handled automatically via Supabase anonymous accounts.

## Principles
1. No login screen — Welcome → straight to Home
2. `signInAnonymously()` called automatically on app start
3. Saved to Supabase with anonymous UUID (RLS works normally)
4. Subscriptions: RevenueCat anonymous ID (no app account required)
5. Link Apple/Google/Email in Settings (optional)
6. Use `linkIdentityWithIdToken()` — preserves native + anonymous UUID
7. Never use browser-based `signInWithOAuth` / `linkIdentity`

## The Only Moment Login Is Required
- Data migration when switching devices

## Native Login (packages/auth)

### Sign In (New Login)
- Google: `google_sign_in` → `signInWithIdToken`
- Apple: `sign_in_with_apple` + nonce(crypto) → `signInWithIdToken`
- Email: `signInWithPassword`

### Link (Anonymous → Account Linking)
- Google: `google_sign_in` → `linkIdentityWithIdToken`
- Apple: `sign_in_with_apple` + nonce → `linkIdentityWithIdToken`
- Email: `updateUser(email, password)`
- On `identity_already_exists` error → `signInWithIdToken` fallback (recover existing account)

### Supabase Dashboard Required Settings
- Authentication > Providers > **"Enable Manual Linking"** must be enabled

## Multi-App Provider Configuration

How multiple apps share social login on a single Supabase project:

### Apple Provider
List all bundle IDs comma-separated in the Client IDs field:
```
com.ystech.abba, com.ystech.blacklabelled, com.ystech.babyletter
```
App Grouping in Apple Developer Console is recommended (ensures same sub).

### Google Provider
List Web first, then others comma-separated in Client IDs field:
```
WEB_CLIENT_ID, ABBA_IOS_ID, BL_IOS_ID, BABYLETTER_IOS_ID
```
"Skip Nonce Check" must be enabled.

### Per-App .env.client
```
GOOGLE_WEB_CLIENT_ID=shared-web-client-id     (same for all apps)
GOOGLE_IOS_CLIENT_ID=per-app-ios-client-id     (different per app)
```
Apple uses the bundle ID automatically, so no additional configuration is needed.
