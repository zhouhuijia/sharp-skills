---
name: sharp-presentation
description: Presentation and slide deck quality enforcement. Covers PPT/keynote slide design, presentation narrative structure, data slide design, and public speaking materials. This skill should be used when the user asks to create, review, or improve presentation slides, pitch decks, keynote talks, or any slide-based communication. It corrects the most common AI presentation failures: walls of text, no narrative arc, unreadable chart annotations, and generic closing slides.
agent_created: true
---

# sharp-presentation: Presentation & Slide Quality

> Pitch decks, keynote talks, team presentations, project updates. Not academic lecture slides, not investor financial models (though the narrative applies), not printed reports.
> Most presentations fail before the first slide is designed — because the story was never structured. A slide deck is a narrative medium disguised as a visual one.

---

## 0. PRESENTATION TYPE INFERENCE

Before creating a single slide:

1. **What is the goal?** (Get funding? Get approval? Teach something? Inspire action?)
2. **Who is the audience?** (Executives with 5 minutes? Peers with 30 minutes? Conference audience with 45 minutes?)
3. **What is the ONE thing they should remember?** (If they forget everything else, what sticks?)
4. **What is the time limit?** (A 5-minute pitch and a 45-minute keynote have entirely different structures.)

Output a one-line read: **"Presenting to \<audience> for \<goal>, the one thing to remember is \<core message>, in \<duration>."**

---

## 1. THE PYRAMID PRINCIPLE (Mandatory Structure)

Every presentation follows this structure. Never deviate without justification.

### 1.1 The Three-Act Structure
| Act | Purpose | % of slides |
|---|---|---|
| **Setup** | Hook + problem + stakes | 15-20% |
| **Conflict** | Solution + evidence + differentiation | 50-60% |
| **Resolution** | Summary + call to action + memorable close | 20-25% |

### 1.2 Act 1: Setup
- **Slide 1: Title** — presentation title + presenter name + date. One sentence max.
- **Slide 2: The hook** — a surprising stat, a provocative question, or a relatable story. NOT an agenda slide.
- **Slide 3: The problem** — what is broken, who suffers, why it matters. Make it visceral.
- **Slide 4: The stakes** — what happens if we don't fix this. Or what opportunity we miss.

### 1.3 Act 2: Conflict
- **Slide 5: The solution** — what we built/changed/propose. One sentence, one visual.
- **Slides 6-N: Evidence** — data, case studies, demos. Each slide proves ONE point.
- Supporting slides follow the assertion-evidence pattern (Section 2).

### 1.4 Act 3: Resolution
- **Summary slide**: 3-5 bullet points max. Each is a sentence, not a fragment.
- **Call to action**: one specific ask. Not "thank you for listening."
- **Closing slide**: your contact info + one memorable line. Not just "Q&A" or "Thank You."

---

## 2. ONE SLIDE, ONE MESSAGE (The Iron Rule)

Every slide must answer exactly ONE question. If a slide tries to make two points, split it into two slides.

### 2.1 Assertion-Evidence Pattern
Every content slide has this structure:
1. **Headline** — the assertion, a full sentence (not a topic label), 1 line max
2. **Evidence** — the visual proof (chart, diagram, screenshot, quote)
3. **Annotation** — 1-2 lines of context ONLY if the visual doesn't speak for itself

```
BAD headline:  "Q3 Revenue"
GOOD headline: "Revenue dropped 12% in Q3 — first decline in 8 quarters"
```

### 2.2 Headline Rules
- **Always a full sentence**, never a noun phrase
- **Max 1 line**, never wraps
- **Font size**: 28-36pt for slide headlines, larger than body text
- **States a finding**, not a topic

---

## 3. TYPOGRAPHY HIERARCHY

### 3.1 The Four-Level System
| Level | Use | Font Size | Weight |
|---|---|---|---|
| **H1** | Slide headline | 28-36pt | Bold |
| **H2** | Section divider within slide | 20-24pt | Semibold |
| **Body** | Bullets, paragraphs, annotations | 16-20pt | Regular |
| **Caption** | Source lines, footnotes, data labels | 10-14pt | Regular |

### 3.2 Minimum Font Size
**14pt is the absolute minimum** for any text that must be read. If you need smaller text, you have too much content on one slide.

### 3.3 Font Choice
- **Sans-serif for presentations.** Serif fonts are harder to read on projected screens.
- **One font family** for the entire deck. Body and headline can differ but must pair well.
- Default: system fonts (Arial/Helvetica on presentations that will travel). For branded decks, use the brand font.

---

## 4. THE ANTI-WALL-OF-TEXT RULES

### 4.1 Content Limits Per Slide
| Element | Hard Maximum |
|---|---|
| Headline | 1 line |
| Bullet points | 5 items |
| Words per bullet | 12 |
| Total words on slide (excluding captions) | 40 |
| Paragraphs | BANNED entirely |

### 4.2 Bullet Point Rules
- Each bullet is a **sentence fragment** or **short sentence**, never a paragraph
- Bullets must be **grammatically parallel** (all start with verbs, or all start with nouns, etc.)
- Bullets are **spoken cues**, not reading material — the audience should listen to you, not read slides
- **No sub-bullets.** If you need sub-bullets, split the slide.

### 4.3 The Squint Test
Step back from the screen and squint. If the slide looks like a grey rectangle (wall of text), it fails. You should see visual hierarchy — a bold headline, distinct shapes for evidence, negative space.

---

## 5. CHART & DATA SLIDE RULES

For any slide containing a chart, apply these rules ON TOP of the sharp-dataviz skill:

### 5.1 Chart Annotation Size
- **Axis labels**: minimum 14pt
- **Data labels**: minimum 12pt, only on the most important data points (max 3 per chart)
- **Source line**: minimum 10pt, bottom of slide

### 5.2 One Chart Per Slide
Do not put two charts on the same slide. Each chart needs room to breathe and a single message to convey. If you need to compare two charts, use two slides or a side-by-side layout with large enough fonts.

### 5.3 The "Back Row Test"
Everything on the slide must be readable from the back of the room. Assume the screen is 1/4 the size you're designing on. If a data label is barely readable on your laptop at 100%, it will be invisible in a conference room.

---

## 6. VISUAL DESIGN DISCIPLINE

### 6.1 Consistency Locks
- **Color palette**: max 3 colors (1 primary, 1 accent, 1 neutral). Applied to ALL slides.
- **Background**: solid white or solid dark. No gradients as slide backgrounds.
- **Alignment**: every element aligns to a grid. No free-floating elements.
- **Image treatment**: all images on the deck use the same corner radius, shadow style, and border.

### 6.2 Image Rules
- **Full-bleed or framed.** Nothing in between — an image either fills the slide edge-to-edge or sits in a defined frame with consistent padding.
- **No low-resolution images.** If it looks pixelated on your screen at 100%, it's unusable.
- **No clip art or generic stock photos** of people shaking hands. Use abstract/symbolic visuals or real photography.

### 6.3 White Space
Every slide must have at least 20% white space (empty area). White space is not wasted — it directs attention to what matters.

---

## 7. SPECIAL SLIDE TYPES

### 7.1 Agenda Slide (Use Sparingly)
- Use ONLY for presentations longer than 20 minutes
- Max 4 items, each a verb phrase
- Highlight the current section when used as a section divider
- **Never** as slide 2 in a pitch deck — the hook goes there

### 7.2 Quote Slide
- One quote per slide
- Quote text: 24-32pt, italic or distinct style
- Attribution: name + title + company, 14-16pt below the quote
- Use typographic (curly) quotes: " " not " "

### 7.3 Transition Slide (Section Divider)
- Section number + title (e.g., "02 / Market Opportunity")
- One line only
- Consistent style across all section dividers
- Optional: one-line preview of what's coming

### 7.4 Closing Slide
- Presenter name + title + email/LinkedIn
- One memorable line (reiterate the core message)
- Optional: QR code for resources
- **Never**: just "Q&A" or "Thank You" with nothing else

---

## 8. NARRATIVE FLOW BETWEEN SLIDES

### 8.1 The Verbal Transition
After every 3-5 slides, plan a verbal transition sentence. This connects the previous section to the next one.

```
"Now that we've seen the scope of the problem, let me show you what we built."
"The data makes the case. But what does this look like in practice?"
```

### 8.2 Pacing
- **Average 1-2 minutes per slide** for a presentation with speaking
- **Faster is fine** for simple slides (quotes, divider slides)
- **Slower for data slides** — give the audience time to absorb the chart

### 8.3 The "So What" Bridge
After every evidence slide, have a verbal (not written) bridge that answers "so what?" The slide shows the data. YOU explain what it means.

---

## 9. BANNED PATTERNS (AI Tells)

- **Slide 2 = Agenda** — this is the most common AI presentation cliche. Replace with a hook.
- **Closing slide = "Thank You"** — wastes the most valuable real estate in the deck.
- **Paragraphs on slides** — if it's more than one line, it belongs in your speaker notes.
- **Sub-bullets** — if your hierarchy goes deeper than one level, restructure the information.
- **"Questions?" as the only closing content**
- **Stock photos of people shaking hands / staring at laptops / pointing at whiteboards**
- **Full sentences as bullet points** — bullets are cues, not scripts
- **3D charts** — always distort perception
- **Decorative animations** — slide transitions and element animations with no narrative purpose
- **Fonts below 14pt** anywhere on the slide
- **Multiple charts on one slide**
- **Low-contrast text** — grey text on white background that fails accessibility checks
- **"Key Takeaways" slide with 10+ items** — if everything is key, nothing is

---

## 10. SPEAKER NOTES

Speaker notes are part of the deliverable. For each slide:
- Write 2-4 sentences of what to say while this slide is shown
- Write in conversational tone, not scripted prose
- Include the "so what" bridge for evidence slides
- Mark timing cues: "[2 min]" at the start of longer explanations

---

## 11. PRE-FLIGHT CHECKLIST

- [ ] **Presentation type declared**: audience, goal, core message, duration?
- [ ] **Three-act structure**: setup → conflict → resolution, with proper slide counts?
- [ ] **Every headline** is a full-sentence assertion, not a topic label?
- [ ] **One message per slide**: no slide trying to make two points?
- [ ] **Wall-of-text check**: every slide has <= 40 words, <= 5 bullets, zero paragraphs?
- [ ] **Font size**: nothing below 14pt, headlines 28-36pt?
- [ ] **Chart check**: one chart per slide, labels >= 14pt, source attributed?
- [ ] **Squint test**: every slide shows clear visual hierarchy when squinted at?
- [ ] **White space**: >= 20% empty area on every slide?
- [ ] **Consistency**: one color palette, one font family, one image treatment?
- [ ] **Closing slide**: contact info + memorable line, not just "Thank You"?
- [ ] **Speaker notes**: written for every slide, conversational tone?
- [ ] **No banned patterns** from Section 9?
- [ ] **Pacing**: slide count appropriate for the stated duration?

---

## 12. OUT OF SCOPE

This skill is NOT for:
- Printed reports or documents (different medium, different rules)
- Academic lecture slides (conventions differ significantly)
- Investor financial models (the spreadsheet, not the deck)
- Video scripts or teleprompter text
- Social media carousels or infographics
