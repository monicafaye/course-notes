---
name: exam-prep
description: >-
  Generate high-density Typst exam cheat sheets / formula summaries, create mock
  practice exams, or solve raw past exam papers into two-part Typst PDFs (Part 1:
  clean exam problems for self-testing, Part 2: full step-by-step worked solutions
  and grading rubrics). Activate this skill whenever the user asks for a cheat
  sheet, cram sheet, formula summary, practice exam, midterm/final review, or feeds
  a past exam paper to solve.
---

# Exam Prep, Cheat Sheet & Past Paper Synthesis Skill (`exam-prep`)

Follow this workflow whenever the user asks to create a cheat sheet, generate a practice exam, or solve a past exam paper for a course in `courses/<course-code>/`.

## 1. Directory & File Conventions

Inside `courses/<course-code>/`:
- **Raw Past Exam Inputs (Gitignored)**: Place or read raw past exam PDFs/images from `courses/<course-code>/slides/exams/` (or `raw-exams/`).
- **Typst Exam Sources (Tracked)**: Write all exam prep `.typ` files inside `courses/<course-code>/exams/`:
  - Cheat sheets: `exams/midterm-cheatsheet.typ`, `exams/final-cheatsheet.typ`, or `exams/cheatsheet.typ`.
  - Mock exams & solved past papers: `exams/midterm-practice.typ`, `exams/final-practice.typ`, `exams/past-exam-2025.typ`.
- **Compiled PDF Outputs (Tracked)**: Compile into `courses/<course-code>/build/exams/<name>.pdf`.

Ensure `courses/<course-code>/.gitignore` ignores `slides/*` and `raw-exams/*` so raw input papers are never committed.

---

## 2. Mode A: High-Density Formula & Concept Cheat Sheet (`#cheatsheet`)

When the user asks for a **cheat sheet**, **cram sheet**, or **formula summary** covering a range of lectures (or an entire course):

1. **Read the Target Lectures**:
   Read all relevant `courses/<course-code>/lectures/*.typ` files to extract every definition, theorem, formula, algorithm complexity, identity table, and high-yield pitfall.
2. **Use the `#cheatsheet` & `#cheat-card` Primitives**:
   Create `courses/<course-code>/exams/<name>-cheatsheet.typ` using the 2-column `#cheatsheet` wrapper from `/templates/course-note.typ`:
   ```typst
   #import "/templates/course-note.typ": *

   #show: cheatsheet.with(
     course-code: "AIF231105",
     course-name: "Discrete Mathematics",
     title: "Midterm Formula & Concept Cheat Sheet",
     subtitle: "Lectures 1–6 Quick Reference",
     cols: 2,
   )

   = 1. Set Theory & Operations

   #cheat-card(title: "Core Set Operations & Cardinality")[
     - *Union / Intersection*: $A union B$, $A inter B$
     - *Difference / Symmetric Diff*: $A - B = A inter overline(B)$, $A plus.o B = (A - B) union (B - A)$
     - *Power Set*: $|cal(P)(A)| = 2^(|A|)$
     - *Inclusion–Exclusion*: $|A union B| = |A| + |B| - |A inter B|$
   ]
   ```
3. **Formatting Rules for Cheat Sheets**:
   - Keep prose ultra-concise: prioritize equations, conditions, equivalence criteria, matrix signatures, and compact `#table` comparisons.
   - 100% English only (zero source-language words).
   - Aim for 1–3 dense, well-balanced two-column pages with no overflowing equations.

---

## 3. Mode B: Mock Exams & Solved Past Papers (`#exam-paper`)

When the user asks for a **mock exam / practice test** or provides a **raw past exam paper** to solve:

1. **Two-Part Document Structure (Self-Test First, Solutions Second)**:
   Always structure `courses/<course-code>/exams/<name>.typ` using `#exam-paper` in two distinct parts separated by `#pagebreak()`:
   - **Part 1 — Exam Questions (Self-Test Sheet)**:
     Present every problem cleanly using `#problem(number: N, title: "...", points: ...)[...]` with **no spoilers or answers** so the reader can print or attempt the exam under test conditions.
   - **`#pagebreak()`**
   - **Part 2 — Complete Worked Solutions & Grading Rubric**:
     Present the step-by-step solution to every problem using `#solution(number: N, title: "...")[...]`, followed by `#pitfall(title: "Common Exam Trap")[...]` where appropriate.

2. **Boilerplate Template for `exams/<name>.typ`**:
   ```typst
   #import "/templates/course-note.typ": *

   #show: exam-paper.with(
     course-code: "AIF231105",
     course-name: "Discrete Mathematics",
     title: "Midterm Practice Exam",
     subtitle: "Covers Lectures 1–6 · Time Limit: 120 Minutes · Total: 100 Points",
   )

   = Part I — Exam Problems

   #problem(number: 1, title: "Inclusion–Exclusion & Set Algebra", points: 15)[
     1. In a survey of 100 students...
     2. Prove algebraically using the laws of set algebra that $(A union B) - (A inter B) equiv (A - B) union (B - A)$.
   ]

   #pagebreak()

   = Part II — Complete Worked Solutions

   #solution(number: 1, title: "Inclusion–Exclusion & Set Algebra")[
     *Part 1:* Let $U$ be the universal set with $|U| = 100$...
     *Part 2:* Starting from the left-hand side:
     $ (A union B) - (A inter B) &= (A union B) inter overline((A inter B)) quad &("Definition of Difference") $
   ]
   ```

3. **Language & Diagram Rules**:
   - Translate any non-English past exam questions into 100% natural English (zero source-language terms).
   - Reconstruct any figures, graphs, matrices, or tables natively in Typst (never crop raster images from the exam PDF).

---

## 4. Compilation, Visual Verification & README Update

1. **Compile from the Repository Root**:
   ```powershell
   New-Item -ItemType Directory -Force -Path courses/<course-code>/build/exams | Out-Null
   typst compile --root . courses/<course-code>/exams/<name>.typ courses/<course-code>/build/exams/<name>.pdf
   ```
2. **Visual Verification**:
   Inspect the compiled PDF (`courses/<course-code>/build/exams/<name>.pdf`) using `read_file` to verify that all math expressions, columns, and callout boxes render cleanly without overflow.
3. **Update `courses/<course-code>/README.md`**:
   Add or update an **Exam Prep & Cheat Sheets** section in `courses/<course-code>/README.md` linking to both `./build/exams/<name>.pdf` and `./exams/<name>.typ`.
