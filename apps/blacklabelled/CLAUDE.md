# BlackLabelled

Interior design studio app. Portfolio showcase + consultation booking.

## Domain Context

- Target: Customers interested in interior design (B2C) + studio management (B2B)
- Core value: Premium portfolio + one-click consultation request
- UX principles: Dark premium theme only (`BlackLabelledTheme.darkTheme`), upscale tone
- Dual platform: Flutter app + Next.js web (`apps/blacklabelled/web/`)

## Feature Structure

```
lib/features/
├── home/           # Main (portfolio highlights)
├── portfolio/      # Portfolio gallery (photos/videos)
├── furniture/      # Furniture/materials catalog
├── consult/        # Consultation booking/request
├── mypage/         # My page
└── shell/          # App shell (navigation)
```

## App-Specific Commands

```bash
# Flutter app
flutter run apps/blacklabelled

# Next.js web (separate)
cd apps/blacklabelled/web && npm run build
cd apps/blacklabelled/web && npx vitest run
```

## Supabase Schema

- Schema name: `blacklabelled`
- Main tables: portfolios, portfolio_images, consultations, furniture_items
- Portfolio images: Uses Supabase Storage

## Notes

- Dark theme only — `themeMode: ThemeMode.dark` fixed
- Next.js web is a separate codebase (see `web/CLAUDE.md` for separate rules)
- B2B nature: Admin features are provided only on the web
