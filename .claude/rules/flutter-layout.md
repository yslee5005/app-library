---
paths: ["packages/ui_kit/**", "apps/**"]
---

# Flutter 레이아웃 규칙 (필수 준수)

## ListView / GridView 사용 규칙
- ListView/GridView는 **반드시 높이가 제한된 부모** 안에서만 사용
- Scaffold body에서 직접 사용: ✅ OK (Scaffold가 높이 제한함)
- Column/Row/다른 스크롤 위젯 안에서 사용: ❌ 금지 (unbounded height 에러)
- 불가피하면 `shrinkWrap: true` + `NeverScrollableScrollPhysics()` 사용
- **폼 위젯은 ListView 대신 SingleChildScrollView + Column 사용**

## 중첩 스크롤 금지 패턴
```dart
// ❌ 금지: ListView 안에 ListView
ListView(children: [ListView(...)]) // → unbounded height 크래시

// ✅ 올바른 방법 1: shrinkWrap
ListView(children: [
  ListView(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), ...)
])

// ✅ 올바른 방법 2: CustomScrollView + SliverList
CustomScrollView(slivers: [SliverList(...), SliverList(...)])

// ✅ 올바른 방법 3: SingleChildScrollView + Column (폼에 적합)
SingleChildScrollView(child: Column(children: [...]))
```

## 반응형 레이아웃 규칙
- 고정 width/height 사용 자제 → Expanded, Flexible, FractionallySizedBox 사용
- 화면 너비 참조: `MediaQuery.sizeOf(context).width`
- 이미지: BoxFit.cover 또는 BoxFit.contain 사용 (overflow 방지)
- 텍스트: maxLines + overflow: TextOverflow.ellipsis 항상 고려

## 위젯 크기 규칙
- 부모가 unbounded면 자식에게 명시적 크기 제공
- Expanded는 Flex(Row/Column) 안에서만 사용
- AspectRatio로 비율 고정 시 부모의 cross-axis가 bounded인지 확인

## SafeArea
- 최상위 Scaffold에서 SafeArea 사용 (노치/홈인디케이터 대응)
- 중첩 SafeArea 금지 (padding 중복)

## 성능
- 긴 리스트: ListView.builder 사용 (ListView(children:[]) 금지)
- const 생성자 최대한 사용
- RepaintBoundary: 자주 변경되는 위젯에 감싸기
