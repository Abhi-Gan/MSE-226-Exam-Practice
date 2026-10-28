# MS&E 226 Midterm 1 Practice Generator

Given context on content for Midterm 1 coverage, this repo stores practice questions (typst).

`context/` - context on course material. Not posting here due to privacy of course materials; however this includes:
  - lecture transcripts
  - lecture slides
  - past psets questions with answers
  - Midterm 2025 questions with answers
  - Practice questions from discussion

`generated_questions/` - each generated batch of practice questions lives
in its own subfolder, e.g. `generated_questions/set-1/`, so batches never
collide or overwrite each other. The shared rendering template,
`generated_questions/typst_template.typ`, lives alongside the set folders
(not under `context/`, since it's tooling for this output stage, not for
the raw-to-cleaned context pipeline). Each set folder has three files:
  - `questions_data.typ` - the actual content: one array entry per question
    (prompt, choices, correct answer, per-choice explanation). The single
    source of truth for that set.
  - `generated_questions.typ` - renders the question set only (no answers)
    from `questions_data.typ`, using `../typst_template.typ`.
  - `generated_solutions.typ` - renders the answer key (correct choice +
    explanation per option) from the same `questions_data.typ`, so
    questions and solutions can never drift out of sync with each other.

Compile from the repo root with the root explicitly set (Typst's default
root is the file's own directory, which is one level too shallow to reach
the shared template):
```
typst compile --root . generated_questions/set-1/generated_questions.typ
typst compile --root . generated_questions/set-1/generated_solutions.typ
```

course website https://web.stanford.edu/class/msande226/l_notes.html may also contain extra material that might be useful.