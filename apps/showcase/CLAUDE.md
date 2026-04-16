# Showcase

App Library 위젯 카탈로그 데모 앱. packages/ 의 컴포넌트를 실제로 렌더링해서 확인하는 용도.

## 도메인 컨텍스트

- 목적: 실제 앱이 아님. 마스터 레퍼런스 패키지의 위젯/기능 데모
- 사용자: 개발자 (본인). 새 앱에 복붙할 컴포넌트를 미리 확인
- packages/ 를 직접 import (path 의존성): core, theme, ui_kit, auth, comments, pagination

## 앱 고유 명령어

```bash
flutter run apps/showcase
```

## 주의사항

- 프로덕션 배포 대상 아님
- packages/ 의 변경사항을 즉시 반영해서 확인하는 용도
- sample_data/와 mocks/에 테스트용 더미 데이터 포함
- 새 위젯을 packages/ui_kit/에 추가하면 여기에도 데모 페이지 추가
