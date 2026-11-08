#import "/templates/course-note.typ": *

#show: course-book.with(
  course-code: "CS-101",
  course-name: "Foundations of Software Systems & Product Strategy",
  subtitle: "Comprehensive Course Notes Synthesized from Lecture Slides",
  semester: "Fall 2026",
  instructor: "Department of Computer Science & Management",
  author: "English Textbook Synthesis Edition",
  description: [
    This compendium synthesizes lecture slide decks into self-contained, textbook-quality notes. Terse slide bullets are expanded with formal definitions, conceptual intuition, worked traces, case studies, and native Typst diagrams.
  ],
)

// Include individual lectures below (each file also compiles standalone!):
#include "lectures/01-sample-lecture.typ"
