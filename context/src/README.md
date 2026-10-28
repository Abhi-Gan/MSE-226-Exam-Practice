# context/src — raw → cleaned pipeline

Scripts used to turn `context/raw/` into `context/cleaned/`. The pipeline is
two stages for every source:

1. **Mechanical extraction (scripted, deterministic, reproducible here).**
   Strips things that need no judgment call: PDF text layers, LaTeX
   preamble boilerplate, transcript timestamp lines.
2. **Semantic cleanup (LLM pass, not scripted).** Takes stage-1 output and
   does the parts that need understanding of the course content: removing
   filler/false starts, organizing into topical sections, reconstructing
   proper math notation where stage 1 mangled symbols, pairing each
   question with its solution, and skipping purely administrative content.
   This stage was done by Claude reading the stage-1 output (and, where the
   text layer was ambiguous — dense math, figures — the rendered PDF pages
   directly) and writing the result into `context/cleaned/`. The actual
   prompts used are saved as reusable templates in `prompts/` — see
   `prompts/README.md`.

Stage-1 outputs themselves are not checked in (they're an intermediate,
fully reproducible from `context/raw/` by rerunning the scripts below); only
the scripts and the final `context/cleaned/` output are kept.

## Scripts

- `extract_pdf_text.sh <input.pdf> [output.txt]`
  Runs `pdftotext -layout` to pull the text layer out of a slide deck or
  exam PDF. Used for everything in `Lecture_Slides/`, `old_exams/`, and
  `discussion_practice/`. Math symbols (sums, integrals, set membership)
  and anything that's a picture (plots, diagrams) don't survive this step
  cleanly — the LLM pass reconstructs those, checking the actual PDF page
  when needed.

- `extract_tex_body.py <input.tex> [output.tex]`
  Strips the `\usepackage`/`\newcommand` preamble from the problem-set
  `.tex` sources (`context/raw/psets/Problem_Sets_export/`), keeping only
  the `\begin{document}...\end{document}` body. Custom macros (e.g. `\b{Y}`
  for $\bar{Y}$, `\SSE`) are left as-is for the LLM pass to render properly.

- `strip_transcript_timestamps.py <input.md> [output.md]`
  For `context/raw/Lecture_Transcripts/*.md`: splits off the AI-generated
  Key Points/Summary header, drops the standalone caption-timestamp lines
  (e.g. `2:09`), and joins the remaining spoken-text lines into paragraphs.
  Purely mechanical — no filler removal or restructuring. On the full
  transcript set this took raw input from ~22k lines to ~2.9k lines before
  the LLM pass.

- `extract_timed_segments.py <input.md> [output.md]`
  Sibling of `strip_transcript_timestamps.py`, used for the
  `topic_emphasis.json` side-pipeline (see below) instead of the main
  transcript cleanup. Keeps the timestamps instead of dropping them: splits
  the transcript into ~6-line segments, each tagged with
  `[start-end, duration_seconds]`, so an LLM pass afterwards can tag each
  segment with a topic and sum class-minutes per topic.

- `build_topic_emphasis.py`
  Builds `context/cleaned/topic_emphasis.json` from the minutes-per-topic
  numbers an LLM reported after tagging every `extract_timed_segments.py`
  segment against `context/cleaned/Lecture_Slides/midterm_review.md`'s
  outline (the fixed topic taxonomy — the instructor's own review deck).
  The dict-building/ranking in this script is deterministic; the *inputs*
  (which minutes belong to which topic) are not — they came from an LLM
  reading the raw transcripts, so correcting a number means re-examining
  the transcript, not editing this script's arithmetic.

The problem-set solution `.Rmd` files
(`context/raw/psets/Solutions_export/*.Rmd`) needed no extraction step —
they're already clean R Markdown — and were used directly, alongside
`pdftotext` output of the matching solutions PDF (the Rmd only has the
code/plots for parts that involve simulation; written proof-style parts
live only in the PDF).

## Re-running

```bash
# Slides / exams / discussion practice
./extract_pdf_text.sh ../raw/Lecture_Slides/lecture1_intro.pdf out.txt

# Problem set LaTeX
python3 extract_tex_body.py ../raw/psets/Problem_Sets_export/HW1-flat.tex out.tex

# Lecture transcripts
python3 strip_transcript_timestamps.py ../raw/Lecture_Transcripts/2026_09_22.md out.md

# Topic-emphasis side-pipeline
python3 extract_timed_segments.py ../raw/Lecture_Transcripts/2026_09_22.md out.md
python3 build_topic_emphasis.py   # writes ../cleaned/topic_emphasis.json
```

Re-running the semantic (stage-2) pass means re-doing the LLM cleanup with
the same instructions — it isn't scripted since it requires judgment
about course content, but the instructions themselves are not ad hoc:
they're saved as templates in `prompts/`:

| Source | Prompt template |
|---|---|
| `Lecture_Slides/*.pdf` | `prompts/clean_lecture_slides.md` |
| `Lecture_Transcripts/*.md` | `prompts/clean_lecture_transcripts.md` |
| `old_exams/*.pdf`, `discussion_practice/*.pdf` | `prompts/clean_old_exams_and_discussion_practice.md` |
| `psets/**` | `prompts/clean_psets.md` |
| `topic_emphasis.json` minutes tagging | `prompts/tag_topic_emphasis_minutes.md` |

Fill in each template's `{{PLACEHOLDER}}`s (file paths, course/exam name)
and hand it to an LLM with file-editing + PDF-viewing tools. See
`prompts/README.md` for the one scope rule shared across all five.
