---
name: course-repo-manager
description: >-
  Scaffold new course repositories under `courses/<course-code>/`, keep per-course
  `README.md` lecture/exam tables and the root tooling `README.md` course catalog
  automatically synchronized, and publish or push course and tooling repositories
  to GitHub (`--public` by default). Activate this skill whenever the user starts
  a new course, renumbers or adds lectures/exams, asks to update READMEs, or asks
  to push/publish changes to GitHub.
---

# Course Repository Scaffolding, README Sync & GitHub Publishing Skill (`course-repo-manager`)

This workspace uses a **multi-repository architecture**:
- The **root repository** (`course-notes`) is the shared Typst tooling, template, and AI skills workspace. It gitignores `courses/*` except `!courses/starter-course/`.
- Each **course directory** (`courses/<course-code>/`) is named strictly by its uppercase `<course-code>` (no spaces, no non-English course names in the folder/repo name) and functions as its own standalone Git repository.

---

## Workflow 1: Scaffolding a New Course (`courses/<course-code>/`)

Whenever the user introduces a new course:

1. **Create the Directory Hierarchy**:
   Use the uppercase course code (e.g., `courses/AIF231105/`):
   ```powershell
   New-Item -ItemType Directory -Force -Path `
     "courses/<course-code>/slides", `
     "courses/<course-code>/slides/exams", `
     "courses/<course-code>/lectures", `
     "courses/<course-code>/exams", `
     "courses/<course-code>/build/lectures", `
     "courses/<course-code>/build/exams" | Out-Null
   ```
2. **Create `courses/<course-code>/.gitignore`**:
   ```gitignore
   # Ignore raw course slide decks and raw past exam papers
   slides/*
   !slides/.gitkeep
   !slides/README.md
   raw-exams/*

   # OS and Editor artifacts
   .DS_Store
   Thumbs.db
   *.tmp
   *~
   .vscode/
   .idea/
   ```
3. **Create `courses/<course-code>/main.typ`**:
   ```typst
   #import "/templates/course-note.typ": *

   #show: course-book.with(
     course-code: "<COURSE-CODE>",
     course-name: "<English Course Name>",
     subtitle: "<Concise English Thematic Subtitle>",
   )

   // Include lectures in numerical order:
   // #include "lectures/01-topic.typ"
   ```
4. **Create `courses/<course-code>/README.md`**:
   Follow the standard 100% English public README layout (see Workflow 2 below).
5. **Initialize the Standalone Course Git Repository**:
   ```powershell
   git -C courses/<course-code> init -b main
   ```

---

## Workflow 2: Synchronizing `README.md` Files

Whenever lectures or exam prep files are added, renamed, or renumbered in `courses/<course-code>/`:

1. **Update `courses/<course-code>/README.md`**:
   - Title: `# <COURSE-CODE> — <English Course Name>` (100% English).
   - **Full Course Compendium** section with a direct link to `[./build/<COURSE-CODE>-book.pdf](./build/<COURSE-CODE>-book.pdf)`.
   - **Lectures & Topics Covered** markdown table listing every lecture `#`, `Lecture Title`, `Core Topics Covered`, `Standalone PDF` link (`./build/lectures/XX-topic.pdf`), and `Typst Source` link (`./lectures/XX-topic.typ`).
   - **Exam Prep & Cheat Sheets** markdown table (if `exams/` contains files) linking to `./build/exams/<name>.pdf` and `./exams/<name>.typ`.
   - **Repository Structure** tree and **Building from Source** instructions showing how to clone both `course-notes` and `<COURSE-CODE>` (`git clone <url> courses/<COURSE-CODE>`) and compile with `typst compile --root .`.
2. **Update Root `README.md`**:
   Ensure the **Course Repositories** table in the root [`README.md`](../../../README.md) lists `<COURSE-CODE>` with its GitHub repository link, English course title, and concise topic summary.

---

## Workflow 3: Publishing & Syncing to GitHub

1. **Compile All Targets First (Inside Sandbox)**:
   Before committing or pushing, verify that `main.typ`, all `lectures/*.typ`, and any `exams/*.typ` compile with exit code 0 using `typst compile --root .`.
2. **Stage and Commit Locally (Inside Sandbox)**:
   - Ensure local Git author identity is set (`git config user.name` and `git config user.email`).
   - Stage and commit changes in `courses/<course-code>`:
     ```powershell
     git -C courses/<course-code> status -u
     git -C courses/<course-code> add .
     git -C courses/<course-code> commit -m "<descriptive commit message>"
     ```
   - If root tooling files (`templates/`, `.agents/skills/`, `AGENTS.md`, or root `README.md`) changed, stage and commit in the root repo as well:
     ```powershell
     git add .
     git commit -m "<descriptive commit message>"
     ```
3. **Create or Push to Public GitHub Repositories**:
   - Use `"C:\Program Files\GitHub CLI\gh.exe"` (or `gh` on `PATH`) and `git push`.
   - If the course does not have a remote `origin` yet, create a **public** repository named strictly `<course-code>`:
     ```powershell
     & "C:\Program Files\GitHub CLI\gh.exe" repo create <course-code> --public --source=courses/<course-code> --remote=origin --push --description "<COURSE-CODE> — <English Course Name> course notes in Typst"
     ```
   - If `origin` already exists, push directly:
     ```powershell
     git -C courses/<course-code> push origin main
     ```
   - If the root `course-notes` repository has new commits, push it as well:
     ```powershell
     git push origin main
     ```
