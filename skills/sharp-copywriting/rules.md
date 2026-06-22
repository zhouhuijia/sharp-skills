# sharp-copywriting: Marketing & Product Copy Quality

> Landing pages, product descriptions, ad copy, email subject lines, brand taglines. Not technical documentation, not legal disclaimers, not investor decks.
> Good copy makes the reader feel understood. AI copy makes them feel marketed at.

---

## 0. AUDIENCE & CONTEXT INFERENCE

Before writing a single word:

1. **Who is reading this?** (Role + specific problem they have right now)
2. **Where are they reading it?** (Landing page scanning? Email inbox? Search results? Social feed?)
3. **What is the ONE thing they should do after reading?** (If you can't name it in one verb, the copy will drift.)
4. **What is their skepticism level?** (B2B procurement committee = high. Friend's recommendation = low. First-time visitor = medium.)

Output a one-line read: **"Writing for: \<who>, reading on \<where>, to drive \<action>, skepticism level \<low/medium/high>."**

---

## 1. THE BUZZWORD BLACKLIST

These words are banned from all copy unless they appear in a direct customer quote:

### English banned list
`elevate`, `transform`, `unleash`, `empower`, `revolutionize`, `disrupt`, `next-gen`, `best-in-class`, `world-class`, `industry-leading`, `cutting-edge`, `state-of-the-art`, `seamless`, `holistic`, `synergy`, `robust`, `scalable` (as a standalone claim), `innovative` (without naming the innovation), `game-changer`

### Chinese banned list
`赋能`, `打通`, `闭环`, `抓手`, `落地`, `对齐`, `拉通`, `倒逼`, `反哺`, `深度绑定`, `底层逻辑`, `降本增效`, `一站式`, `全链路`, `全域`, `全场景`, `极致`, `匠心`, `深耕`

### The Replacement Rule
Every time you delete a banned word, you MUST replace it with something specific. No placeholder. No rewording to avoid saying anything at all.

| Banned | Replacement must answer |
|---|---|
| "Seamless integration" | Integrates with WHAT, in HOW MANY steps? |
| "极致体验" | 比什么快/好/便宜了百分之多少？ |
| "赋能业务增长" | 帮哪个岗位的人，在什么场景下，省了多少时间或赚了多少钱？ |

---

## 2. SPECIFICITY MANDATE

### 2.1 Every Claim Needs a Hook
A "hook" is one of: a number, a customer name, a concrete scenario, or a before/after contrast. No claim may appear without at least one hook.

| Weak | Strong |
|---|---|
| "Our platform is fast." | "Cold start in 47ms. That's faster than a screen refresh." |
| "Trusted by leading companies." | "Trusted by the data teams at Stripe, Notion, and Vercel." |
| "帮助企业管理数据" | "光年之外用它在 3 天内完成了原需 2 个月的数据迁移。" |

### 2.2 The "So What" Test
Every sentence must pass the "so what?" test. If a reader can read a sentence and reasonably ask "so what?", the sentence fails.

```
FAILS: "Our algorithm uses advanced machine learning techniques."
SO WHAT: "Our algorithm catches 94% of fraudulent transactions before they clear."
```

### 2.3 Banned Fake-Precise Numbers
Do not invent numbers. The following patterns are red flags:
- "500+ companies" (the + is a tell)
- "10x faster" (without a baseline)
- "99.9% uptime" (without saying how that's measured)

If you don't have the number, use a qualitative hook instead. A specific customer story without numbers beats a fake number every time.

---

## 3. STRUCTURAL PATTERNS BY FORMAT

### 3.1 Landing Page Hero

Max 4 elements in exact order:
1. **Eyebrow** (optional): one-line category label or social proof ("Used by X, Y, Z")
2. **Headline**: max 8 words (EN) / 15 characters (CN), states the core value
3. **Subhead**: max 20 words (EN) / 40 characters (CN), adds the "how" or "for whom"
4. **CTA**: one primary button, max 3 words

**Banned in hero:**
- Feature bullet lists
- Pricing teasers
- "Trusted by" logo walls (those go below the hero)
- Multiple competing CTAs
- Taglines below the CTA

### 3.2 Product Description

Structure:
1. **What it is** — one sentence, plain language, no jargon
2. **Who it's for** — name the specific role or persona
3. **What problem it solves** — the before state, vividly described
4. **How it works** — max 3 steps, each a simple verb phrase
5. **Why it's different** — max 2 differentiators, each concrete

### 3.3 Email Subject Line
- Max 40 characters (mobile truncation at ~35-40)
- Must contain either a number, a question, or a proper noun
- Never start with "[Newsletter]" or "[Update]"
- Personalization (`{{name}}`) only when it feels natural, never in a cold outreach

### 3.4 Ad Headline (Search & Social)
- Max 30 characters for search ads (truncation risk)
- Must include the primary keyword naturally
- Must answer "what will I get?" in the first 3 words
- No exclamation marks (unless the offer is genuinely exciting)

---

## 4. TONE CALIBRATION

### 4.1 The Tone Dial
Set a tone before writing. Do not default to "professional-casual."

| Tone | When to use | Characteristics |
|---|---|---|
| **Direct** | B2B, developer tools, finance | Short sentences, no adjectives, numbers-first |
| **Warm** | Consumer, wellness, lifestyle | Conversational, "you"-forward, emotional benefit |
| **Bold** | Creative, gaming, DTC challenger | Opinionated, surprising, sometimes polarizing |
| **Trust** | Healthcare, legal, enterprise security | Precise, cited, risk-aware, no exaggeration |
| **Playful** | Social apps, entertainment, snacks | Puns allowed, emojis OK, short and punchy |

### 4.2 "You" Density
In warm and direct tones: "you" should appear at least once every 3 sentences. The reader should feel the copy is about THEM, not about the product.

---

## 5. THE ANTI-CORPORATE VOICE

### 5.1 Read It Aloud Test
Read the copy aloud. If you sound like a press release, rewrite it. If you sound like a human explaining something to a friend, you passed.

### 5.2 First-Person is Allowed
"I" and "we" are not unprofessional. "We built this because our own deploy pipeline kept breaking" is better than "This solution was designed to address deployment inefficiencies."

### 5.3 Negatives are Allowed
It is OK to say what the product is NOT for. "Not for teams that need real-time collaboration. For that, try X." This builds more trust than pretending to serve everyone.

---

## 6. SOCIAL PROOF HIERARCHY

When including trust signals, use this priority order:
1. **Named customer quotes** with photo, name, title, company
2. **Specific metric** from a real deployment ("Processed 2.3M transactions/day")
3. **Named customer logos** (real SVGs, not placeholder boxes)
4. **Review platform rating** with review count ("4.8 on G2, 340 reviews")
5. **Media mentions** with publication name and date

**Banned:** "Trusted by thousands" — it means "trusted by zero."

---

## 7. CTA RULES

- **One primary CTA per viewport.** Secondary CTA is optional and must use a visually weaker style.
- **CTA text is a verb phrase**, not a noun. "Start free trial" not "Free Trial." "Get the guide" not "Download."
- **CTA answers "what happens next?"** — "Start building" is better than "Get started" because it implies immediate action.
- **No two CTAs with the same intent** anywhere on the same page.

---

## 8. LOCALIZATION AWARENESS (Chinese Market)

For copy targeting Chinese audiences:
- **No direct translation** of English slogans. Re-create from the value proposition.
- **Four-character idioms (成语) are high-risk.** Use only if you are certain of both meaning and tone.
- **Humbleness sells.** "我们做得还不够好" can be more effective than "我们是最好的."
- **Numbers in Chinese copy:** use Chinese numerals (一、两) for counts under 10, Arabic (1, 2) for data/metrics.

---

## 9. PRE-FLIGHT CHECKLIST

- [ ] **Audience declared**: who, where, what action, skepticism level?
- [ ] **Buzzword audit**: zero banned words from Section 1?
- [ ] **Specificity audit**: every claim has a hook (number/name/scenario/contrast)?
- [ ] **"So what" test**: every sentence passes?
- [ ] **No fake-precise numbers** invented?
- [ ] **Hero discipline**: max 4 elements, no feature lists, no logo wall inside hero?
- [ ] **CTA**: one primary, verb phrase, clear next step?
- [ ] **Tone dial** set and consistent throughout?
- [ ] **Read-aloud test**: doesn't sound like a press release?
- [ ] **Social proof**: real names and numbers, not "trusted by thousands"?
- [ ] **Localization** (if CN): not a direct translation, culturally appropriate?

---

## 10. OUT OF SCOPE

This skill is NOT for:
- Technical documentation (use sharp-tech-writing)
- Legal disclaimers or terms of service
- Investor pitch decks (different structure entirely)
- Internal company communications
- Academic or scientific writing
