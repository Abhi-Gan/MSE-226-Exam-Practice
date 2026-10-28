Repo root (absolute path; quote it if it contains spaces): "{{REPO_ROOT}}"

CONTEXT: This repo generates {{COURSE_NAME}} {{EXAM_NAME}} practice
questions. `context/raw/` holds the raw source material; your job is to
produce cleaned, LLM-easy-to-ingest markdown in `context/cleaned/`,
mirroring the raw directory structure. Do not modify anything under
`context/raw/` or `context/src/`.

YOUR FILE(S): {{LIST_OF_SLIDE_PDF_PATHS_WITH_PAGE_COUNTS}}

SCOPE NOTE: before cleaning, read `context/cleaned/ed_posts.md` (or the
instructor's current scope announcement) and the current review deck
(e.g. `context/cleaned/Lecture_Slides/midterm_review.md`) to determine the
exact exam scope boundary. If any of your assigned decks contain material
past that boundary, clean it anyway (don't delete it) but add a short
italic flag like "*(out of scope for {{EXAM_NAME}} — {{REASON}})*" at the
start of the affected section. Do NOT infer scope from how advanced a
topic "feels" — check it against the review deck's own markers (e.g. a
`[∗]`/"optional" annotation) or the instructor's explicit statement. A
topic that sounds advanced but has no optional marker and appears in the
review deck's outline is in scope.

METHOD:
1. For each PDF, first run `context/src/extract_pdf_text.sh <pdf>` (wraps
   `pdftotext -layout`) for a cheap text-layer dump. This captures most
   bullet text but mangles math symbols (Σ, ∈, ∫, overline/hat accents
   become stray punctuation) and produces nothing for pure images/diagrams.
2. View the actual PDF pages (rendered as images, not just the text dump)
   for any slide where the dump is math-heavy, ambiguous, or clearly
   describes a figure/diagram/plot that matters conceptually. Batch
   through a deck in chunks (e.g. 20 pages at a time) rather than one page
   at a time.
3. Write one cleaned markdown file per deck to
   `context/cleaned/Lecture_Slides/<same-basename>.md`.

OUTPUT FORMAT per file:
- Organize by topic/concept with `##` headers — group a sequence of
  slides that build one idea; don't make one header per slide number.
- Render all math as LaTeX (`$...$` inline, `$$...$$` display).
  Reconstruct correct notation from context (e.g. `$\bar{X}$`,
  `$\sum_i$`, `$\mathbb{E}[\cdot]$`) — the text dump will not give you
  this directly.
- Keep every formula, worked numeric example, theorem statement, and
  definition. Briefly describe a figure/diagram in `[brackets]` only if
  it's conceptually load-bearing — don't describe purely decorative
  images. If a slide renders blank (e.g. an animation/video that didn't
  survive PDF export), say so inline rather than fabricating content.
- Drop pure filler (title slides, "Questions?", blank section dividers) —
  never drop technical content.
- Precision matters for later exam-question writing: preserve the exact
  distinctions the slides draw (e.g. population quantity vs. sample
  estimate, fitted model vs. learning algorithm, fixed vs. random
  quantities, the assumptions stated for a result).

When done, report: the list of output files written, where you placed any
scope flags, and any slides/pages where you had real trouble
reconstructing content (so it can be spot-checked).
