---
name: sharp-interview
description: Technical interview and assessment design quality enforcement. Covers interview question design, technical assessment rubrics, hiring evaluation criteria, and candidate experience. This skill should be used when the user asks to design interview questions, create a hiring assessment, build a technical evaluation rubric, or review an existing interview process. It corrects the most common AI failures: LeetCode-only question banks, generic behavioral questions, zero scoring criteria, and no follow-up strategy.
---

# sharp-interview: Technical Interview & Assessment Quality

> Interview question design, technical assessments, hiring rubrics, candidate evaluation. Not general HR processes, not compensation negotiation, not onboarding.
> A bad interview wastes the candidate's time and misses the hire. Most interviews test what's easy to test, not what matters.

---

## 0. ROLE & ASSESSMENT INFERENCE

Before writing a single question:

1. **What is the actual job?** (Not the title. What will this person do in their first 90 days?)
2. **What level?** (Junior: can they learn? Mid: can they deliver independently? Senior: can they design and lead? Staff: can they multiply the team?)
3. **What is the failure mode?** (What happens if you hire the wrong person? Bugs in production? Team morale collapse? Missed deadlines?)
4. **How many stages?** (Screening → Technical → System Design → Behavioral → Final. Not all roles need all stages.)

Output a one-line read: **"Assessing: \<role> at \<level>, primary risk is \<failure mode>, across \<N> stages."**

---

## 1. QUESTION TYPE MATRIX

Match question types to what the role actually requires:

| Role type | Technical questions | System design | Behavioral | Portfolio/Code review |
|---|---|---|---|---|
| Frontend | 30% | 20% | 30% | 20% |
| Backend | 25% | 35% | 25% | 15% |
| Full-stack | 25% | 25% | 30% | 20% |
| Mobile | 30% | 20% | 30% | 20% |
| DevOps/SRE | 20% | 40% | 25% | 15% |
| Data Engineer | 30% | 30% | 25% | 15% |
| ML Engineer | 25% | 30% | 25% | 20% |
| Engineering Manager | 10% | 15% | 60% | 15% |

**Anti-pattern: 100% LeetCode for any role.** Algorithmic problem-solving is at most 25% of any technical interview, and 0% for senior+ roles unless the role specifically involves algorithm design.

---

## 2. QUESTION DESIGN PRINCIPLES

### 2.1 The Problem-Scenario Format
Every question must follow this structure:
1. **Context** — real-world situation the candidate would face in this role (2-3 sentences)
2. **Task** — what they need to figure out or build (1 sentence)
3. **Constraints** — what limits exist (time, tools, data, etc.)
4. **Success criteria** — what "good" looks like (visible to the interviewer, not necessarily the candidate)

```
BAD:  "Reverse a linked list."
GOOD: "We have a feature where users can undo their last 10 actions. The current
       implementation stores actions in an array and shifts elements on undo,
       causing stutter with >100 actions. Design a data structure that supports
       O(1) undo regardless of history size."
```

### 2.2 The "No Trick Questions" Rule
Every question must test a skill the candidate will actually use. If you cannot explain in one sentence why this question matters for the role, cut it.

### 2.3 Progressive Difficulty
Each question should have:
- **Warm-up** (confirm basic competence, 5 min)
- **Core** (the real assessment, 15-20 min)
- **Extension** (stretch goal, only if time allows, 5-10 min)

### 2.4 Open-Ended Design Questions
For system design and architecture questions:
- Start with an intentionally vague prompt ("Design a URL shortener")
- The candidate MUST ask clarifying questions. This IS part of the assessment.
- Provide information only when asked (traffic estimates, constraints, etc.)
- Evaluate the WHY behind each decision, not just the final diagram

---

## 3. SCORING RUBRIC

### 3.1 The Four-Level Scale
Every question must have a rubric with these four levels:

| Level | Label | Meaning |
|---|---|---|
| 0 | No attempt / Fundamentally wrong | Cannot start or makes critical errors |
| 1 | Needs guidance | Can proceed with hints, makes progress with support |
| 2 | Solid | Independently reaches a working solution, explains reasoning |
| 3 | Exceptional | Considers edge cases proactively, discusses trade-offs, suggests improvements beyond the prompt |

### 3.2 Rubric Must Be Specific
Each level must describe what the candidate SAYS or DOES, not a vague feeling.

```
BAD rubric:
  2 = "Good understanding"
  1 = "Some understanding"

GOOD rubric for a system design question:
  3 = "Identifies at least 3 non-functional requirements unprompted, compares
       2+ storage solutions with specific trade-offs, addresses failure modes"
  2 = "Produces a working design with reasonable component choices, explains
       data flow clearly, addresses 1-2 bottlenecks when asked"
  1 = "Struggles with scope, needs prompting to identify components, makes
       at least one inappropriate technology choice without realizing it"
  0 = "Cannot describe a high-level architecture, or proposes a design that
       would not work under stated constraints"
```

### 3.3 Score Aggregation
- Each stage gets an independent score
- Do not average across stages — a candidate who fails the technical but excels at behavioral is NOT a "maybe"
- Each stage has a minimum bar. Failing any stage = no hire for that role.

---

## 4. FOLLOW-UP QUESTION STRATEGY

### 4.1 The Three Follow-Up Categories
For every core question, prepare at least one follow-up in each category:

1. **Deepen** — "What if the input is 100x larger?" "What if this needs to work offline?"
2. **Broaden** — "How would you monitor this in production?" "How would you onboard a teammate to maintain this?"
3. **Pivot** — "That's a solid approach. What if the requirement changed to X?"

### 4.2 When to Follow Up
- Ask "deepen" when the candidate finishes the core solution quickly (>5 min left)
- Ask "broaden" when the candidate demonstrates solid technical skills (to test scope)
- Ask "pivot" only for senior+ roles (to test adaptability and thinking under ambiguity)

### 4.3 What NOT to Ask
- "Can you make it more optimal?" (vague, frustrating)
- "Are you sure?" (undermining, tests confidence not skill)
- Leading questions that give away the answer

---

## 5. FAIRNESS & INCLUSIVITY CHECKLIST

Before delivering any interview plan:

- [ ] **Single standard**: same questions and rubric for all candidates for the same role?
- [ ] **No trivia**: no questions that reward memorization over understanding?
- [ ] **No cultural assumptions**: all scenarios are universal (no "American college experience" defaults)?
- [ ] **Time pressure justified**: is speed genuinely part of the job? If not, give sufficient time.
- [ ] **Accommodations considered**: can a candidate with accessibility needs complete this assessment?
- [ ] **Language fairness**: for non-native speakers, is technical depth assessed separately from language fluency?
- [ ] **Multiple signals**: does no single question make or break the entire interview?

---

## 6. CANDIDATE EXPERIENCE

### 6.1 Pre-Interview Communication
Candidates must know BEFORE the interview:
- What to expect (format, duration, tools needed)
- What to prepare (if anything)
- Who they'll meet (names and roles)

### 6.2 During the Interview
- **First 2 minutes**: introductions, make the candidate comfortable
- **The interview is a conversation, not an interrogation.** Ask questions, listen, respond to what they actually say.
- **Give hints when stuck.** The goal is to assess capability, not to watch someone struggle in silence.
- **Leave 5 minutes for their questions.** Respect this time — it's part of the assessment (and your sales pitch).

### 6.3 Post-Interview
- Decision within 48 hours (candidates are interviewing elsewhere)
- Rejection with a reason, not a generic template
- Offer specific, actionable feedback if the candidate requests it

---

## 7. ROLE-SPECIFIC QUESTION TEMPLATES

### 7.1 Senior+ Behavioral Questions
Focus on leadership, conflict resolution, and technical strategy:
- "Tell me about a time you disagreed with a technical decision your team made. What did you do?"
- "Describe a project where you had to convince stakeholders to take a different approach."
- "How do you decide what NOT to build?"

### 7.2 Junior/Mid Technical Questions
Focus on fundamentals, debugging, and code comprehension:
- "Here's a function with a subtle bug. Walk me through how you'd find and fix it."
- "Given this API response, how would you transform it for the UI?"
- "Here's a code review. What feedback would you give?"

### 7.3 System Design (All Levels)
Adjust scope by level, not question type:
- **Junior**: design one component or service
- **Mid**: design a system with 2-3 services
- **Senior**: design a distributed system with trade-off analysis
- **Staff**: design across teams/orgs, considering organizational constraints

---

## 8. BANNED PATTERNS (AI Tells)

- **LeetCode hard problems** for roles that don't need algorithm design
- **Brain teasers** ("How many golf balls fit in a school bus?") — these test nothing job-relevant
- **"Tell me about yourself"** as the only behavioral question
- **"What's your greatest weakness?"** — lazy, candidates have canned answers
- **Questions that can be answered with a yes/no** without follow-up
- **"Where do you see yourself in 5 years?"** — tests ambition projection, not job fit
- **Coding without a real IDE/editor** — unless whiteboard coding is genuinely part of the job
- **No rubric** — "I'll know it when I see it" is how bias enters the process

---

## 9. PRE-FLIGHT CHECKLIST

- [ ] **Role and level** declared, with failure mode identified?
- [ ] **Question type mix** matches the role matrix (Section 1)?
- [ ] **Every question** follows the problem-scenario format?
- [ ] **Every question** has a specific 4-level rubric?
- [ ] **Every core question** has at least one follow-up in each category?
- [ ] **Progressive difficulty**: warm-up → core → extension for each question?
- [ ] **Fairness checklist** (Section 5) passed?
- [ ] **Candidate communication**: do they know what to expect before showing up?
- [ ] **5-minute Q&A buffer** at the end?
- [ ] **No banned patterns** from Section 8?
- [ ] **Score aggregation** rules defined (not averaging across stages)?

---

## 10. OUT OF SCOPE

This skill is NOT for:
- General HR processes (compensation, benefits, onboarding)
- Performance reviews for existing employees
- Non-technical role interviews (sales, marketing, operations)
- University admissions interviews
- Contractor/vendor selection processes
