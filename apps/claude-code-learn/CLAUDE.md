# Claude Code Learn

An app for interactively learning how to use Claude Code.

## Domain Context

- Purpose: A learning app for step-by-step Claude Code features/workflows
- Target: Developers new to Claude Code
- Content: Markdown-based learning materials + hands-on guides

## Feature Structure

```
lib/
├── main.dart
├── app.dart
├── config/         # App configuration
├── router/         # go_router
└── features/       # Learning content screens
```

## Notes

- Uses workspace resolution (references monorepo packages)
- Markdown rendering: Uses `markdown_widget` package
- Learning progress: Stored locally with `shared_preferences`
- Does not use Supabase
