# SHARP — AI Output Quality Standards

> Drop this file into any AI agent's rules/config (Claude Code, Cursor, Codex, Copilot, Windsurf, Aider, WorkBuddy) to enforce quality across six domains.
> Full per-domain rules live in `skills/sharp-*/rules.md`. This is the condensed essentials — load more as needed.

---

## SHARP-TECH-WRITING: Technical Documentation

### Active Voice Mandate
Every action sentence uses active voice. Passive voice only when the actor is genuinely unknown.

| Banned | Correct |
|---|---|
| `The config file can be edited.` | `Edit the config file.` |
| `When clicked, a request is sent.` | `Clicking sends a request.` |

### Anti-Fluff Vocabulary
**Banned EN:** `leverage`, `utilize`, `facilitate`, `empower`, `seamless`, `robust`, `scalable`, `state-of-the-art`, `cutting-edge`, `harness the power of`
**Banned CN:** `赋能`, `打通`, `闭环`, `抓手`, `落地`, `对齐`, `拉通`, `底层逻辑`

### Information Hierarchy
Title → One-liner → Quick Start (copy-paste) → Details. Never bury the install command under paragraphs of philosophy.

### Example-First
Every concept: show the example (code block) FIRST, then explain. The example IS the explanation.

### Hard Limits
- Sentence: max 25 words (EN) / 40 chars (CN)
- Paragraph: max 4 sentences
- README Quick Start: max 3 commands
- Every code block has a language tag and is complete/runable

### Error Messages
Two-part format: (1) What happened, (2) One concrete fix action. Never "Something went wrong." Never blame the user.

---

## SHARP-DATAVIZ: Data Visualization

### Chart Type Decision
- Compare categories → Horizontal bar
- Trend over time → Line chart
- Distribution → Histogram
- Correlation → Scatter
- Part-to-whole → Stacked bar (100%)

**Banned:** 3D charts, pie charts with >5 slices, dual-axis without documented relationship, radar charts.

### Color Semantics
Every color serves exactly ONE function: Category (distinguish groups), Value (encode magnitude), or Emphasis (draw attention). Never mix.

### Chinese Stock Convention
**Red = price up (涨), Green = price down (跌).** Opposite of US convention.

### Title Must Be a Conclusion
| Banned | Required |
|---|---|
| "Revenue Over Time" | "Q3 Revenue Dropped 12% — First Decline in 2 Years" |

### Y-Axis Rule
Bar/column/area charts: Y-axis MUST start at zero. Line/scatter: non-zero OK, but add a note.

### Accessibility
Never rely on color alone. Test every chart in greyscale. Add patterns or labels.

### Clutter to Strip
Gridlines (unless reading exact values), chart borders, background fills, unnecessary decimals. Source attribution required on every chart.

---

## SHARP-COPYWRITING: Marketing & Product Copy

### Buzzword Blacklist
**Banned EN:** `elevate`, `transform`, `unleash`, `empower`, `revolutionize`, `disrupt`, `next-gen`, `seamless`, `holistic`, `synergy`, `game-changer`
**Banned CN:** `赋能`, `打通`, `闭环`, `抓手`, `一站式`, `全链路`, `全域`, `极致`, `匠心`, `降本增效`

### Specificity Mandate
Every claim needs a hook: a number, a customer name, a concrete scenario, or a before/after contrast. If you can't attach one, the claim is empty.

### The "So What" Test
Every sentence must pass: if a reader can read it and ask "so what?", it fails.

### Hero Discipline
Max 4 elements in order: Eyebrow (optional) → Headline (max 8 words) → Subhead (max 20 words) → One CTA. No feature lists, no logo walls, no multiple CTAs inside the hero.

### CTA Rules
One primary CTA per viewport. Verb phrase, not noun. Answers "what happens next?" No duplicate intent on the same page.

### Tone Calibration
Set a tone before writing: Direct / Warm / Bold / Trust / Playful. Never default to "professional-casual."

### Read-Aloud Test
If the copy sounds like a press release when read aloud, rewrite it. If it sounds like a human talking to a friend, keep it.

---

## SHARP-API-DESIGN: API Design

### Naming Consistency (Highest Priority)
- Plural nouns: `/users`, `/orders`
- No verbs in URL paths: `POST /users` not `POST /createUser`
- kebab-case for multi-word: `/shipping-addresses`
- One field naming convention: ALL camelCase or ALL snake_case. Never mix.

### Error Response Standard
Never return HTTP 200 with an error body. Standard schema:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "...",
    "details": [{ "field": "...", "reason": "...", "message": "..." }],
    "requestId": "req_..."
  }
}
```

### Pagination
Cursor-based (default): `{ "data": [...], "nextCursor": "...", "hasMore": true }`
One strategy for the ENTIRE API. Never mix cursor and offset.

### Versioning
Internal same-team: no versioning. Internal different teams: header-based. Public: URL path (`/v1/...`) or header-based.

### Idempotency
`Idempotency-Key` header required on all POST endpoints that create resources.

### Banned Patterns
- Mixing REST and RPC styles
- Inconsistent field naming
- 200 OK with error body
- Generic error messages
- Stack traces in production responses
- GET endpoints that modify state
- Nested resources beyond 2 levels

---

## SHARP-INTERVIEW: Technical Interview Design

### Question Mix by Role
| Role | Technical | System Design | Behavioral | Portfolio |
|---|---|---|---|---|
| Frontend | 30% | 20% | 30% | 20% |
| Backend | 25% | 35% | 25% | 15% |
| DevOps/SRE | 20% | 40% | 25% | 15% |
| EM | 10% | 15% | 60% | 15% |

Anti-pattern: 100% LeetCode for any role.

### Problem-Scenario Format
Every question: (1) Real-world context, (2) Specific task, (3) Constraints, (4) Success criteria. Never "Reverse a linked list" without scene.

### Scoring Rubric (4 Levels)
- 0: No attempt / Fundamentally wrong
- 1: Needs guidance
- 2: Solid — independently reaches working solution, explains reasoning
- 3: Exceptional — considers edge cases proactively, discusses trade-offs

Each level must describe what the candidate SAYS or DOES, not a vague feeling.

### Follow-Up Strategy
- Deepen: "What if 100x larger?"
- Broaden: "How would you monitor this?"
- Pivot: "What if the requirement changed to X?" (senior+ only)

### Fairness Checklist
Same questions for all candidates. No trivia (tests memory, not skill). No cultural assumptions. Time pressure only if job requires it.

### Banned Questions
Brain teasers, "greatest weakness", yes/no without follow-up, "where in 5 years".

---

## SHARP-PRESENTATION: Presentation & Slide Quality

### Three-Act Structure
- Setup (15-20%): Hook + Problem + Stakes
- Conflict (50-60%): Solution + Evidence
- Resolution (20-25%): Summary + CTA + Close

### One Slide = One Message
Every slide answers exactly ONE question. Headline is a full-sentence assertion, not a topic label.

| Banned headline | Required headline |
|---|---|
| "Q3 Revenue" | "Revenue dropped 12% in Q3 — first decline in 8 quarters" |

### Anti-Wall-of-Text
- Headline: 1 line
- Bullets: max 5, max 12 words each
- Total words on slide: max 40
- Paragraphs: BANNED on slides
- Minimum font size: 14pt

### Typography Hierarchy
Headline 28-36pt Bold → Body 16-20pt → Captions 10-14pt. Sans-serif only. One font family.

### Chart on Slides
One chart per slide. Axis labels >= 14pt. Data labels >= 12pt. Source line at bottom. Must pass the "back row test."

### Banned Patterns
- Slide 2 = Agenda (use a hook instead)
- Closing slide = "Thank You" (use contact info + memorable line)
- Stock photos of people in offices
- Paragraphs, sub-bullets, decorative animations
- Multiple charts per slide
- Fonts below 14pt

### Speaker Notes
2-4 conversational sentences per slide. Include timing cues and "so what" bridges.

---

## USAGE BY PLATFORM

| Platform | How to use |
|---|---|
| **Claude Code** | Copy `SHARP.md` to project root as `CLAUDE.md`, or copy individual `skills/sharp-*/rules.md` to `.claude/rules/` |
| **Cursor** | Copy `SHARP.md` to `.cursorrules`, or copy individual rules to `.cursor/rules/` |
| **Codex / OpenAI** | Use `SHARP.md` as a system instruction or custom rules file |
| **GitHub Copilot** | Copy relevant sections to `.github/copilot-instructions.md` |
| **Windsurf** | Copy `SHARP.md` to `.windsurfrules` |
| **Aider** | Copy `SHARP.md` to `CONVENTIONS.md` |
| **WorkBuddy** | Copy individual `skills/sharp-*/` directories to `~/.workbuddy/skills/` |

## DISCOVERY Q&A

**Q: This file is huge. Do I need all of it?**
A: No. This is the all-in-one version. For most projects, pick 2-3 domains you actually work in. The full per-domain rules are in `skills/sharp-{domain}/rules.md`.

**Q: Can I mix SHARP with taste-skill?**
A: Yes. taste-skill covers frontend visual design. SHARP covers everything else. They don't overlap — they complement.

**Q: When should I NOT use these rules?**
A: When the style your team/project uses is clearly incompatible. These are defaults, not dogma. But the anti-pattern lists (banned words, banned practices) are nearly universal.
