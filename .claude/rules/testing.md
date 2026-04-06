---
paths: ["packages/**", "apps/**"]
---

# 테스트 규칙

## 필수 테스트

### 패키지 (packages/)
- 모든 public API에 단위 테스트
- Result 반환 함수: success + failure 케이스 모두
- `melos test` 통과 필수

### 앱 (apps/)
- 모든 화면 위젯: 최소 1개 위젯 테스트
- 오버플로 테스트: `testOverflow()` 사용 (compact + medium)
- ViewModel: 상태 전이 테스트 (loading → data, loading → error)

## 테스트 헬퍼 사용

### 위젯 테스트
```dart
import 'package:app_lib_ui_kit/test/helpers/widget_test_helpers.dart';

// 빠른 반응형 테스트
testResponsive('MyWidget', widget: const MyWidget());

// 개별 오버플로 테스트
testOverflow('긴 텍스트 오버플로 없음',
  widget: const MyWidget(title: '매우 긴 텍스트...'),
  size: TestScreenSizes.compact,
);

// 커스텀 크기 테스트
testWidgets('태블릿 레이아웃', (tester) async {
  await tester.binding.setSurfaceSize(TestScreenSizes.expanded);
  // ...
});
```

## 테스트 네이밍
- `{기능}_test.dart` (snake_case)
- test/는 lib/src/ 구조를 미러링
- group()으로 클래스/기능별 그룹핑

## 금지 사항
- 기존 테스트 삭제 금지 (Ralph 규칙)
- sleep/delay 기반 테스트 금지 → pumpAndSettle 사용
- 테스트에서 실제 네트워크 호출 금지 → Mock 사용
