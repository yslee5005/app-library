# Abba

Prayer (기도) / QT (묵상) AI companion app. Helps senior Christians aged 50-70 build a daily prayer habit.

## Domain Context

- Target: Christians aged 50-70 (worldwide), secondary target all-age Christians
- Core value: Pray and AI responds with Scripture + personalized feedback
- UX principles: Start with one button, complete in 3 taps. Senior-friendly (large text, simple flow)
- Multilingual: 35 languages supported (l10n). English default, Korean simultaneously supported
- Tone: Warm and reverent language. Minimize technical jargon

## Feature Structure

```
lib/features/
├── welcome/        # Onboarding (Anonymous-First → straight to Home)
├── home/           # Main dashboard
├── qt/             # QT (Quiet Time) feature — AI Scripture meditation (묵상)
├── recording/      # Prayer recording/input
├── ai_loading/     # AI response generation loading UX (lazy loading)
├── calendar/       # Prayer calendar (streaks, history)
├── history/        # Prayer history
├── dashboard/      # Statistics/growth dashboard
├── community/      # Instagram-style community + report email
├── my_page/        # Profile, account linking
├── settings/       # Notification settings, language change
└── login/          # Account linking only (not required)
```

## Supabase Schema

- Schema name: `abba`
- Main tables: prayers, qt_sessions, prayer_responses, community_posts, reports
- AI responses are generated via Supabase Edge Functions

## Notes

- AI loading uses lazy loading pattern — feels like instant response to the user
- Premium UX: Core features available without subscription; premium expands AI usage limits
- Community reporting: Email-based (no in-app admin panel)
- Calendar redesign completed (as of v1.0)

## Reference Documents

@specs/REQUIREMENTS.md
@specs/DESIGN.md
