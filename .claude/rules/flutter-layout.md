---
paths: ["packages/ui_kit/**", "apps/**"]
---

# Flutter Layout Rules (Must Follow)

## ListView / GridView Usage Rules
- ListView/GridView must **only be used inside a parent with bounded height**
- Direct use in Scaffold body: OK (Scaffold bounds height)
- Inside Column/Row/another scroll widget: forbidden (unbounded height error)
- If unavoidable, use `shrinkWrap: true` + `NeverScrollableScrollPhysics()`
- **Form widgets should use SingleChildScrollView + Column instead of ListView**

## Nested Scroll Prevention Patterns
```dart
// ❌ forbidden: ListView inside ListView
ListView(children: [ListView(...)]) // → unbounded height crash

// ✅ correct approach 1: shrinkWrap
ListView(children: [
  ListView(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), ...)
])

// ✅ correct approach 2: CustomScrollView + SliverList
CustomScrollView(slivers: [SliverList(...), SliverList(...)])

// ✅ correct approach 3: SingleChildScrollView + Column (suitable for forms)
SingleChildScrollView(child: Column(children: [...]))
```

## Responsive Layout Rules
- Avoid fixed width/height → use Expanded, Flexible, FractionallySizedBox
- Reference screen width: `MediaQuery.sizeOf(context).width`
- Images: use BoxFit.cover or BoxFit.contain (prevent overflow)
- Text: always consider maxLines + overflow: TextOverflow.ellipsis

## Widget Sizing Rules
- If parent is unbounded, provide explicit size to children
- Expanded must only be used inside Flex (Row/Column)
- When fixing ratio with AspectRatio, verify parent's cross-axis is bounded

## SafeArea
- Use SafeArea in the top-level Scaffold (handles notch/home indicator)
- Nested SafeArea is forbidden (causes padding duplication)

## Performance
- Long lists: use ListView.builder (ListView(children:[]) is forbidden)
- Maximize const constructor usage
- RepaintBoundary: wrap frequently changing widgets
