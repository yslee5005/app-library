# PROMPT — Anonymous-First 인증 패턴 적용

> Ralph 자율 실행용 프롬프트
> 목표: 로그인 화면 제거 → 익명 자동 인증 → Settings에서 계정 연결

---

## 실행 규칙

1. 각 파일 수정 전 반드시 Read로 읽기
2. 기존 테스트 깨지지 않게 주의
3. 수정 후 `flutter analyze` + `flutter test` 검증

---

## 필수 읽기

- `apps/abba/lib/main.dart`
- `apps/abba/lib/router/app_router.dart`
- `apps/abba/lib/features/login/view/login_view.dart`
- `apps/abba/lib/features/welcome/view/welcome_view.dart`
- `apps/abba/lib/features/settings/view/settings_view.dart`
- `apps/abba/lib/services/auth_service.dart`
- `apps/abba/lib/services/real/supabase_auth_service.dart`
- `apps/abba/lib/services/mock/mock_auth_service.dart`
- `apps/abba/lib/providers/providers.dart`
- `apps/abba/lib/l10n/app_en.arb`
- `apps/abba/lib/l10n/app_ko.arb`

---

## 변경 1: AuthService 인터페이스 확장

### `lib/services/auth_service.dart` 수정

```dart
abstract class AuthService {
  // 기존 유지
  Future<UserProfile> signInWithGoogle();
  Future<UserProfile> signInWithApple();
  Future<UserProfile> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserProfile?> getCurrentUser();
  Stream<AbbaAuthState> get authStateChanges;

  // 새로 추가
  Future<UserProfile> signInAnonymously();
  Future<UserProfile> linkWithGoogle();
  Future<UserProfile> linkWithApple();
  Future<UserProfile> linkWithEmail(String email, String password);
  bool get isAnonymous;
}
```

### `lib/services/real/supabase_auth_service.dart` 수정

```dart
@override
Future<UserProfile> signInAnonymously() async {
  final response = await _client.auth.signInAnonymously();
  if (response.user == null) {
    throw Exception('Anonymous sign-in failed');
  }
  return _ensureProfile(response.user!);
}

@override
bool get isAnonymous {
  final user = _client.auth.currentUser;
  return user?.isAnonymous ?? true;
}

@override
Future<UserProfile> linkWithGoogle() async {
  await _client.auth.linkIdentity(OAuthProvider.google);
  return _waitForProfile();
}

@override
Future<UserProfile> linkWithApple() async {
  await _client.auth.linkIdentity(OAuthProvider.apple);
  return _waitForProfile();
}

@override
Future<UserProfile> linkWithEmail(String email, String password) async {
  await _client.auth.updateUser(
    UserAttributes(email: email, password: password),
  );
  final user = _client.auth.currentUser!;
  return _ensureProfile(user);
}
```

### `lib/services/mock/mock_auth_service.dart` 수정

```dart
bool _isAnonymous = true;

@override
Future<UserProfile> signInAnonymously() async {
  await Future.delayed(const Duration(milliseconds: 300));
  _isAnonymous = true;
  final profile = UserProfile(
    id: 'anon-${DateTime.now().millisecondsSinceEpoch}',
    name: '',
    email: '',
  );
  _controller.add(AbbaAuthState(
    status: AuthStatus.authenticated,
    user: profile,
  ));
  return profile;
}

@override
bool get isAnonymous => _isAnonymous;

@override
Future<UserProfile> linkWithGoogle() async {
  await Future.delayed(const Duration(milliseconds: 500));
  _isAnonymous = false;
  final profile = await _mockData.getUserProfile();
  _controller.add(AbbaAuthState(
    status: AuthStatus.authenticated,
    user: profile,
  ));
  return profile;
}

@override
Future<UserProfile> linkWithApple() => linkWithGoogle(); // same mock

@override
Future<UserProfile> linkWithEmail(String email, String password) async {
  await Future.delayed(const Duration(milliseconds: 500));
  _isAnonymous = false;
  final profile = UserProfile(
    id: 'user-linked',
    name: email.split('@').first,
    email: email,
  );
  _controller.add(AbbaAuthState(
    status: AuthStatus.authenticated,
    user: profile,
  ));
  return profile;
}
```

---

## 변경 2: main.dart — 앱 시작 시 익명 인증 자동

```dart
// main.dart에서 앱 시작 시:
// 1. 기존 세션이 있으면 그대로 사용
// 2. 없으면 signInAnonymously() 자동 호출

// ProviderScope 생성 후, 앱 시작 전에:
final authService = /* mock or real */;
final currentUser = await authService.getCurrentUser();
if (currentUser == null) {
  await authService.signInAnonymously();
}
```

overrides에서 authService를 먼저 생성하고, 앱 실행 전에 익명 인증 처리.
authStateProvider를 authenticated로 설정.

---

## 변경 3: Router — Login 경로 제거

### `lib/router/app_router.dart` 수정

```dart
// 변경 전:
GoRoute(path: '/login', builder: LoginView),
redirect: (context, state) {
  if (!isLoggedIn && !isAuthRoute) return '/welcome';
  if (isLoggedIn && isAuthRoute) return '/home';
},

// 변경 후:
// /login 라우트 삭제
// redirect 제거 또는 단순화:
redirect: (context, state) {
  // welcome은 첫 실행 시에만 보여줌 (SharedPreferences로 체크)
  // 이후에는 바로 /home
  return null; // 리다이렉트 없음
},
```

Welcome → "시작하기" 버튼 → 바로 `/home` (Login 건너뛰기)

### `lib/features/welcome/view/welcome_view.dart` 수정

```dart
// "시작하기" 버튼 onPressed:
// 변경 전: context.go('/login')
// 변경 후: context.go('/home')
```

---

## 변경 4: Settings에 "계정 연결" 섹션 추가

### `lib/features/settings/view/settings_view.dart` 수정

프로필 섹션 아래에 "계정 연결" 카드 추가.
`authService.isAnonymous`가 true일 때만 표시.

```dart
// 익명 유저일 때:
AbbaCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.cloud_outlined, color: AbbaColors.sage),
          SizedBox(width: AbbaSpacing.sm),
          Text(l10n.linkAccountTitle, style: AbbaTypography.h2),
        ],
      ),
      SizedBox(height: AbbaSpacing.sm),
      Text(
        l10n.linkAccountDescription,
        style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
      ),
      SizedBox(height: AbbaSpacing.md),
      // Apple 연결 버튼
      SizedBox(
        width: double.infinity,
        height: abbaButtonHeight,
        child: ElevatedButton.icon(
          icon: Icon(Icons.apple),
          label: Text(l10n.linkWithApple),
          onPressed: () => _linkAccount('apple'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AbbaColors.warmBrown,
            foregroundColor: AbbaColors.white,
          ),
        ),
      ),
      SizedBox(height: AbbaSpacing.sm),
      // Google 연결 버튼
      SizedBox(
        width: double.infinity,
        height: abbaButtonHeight,
        child: OutlinedButton.icon(
          icon: Icon(Icons.g_mobiledata),
          label: Text(l10n.linkWithGoogle),
          onPressed: () => _linkAccount('google'),
        ),
      ),
    ],
  ),
)

// 이미 연결된 유저일 때: 이 카드 안 보임
```

`_linkAccount` 메서드:
```dart
Future<void> _linkAccount(String provider) async {
  try {
    final auth = ref.read(authServiceProvider);
    if (provider == 'apple') {
      await auth.linkWithApple();
    } else {
      await auth.linkWithGoogle();
    }
    // 성공 → 프로필 업데이트
    ref.invalidate(userProfileProvider);
    if (mounted) {
      showAbbaSnackBar(context, message: l10n.linkAccountSuccess);
    }
  } catch (e) {
    if (mounted) {
      showAbbaSnackBar(context, message: l10n.errorGeneric);
    }
  }
}
```

---

## 변경 5: 프로필 표시 변경

익명 유저일 때 프로필 섹션:
- 이름: "기도하는 사람" (또는 l10n.anonymousUser)
- 이메일: 표시 안 함
- 아바타: 🙏 이모지

연결된 유저일 때:
- 이름: 실제 이름
- 이메일: 실제 이메일
- 로그아웃 버튼 표시

---

## 변경 6: ARB 키 추가

5개 언어 모두:

```
linkAccountTitle: "계정 연결" / "Link Account"
linkAccountDescription: "계정을 연결하면 기기를 변경해도 기도 기록이 유지됩니다" / "Link your account to keep prayer records when switching devices"
linkWithApple: "Apple로 연결" / "Link with Apple"
linkWithGoogle: "Google로 연결" / "Link with Google"
linkAccountSuccess: "계정이 연결되었습니다!" / "Account linked successfully!"
anonymousUser: "기도하는 사람" / "Prayer Warrior"
```

---

## 변경 7: Login 페이지 처리

`lib/features/login/view/login_view.dart` — 삭제하지 말고 유지.
라우터에서 경로만 제거. 나중에 Settings에서 이메일 연결용으로 재활용할 수 있음.

---

## 완료 조건

- [ ] 앱 시작 시 로그인 화면 없이 바로 Home
- [ ] signInAnonymously() 자동 호출
- [ ] 모든 기능 익명으로 동작 (기도, QT, 커뮤니티, 캘린더)
- [ ] 데이터 클라우드 저장 (Supabase)
- [ ] Settings에 "계정 연결" 표시 (익명일 때만)
- [ ] 계정 연결 시 데이터 병합
- [ ] `flutter analyze` 0 에러
- [ ] `flutter test` 전체 통과
- [ ] 5개 언어 ARB 동기화
