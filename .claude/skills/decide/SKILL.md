---
name: decide
description: Feature decision gate. Classify → present options → STOP before code modification. Code changes only after "실행" (execute).
---

# Decision Gate

Required process before code modification. Classify the request, present options, then STOP.

## Step 1: Collect Context

1. Read CLAUDE.md Boundaries (Always/Never/Ask First)
2. Read the target app's CLAUDE.md (apps/{app}/CLAUDE.md)
3. Read related code files (never rely on memory)
4. Check memory/ for related feedback

## Step 2: Classify

| Classification | Criteria | Examples |
|----------------|----------|----------|
| **Bug Fix** | Existing behavior is broken | Crash, error, incorrect display |
| **Feature Decision** | User behavior/experience changes | Add/remove restrictions, new UI, logic change |
| **Refactoring** | Structure only, no behavior change | File splitting, naming, pattern change |
| **Architecture** | Affects multiple apps/packages | DB schema, infra, shared code |

## Step 3: Response by Classification

### Bug Fix → 5W1H Analysis
```
Who    — Which user
When   — At what point
Where  — On which screen
What   — Doing what
How    — How it behaves
Why    — Why it is a problem
```
→ Present fix plan → **STOP**

### Feature Decision → Present Options (minimum 2)
```
Option A: [approach]
  Pros:
  Cons:
  Blast radius:

Option B: [approach]
  Pros:
  Cons:
  Blast radius:
```
→ **STOP** — Wait until user selects an option + says "실행" (execute)

### Refactoring → Scope + Risk
```
Scope: Which files
Goal: What improves
Risk: What could break
```
→ **STOP**

### Architecture → Apply CLAUDE.md "Ask First" Rule
```
Impact: Which apps/packages
Migration: Whether needed
Compatibility: Effect on existing code
```
→ **STOP**

## Step 4: STOP

**Never modify code.**

Wait until the user says one of the following:
- "실행"
- "실행해"
- "옵션 A로 실행"
- "go ahead"

## Over-Optimization Check

For every option:
- "Is this really needed for MVP right now?"
- "Can this be done later?"
- "What is the blast radius of this change?"

## Boundaries Checklist

Auto-verify before code modification:
- [ ] No Always rule violations
- [ ] No Never rule violations
- [ ] Is this an Ask First item
- [ ] Is this a security-related change (.env, keys, RLS)
