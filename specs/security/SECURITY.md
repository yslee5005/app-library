# SECURITY.md — App Library

> Version: 1.0 | Last Updated: 2026-04-01
> Status: Draft

---

## 위협 모델 요약

단일 Supabase 인스턴스에 여러 앱 데이터를 저장하는 멀티테넌트 구조이므로, **하나의 취약점이 모든 앱의 데이터를 동시에 노출**시킬 수 있다.

| 공격 표면 | 위험도 | 핵심 위협 |
|----------|--------|----------|
| A. Supabase RLS | **CRITICAL** | RLS 미설정/우회 → 전체 DB 노출 |
| B. 키/시크릿 노출 | **HIGH** | JWT Secret 유출 → 토큰 위조 |
| C. 공급망 공격 | **MEDIUM-HIGH** | 의존성 혼동, 악성 패키지 |
| D. 앱스토어 정책 | **MEDIUM** | 템플릿 앱 리젝, 계정 정지 |
| E. 리버스 엔지니어링 | **MEDIUM** | API키/로직 추출 |

---

## A. Supabase RLS 방어 (CRITICAL)

### A.1 RLS 강제 활성화
- [ ] 모든 테이블 생성 시 즉시 `ENABLE ROW LEVEL SECURITY`
- [ ] CI에 RLS 미설정 테이블 탐지 쿼리 추가:
  ```sql
  SELECT schemaname, tablename FROM pg_tables
  WHERE schemaname = 'public' AND NOT rowsecurity;
  ```
- [ ] 결과가 0이 아니면 CI 실패

### A.2 app_id 검증 강화
- [ ] RLS 정책에서 JWT app_metadata에서만 app_id 읽기
- [ ] NULL 방어 필수 적용:
  ```sql
  USING (app_id = COALESCE(
    current_setting('request.jwt.claims', true)::json->>'app_id',
    '___INVALID___'
  ))
  ```
- [ ] 클라이언트에서 전달하는 app_id 파라미터는 RLS에서 무시
- [ ] app_versions 테이블로 유효한 app_id 화이트리스트 관리

### A.3 권한 최소화
- [ ] `service_role` 키: Edge Function에서만 사용, 클라이언트 코드에 절대 포함 금지
- [ ] `anon` 역할: SELECT만 허용 (기본)
- [ ] `authenticated` 역할: INSERT/UPDATE/DELETE 허용 (본인 데이터만)
- [ ] Supabase publishable key 도입 시 마이그레이션

### A.4 감사 및 모니터링
- [ ] 비정상 접근 패턴 로깅 (Edge Function에서)
- [ ] 주기적 RLS 정책 리뷰 (분기 1회)
- [ ] 마이그레이션 적용 전 RLS 테스트 스크립트 실행

---

## B. 키/시크릿 보호 (HIGH)

### B.1 시크릿 분리
- [ ] `.env` 파일: Supabase URL + anon key (Git 제외)
- [ ] `.gitignore`에 `.env`, `*.env`, `.env.*` 추가
- [ ] JWT Secret: 절대 클라이언트에 포함 금지
- [ ] `service_role` key: Edge Function 환경변수만
- [ ] `--dart-define`으로 빌드 시 주입 (바이너리 하드코딩 방지):
  ```bash
  flutter build apk --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
  ```

### B.2 안전한 저장소
- [ ] 토큰/세션: `flutter_secure_storage` 사용 (iOS Keychain / Android Keystore)
- [ ] `SharedPreferences`: 민감 데이터 저장 금지
- [ ] JWT 만료시간: 짧게 설정 (기본 1시간, 자동 갱신)

### B.3 유출 대응
- [ ] GitHub Secret Scanning 활성화
- [ ] `.env.example` 파일 제공 (실제 값 없음)
- [ ] JWT Secret 유출 시 키 로테이션 절차 문서화
- [ ] Supabase 비대칭 JWT Signing Keys 도입 검토

---

## C. 공급망 보안 (MEDIUM-HIGH)

### C.1 Dependency Confusion 방지
- [ ] 공유 패키지 이름에 고유 prefix 사용: `app_lib_core`, `app_lib_auth` 등
- [ ] path 의존성만 사용 (pub.dev에서 패키지 설치 안 함)
- [ ] `dependency_overrides` 사용 시 리뷰 필수

### C.2 의존성 관리
- [ ] `pubspec.lock` 커밋 (버전 고정)
- [ ] 외부 패키지 버전 범위 제한 (와일드카드 금지)
- [ ] `dart pub outdated` 주기적 실행
- [ ] 신규 의존성 추가 시 라이선스 확인

### C.3 Breaking Change 방어
- [ ] 패키지 변경 시 `melos run test` 전체 실행
- [ ] core 인터페이스 변경 시 CHANGELOG 필수
- [ ] SemVer: 인터페이스 변경 = major 버전 증가

---

## D. 앱스토어 정책 대응 (MEDIUM)

### D.1 템플릿 앱 리젝 방지
- [ ] 앱별 고유 디자인 필수 (동일 UI 금지)
- [ ] 앱별 고유 콘텐츠/기능 필수
- [ ] 플레이스홀더 텍스트 제거 확인 (빌드 전 체크)

### D.2 계정 관리
- [ ] 앱별 Apple Developer / Google Play 계정 분리 권장
- [ ] 중앙 집중 계정 사용 시 브랜드 명확히 구분

### D.3 AI 생성 코드 정책
- [ ] Apple 2026 가이드라인 준수: AI 기능 명시
- [ ] 자동 생성 코드 리�� 후 제출

---

## E. 리버스 엔지니어링 방어 (MEDIUM)

### E.1 코드 난독화
- [ ] 릴리스 빌드 시 필수 적용:
  ```bash
  flutter build apk --obfuscate --split-debug-info=build/debug-info
  ```
- [ ] iOS도 동일 적용

### E.2 시크릿 보호
- [ ] 바이너리에 하드코딩되는 값: Supabase URL + anon key만 (RLS로 보호)
- [ ] 비즈니스 로직 중 핵심 부분: Edge Function으로 서버 사이드 이동 검토

### E.3 네트워크 보안
- [ ] HTTPS 전용 (Supabase 기본 제공)
- [ ] Certificate Pinning 검토 (MITM 방지)

---

## 보안 체크리스트 (배포 전)

배포 전 반드시 확인:

```
□ 모든 테이블에 RLS 활성화 확인
□ RLS 정책에 NULL 방어 (COALESCE) 적용 확인
□ .env 파일이 Git에 포함되지 않음 확인
□ service_role 키가 클라이언트 코드에 없음 확인
□ JWT Secret이 클라이언트 코드에 없음 확인
□ flutter_secure_storage로 토큰 저장 확인
□ SharedPreferences에 민감 데이터 없음 확인
□ --obfuscate 플래그로 빌드 확인
□ 다른 app_id로 데이터 접근 불가 확인 (수동 테스트)
□ dependency_overrides ���음 확인
□ pubspec.lock 커밋 확인
```
