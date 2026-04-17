# Baby Letter

A parenting app that delivers developmental science through first-person letters from the baby, records without judgment, and supports triangle care (엄마+아빠+아기 삼각형 케어).

## Domain Context

- Target: Parents from pregnancy through infancy (both mom and dad)
- Core value: Non-judgmental parenting. Delivers science-based developmental information through letters from the baby's perspective
- UX principles: Emotional tone, warm first-person narration ("Mommy, I grew this much today")
- Triangle care: Balanced perspectives of mom + dad + baby
- Bundle ID: `com.ystech.babyletter`

## Feature Structure

```
lib/features/
├── onboarding/     # Progressive Profiling (pregnancy/postnatal branch, 3 questions)
├── home/           # Main — fetal growth video, baby's letter, developmental tips
├── growth/         # Growth records (weekly/monthly tracking)
├── record/         # Daily records (feeding, sleep, diapers, etc.)
├── us/             # Parent care ("Us" tab)
└── settings/       # Settings
```

## Notes

- Pregnancy vs postnatal UX is completely different — branches at onboarding
- Fetal growth videos: 47 videos (1080x1080 loop), not local assets → CDN
- Serve & Return practice guide: Scientific source citations required
- 4th Trimester preparation content: Activates after week 30

## Reference Documents

@specs/REQUIREMENTS.md
@specs/DESIGN.md
@specs/ROADMAP.md
