# Typst Course Notes — Tooling & Textbook Synthesis Framework

A modular **Typst** typesetting framework and AI-assisted workflow for transforming raw university lecture slides into clear, textbook-style course notes.

This repository serves as the **core tooling workspace**—providing the shared Typst template, pedagogical callout components, native diagram primitives, and agent instructions—while each individual course lives in its own dedicated repository under `courses/<course-code>/`.

---

## Key Features

- **Dual Compilation Architecture**: Every lecture file (`lectures/XX-topic.typ`) is a self-contained Typst document that compiles **standalone** as an individual lecture handout (`build/lectures/XX-topic.pdf`) AND can be `#include`d into `main.typ` to compile a unified, chapter-numbered **Master Course Book** (`build/<course-code>-book.pdf`).
- **Pedagogical Callout System**: Built-in visual callout boxes (`#definition`, `#concept`, `#intuition`, `#example`, `#case-study`, `#pitfall`) that turn fragmented slide bullets into structured, textbook-grade explanations.
- **100% Pure Native Typst Diagrams**: Zero cropped or rasterized slide screenshots. All pipelines, layered architectures, 2×2 matrices, and algorithm boxes are reconstructed natively in Typst (`#flow-chain`, `#arch-stack`, `#matrix-2x2`, `#algo-box`, and `#table`).
- **Clean, Minimalist Typography**: Distraction-free layout without header/banner clutter, keeping focus on definitions, intuition, proofs, and worked examples.
- **Multi-Repo Course Isolation**: The root repository tracks only the shared template, AI synthesis rules, and a `starter-course` scaffold. Each real course (`courses/<course-code>/`) is gitignored by the root repo so it can be versioned and published as its own standalone Git repository.

---

## Workspace & Multi-Repo Architecture

```text
course-notes/                            # Root Tooling Repository
├── AGENTS.md                            # Workspace rules for AI slide-to-notes synthesis
├── .agents/
│   └── skills/
│       ├── slide-to-notes/              # Convert raw lecture slides into Typst notes & books
│       ├── exam-prep/                   # Generate 2-column cheat sheets & 2-part practice exams
│       └── course-repo-manager/         # Scaffold courses, sync READMEs & publish to GitHub
├── templates/
│   └── course-note.typ                  # Shared template, wrappers, callouts & diagram primitives
└── courses/
    ├── starter-course/                  # Tracked starter template for new courses
    │   ├── README.md
    │   ├── .gitignore
    │   ├── main.typ
    │   ├── lectures/
    │   │   └── 01-sample-lecture.typ
    │   └── build/
    │       ├── starter-course-book.pdf
    │       └── lectures/
    │           └── 01-sample-lecture.pdf
    └── <course-code>/                   # Independent Git repository per course (gitignored here)
        ├── README.md                    # Public course index & PDF links
        ├── .gitignore                   # Ignores raw slide decks (slides/*)
        ├── main.typ                     # Master course book entry point
        ├── slides/                      # Raw slide decks & raw past exams — gitignored
        ├── lectures/                    # Modular per-lecture Typst sources
        ├── exams/                       # Cheat sheets & practice exam Typst sources
        └── build/                       # Compiled PDF outputs (book, lectures, exams)
```

---

## Course Repositories

Each course is maintained in its own repository named after its course code and cloned into `courses/<course-code>/`:

| Course Code | Course Title | Description |
| :--- | :--- | :--- |
| [**`AIF231105`**](https://github.com/monicafaye/AIF231105) | **Discrete Mathematics** | Sets, Binary Relations, Functions, Sequences & Series, Number Theory, Recursive Functions, and Mathematical Induction |

---

## Getting Started

### Prerequisites

- [**Typst CLI**](https://github.com/typst/typst) (`typst >= 0.11`) installed and available on your `PATH`.

### 1. Clone the Tooling Repository

```bash
git clone https://github.com/monicafaye/course-notes.git
cd course-notes
```

### 2. Clone an Existing Course Repository (or Create a New One)

To work on an existing course repository, clone it into `courses/<course-code>/`:

```bash
git clone https://github.com/monicafaye/AIF231105.git courses/AIF231105
```

To start a brand-new course repository from the starter template:

```bash
cp -r courses/starter-course courses/<course-code>
cd courses/<course-code>
git init
```

### 3. Compile Notes (`typst compile --root .`)

Because every course imports the shared template via `#import "/templates/course-note.typ": *`, always run `typst compile` from the **root of the `course-notes` workspace** with `--root .`:

```bash
# Compile a standalone lecture PDF
typst compile --root . courses/<course-code>/lectures/01-topic.typ courses/<course-code>/build/lectures/01-topic.pdf

# Compile the unified master course book PDF
typst compile --root . courses/<course-code>/main.typ courses/<course-code>/build/<course-code>-book.pdf
```

---

## Template Primitives Reference (`/templates/course-note.typ`)

### Document Wrappers

- **`#show: lecture.with(course-code: "...", course-name: "...", number: 1, title: "...", subtitle: "...")`**
  Used at the top of each file in `lectures/XX-topic.typ`. Renders a standalone lecture document when compiled directly, or a numbered chapter when included inside `main.typ`.
- **`#show: course-book.with(course-code: "...", course-name: "...", subtitle: "...")`**
  Used in `main.typ` before `#include`ing each lecture file. Generates the book title, table of contents, and chapter-prefixed section numbering (`1.1`, `1.2`, `2.1`, etc.).
- **`#show: cheatsheet.with(course-code: "...", course-name: "...", title: "...", cols: 2)`**
  Used in `exams/*-cheatsheet.typ` (paired with `#cheat-card(title: "...")[...]`) to generate compact 2-column formula & concept reference sheets.
- **`#show: exam-paper.with(course-code: "...", course-name: "...", title: "...", subtitle: "...")`**
  Used in `exams/*.typ` (paired with `#problem(number: 1, title: "...", points: 15)[...]` and `#solution(number: 1, title: "...")[...]`) for two-part mock exams and past paper walkthroughs.

### Pedagogical Callouts

| Macro | Purpose |
| :--- | :--- |
| `#definition("Term")[...]` | Formal definitions, notation, and mathematical terminology |
| `#concept(title: "...")[...]` | Core theorems, laws, and structural principles |
| `#intuition(title: "...")[...]` | Practical intuition, motivation, and mental models |
| `#example(title: "...")[...]` | Step-by-step worked examples and problem walkthroughs |
| `#case-study(title: "...")[...]` | Real-world system applications and extended analyses |
| `#pitfall(title: "...")[...]` | Common misconceptions, edge cases, and subtle traps |

### Native Diagram Helpers

| Macro | Purpose |
| :--- | :--- |
| `#flow-chain(caption: "...", ("Step 1", "Desc"), ...)` | Horizontal process pipelines and state transitions |
| `#arch-stack(caption: "...", ("Layer 1", "Desc"), ...)` | Layered architectures and hierarchical stacks |
| `#matrix-2x2(title: "...", tl-title: ..., ...)` | 2×2 comparison grids, trade-off matrices, and quadrants |
| `#algo-box(title: "...", input: [...], output: [...])[...]` | Structured algorithms, pseudocode, and proof blueprints |

---

## AI-Assisted Slide-to-Notes Workflow

When using an AI coding agent in this workspace:

1. Drop raw lecture slide decks (`.pdf` or `.pptx`) into `courses/<course-code>/slides/`.
2. Prompt the agent:
   > *"Generate course notes for `courses/<course-code>/slides/`"*
3. Following [`AGENTS.md`](./AGENTS.md) and [`.agents/skills/slide-to-notes/SKILL.md`](./.agents/skills/slide-to-notes/SKILL.md), the agent translates and expands the slides into 100% English textbook notes, reconstructs all diagrams natively in Typst, and compiles both the standalone lecture PDFs and the unified course book PDF.
