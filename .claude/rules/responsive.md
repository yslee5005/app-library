# 반응형 레이아웃 규칙

## ScreenSize 사용 필수

모든 화면은 `ScreenSize`로 분기:

```dart
final size = ScreenSize.fromWidth(MediaQuery.sizeOf(context).width);
```

## 브레이크포인트 (Material 3 Window Size Classes)

| ScreenSize | 폭 | 컬럼 | 대상 |
|------------|-----|------|------|
| compact | < 600 | 4 | 폰 세로 |
| medium | 600-839 | 8 | 폰 가로, 작은 태블릿 |
| expanded | 840-1199 | 12 | 태블릿, 소형 데스크톱 |
| large | >= 1200 | 12 | 대형 태블릿, 데스크톱 |

## 필수 규칙

### 레이아웃
- 하드코딩된 width/height 금지 → LayoutBuilder 또는 ScreenSize 사용
- compact에서 오버플로 없어야 함 (320dp 최소 지원)
- 텍스트: maxLines + overflow: TextOverflow.ellipsis 필수
- 리스트: Expanded 또는 Flexible 래핑 (unbounded height 방지)

### 패딩/마진
- ScreenSize.horizontalPadding 사용
- 하드코딩 패딩은 compact 기준으로만 (medium 이상은 ScreenSize에서 가져옴)

### 이미지
- BoxFit.cover 또는 BoxFit.contain 필수
- 가로/세로 비율 하드코딩 금지 → AspectRatio 위젯 사용

### 테스트
- 모든 화면 위젯 테스트에 최소 2개 크기 테스트:
  - compact (320 x 568)
  - medium (768 x 1024)
- 오버플로 테스트 필수 (tester.pumpWidget 후 FlutterError 체크)
