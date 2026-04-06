---
paths: ["packages/**", "apps/**"]
---

# 에러 처리 규칙

## 30가지 에러 유형 방어 체크리스트

모든 패키지/앱 코드는 아래 규칙을 따릅니다.

## A. 빌드 타임

- `melos analyze` 통과 필수 (strict 린트)
- freezed/json_serializable 모델은 `melos build_runner` 후 커밋
- .env 키는 `EnvValidator.validate()`로 앱 시작 시 검증
- `AppEnvironment.fromString()`으로 환경 분기

## B. 런타임

### 예외 처리
- 모든 예외는 `AppException` 서브클래스 사용 (throw Exception 금지)
- 네트워크 호출은 반드시 try-catch + `NetworkException`
- DB 호출은 반드시 try-catch + `DatabaseException`
- catch(e)에서 `rethrow` 또는 `AppException`으로 래핑 (삼키기 금지)

### Result 패턴
- Repository 반환값: `Result<T>` 사용 권장
- ViewModel에서 `result.when(success: ..., failure: ...)` 패턴

### 상태 관리
- AsyncNotifier 사용 시 AsyncValue의 loading/error/data 3가지 상태 모두 처리
- `ref.watch()` 결과를 `.when()` 으로 분기 (error 무시 금지)

### 권한
- 카메라/위치/알림 사용 전 권한 체크 + 거부 시 안내 UI
- `permission_handler` 패키지는 앱 레벨에서만 사용 (core/에 넣지 않음)

## C. UI/UX

### 3가지 상태 필수
모든 데이터 표시 화면은 반드시 3가지 상태 구현:
- **Loading**: `SkeletonLoader` 또는 `CircularProgressIndicator`
- **Error**: `ErrorStateView` + retry 버튼
- **Empty**: `EmptyStateView` + 안내 메시지

### 오버플로 방지
- `Text` 위젯: `maxLines` + `overflow: TextOverflow.ellipsis`
- 리스트: `Expanded` 또는 `Flexible` 래핑
- 긴 컨텐츠: `SingleChildScrollView` 래핑
- 하드코딩 width/height 금지 → `ScreenSize` 사용

### 디자인 일관성
- 색상: `Theme.of(context).colorScheme` 사용 (하드코딩 금지)
- 간격: 8의 배수 (8, 16, 24, 32)
- 폰트: `Theme.of(context).textTheme` 사용

## D. 데이터/백엔드

- Supabase 호출은 반드시 `AppSupabaseClient` 경유 (app_id 자동 스코핑)
- RLS 정책: COALESCE + app_id 필터 필수
- freezed 모델과 Supabase 스키마 일치 확인
- nullable 필드는 모델에서도 nullable 선언

## E. 배포

- 릴리스 빌드: `--obfuscate --split-debug-info` 필수
- `AppEnvironment.prod`에서 verbose 로그 비활성화 확인
- 피처 플래그: 새 기능은 `FeatureFlag`로 래핑 후 점진적 활성화
