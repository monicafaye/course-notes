// =============================================================================
// Shared Typst Template for Course Notes
// Aesthetic: Modern Academic / Textbook
// Supports dual compilation:
//   1. Standalone lecture PDF (`typst compile courses/<code>/lectures/01-intro.typ`)
//   2. Master course book PDF (`typst compile courses/<code>/main.typ`)
// Pure Native Typst (zero external image or network dependencies)
// =============================================================================

// State tracking whether a lecture is being compiled inside a master course book
#let _in-book-mode = state("course-notes-in-book-mode", false)
#let _book-course-code = state("course-notes-code", "")
#let _book-course-name = state("course-notes-name", "")

// -----------------------------------------------------------------------------
// Color Palette (Modern Academic)
// -----------------------------------------------------------------------------
#let palette = (
  primary: rgb("#1e3a5f"),       // Deep Academic Navy
  primary-light: rgb("#eef3f9"), // Soft Navy Tint
  primary-border: rgb("#4a72a8"),

  intuition: rgb("#0f5e59"),     // Deep Teal / Emerald
  intuition-bg: rgb("#edf7f6"),
  intuition-border: rgb("#2a9d8f"),

  example: rgb("#334155"),       // Slate Blue-Gray
  example-bg: rgb("#f8fafc"),
  example-border: rgb("#64748b"),

  case-study: rgb("#7c4a03"),    // Warm Amber / Ochre (for Business / Humanities cases)
  case-study-bg: rgb("#fdf8ef"),
  case-study-border: rgb("#d97706"),

  pitfall: rgb("#881337"),       // Deep Crimson / Rose
  pitfall-bg: rgb("#fff1f2"),
  pitfall-border: rgb("#e11d48"),

  code-bg: rgb("#f4f6f9"),
  code-border: rgb("#d8dee9"),
  muted: rgb("#64748b"),
  ink: rgb("#1e293b"),
  rule: rgb("#cbd5e1"),
)

// -----------------------------------------------------------------------------
// Typography Fonts
// -----------------------------------------------------------------------------
#let font-serif = ("Libertinus Serif", "New Computer Modern", "Georgia")
#let font-sans = ("Segoe UI", "Calibri", "Arial")
#let font-mono = ("Cascadia Mono", "Consolas", "DejaVu Sans Mono")

// -----------------------------------------------------------------------------
// Shared Base Styling (applied to both standalone lectures and master books)
// -----------------------------------------------------------------------------
#let _apply-base-styles(body) = {
  set text(
    font: font-serif,
    size: 10.5pt,
    fill: palette.ink,
    lang: "en",
  )

  set par(
    justify: true,
    leading: 0.68em,
    spacing: 1.15em,
  )

  set list(indent: 0.8em, body-indent: 0.5em)
  set enum(indent: 0.8em, body-indent: 0.5em)

  // Heading styles (Sans-serif contrast against serif prose)
  show heading: it => {
    set text(font: font-sans, fill: palette.primary, weight: "bold")
    if it.level == 1 {
      if it.numbering == none {
        block(breakable: false, sticky: true, text(size: 16.5pt, it.body))
      } else {
        v(1.2em, weak: true)
        block(width: 100%, breakable: false, sticky: true)[
          #text(size: 15pt, it)
          #v(-0.55em)
          #line(length: 100%, stroke: 0.75pt + palette.rule)
        ]
        v(0.5em, weak: true)
      }
    } else if it.level == 2 {
      v(1.0em, weak: true)
      block(breakable: false, text(size: 12.5pt, it))
      v(0.4em, weak: true)
    } else if it.level == 3 {
      v(0.8em, weak: true)
      block(breakable: false, text(size: 11pt, fill: palette.ink, it))
      v(0.3em, weak: true)
    } else {
      v(0.6em, weak: true)
      block(breakable: false, text(size: 10.5pt, style: "italic", fill: palette.muted, it))
      v(0.25em, weak: true)
    }
  }

  // Inline and block code styling
  show raw.where(block: false): box.with(
    fill: palette.code-bg,
    stroke: 0.4pt + palette.code-border,
    inset: (x: 3.5pt, y: 0pt),
    outset: (y: 2.5pt),
    radius: 2.5pt,
  )

  show raw.where(block: true): it => {
    set text(font: font-mono, size: 8.8pt)
    block(
      width: 100%,
      fill: palette.code-bg,
      stroke: (left: 2.5pt + palette.primary-border, rest: 0.5pt + palette.code-border),
      radius: (right: 4pt, left: 1pt),
      inset: (x: 10pt, y: 9pt),
      breakable: true,
      [
        #if it.lang != none [
          #place(top + right, dx: -2pt, dy: -3pt)[
            #text(font: font-sans, size: 7.5pt, weight: "semibold", fill: palette.muted, upper(it.lang))
          ]
        ]
        #it
      ]
    )
  }

  // Clean table defaults
  set table(
    stroke: (_, y) => (
      top: if y == 0 { 1.2pt + palette.primary } else if y == 1 { 0.8pt + palette.primary } else { 0pt },
      bottom: 0.6pt + palette.rule,
    ),
    fill: (_, y) => if y == 0 { palette.primary-light } else if calc.odd(y) { white } else { rgb("#f8fafc") },
    inset: (x: 8pt, y: 6.5pt),
  )

  show table.cell.where(y: 0): set text(font: font-sans, weight: "bold", size: 9.5pt, fill: palette.primary)

  body
}

// -----------------------------------------------------------------------------
// 1. Master Course Book Wrapper (`main.typ`)
// -----------------------------------------------------------------------------
#let course-book(
  course-code: "COURSE-101",
  course-name: "Course Title",
  subtitle: none,
  semester: none,
  instructor: none,
  author: "Course Notes",
  description: none,
  body,
) = {
  set document(title: course-name)

  set page(
    paper: "a4",
    margin: (top: 2.2cm, bottom: 2.2cm, left: 2.3cm, right: 2.3cm),
    header: none,
    footer: context {
      set text(font: font-sans, size: 8.5pt, fill: palette.muted)
      align(center, counter(page).display("1"))
    },
  )

  show: _apply-base-styles

  // Record book state so included lectures adapt automatically
  _in-book-mode.update(true)
  _book-course-code.update(course-code)
  _book-course-name.update(course-name)

  // Clean, minimal title + Table of Contents (no heavy banner or metadata boxes)
  v(0.4cm)
  block(width: 100%)[
    #set text(font: font-sans)
    #text(size: 22pt, weight: "bold", fill: palette.primary, course-name)
    #if subtitle != none [
      #v(0.2em)
      #text(size: 11.5pt, fill: palette.muted, subtitle)
    ]
    #v(0.4em)
    #line(length: 100%, stroke: 1pt + palette.rule)
  ]

  v(0.5cm)
  block(
    width: 100%,
    stroke: 0.6pt + palette.rule,
    radius: 5pt,
    inset: 16pt,
    [
      #text(font: font-sans, size: 12pt, weight: "bold", fill: palette.primary, "Contents")
      #v(0.4em)
      #outline(title: none, indent: 1.2em, depth: 3)
    ]
  )

  body
}

// -----------------------------------------------------------------------------
// 2. Lecture Wrapper (`lectures/XX-topic.typ`)
//    Works both standalone AND when `#include`d in `main.typ`!
// -----------------------------------------------------------------------------
#let lecture(
  course-code: "COURSE-101",
  course-name: "Course Title",
  number: 1,
  title: "Lecture Title",
  subtitle: none,
  slides: none,
  date: none,
  topics: (),
  body,
) = context {
  let in-book = _in-book-mode.get()

  if in-book {
    // --- BOOK MODE: Render as a clean Chapter heading ---
    pagebreak(weak: true)

    block(width: 100%, breakable: false, sticky: true)[
      #show heading: set text(font: font-sans, size: 18pt, weight: "bold", fill: palette.primary)
      #show heading: it => block(sticky: true, it.body)
      #heading(level: 1, numbering: none)[#number. #title]
      #if subtitle != none [
        #v(-0.3em)
        #text(font: font-sans, size: 10pt, fill: palette.muted, subtitle)
      ]
      #v(-0.2em)
      #line(length: 100%, stroke: 1pt + palette.primary)
    ]
    v(0.4em)

    // Reset section counter for this lecture so sections always start at N.1
    counter(heading).update(number)

    // Offset headings inside the lecture so `= Section` becomes level 2 (`N.1 Section`)
    set heading(
      offset: 1,
      numbering: (..nums) => {
        let arr = nums.pos()
        if arr.len() >= 1 {
          str(number) + "." + arr.slice(1).map(str).join(".")
        }
      },
    )

    body
  } else {
    // --- STANDALONE MODE: Clean page setup without header/footer clutter ---
    set page(
      paper: "a4",
      margin: (top: 2.2cm, bottom: 2.2cm, left: 2.2cm, right: 2.2cm),
      header: none,
      footer: context {
        set text(font: font-sans, size: 8.5pt, fill: palette.muted)
        align(center, counter(page).display("1"))
      },
    )

    show: _apply-base-styles

    set heading(numbering: "1.1")

    // Simple, clean title heading at the top of the standalone document
    block(width: 100%, breakable: false)[
      #set text(font: font-sans)
      #text(size: 18pt, weight: "bold", fill: palette.primary, title)
      #if subtitle != none [
        #v(0.2em)
        #text(size: 10.5pt, fill: palette.muted, subtitle)
      ]
      #v(0.35em)
      #line(length: 100%, stroke: 1pt + palette.primary)
    ]
    v(0.5em)

    body
  }
}

// -----------------------------------------------------------------------------
// 3. Pedagogical Callout Environments
// -----------------------------------------------------------------------------
#let _callout-box(
  badge: "CONCEPT",
  title: none,
  fg: palette.primary,
  bg: palette.primary-light,
  border: palette.primary-border,
  body,
) = {
  v(0.5em, weak: true)
  block(
    width: 100%,
    fill: bg,
    stroke: (left: 3.5pt + border, rest: 0.5pt + border.lighten(45%)),
    radius: (right: 4pt, left: 1pt),
    inset: (x: 12pt, y: 10pt),
    breakable: true,
    [
      #block(breakable: false, sticky: true)[
        #set text(font: font-sans)
        #box(
          fill: fg,
          radius: 2.5pt,
          inset: (x: 5.5pt, y: 2.2pt),
          text(size: 7.5pt, weight: "bold", tracking: 0.6pt, fill: white, upper(badge)),
        )
        #if title != none [
          #h(6pt)
          #text(size: 10pt, weight: "bold", fill: fg, title)
        ]
      ]
      #v(0.35em)
      #body
    ]
  )
  v(0.5em, weak: true)
}

// 3.1 Core Concept / Formal Definition Box
#let concept(title: none, body) = _callout-box(
  badge: "Core Concept",
  title: title,
  fg: palette.primary,
  bg: palette.primary-light,
  border: palette.primary-border,
  body,
)

#let definition(term, body) = _callout-box(
  badge: "Definition",
  title: term,
  fg: palette.primary,
  bg: palette.primary-light,
  border: palette.primary-border,
  body,
)

// 3.2 Intuition & Deep Dive / "Why It Matters" Callout
#let intuition(title: "Why It Matters & Intuition", body) = _callout-box(
  badge: "Intuition & Deep Dive",
  title: title,
  fg: palette.intuition,
  bg: palette.intuition-bg,
  border: palette.intuition-border,
  body,
)

// 3.3 Examples, Walkthroughs & Business Case Studies
#let example(title: none, body) = _callout-box(
  badge: "Example & Walkthrough",
  title: title,
  fg: palette.example,
  bg: palette.example-bg,
  border: palette.example-border,
  body,
)

#let case-study(title: none, body) = _callout-box(
  badge: "Case Study",
  title: title,
  fg: palette.case-study,
  bg: palette.case-study-bg,
  border: palette.case-study-border,
  body,
)

// 3.4 Common Pitfalls / Exam Tips / Warnings
#let pitfall(title: "Common Pitfall & Edge Case", body) = _callout-box(
  badge: "Pitfall / Warning",
  title: title,
  fg: palette.pitfall,
  bg: palette.pitfall-bg,
  border: palette.pitfall-border,
  body,
)

// -----------------------------------------------------------------------------
// 4. Pure Native Typst Diagram & Visual Helpers
//    (Used to redraw slide diagrams natively without external image files)
// -----------------------------------------------------------------------------

// 4.1 Horizontal Process / Pipeline Flowchart (`flow-chain`)
//     Pass steps as tuples `(title, subtitle)` or content blocks
#let flow-chain(caption: none, ..steps) = {
  let items = steps.pos()
  let n = items.len()
  if n == 0 { return }

  let cols = ()
  let cells = ()
  for (i, item) in items.enumerate() {
    cols.push(1fr)
    cells.push(
      block(
        width: 100%,
        fill: palette.primary-light,
        stroke: 0.8pt + palette.primary-border,
        radius: 4pt,
        inset: (x: 8pt, y: 8pt),
        align(center + horizon)[
          #set text(font: font-sans, size: 8.8pt)
          #if type(item) == array and item.len() >= 2 [
            #text(weight: "bold", fill: palette.primary, item.at(0))\
            #v(2pt)
            #text(size: 8pt, fill: palette.ink, item.at(1))
          ] else [
            #item
          ]
        ]
      )
    )
    if i < n - 1 {
      cols.push(auto)
      cells.push(
        align(center + horizon)[
          #text(font: font-sans, size: 13pt, weight: "bold", fill: palette.primary, sym.arrow.r)
        ]
      )
    }
  }

  v(0.5em, weak: true)
  block(width: 100%, breakable: false)[
    #grid(
      columns: cols,
      gutter: 5pt,
      align: horizon,
      ..cells,
    )
    #if caption != none [
      #v(4pt)
      #align(center, text(font: font-sans, size: 8.5pt, style: "italic", fill: palette.muted, caption))
    ]
  ]
  v(0.5em, weak: true)
}

// 4.2 Layered Architecture / Hierarchy Stack (`arch-stack`)
//     Great for OS layers, network stacks, compiler phases, or business hierarchies
#let arch-stack(caption: none, ..layers) = {
  let items = layers.pos()
  v(0.5em, weak: true)
  block(width: 100%, breakable: false)[
    #stack(
      dir: ttb,
      spacing: 4pt,
      ..items.enumerate().map(((i, layer)) => {
        let is-even = calc.even(i)
        block(
          width: 100%,
          fill: if is-even { palette.primary-light } else { palette.example-bg },
          stroke: 0.7pt + if is-even { palette.primary-border } else { palette.example-border },
          radius: 3.5pt,
          inset: (x: 12pt, y: 7pt),
          if type(layer) == array and layer.len() >= 2 [
            #grid(
              columns: (130pt, 1fr),
              gutter: 10pt,
              align: (left + horizon, left + horizon),
              text(font: font-sans, size: 9pt, weight: "bold", fill: palette.primary, layer.at(0)),
              text(size: 9pt, fill: palette.ink, layer.at(1)),
            )
          ] else [
            #layer
          ]
        )
      })
    )
    #if caption != none [
      #v(4pt)
      #align(center, text(font: font-sans, size: 8.5pt, style: "italic", fill: palette.muted, caption))
    ]
  ]
  v(0.5em, weak: true)
}

// 4.3 2x2 Analytical Matrix (`matrix-2x2`)
//     Ideal for SWOT, Trade-off matrices, BCG, Eisenhower, or CS theorem quadrants
#let matrix-2x2(
  title: none,
  tl-title: "Quadrant I",
  tl-body: [],
  tr-title: "Quadrant II",
  tr-body: [],
  bl-title: "Quadrant III",
  bl-body: [],
  br-title: "Quadrant IV",
  br-body: [],
) = {
  v(0.5em, weak: true)
  block(width: 100%, breakable: false)[
    #if title != none [
      #align(center, text(font: font-sans, size: 10pt, weight: "bold", fill: palette.primary, title))
      #v(4pt)
    ]
    #grid(
      columns: (1fr, 1fr),
      gutter: 8pt,
      block(width: 100%, fill: palette.primary-light, stroke: 0.7pt + palette.primary-border, radius: 4pt, inset: 10pt)[
        #text(font: font-sans, size: 9.5pt, weight: "bold", fill: palette.primary, tl-title)
        #v(3pt)
        #tl-body
      ],
      block(width: 100%, fill: palette.intuition-bg, stroke: 0.7pt + palette.intuition-border, radius: 4pt, inset: 10pt)[
        #text(font: font-sans, size: 9.5pt, weight: "bold", fill: palette.intuition, tr-title)
        #v(3pt)
        #tr-body
      ],
      block(width: 100%, fill: palette.case-study-bg, stroke: 0.7pt + palette.case-study-border, radius: 4pt, inset: 10pt)[
        #text(font: font-sans, size: 9.5pt, weight: "bold", fill: palette.case-study, bl-title)
        #v(3pt)
        #bl-body
      ],
      block(width: 100%, fill: palette.pitfall-bg, stroke: 0.7pt + palette.pitfall-border, radius: 4pt, inset: 10pt)[
        #text(font: font-sans, size: 9.5pt, weight: "bold", fill: palette.pitfall, br-title)
        #v(3pt)
        #br-body
      ],
    )
  ]
  v(0.5em, weak: true)
}

// 4.4 Algorithm / Structured Procedure Block (`algo-box`)
#let algo-box(title: "Algorithm", input: none, output: none, complexity: none, body) = {
  v(0.5em, weak: true)
  block(
    width: 100%,
    fill: white,
    stroke: 0.8pt + palette.primary,
    radius: 4pt,
    inset: 0pt,
    breakable: true,
    [
      #block(
        width: 100%,
        fill: palette.primary,
        inset: (x: 12pt, y: 7pt),
        radius: (top: 3.5pt),
        breakable: false,
        sticky: true,
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          text(font: font-sans, size: 9.5pt, weight: "bold", fill: white, "Algorithm: " + title),
          if complexity != none {
            text(font: font-mono, size: 8pt, fill: rgb("#e2e8f0"), complexity)
          },
        ),
      )
      #if input != none or output != none [
        #block(
          width: 100%,
          fill: palette.primary-light,
          inset: (x: 12pt, y: 6pt),
          stroke: (bottom: 0.5pt + palette.primary-border),
          breakable: false,
          [
            #set text(size: 9pt)
            #if input != none [*Input:* #input]
            #if input != none and output != none [\ ]
            #if output != none [*Output:* #output]
          ]
        )
      ]
      #block(
        width: 100%,
        inset: (x: 12pt, y: 9pt),
        body,
      )
    ]
  )
  v(0.5em, weak: true)
}

// 4.5 Native Typst Venn Diagram Helper (`venn-2`)
//     Draws a crisp vector 2-set Venn diagram inside Universe U using pure Typst shapes
#let venn-2(
  caption: none,
  label-a: "A",
  label-b: "B",
  label-u: "U",
  mode: "overlap", // "overlap", "disjoint", "subset"
  shade-u: false,
  shade-a: false,
  shade-b: false,
  shade-inter: false,
  items-a: none,
  items-b: none,
  items-inter: none,
  items-u: none,
) = {
  let active-fill = rgb("#bfdbfe").transparentize(25%)
  let base-fill = white.transparentize(40%)
  let u-bg = if shade-u { rgb("#fef3c7") } else { palette.example-bg }

  v(0.4em, weak: true)
  align(center)[
    #block(breakable: false)[
      #box(
        width: 240pt,
        height: 125pt,
        fill: u-bg,
        stroke: 1pt + palette.primary,
        radius: 4pt,
        [
          #place(top + left, dx: 7pt, dy: 6pt)[
            #text(font: font-sans, size: 9pt, weight: "bold", fill: palette.primary, label-u)
          ]
          #if mode == "subset" [
            // Outer circle B, inner circle A
            #place(top + left, dx: 55pt, dy: 16pt)[
              #circle(
                radius: 46pt,
                fill: if shade-b { active-fill } else { base-fill },
                stroke: 1.2pt + palette.primary,
              )[
                #place(top + left, dx: 14pt, dy: 10pt)[
                  #text(font: font-sans, size: 8.5pt, weight: "bold", fill: palette.primary, label-b)
                ]
              ]
            ]
            #place(top + left, dx: 82pt, dy: 38pt)[
              #circle(
                radius: 24pt,
                fill: if shade-a { rgb("#93c5fd") } else { white },
                stroke: 1.2pt + palette.pitfall-border,
              )[
                #align(center + horizon)[
                  #text(font: font-sans, size: 8.5pt, weight: "bold", fill: palette.pitfall, label-a)
                ]
              ]
            ]
          ] else if mode == "disjoint" [
            #place(top + left, dx: 28pt, dy: 24pt)[
              #circle(
                radius: 38pt,
                fill: if shade-a { active-fill } else { base-fill },
                stroke: 1.2pt + palette.primary,
              )[
                #align(center + horizon)[
                  #text(font: font-sans, size: 9pt, weight: "bold", fill: palette.primary, label-a)
                  #if items-a != none [\ #text(size: 8pt, fill: palette.ink, items-a)]
                ]
              ]
            ]
            #place(top + left, dx: 132pt, dy: 24pt)[
              #circle(
                radius: 38pt,
                fill: if shade-b { active-fill } else { base-fill },
                stroke: 1.2pt + palette.intuition-border,
              )[
                #align(center + horizon)[
                  #text(font: font-sans, size: 9pt, weight: "bold", fill: palette.intuition, label-b)
                  #if items-b != none [\ #text(size: 8pt, fill: palette.ink, items-b)]
                ]
              ]
            ]
          ] else [
            // Standard overlapping 2-set Venn diagram
            #place(top + left, dx: 44pt, dy: 22pt)[
              #circle(
                radius: 42pt,
                fill: if shade-a { active-fill } else { base-fill },
                stroke: 1.2pt + palette.primary,
              )
            ]
            #place(top + left, dx: 106pt, dy: 22pt)[
              #circle(
                radius: 42pt,
                fill: if shade-b { active-fill } else { base-fill },
                stroke: 1.2pt + palette.intuition-border,
              )
            ]
            // Labels
            #place(top + left, dx: 62pt, dy: 10pt)[
              #text(font: font-sans, size: 8.5pt, weight: "bold", fill: palette.primary, label-a)
            ]
            #place(top + left, dx: 162pt, dy: 10pt)[
              #text(font: font-sans, size: 8.5pt, weight: "bold", fill: palette.intuition, label-b)
            ]
            #if items-a != none [
              #place(top + left, dx: 54pt, dy: 55pt)[
                #text(font: font-sans, size: 8pt, fill: palette.ink, items-a)
              ]
            ]
            #if items-inter != none [
              #place(top + left, dx: 108pt, dy: 55pt)[
                #text(font: font-sans, size: 8pt, weight: "bold", fill: palette.primary, items-inter)
              ]
            ]
            #if items-b != none [
              #place(top + left, dx: 148pt, dy: 55pt)[
                #text(font: font-sans, size: 8pt, fill: palette.ink, items-b)
              ]
            ]
            #if items-u != none [
              #place(bottom + left, dx: 10pt, dy: -8pt)[
                #text(font: font-sans, size: 7.5pt, fill: palette.muted, items-u)
              ]
            ]
          ]
        ]
      )
      #if caption != none [
        #v(3pt)
        #text(font: font-sans, size: 8.5pt, style: "italic", fill: palette.muted, caption)
      ]
    ]
  ]
  v(0.4em, weak: true)
}

// -----------------------------------------------------------------------------
// 5. Exam Prep & Cheat Sheet Wrappers (`exams/*.typ`)
// -----------------------------------------------------------------------------

// 5.1 Compact Multi-Column Cheat Sheet Wrapper
#let cheatsheet(
  course-code: "COURSE-101",
  course-name: "Course Title",
  title: "Formula & Concept Cheat Sheet",
  subtitle: none,
  cols: 2,
  body,
) = {
  set document(title: course-code + " — " + title)
  set page(
    paper: "a4",
    margin: (top: 1.2cm, bottom: 1.2cm, left: 1.2cm, right: 1.2cm),
    header: none,
    footer: context {
      set text(font: font-sans, size: 7.5pt, fill: palette.muted)
      align(center, counter(page).display("1"))
    },
  )

  set text(font: font-serif, size: 8.8pt, fill: palette.ink, lang: "en")
  set par(justify: true, leading: 0.52em, spacing: 0.65em)
  set list(indent: 4pt, body-indent: 4pt, spacing: 0.45em)
  set enum(indent: 4pt, body-indent: 4pt, spacing: 0.45em)

  show heading: set text(font: font-sans, fill: palette.primary, weight: "bold")
  show heading.where(level: 1): it => block(
    width: 100%,
    fill: palette.primary,
    inset: (x: 6pt, y: 3.5pt),
    radius: 2.5pt,
    above: 0.7em,
    below: 0.45em,
    sticky: true,
    text(size: 9.2pt, weight: "bold", fill: white, it.body),
  )
  show heading.where(level: 2): it => block(
    above: 0.55em,
    below: 0.3em,
    sticky: true,
    text(size: 8.8pt, weight: "bold", fill: palette.primary, it.body),
  )

  block(width: 100%, breakable: false)[
    #set text(font: font-sans)
    #grid(
      columns: (1fr, auto),
      align: (left + bottom, right + bottom),
      [
        #text(size: 14pt, weight: "bold", fill: palette.primary, title)
        #if subtitle != none [
          #h(6pt)
          #text(size: 9pt, fill: palette.muted, "— " + subtitle)
        ]
      ],
      text(size: 8.5pt, weight: "bold", fill: palette.muted, course-code + " · " + course-name),
    )
    #v(0.25em)
    #line(length: 100%, stroke: 1pt + palette.primary)
  ]
  v(0.35em)

  columns(cols, gutter: 10pt, body)
}

// 5.2 Compact Card for Cheat Sheets
#let cheat-card(title: none, body) = {
  v(0.3em, weak: true)
  block(
    width: 100%,
    fill: palette.surface,
    stroke: 0.6pt + palette.border,
    radius: 3pt,
    inset: (x: 7pt, y: 5.5pt),
    breakable: true,
    [
      #if title != none [
        #block(breakable: false, sticky: true)[
          #text(font: font-sans, size: 8.5pt, weight: "bold", fill: palette.primary, title)
          #v(0.15em)
          #line(length: 100%, stroke: 0.4pt + palette.border)
          #v(0.2em)
        ]
      ]
      #body
    ]
  )
  v(0.3em, weak: true)
}

// 5.3 Practice / Past Exam Paper Wrapper
#let exam-paper(
  course-code: "COURSE-101",
  course-name: "Course Title",
  title: "Practice Exam",
  subtitle: none,
  body,
) = {
  set document(title: course-code + " — " + title)
  set page(
    paper: "a4",
    margin: (top: 2.0cm, bottom: 2.0cm, left: 2.0cm, right: 2.0cm),
    header: none,
    footer: context {
      set text(font: font-sans, size: 8.5pt, fill: palette.muted)
      align(center, counter(page).display("1"))
    },
  )

  show: _apply-base-styles
  set heading(numbering: none)

  block(width: 100%, breakable: false)[
    #set text(font: font-sans)
    #text(size: 18pt, weight: "bold", fill: palette.primary, title)
    #if subtitle != none [
      #v(0.2em)
      #text(size: 10.5pt, fill: palette.muted, subtitle)
    ]
    #v(0.35em)
    #line(length: 100%, stroke: 1pt + palette.primary)
  ]
  v(0.5em)

  body
}

// 5.4 Exam Problem & Worked Solution Callouts
#let problem(number: 1, title: none, points: none, body) = {
  v(0.55em, weak: true)
  block(
    width: 100%,
    fill: palette.surface,
    stroke: (left: 3.5pt + palette.primary, rest: 0.6pt + palette.border),
    radius: (right: 4pt, left: 1pt),
    inset: (x: 12pt, y: 10pt),
    breakable: true,
    [
      #block(breakable: false, sticky: true)[
        #set text(font: font-sans)
        #grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          [
            #box(
              fill: palette.primary,
              radius: 2.5pt,
              inset: (x: 6pt, y: 2.5pt),
              text(size: 8pt, weight: "bold", tracking: 0.5pt, fill: white, "PROBLEM " + str(number)),
            )
            #if title != none [
              #h(6pt)
              #text(size: 10pt, weight: "bold", fill: palette.primary, title)
            ]
          ],
          if points != none {
            box(
              fill: palette.primary-light,
              stroke: 0.5pt + palette.primary-border,
              radius: 2.5pt,
              inset: (x: 6pt, y: 2pt),
              text(size: 8pt, weight: "bold", fill: palette.primary, str(points) + " pts"),
            )
          },
        )
      ]
      #v(0.35em)
      #body
    ]
  )
  v(0.55em, weak: true)
}

#let solution(number: 1, title: none, body) = _callout-box(
  badge: "Solution " + str(number),
  title: title,
  fg: palette.intuition,
  bg: palette.intuition-light,
  border: palette.intuition-border,
  body,
)


