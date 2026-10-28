#!/usr/bin/env python3
"""
Deterministic first-pass cleanup for raw lecture transcripts in
context/raw/Lecture_Transcripts/*.md.

Each raw transcript file has the shape:

    <AI-generated Key Points + Summary header>
    ===
    <line of spoken text>
    <timestamp, e.g. "2:09" or "1:02:17">
    <line of spoken text>
    <timestamp>
    ...

This script splits off the header, strips the standalone timestamp lines
from the transcript body, and joins the remaining spoken-text lines into
flowing paragraphs (a new paragraph every PARA_EVERY lines, which roughly
tracks topic shifts without requiring any NLP).

It does NOT do any semantic cleanup (filler-word removal, de-duplication,
topic structuring, fixing mis-transcribed words, etc.) -- that pass is done
afterwards by an LLM, since it requires judgment about course content. This
script only removes the purely mechanical noise (timestamps) so that the
LLM pass starts from clean input.

Usage:
    python3 strip_transcript_timestamps.py <input.md> [output.md]

If output.md is omitted, writes to stdout.
"""
import re
import sys

TIMESTAMP_RE = re.compile(r"^\d{1,2}(:\d{2}){1,2}$")
PARA_EVERY = 8  # lines of spoken text per paragraph break, before LLM pass


def strip(text: str) -> str:
    parts = text.split("\n===\n", 1)
    if len(parts) == 2:
        header, body = parts
        header = header.rstrip() + "\n\n===\n\n"
    else:
        header, body = "", text

    lines = [ln for ln in body.splitlines() if not TIMESTAMP_RE.match(ln.strip())]
    # Drop now-blank lines left behind by removed timestamps, keep text lines.
    text_lines = [ln.strip() for ln in lines if ln.strip()]

    paragraphs = []
    for i in range(0, len(text_lines), PARA_EVERY):
        paragraphs.append(" ".join(text_lines[i : i + PARA_EVERY]))

    return header + "\n\n".join(paragraphs) + "\n"


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    with open(sys.argv[1], encoding="utf-8") as f:
        raw = f.read()
    cleaned = strip(raw)
    if len(sys.argv) >= 3:
        with open(sys.argv[2], "w", encoding="utf-8") as f:
            f.write(cleaned)
    else:
        sys.stdout.write(cleaned)


if __name__ == "__main__":
    main()
