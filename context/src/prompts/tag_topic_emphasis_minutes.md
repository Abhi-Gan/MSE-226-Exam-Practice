Repo root (absolute path; quote it if it contains spaces): "{{REPO_ROOT}}"

CONTEXT: We're building a topic-emphasis reference so a downstream LLM
can weight practice questions by how much class time the instructor
actually spent on each topic (instructors often say in lecture that
time-spent/repetition tracks exam importance). This recovers that signal
from the raw transcript timestamps, which the main transcript-cleanup
pass (see `clean_lecture_transcripts.md`) deliberately throws away for
readability.

YOUR FILE(S): {{LIST_OF_RAW_TRANSCRIPT_PATHS}}

METHOD:
1. Run `python3 context/src/extract_timed_segments.py <input>
   <some-tmp-path>.md` for each file — deterministic, groups the
   transcript into ~6-line segments tagged with
   `[start-end, duration_seconds]` computed from the original caption
   timestamps. Use any scratch/tmp path for the intermediate; disposable.
2. Canonical taxonomy: use the current official review deck (e.g.
   `context/cleaned/Lecture_Slides/midterm_review.md`) — it's the
   instructor's own outline, organized by lecture, each exam-relevant
   concept as a bullet. Use its exact bullet/heading text as topic
   labels (use the nearest parent heading if a segment covers a whole
   area rather than one specific sub-bullet).
3. Walk the timed segments of each file and assign each to the single
   best-matching topic label. Segments that are pure logistics/banter/
   administrative chatter with no exam content get the label "EXCLUDED
   (logistics/banter)". Segments covering material outside the target
   exam's scope (per `context/cleaned/ed_posts.md` or the current scope
   announcement) get "EXCLUDED (out of scope — {{REASON}})" instead of
   being forced onto an in-scope label.
4. Sum `duration_seconds` per topic, convert to minutes (1 decimal
   place).
5. If any of your files are problem/discussion sessions rather than
   first-pass lectures, produce a SEPARATE table for them: time spent
   drilling/reviewing a topic in a problem session is a different signal
   (likely-to-be-tested / commonly confusing) than first-pass teaching
   time, and shouldn't be summed into the same number. For a session
   that is itself the instructor's own exam review (walking through
   practice questions), also separately note which specific questions
   were discussed and which topic each one targeted — that mapping is
   independently valuable for calibrating new-question difficulty.

Report back (don't write files if this is one of several parallel
batches feeding a central aggregator): a markdown table per
file-category — | Topic (exact label) | Minutes | File(s) | — plus a row
for total EXCLUDED minutes per category and a row for total runtime per
file (so the aggregator can sanity-check your minutes against each
session's actual length).
