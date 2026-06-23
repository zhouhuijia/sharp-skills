---
name: sharp-tech-writing
description: Technical writing quality enforcement. Covers README files, API documentation, developer guides, changelogs, and error messages. This skill should be used when the user asks to write, review, or improve technical documentation. It corrects the most common AI writing failures: passive-voice bloat, missing concrete examples, filler vocabulary, and information hierarchy collapse.
---

# sharp-tech-writing: Technical Documentation Quality

> README, API docs, developer guides, changelogs, error messages. Not marketing copy, not user manuals for non-technical audiences.
> Every rule is contextual. First read the output type, then pull only what fits.

---

## 0. DOCUMENT TYPE INFERENCE

Before touching text, infer what is being written:

1. **README** — first-impression doc for a repo. Must answer "what is this, why should I care, how do I start" in under 30 seconds of scanning.
2. **API Reference** — endpoint-by-endpoint spec. Must be scannable, predictable, complete. The reader is already using the API and needs to find one thing fast.
3. **Developer Guide** — tutorial-style, ordered by learning path. Must work end-to-end when copy-pasted.
4. **Changelog** — chronological, versioned. Must separate breaking changes from features from fixes.
5. **Error Message** — one-sentence diagnostic + one concrete fix action. Must not blame the user.

Output a one-line doc-type read before generating: **"Writing this as: \<type> for \<reader profile>, with \<tone>."**

---

## 1. THE FOUR PILLARS (Non-Negotiable)

### 1.1 Active Voice Mandate

Every sentence that describes an action MUST use active voice. Passive voice is permitted ONLY when the actor is genuinely unknown or irrelevant.

| Banned | Correct |
|---|---|
| `The configuration file can be edited by the user.` | `Edit the configuration file.` |
| `When the button is clicked, a request is sent.` | `Clicking the button sends a request.` |
| `Errors should be handled by the caller.` | `The caller must handle errors.` |

**Audit rule:** grep for `can be`, `should be`, `is done`, `are made`, `has been`. Replace every instance unless the actor is truly unknown.

### 1.2 Example-First Structure

Every concept explanation follows this order:
1. **Example** (code block or concrete scenario)
2. **What it does** (one sentence)
3. **When to use it** (one sentence, optional)
4. **Caveats** (one sentence, optional)

Never explain a concept in prose first and then attach an example. The example IS the explanation.

### 1.3 Anti-Fluff Vocabulary

The following words and phrases are banned in technical writing (unless they appear in code or quoted output):

**English banned list:**
`leverage`, `utilize`, `facilitate`, `empower`, `seamless`, `robust`, `scalable`, `state-of-the-art`, `cutting-edge`, `best-in-class`, `world-class`, `industry-leading`, `in today's fast-paced`, `harness the power of`, `unlock the potential of`

**Chinese banned list:**
`赋能`, `打通`, `闭环`, `抓手`, `赋能`, `落地`, `对齐`, `拉通`, `倒逼`, `反哺`, `深度绑定`, `底层逻辑`

**Replacement rule:** When you find yourself reaching for one of these, ask "what specifically does this mean?" and write THAT instead.

### 1.4 Information Hierarchy

- **Title** — what is this thing (noun phrase, max 5 words)
- **One-liner** — what problem it solves (max 1 sentence)
- **Quick start** — copy-paste to working state (max 3 commands)
- **Details** — everything else, organized by heading

A README that buries the install command under 3 paragraphs of philosophy is a failed README.

---

## 2. STRUCTURAL RULES BY DOC TYPE

### 2.1 README

| Section | Mandatory? | Max Length |
|---|---|---|
| Title + One-liner | Yes | 2 lines |
| Badges | Optional | 1 line |
| Quick Start | Yes | 5-10 lines |
| What/Why | Yes | 3-5 sentences |
| API / Usage | Yes | Scoped to top 3 use cases |
| Install | Yes | OS-specific if needed |
| Contributing | Optional | Link preferred |
| License | Yes | 1 line |

**Banned in README:**
- Feature lists longer than 6 items
- Logo bigger than 200px wide
- Philosophy essays
- "Star us on GitHub!" callouts

### 2.2 API Reference

Every endpoint MUST document:
1. **Method + Path** — one line
2. **Description** — one sentence, what it does
3. **Request** — headers, path params, query params, body (with example)
4. **Response** — status code + body example (success AND error)
5. **Errors** — specific codes and what they mean

**One endpoint per section.** Do not merge multiple endpoints into one block.

### 2.3 Developer Guide

- Ordered by the reader's learning path, not by the codebase structure
- Every code block must be copy-paste runnable
- Every prerequisite must be stated before the step that needs it
- "You should see..." after every runnable step confirms success

### 2.4 Changelog

Format: `## [version] - YYYY-MM-DD`

Categories in fixed order:
- **Breaking** — what changed and migration steps
- **Added** — new features
- **Fixed** — bug fixes
- **Deprecated** — what will be removed and when

### 2.5 Error Messages

Every error message has exactly two parts:
1. **What happened** (one sentence, technical but human-readable)
2. **What to do** (one concrete action, not "check your configuration")

```
BAD:  "Error: Invalid configuration."
GOOD: "Config file at ./app.json is missing the 'port' field. Add \"port\": 3000 to the file."
```

---

## 3. SENTENCE & PARAGRAPH DISCIPLINE

### 3.1 Hard Limits
- **Sentence:** max 25 words (English), max 40 characters (Chinese)
- **Paragraph:** max 4 sentences
- **Code block intro:** max 1 sentence
- **Section intro:** max 2 sentences before the first code block or list

### 3.2 Paragraph Structure
Every paragraph starts with the conclusion, then elaborates. Never bury the point in the third sentence.

```
BAD:  "When working with the authentication module, developers often encounter
       situations where tokens expire. In these cases, it is recommended to
       implement a refresh mechanism. You should use the refreshToken method."

GOOD: "Call refreshToken() when the auth token expires. Pass the expired token
       as the first argument. The method returns a new token valid for 24 hours."
```

---

## 4. CODE BLOCK RULES

- Every code block has a language tag: ```python not ```
- Every code block is preceded by one sentence stating what it does
- Code blocks are complete and runnable — no `...` or `// your code here` placeholders
- Import statements are included unless the reader is clearly already in the same module
- Shell commands use `$` prompt prefix for readability

---

## 5. CROSS-REFERENCING

- Link to other sections within the same doc: `[Section Name](#section-name)`
- Link to external docs: full URL, no bare domain names
- Never write "see documentation" without a link
- Never write "refer to the official docs" without specifying which page

---

## 6. PRE-FLIGHT CHECKLIST

Before delivering any technical document:

- [ ] **Doc type** declared at the top?
- [ ] **Active voice** audit: zero `can be` / `should be` / `is done` (unless justified)?
- [ ] **Example-first** structure: every concept has a code example before prose?
- [ ] **Fluff audit**: zero banned words from Section 1.3?
- [ ] **Sentence length**: all under 25 words (EN) / 40 chars (CN)?
- [ ] **Paragraph length**: all 4 sentences or fewer?
- [ ] **Quick start**: copy-paste runnable in under 3 commands?
- [ ] **Code blocks**: all have language tags, all are complete, all are introduced?
- [ ] **Links**: all cross-references are actual links, not bare mentions?
- [ ] **Error messages** (if applicable): cause + fix, not blaming the user?

---

## 7. OUT OF SCOPE

This skill is NOT for:
- Marketing copy or landing pages (use sharp-copywriting)
- User-facing UI text
- Tutorial blog posts for beginners
- Academic or research papers
- Legal or compliance documents
