# Ralph — Pet Life App Implementation

## Context
You are Ralph working on **app-library** monorepo.
Build the Pet Life app at `apps/pet-life/`.
Read `apps/pet-life/specs/REQUIREMENTS.md` for full requirements.
Read `CLAUDE.md` for project rules.
Read `.claude/rules/flutter-layout.md` for layout rules.

The app concept: **"말 못하는 반려견의 상태를 대변하는 앱"**

## Tech Stack
- Flutter, go_router, shared_preferences, lottie, share_plus, intl
- App Library packages: core, theme, ui_kit, cache, notifications, l10n
- Design: dark premium (#1C1C2E background, #D4A574 amber accent)
- Data: breed_database.json (130 breeds) in assets/data/

## CRITICAL: Do NOT use Lottie files that don't exist
Since we don't have actual Lottie JSON files yet, use PLACEHOLDER widgets for dog animation:
```dart
// Placeholder for dog character — will be replaced with Lottie later
Container(
  width: 150, height: 150,
  decoration: BoxDecoration(
    color: Color(0xFFD4A574).withOpacity(0.2),
    borderRadius: BorderRadius.circular(75),
  ),
  child: Icon(Icons.pets, size: 60, color: Color(0xFFD4A574)),
)
```

## Checklist — Build in Order

### Phase 1: App Structure + Data Layer
- [ ] Create app structure: config/, router/, features/, models/, services/
- [ ] Implement PetProfile model (name, breed, birthDate, weightKg, neutered, routines)
- [ ] Implement DailyRoutine model (id, name, icon, goalPerDay, streak)
- [ ] Implement DailyLog model (date, routineId, completed, time)
- [ ] Implement BreedDataService — loads breed_database.json + breeds_tier2-4.json from assets
- [ ] Implement PetStorageService — save/load PetProfile and DailyLogs using shared_preferences
- [ ] Implement DogStateService — determines dog mood based on logs (happy/sad/sleeping/hungry/bored)
- [ ] Implement LifeCalculator — remaining days, remaining walks, human age, life percentage
- [ ] Git commit: "feat: pet-life data layer — models and services"

### Phase 2: Onboarding
- [ ] Create features/onboarding/ with 3 steps
- [ ] Step 1: Pet info (name, breed search/select, birth date, weight)
  - Breed search: TextField that filters breed list from JSON
  - Show breed info when selected (lifespan, size, exercise needs)
- [ ] Step 2: Daily routine setup
  - Toggle cards for routines (walk AM/PM, meal AM/PM, teeth, meds)
  - Breed-based recommendation text at bottom
  - [+ 직접 추가] button
- [ ] Step 3: Summary + start
- [ ] Save to shared_preferences on complete
- [ ] Navigate to main home after onboarding
- [ ] Git commit: "feat: pet-life onboarding — breed select + routine setup"

### Phase 3: Main Home Screen
- [ ] Create features/home/ with HomeView
- [ ] Top bar: pet name left + streak badge right
- [ ] Hero section: glassmorphism card with dog placeholder + speech bubble
  - Speech bubble text from DogStateService
  - States: happy, wants_walk, hungry, sad, sleeping, bored, very_happy
- [ ] Life journey mini timeline:
  - Horizontal bar: Born●━━●━━●━━🐕━●━━○━━○
  - Past = amber, future = gray, current = paw icon with glow
  - Show "XX% 경과" text
  - CustomPaint or Row of widgets
- [ ] Routine section: horizontal PageView of routine cards
  - Each card: icon + name + streak fire + complete button
  - Tap complete → update log → dog reacts → streak increments
  - Page indicator dots below
- [ ] Daily insight card: rotating health facts from breed data
- [ ] Bottom nav: 4 tabs (Home/Analysis/Guide/Settings) with XP bar above
- [ ] Git commit: "feat: pet-life main home — dog state + journey timeline + routine cards"

### Phase 4: Analysis Page
- [ ] Create features/analysis/ with AnalysisView
- [ ] Life Journey Timeline (full vertical scroll):
  - Past milestones (amber): birth, socialization, adult, senior
  - Current position (glowing): age, human age, remaining days
  - Future warnings (gray): health risks by age from breed data
  - Emotional message at bottom + share button
- [ ] Time tab: remaining days card, remaining walks, human age, life progress ring
- [ ] Health tab: breed-specific disease risk cards with severity colors
  - Red = critical, orange = high, yellow = moderate
  - Each card shows: condition, prevalence %, severity, source
  - Tap → detail page with prevention tips + citation
- [ ] Record tab: monthly routine completion chart (simple bar chart)
- [ ] Git commit: "feat: pet-life analysis — journey timeline + health dashboard"

### Phase 5: Guide + Settings
- [ ] Create features/guide/ — age-based health checklist, vaccination schedule
- [ ] Create features/settings/ — edit routines, edit pet info, dark mode, language
- [ ] Add notification scheduling for routine reminders
- [ ] Git commit: "feat: pet-life guide + settings"

### Phase 6: Polish
- [ ] Theme: dark premium with ThemeConfig(seedColor: Color(0xFFD4A574))
- [ ] All glassmorphism cards: Container with semi-transparent background + blur
- [ ] Streak animation when completing a routine
- [ ] Dog speech bubble changes based on time of day + completion status
- [ ] flutter analyze — 0 errors
- [ ] Git commit: "feat: pet-life polish — theme, animations, final touches"

## Data Flow
```
breed_database.json → BreedDataService → breed info
PetProfile (shared_prefs) → LifeCalculator → remaining days, walks
DailyLog (shared_prefs) → DogStateService → dog mood/speech
DogState + LifeCalc → HomeView → display
```

## Design Specs
- Background: #1C1C2E
- Accent: #D4A574 (amber)
- Cards: glassmorphism (Colors.white.withOpacity(0.08) + 1px white border 0.1 opacity)
- Text: white, amber, Colors.white70
- Border radius: 24px
- Bottom nav: with thin XP bar above

## Glassmorphism Card Pattern
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.08),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withOpacity(0.1)),
  ),
  child: ...
)
```

## Layout Rules
- NEVER use ListView inside another scrollable
- Forms: SingleChildScrollView + Column
- Use CustomScrollView with Slivers for complex scrolling
- Main home: SingleChildScrollView wrapping Column

### Phase 7: Unit Tests + Flow Tests
- [ ] Create test/models/ — PetProfile, DailyRoutine, DailyLog model tests
  - Construction, serialization (toJson/fromJson), edge cases
- [ ] Create test/services/life_calculator_test.dart
  - Remaining days calculation (breed median lifespan - current age)
  - Remaining walks (remaining days × walks per day)
  - Human age conversion (16 × ln(dog_age) + 31)
  - Life percentage (current age / median lifespan × 100)
  - Edge cases: newborn puppy (0 days), very old dog (past median)
- [ ] Create test/services/dog_state_test.dart
  - Returns happy when all routines completed today
  - Returns wants_walk when walk not done and hour > 10
  - Returns sad when no routines done for 3+ days
  - Returns sleeping when hour is 22-6
  - Returns very_happy when perfect day streak > 0
  - Returns bored when walk not done for 3+ days
- [ ] Create test/services/breed_data_test.dart
  - Loads breed database JSON correctly
  - Finds breed by ID
  - Returns genetic health risks for known breed
  - Returns empty risks for unknown breed
  - Returns "limited" data_confidence for rare breeds
- [ ] Create test/services/pet_storage_test.dart
  - Save and load PetProfile
  - Save and load DailyLog
  - Streak calculation: consecutive days count
  - Streak reset when day missed
  - Streak freeze: doesn't reset when freeze active
- [ ] Create test/flow/onboarding_flow_test.dart (widget test)
  - Can select breed from list
  - Can enter name, age, weight
  - Can toggle routines on/off
  - Completing onboarding saves profile
  - Navigates to home after completion
- [ ] Create test/flow/routine_completion_flow_test.dart (widget test)
  - Tapping routine card marks it complete
  - Completion updates streak count
  - Completion changes dog state/speech
  - All routines complete → "완벽한 하루" state
- [ ] Run all tests: `flutter test` — ALL PASS
- [ ] Git commit: "test: pet-life unit tests + flow tests — all passing"

## Protected Files
- .ralph/, .ralphrc, packages/, specs/, templates/
- breed_database.json and tier files (already created, just READ them)

## Boundaries
### Always
- Dark theme throughout
- Korean text for UI labels
- Every health stat shows source citation
- flutter analyze after each phase
- Git commit after each phase
### Never
- git push, rm -rf
- Modify any packages/ code
- Use real Lottie files (use placeholder)
- Connect to any backend
- Hardcode colors (use theme or constants)

## Status Reporting
```
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: NOT_RUN
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false | true
RECOMMENDATION: <one line>
---END_RALPH_STATUS---
```
When ALL phases done → EXIT_SIGNAL: true, STATUS: COMPLETE.
