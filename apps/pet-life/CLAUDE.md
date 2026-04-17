# Pet Life

An app that speaks on behalf of your dog — life journey, health insights, daily routines.

## Domain Context

- Target: Dog owners (beginners to experienced)
- Core value: "This app becomes your dog's voice" — concept where the dog speaks
- UX principles: Dark premium background (#1C1C2E), Lottie character animations, emotional speech bubbles
- Breed-specific customization: 130-breed database, breed-based optimal weight/walk recommendations

## Feature Structure

```
lib/features/
├── onboarding/     # Dog registration (name, breed, birthdate, weight, routines)
├── home/           # Hero character + status speech bubble + mini timeline
├── records/        # Daily log (walks, meals, health checks)
├── analysis/       # Health insights/analysis (weight trends, activity levels)
├── guide/          # Breed-specific guide (walks, nutrition, health)
└── settings/       # Settings
```

## Notes

- Local-first app: Currently not using Supabase, uses SharedPreferences + local models
- Lottie animations required: Different animations per character state
- Dog status messages: Happy/walk request/hungry/sad/warning — tone is first-person from the dog's perspective
- Breed data: Local JSON (130 breeds, includes optimal weight/walk distance/lifespan)
- Daily routines: Default recommendations + user customization available

## Reference Documents

@specs/REQUIREMENTS.md
