# Showcase

App Library widget catalog demo app. Used to render and verify components from packages/ in practice.

## Domain Context

- Purpose: Not a production app. Demos widgets/features from master reference packages
- User: Developer (myself). Preview components to copy-paste into new apps
- Directly imports packages/ via path dependencies: core, theme, ui_kit, auth, comments, pagination

## App-Specific Commands

```bash
flutter run apps/showcase
```

## Notes

- Not intended for production deployment
- Used to immediately verify changes made in packages/
- Includes test dummy data in sample_data/ and mocks/
- When adding new widgets to packages/ui_kit/, add a demo page here as well
