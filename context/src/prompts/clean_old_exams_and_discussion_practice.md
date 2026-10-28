Repo root (absolute path; quote it if it contains spaces): "{{REPO_ROOT}}"

CONTEXT: This repo generates {{COURSE_NAME}} {{EXAM_NAME}} practice
questions. `context/raw/` holds raw source material; produce cleaned,
LLM-easy-to-ingest markdown in `context/cleaned/`. Do not modify anything
under `context/raw/` or `context/src/`.

YOUR FILE(S): a question PDF and its matching solutions PDF for each exam
(e.g. `{{EXAM_PDF_PATH}}` + `{{SOLUTIONS_PDF_PATH}}`), and/or a discussion
practice-problems PDF.

These may be from a different year/offering of the same course, or cover
more material than the target exam (e.g. a final covering topics a
midterm doesn't). That's fine — keep everything, it's still a useful
style/difficulty template — just flag what's out of the target exam's
scope (see SCOPE NOTE) rather than silently presenting it as fair game.

SCOPE NOTE: before cleaning, check `context/cleaned/ed_posts.md` (or the
instructor's current scope announcement) for the exact scope boundary.
Flag each question that depends on out-of-scope material with a short
italic note like "*(topic likely outside {{EXAM_NAME}} scope — {{REASON}})*"
— but still include the full question and solution. Verify any "this
looks advanced" judgment against the actual scope statement or the
review deck's own optional-topic markers before flagging; don't flag
on a hunch.

METHOD:
1. Run `context/src/extract_pdf_text.sh <pdf>` (wraps `pdftotext -layout`)
   on each PDF for a cheap text dump. Math symbols get mangled (Σ, ∈,
   overline/hat accents become stray punctuation) — reconstruct proper
   LaTeX from context.
2. View the actual PDF pages (rendered as images) wherever the dump is
   ambiguous — especially for any plot/table/diagram embedded in a
   question, or dense math in a solution's derivation.
3. For each question+solutions pair: produce ONE combined markdown file.
   For each question, give the full question text and all answer
   choices, then immediately below it the correct answer + the official
   explanation (why the right answer is right, and why distractors are
   wrong if the solutions doc explains that — don't invent distractor
   reasoning the source doesn't give). Preserve the original question
   numbering/lettering.
4. For a practice-problems-only document: pair questions with solutions
   the same way if solutions are included; if it's questions-only, say so
   at the top and just clean the questions.

OUTPUT FORMAT:
- Clean markdown, LaTeX math (`$...$` / `$$...$$`), original numbering
  and choice lettering preserved.
- Keep the full text of every question/choice verbatim in meaning (tidy
  wording/whitespace, don't paraphrase away precision — these are the
  actual target style/difficulty for new questions).
- Drop boilerplate exam instructions (time limit, allowed materials,
  Honor Code text, bubble-sheet mechanics) — a one-line note that they
  existed is enough.

When done, report: files written, how many questions in each, and
anything genuinely unclear/unreadable.
