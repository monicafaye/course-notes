# Course Notes Workspace Rules (`AGENTS.md`)

This repository is a multi-course Typst note-taking and textbook-synthesis workspace. Whenever the user provides course slides or asks to create/update course notes, strictly follow these architectural and pedagogical rules.

## 1. Repository Architecture
- **Shared Template**: [`/templates/course-note.typ`](./templates/course-note.typ) provides the Modern Academic / Textbook styling, dual-compilation wrappers (`course-book` and `lecture`), pedagogical callout boxes, and native Typst diagram primitives.
- **Per-Course Repository Layout** (each course folder is named strictly by its `<course-code>` and functions as its own standalone Git repository, gitignored by the root tooling repo):
  ```text
  courses/<course-code>/
  ├── README.md                # Public course overview, lecture table, and PDF links
  ├── .gitignore               # Ignores slides/* and editor temp files
  ├── main.typ                 # Master course book compendium (includes all lectures)
  ├── slides/                  # Raw slide decks (.pdf, .pptx) — gitignored
  ├── lectures/                # Modular per-lecture Typst files (01-topic.typ, 02-topic.typ)
  └── build/                   # Compiled PDF outputs (tracked in the course Git repo)
      ├── <course-code>-book.pdf
      └── lectures/
          └── 01-topic.pdf
  ```
- **Dual Compilation Requirement**:
  Every lecture `.typ` file in `courses/<course-code>/lectures/` MUST compile standalone AND be `#include`d in `courses/<course-code>/main.typ`. Always compile from the repository root using `typst compile --root .`:
  1. `typst compile --root . courses/<course-code>/lectures/<lecture>.typ courses/<course-code>/build/lectures/<lecture>.pdf`
  2. `typst compile --root . courses/<course-code>/main.typ courses/<course-code>/build/<course-code>-book.pdf`

## 2. Language, Tone & Layout Policy
- **Strict English Only (Zero Source-Language Terms)**: All course notes must be written 100% in **English**. If the input slides are in Indonesian, Vietnamese, or any other language, translate everything into natural English and **refrain from including any non-English words, parenthetical translations, or slide-specific metadata**.
- **Technical Yet Approachable Tone**:
  - Keep explanations technically accurate and thorough, but write in a natural, readable, and approachable style—do **not** make the prose overly stiff, pedantic, or bogged down in rigid academic pomp.
  - Do not reference slide numbers (e.g., avoid "On Slide 4..." or "Slide 7 Exercises"); write as a cohesive, standalone set of notes.
  - Expand fragmented slide bullets into clear explanations with smooth transitions, intuition, and worked examples.
- **Minimalist Layout (No Header/Banner Clutter)**:
  - Omit decorative document/lecture title banners, metadata grids (instructor, semester, source deck filenames), and running page headers/footers (keep only simple page numbers).
- **Pedagogical Callouts** (imported from `/templates/course-note.typ`):
  - `#definition("Term")[...]` / `#concept(title: "...")[...]`: Core definitions, terminology, and key principles.
  - `#intuition(title: "...")[...]`: Practical intuition and motivation behind concepts.
  - `#example(title: "...")[...]` / `#case-study(title: "...")[...]`: Worked step-by-step examples, problem walkthroughs, or case studies.
  - `#pitfall(title: "...")[...]`: Common misconceptions, edge cases, or subtle traps.

## 3. Pure Native Typst Visuals (No Extracted Slide Images)
- **Never extract or embed raster/cropped images from slides.** Every `.typ` file must remain 100% self-contained in pure Typst code.
- Always reconstruct diagrams, processes, architectures, and frameworks natively using `/templates/course-note.typ` helpers or native Typst primitives:
  - `#flow-chain(caption: "...", ("Step 1", "Desc"), ("Step 2", "Desc"), ...)` for pipelines, processes, and state transitions.
  - `#arch-stack(caption: "...", ("Layer 1", "Desc"), ...)` for layered software architectures, protocol stacks, or hierarchical models.
  - `#matrix-2x2(title: "...", tl-title: ..., tl-body: ..., ...)` for SWOT, 2x2 trade-off matrices, BCG, Eisenhower, or theoretical quadrants.
  - `#algo-box(title: "...", input: [...], output: [...], complexity: "...")[...]` for algorithms and structured procedures.
  - Native Typst `#table(...)` for structured comparisons across systems, algorithms, or frameworks.
