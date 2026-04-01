# 전역 보안 규칙

## 키/시크릿 보호
- .env 파일: .gitignore ���수
- JWT Secret: 절대 클라이언트 포함 금지
- service_role key: Edge Function 환경변수만
- --dart-define으로 빌드 시 주입 (하드코딩 금지)
- 토큰 저장: flutter_secure_storage만 (SharedPreferences 금지)

## 빌드 보안
- 릴리스: `--obfuscate --split-debug-info` 필수
- HTTPS 전용
- .env.example은 실제 값 없이 제공

## 공��망 보안
- 패키지 이름 prefix: app_lib_ (Dependency Confusion 방지)
- path 의존성만 사용 (pub.dev 배포 안 함)
- pubspec.lock 커밋
- dependency_overrides 무분별 사용 금지

## Ralph 실행 중 추가 제한
- git push 금지
- rm -rf 금지
- .env 수정 금지
- DB 마이그레이션 실행 금지
- 외부 API 직접 호출 금지
- 기존 테스트 삭제 금지
