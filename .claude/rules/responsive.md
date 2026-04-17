# Responsive Layout Rules

## ScreenSize Usage Required

All screens must branch using `ScreenSize`:

```dart
final size = ScreenSize.fromWidth(MediaQuery.sizeOf(context).width);
```

## Breakpoints (Material 3 Window Size Classes)

| ScreenSize | Width | Columns | Target |
|------------|-------|---------|--------|
| compact | < 600 | 4 | Phone portrait |
| medium | 600-839 | 8 | Phone landscape, small tablet |
| expanded | 840-1199 | 12 | Tablet, small desktop |
| large | >= 1200 | 12 | Large tablet, desktop |

## Required Rules

### Layout
- Hardcoded width/height is forbidden → use LayoutBuilder or ScreenSize
- No overflow on compact (minimum 320dp support)
- Text: maxLines + overflow: TextOverflow.ellipsis required
- Lists: wrap with Expanded or Flexible (prevent unbounded height)

### Padding/Margin
- Use ScreenSize.horizontalPadding
- Hardcoded padding only for compact baseline (medium and above pulled from ScreenSize)

### Images
- BoxFit.cover or BoxFit.contain required
- Hardcoded aspect ratios forbidden → use AspectRatio widget

### Testing
- All screen widget tests must include at least 2 size tests:
  - compact (320 x 568)
  - medium (768 x 1024)
- Overflow testing required (check FlutterError after tester.pumpWidget)
