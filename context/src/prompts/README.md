# Stage-2 (semantic cleanup) prompts

The mechanical scripts in `context/src/` only do stage 1 (strip
boilerplate / timestamps / preamble). Stage 2 — the part that needs
judgment about course content — was an LLM pass using the prompts in this
directory. They're written as templates (`{{PLACEHOLDER}}`) so re-running
cleanup on a new or updated source file means filling in the placeholders,
not reinventing the instructions.

Each template assumes the LLM has normal file-editing tools (read a file,
run a shell command, write a file) and, for PDFs, a way to view a PDF page
as an image (not just its extracted text layer).

- `clean_lecture_slides.md` — for `context/raw/Lecture_Slides/*.pdf`
- `clean_lecture_transcripts.md` — for `context/raw/Lecture_Transcripts/*.md`
- `clean_old_exams_and_discussion_practice.md` — for `context/raw/old_exams/*.pdf` and `context/raw/discussion_practice/*.pdf`
- `clean_psets.md` — for `context/raw/psets/**`
- `tag_topic_emphasis_minutes.md` — the side-pipeline behind `topic_emphasis.json`

All five share one scope rule, which should be re-derived (not copy-pasted
stale) if the course offering or exam scope changes:

> Read `context/cleaned/ed_posts.md` (or the instructor's current
> announcement of exam scope) and `context/cleaned/Lecture_Slides/midterm_review.md`
> (or the current review deck) to determine the exact scope boundary
> before cleaning. Clean out-of-scope material anyway (don't delete it),
> but flag it inline rather than silently including it as if it were
> fair game for new questions.

One failure mode worth naming from how this went the first time: a scope
judgment made confidently in one prompt (e.g. "neural nets/trees are
probably out of scope because they feel advanced") turned out to be wrong
once actually checked against the review deck's own `[∗]`-optional
markers. Treat scope claims as empirical questions to check against the
primary source (the review deck / Ed posts), not something to infer from
general intuition about what "feels" advanced or in-scope.
