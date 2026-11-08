---
name: slide-to-notes
description: >-
  Convert course lecture slides (PDF, PPTX, or attached files) into comprehensive,
  textbook-style Typst course notes using `/templates/course-note.typ`, and compile
  both standalone lecture PDFs and the unified course book PDF. Activate this skill
  whenever the user feeds slides, asks to summarize/synthesize a lecture, or wants
  to scaffold a new course or lecture in this repository.
---

# Slide-to-Typst Course Note Generation Skill

Follow this step-by-step workflow whenever the user provides course slides or asks to generate/update lecture notes.

## Step 1: Course & Slide Ingestion
1. **Identify Target Course**:
   - Check `courses/` for an existing course folder (e.g., `courses/cs101/`).
   - If this is a new course, create `courses/<course-code>/` with subdirectories `slides/`, `lectures/`, and `build/lectures/`, plus a `main.typ` modeled after [`courses/starter-course/main.typ`](../../../courses/starter-course/main.typ).
2. **Read the Input Slides Thoroughly**:
   - **PDF Slides**: Use `read_file` directly on the PDF file in `courses/<course-code>/slides/` (or the user-provided path) to inspect every page's visual layout, diagrams, and text. For very long PDFs, read in page ranges so no slide is skipped.
   - **PPTX Slides**: If the slide deck is a `.pptx` file, extract the slide text and notes structure using a quick Python or PowerShell snippet (since `.pptx` is a ZIP archive containing `ppt/slides/slide*.xml`), or convert/inspect its contents systematically slide-by-slide.
3. **Determine Lecture Mapping**:
   - Default to a flexible 1-to-1 mapping (`slides/01-topic.pdf` $\rightarrow$ `lectures/01-topic.typ`).
   - If multiple small slide decks cover a single logical chapter (or one giant deck spans multiple distinct parts), propose or organize the `.typ` lecture files cleanly by topic while recording the source slide filenames in the `slides:` parameter of `#lecture(...)`.

## Step 2: Pedagogical Synthesis & Authoring (`lectures/XX-topic.typ`)
1. **Boilerplate Wrapper**:
   Start every lecture file with a clean `#lecture` wrapper (no slide filenames, instructor metadata, or non-English terms):
   ```typst
   #import "/templates/course-note.typ": *

   #show: lecture.with(
     course-code: "COURSE-CODE",
     course-name: "Course Name",
     number: 1,
     title: "Lecture Title",
     subtitle: "Concise thematic subtitle",
   )
   ```
2. **English-Only, Technical Yet Approachable Prose**:
   - Write 100% in **English**. Never include source-language terms (such as Indonesian) in parentheses or tables, and do not reference slide numbers ("Slide 5", "Slide 12 Exercises").
   - Keep the writing technical and accurate, while staying natural, clear, and approachable—avoid overly stiff or pedantic phrasing.
   - Use standard level-1 `= Section`, level-2 `== Subsection`, and level-3 `=== Subsubsection` headings inside the lecture file (`#lecture` automatically offsets them to `1.1`, `1.2`, etc. when included inside `main.typ`).
3. **Weave in the 4 Pedagogical Callout Environments**:
   - `#definition("Term")[...]` or `#concept(title: "...")[...]` for formal concepts, theorems, or core frameworks.
   - `#intuition(title: "...")[...]` to explain the deeper motivation behind terse slide bullets.
   - `#example(title: "...")[...]` (for CS/technical traces & code walkthroughs) or `#case-study(title: "...")[...]` (for Business/Humanities scenarios).
   - `#pitfall(title: "...")[...]` for edge cases, subtle bugs, complexity traps, or common exam mistakes.
4. **Reconstruct All Visuals Natively in Typst (Zero External Images)**:
   - Never crop or embed image files from slides.
   - Redraw pipelines and processes with `#flow-chain(caption: "...", ("Step 1", "Detail"), ...)`.
   - Redraw layered architectures or hierarchies with `#arch-stack(caption: "...", ("Layer 1", "Detail"), ...)`.
   - Redraw 2x2 frameworks (SWOT, trade-offs, quadrants) with `#matrix-2x2(...)`.
   - Format algorithms and pseudocode with `#algo-box(title: "...", input: [...], output: [...], complexity: "...")[...]`.
   - Format multi-dimensional comparisons with `#table(columns: (...), ...)`.
5. **Typst Math Syntax Checklist**:
   - Use `$...$` for inline math and `$ ... $` (with spaces) for display math.
   - Use parentheses for grouping exponents/subscripts: `$2^(31) - 1$`, `$A_(i, j)$` (never LaTeX curly braces `{}`).
   - Use Typst symbol names: `in.not` (for $\notin$), `==>` (for $\implies$), `<==>` (for $\iff$), `<=` (for $\le$), `>=` (for $\ge$), `!=` (for $\ne$), `dots` (for $\dots$).

## Step 3: Register in `main.typ` & Compile Both Outputs
1. **Ensure Inclusion in `main.typ`**:
   Add `#include "lectures/XX-topic.typ"` in `courses/<course-code>/main.typ` in lecture order.
2. **Compile Both Standalone and Book PDFs**:
   Run from the workspace root (`c:\Users\User\Antigravity\course-notes`):
   ```powershell
   New-Item -ItemType Directory -Force -Path courses/<course-code>/build/lectures | Out-Null
   typst compile --root . courses/<course-code>/lectures/XX-topic.typ courses/<course-code>/build/lectures/XX-topic.pdf
   typst compile --root . courses/<course-code>/main.typ courses/<course-code>/build/<course-code>-book.pdf
   ```
3. **Visual Quality Assurance**:
   Use `read_file` on the compiled PDF (`courses/<course-code>/build/lectures/XX-topic.pdf`) to inspect the rendered pages and confirm there are no layout collisions, raw markup leaks, or overflowing boxes.
