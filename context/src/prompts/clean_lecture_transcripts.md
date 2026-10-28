Repo root (absolute path; quote it if it contains spaces): "{{REPO_ROOT}}"

CONTEXT: This repo generates {{COURSE_NAME}} {{EXAM_NAME}} practice
questions. `context/raw/Lecture_Transcripts/` holds machine-generated
(noisy) lecture transcripts; produce cleaned versions in
`context/cleaned/Lecture_Transcripts/`. Do not modify anything under
`context/raw/` or `context/src/`.

YOUR FILE(S): {{LIST_OF_TRANSCRIPT_PATHS_WITH_ONE_LINE_TOPIC_DESCRIPTION}}

Each file has an AI-generated "Key Points" + "Summary" header, then a line
"===", then the raw transcript as alternating [spoken-text line] / [bare
timestamp line, e.g. "2:09"]. It's machine-generated from classroom audio:
filler words, false starts, interruptions, off-topic chatter.

SCOPE NOTE: before cleaning, check `context/cleaned/ed_posts.md` (or the
instructor's current scope announcement) for the exam scope boundary. If
a file (or part of one) covers material past that boundary, clean it
anyway but add a short italic flag like "*(out of scope for
{{EXAM_NAME}} — {{REASON}})*" right before the affected section. Don't
flag something as out-of-scope just because it sounds advanced — check it
against the actual scope statement or the review deck's own optional
markers first.

METHOD:
1. Run `python3 context/src/strip_transcript_timestamps.py <input>
   <some-tmp-path>.md` — deterministic, drops bare timestamp lines and
   joins spoken text into paragraphs (no semantic cleanup yet). Use any
   scratch/tmp path for the intermediate; it's disposable.
2. Read that stage-1 output and do the semantic cleanup pass:
   - Keep the original "Key Points" + "Summary" header as-is at the top
     of your output. (If a file genuinely has no such header in the raw
     source, say so explicitly at the top rather than fabricating one.)
   - Reorganize the transcript body into topical `##` sections following
     the lecture's natural flow — don't leave it as one undifferentiated
     blob.
   - Remove filler ("um", "uh", false starts, repeated words), pure
     classroom logistics/banter with zero course content, and
     digressions. KEEP anything with real content: definitions, formulas,
     worked examples, specific numbers, explanatory analogies, and any
     student question + answer exchange that reveals a misconception —
     these are valuable for writing exam distractors later.
   - If the file is a problem/discussion session that walks through
     practice questions, err heavily toward keeping detail: preserve each
     question discussed and the full reasoning/common-mistake discussion
     around it, even if only described verbally rather than quoted
     verbatim. This is usually the single most useful material for
     calibrating new-question difficulty and distractors.
   - Fix obvious transcription errors where the intended word/term is
     clear from context, but don't invent content that wasn't there.
   - Render math mentioned in speech as LaTeX (`$...$`) where unambiguous
     (e.g. "R squared" → `$R^2$`).
   - Target a large length reduction (the stage-1 text is still full of
     chatter) but zero loss of technical substance — if in doubt, keep it.
3. Write output to `context/cleaned/Lecture_Transcripts/<same-basename>.md`.

When done, report: files written, approximate line-count before/after for
each, where you placed any scope flags, and anything you cut that you're
not fully sure was safe to cut (so it can be spot-checked).
