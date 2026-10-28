#!/usr/bin/env bash
# Deterministic first-pass text extraction for a PDF in context/raw/.
#
# Uses `pdftotext -layout` (Poppler) to pull the text layer out of a PDF
# while preserving approximate column/line layout, which matters for slide
# decks (bullet indentation) and exams (lettered sub-parts).
#
# This is NOT a full cleanup: math-heavy lines often come out with mangled
# symbols (e.g. summation, "element of", integral signs render as stray
# punctuation), and anything that is a picture (plots, diagrams,
# hand-drawn figures) produces no text at all. The LLM cleanup pass that
# consumes this output is expected to reconstruct proper LaTeX for math and
# to describe/skip purely decorative images, cross-checking the rendered
# PDF page (e.g. via the Read tool) when the extracted text is ambiguous.
#
# Usage:
#   ./extract_pdf_text.sh <input.pdf> [output.txt]
#
# If output.txt is omitted, writes to stdout.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <input.pdf> [output.txt]" >&2
  exit 1
fi

input="$1"
if [[ $# -ge 2 ]]; then
  pdftotext -layout "$input" "$2"
else
  pdftotext -layout "$input" -
fi
