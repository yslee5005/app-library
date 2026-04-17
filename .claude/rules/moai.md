---
paths: ["**"]
---

# MoAI Prompt Template

```
[MoAI Sequential Thinking] Deep-analyze the topic below.

■ Analysis Rules
1. Deep Research via Agent (minimum 5 steps, with WebSearch)
2. Always Read target files before modifying — never rely on memory
3. Output: Problem Definition / Key Findings / Execution Plan / Expected Results
4. Include false positive check in execution plan
5. STOP here — no code modification until "실행" (execute)

■ Execution Rules (after "실행" (execute))
1. 3+ file changes → use Ralph agent
2. Explain implementation direction in 1 line before writing code
3. Run flutter analyze / next build after completion
4. Over-optimization check: "Is this really needed for MVP right now?"

■ Project Context
- Flutter (Dart 3.9+) + Next.js + Supabase
- Multi-tenant: per-app PostgreSQL schema (blacklabelled, abba)
- Anonymous-First authentication (start without login)
- flutter_dotenv runtime loading (String.fromEnvironment is forbidden)
- iOS 26: physical device → flutter run --profile required
- "계획해" (plan only) = analysis only / "실행" (execute) = code modification

■ Topic → {topic}
```
