Repo root (absolute path; quote it if it contains spaces): "{{REPO_ROOT}}"

CONTEXT: This repo generates {{COURSE_NAME}} {{EXAM_NAME}} practice
questions. `context/raw/` holds raw source material; produce cleaned,
LLM-easy-to-ingest markdown in `context/cleaned/psets/`. Do not modify
anything under `context/raw/` or `context/src/`.

YOUR FILE(S) — per homework, three possible sources (not all may exist
for every course/offering):
- Problem statement, LaTeX source: `{{HW_PROBLEM_TEX_PATH}}`
- Solutions, R/Python Markdown (often code/plots for simulation parts
  only, NOT the full written solution): `{{HW_SOLUTIONS_RMD_OR_IPYNB_PATH}}`
- Solutions, PDF (usually has the FULL solution text including written
  derivations/proofs not in the Rmd/ipynb): `{{HW_SOLUTIONS_PDF_PATH}}`

METHOD:
1. For each problem-statement `.tex`, run `python3
   context/src/extract_tex_body.py <file.tex>` to strip the LaTeX
   preamble and get just the body. It still has custom macros (e.g.
   `\b{Y}` meaning $\bar{Y}$, `\SSE` meaning SSE) — render these properly
   in your output rather than leaving raw macro names.
2. Read the solutions Rmd/notebook directly (usually short, already clean
   markdown+code).
3. For the solutions PDF, run `context/src/extract_pdf_text.sh <pdf>` for
   a first-pass dump (math symbols will be mangled — reconstruct proper
   LaTeX from context), and view specific pages directly where the dump
   is ambiguous or math-heavy.
4. Combine problem + solution into ONE file per homework:
   `context/cleaned/psets/HW<N>.md`.

OUTPUT FORMAT per file:
- For each problem (and each lettered/numbered sub-part): the full
  question text, then immediately below it the solution (final answer +
  key derivation/reasoning steps). Preserve original numbering.
- Where a part is a simulation/coding exercise, don't dump the full code
  verbatim with every comment — give a tight 2-4 line description of
  what the code/simulation does and shows, plus the key numeric/
  qualitative result, citing actual numbers from the Rmd/PDF output where
  available. Keep a short code snippet only if the exact construction is
  itself the pedagogical point.
- Render all math as LaTeX (`$...$` / `$$...$$`).
- Skip pure administrative notes (due dates, submission instructions,
  word-count requirements) — not useful for a question generator.
- Precision matters: these problems test exact distinctions (e.g.
  population parameter vs. sample statistic) that later practice
  questions will probe — don't blur the reasoning when summarizing.
- If the official solution is missing content for some sub-part (this
  happens — e.g. a PDF that states a conclusion without showing the
  derivation), you may reconstruct the missing derivation yourself from
  the problem's own definitions, but say so explicitly inline so it can
  be verified against an official key later. Don't silently present a
  self-reconstructed derivation as if it were the official one.

When done, report: files written, and any problem parts where the
written solution was hard to reconstruct (so it can be spot-checked).
