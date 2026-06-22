# sharp-dataviz: Data Visualization Quality

> Charts, graphs, dashboards, data stories. Not infographics, not illustrations, not decorative data art.
> Every rule is contextual. Match the chart to the data, not to what looks cool.

---

## 0. CHART PURPOSE INFERENCE

Before choosing a chart type, answer three questions:

1. **What question does this chart answer?** (One sentence, specific. Not "shows the data.")
2. **Who is reading it?** (Executive scanning in 5 seconds? Analyst studying for 5 minutes?)
3. **What action should they take after seeing it?** (If "none," reconsider whether a chart is needed.)

Output a one-line purpose read: **"This chart answers: \<question> for \<audience>, driving \<action>."**

---

## 1. CHART TYPE DECISION TREE

Follow this order. Never skip to a "fancier" type when a simpler one works.

| Data relationship | First choice | When to use alternative |
|---|---|---|
| Compare categories | Horizontal bar | Pie only if <= 5 categories AND parts-of-a-whole |
| Show trend over time | Line chart | Area chart if cumulative AND < 4 series |
| Show distribution | Histogram | Box plot for comparing multiple distributions |
| Show correlation | Scatter plot | Bubble chart only if a 3rd dimension is essential |
| Part-to-whole | Stacked bar (100%) | Pie only if <= 3 categories, DONUT for single-value highlight |
| Ranking | Horizontal bar (sorted) | Dot plot for change-over-time ranking |
| Geospatial | Choropleth map | Bubble map only if point-level precision matters |

**Banned by default:**
- 3D charts of any kind (distorts perception)
- Pie charts with > 5 slices
- Dual-axis charts unless the two scales share a meaningful relationship
- Radar/spider charts (human eye cannot accurately compare angular areas)

---

## 2. COLOR SEMANTICS: THREE FUNCTIONS

Every color in a chart serves exactly ONE of these functions. Never mix them.

### 2.1 Category (distinguish groups)
- Use a qualitative palette (distinct hues, similar saturation)
- Max 6-8 colors; beyond that, group into "Other"
- Example palettes: Tableau 10, ColorBrewer Set2

### 2.2 Value (encode magnitude)
- Use a sequential palette (single hue, varying lightness)
- Light = low, Dark = high (unless the background is dark)
- Never use rainbow/spectral for sequential data

### 2.3 Emphasis (draw attention)
- Use ONE highlight color against a neutral background
- Everything else in grey or muted tones
- Max 2 emphasized elements per chart

### 2.4 Chinese Stock Market Convention
- **Price increase (涨) → Red (#DC2626 or similar)**
- **Price decrease (跌) → Green (#16A34A or similar)**
- This is the OPPOSITE of US/European convention. Default to this for Chinese audiences unless explicitly told otherwise.

### 2.5 Accessibility
- Never rely on color alone to convey information
- Add patterns, labels, or shapes for color-blind readers
- Test in greyscale: does the chart still communicate the message?

---

## 3. TITLE & LABEL DISCIPLINE

### 3.1 Title Formula
A chart title must be a CONCLUSION, not a description.

| Banned (descriptive label) | Required (conclusion) |
|---|---|
| "Revenue Over Time" | "Q3 Revenue Dropped 12% — First Decline in 2 Years" |
| "User Signups by Channel" | "Organic Search Drives 3x More Signups Than Paid Ads" |
| "Server Response Time" | "P95 Latency Exceeded SLA in 4 of 12 Months" |

If you cannot write a conclusion title, the chart may not be worth showing.

### 3.2 Axis Labels
- Y-axis: always labeled, always includes units
- X-axis: labeled unless categories are self-evident (months, product names)
- Font size: labels >= 10pt in final output

### 3.3 The Y-Axis Must Start at Zero
For bar charts, column charts, and area charts: Y-axis MUST start at zero. Starting at a non-zero baseline distorts visual proportions and is misleading.

**Exception:** Line charts and scatter plots may use non-zero baselines when the variation is the story. But a note must be added.

### 3.4 Data Labels
- Add direct labels to the most important data points (max 3-5 per chart)
- Round numbers: 12.3K not 12345.67
- Remove trailing zeros: 12.3% not 12.30%

---

## 4. ANTI-MISLEADING CHECKLIST

Before shipping any chart:

- [ ] **Proportional ink**: does the ink used represent the data value? (A bar twice as tall must represent twice the value.)
- [ ] **Truncated Y-axis**: is it justified? (If not a line/scatter chart, it must start at zero.)
- [ ] **3D effects**: none present?
- [ ] **Dual axes**: if present, are the two scales clearly labeled and visually distinct?
- [ ] **Pie chart**: total adds to 100%? Slices sorted by size (largest at 12 o'clock)?
- [ ] **Missing data**: gaps are visible, not interpolated deceptively?
- [ ] **Color alone**: is there a non-color way to distinguish every category?

---

## 5. ANNOTATION & CONTEXT

### 5.1 Annotation Priority
1. **Events** — label external events that explain anomalies ("Server migration, Jan 15")
2. **Targets** — show goal lines or ranges when relevant
3. **Comparisons** — add "vs. prior period" callouts for the key numbers

### 5.2 What to Strip
- Gridlines: keep only if the reader needs to read exact values from the chart
- Legend: remove if categories are directly labeled on the chart
- Borders/chrome: remove chart borders, background fills, and decorative elements
- Decimals: strip unless precision is meaningful (money, scientific data)

### 5.3 Source Attribution
Every chart must include a source line:
`Source: [system/dataset], [date range], [any filters applied]`

---

## 6. DASHBOARD LAYOUT RULES

When designing a dashboard with multiple charts:

- **Top-left = most important metric.** The eye lands there first.
- **Max 4-6 charts** on a single view
- **Consistent time periods** across all charts on the same view
- **KPI cards** at top (single numbers with delta indicators), detail charts below
- **Related charts** placed adjacent, with consistent color encoding
- **Filters/controls** at top or left, consistent position across views

---

## 7. MOBILE & RESPONSIVE CONSIDERATIONS

- On mobile, consider whether a chart is even the right format (a single number + delta may be better)
- Horizontal bar charts adapt better to narrow screens than vertical columns
- Interactive tooltips must have tap-accessible fallbacks
- Legend position: top on desktop, bottom on mobile

---

## 8. BANNED PATTERNS (AI Tells)

- **3D anything** — bars, pies, donuts with perspective
- **Gradient fills** on bar/column charts (serves no data purpose)
- **Animated chart entrances** — bars growing, pies spinning
- **Rainbow color scales** for sequential data
- **"Sales Over Time"** style titles (descriptive, not conclusive)
- **"Insights" or "Key Takeaways" as a generic section** — each insight must be a specific sentence
- **Overlapping data labels**
- **Pie charts with 10+ slices** in a rainbow of indistinguishable colors
- **Unlabeled axes**

---

## 9. TECHNOLOGY GUIDANCE

When implementing charts:

- **Web:** prefer ECharts (for Chinese audiences, excellent CJK support) or Observable Plot (for modern data journalism style). Chart.js for simple cases.
- **Python:** matplotlib (publication quality) or plotly (interactive). Seaborn for statistical plots.
- **Always include chart code** — do not describe a chart without providing the code to generate it.
- **Check package.json / requirements.txt** before importing any library.

---

## 10. PRE-FLIGHT CHECKLIST

- [ ] **Purpose declared**: what question does this chart answer?
- [ ] **Chart type**: is this the simplest type that works?
- [ ] **Title is a conclusion**, not a label?
- [ ] **Y-axis starts at zero** (or justified exception)?
- [ ] **Color function**: exactly one of category/value/emphasis?
- [ ] **Stock convention**: red = up, green = down for Chinese audiences?
- [ ] **Accessibility**: chart still works in greyscale?
- [ ] **Annotations**: events and targets called out?
- [ ] **Clutter stripped**: unnecessary gridlines, borders, decimals removed?
- [ ] **Source attributed**: dataset, date range, filters stated?
- [ ] **No banned patterns** from Section 8?
- [ ] **Mobile**: does this degrade gracefully on small screens?

---

## 11. OUT OF SCOPE

This skill is NOT for:
- Infographics or data art (aesthetic over accuracy)
- Statistical model outputs without visualization context
- Raw data tables (use sharp-tech-writing for table presentation)
- GIS/map-specific cartography rules (beyond basic choropleth guidance)
