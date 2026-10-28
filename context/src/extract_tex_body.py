#!/usr/bin/env python3
"""
Deterministic first-pass cleanup for the problem-set LaTeX sources in
context/raw/psets/Problem_Sets_export/*.tex.

Each file is a full compilable LaTeX document: a long preamble of
\\usepackage / \\newcommand boilerplate (not useful to an LLM reading for
course content), followed by \\begin{document} ... \\end{document}, which
holds the actual problem text.

This script extracts just the document body. It deliberately does NOT
expand custom macros (e.g. \\b{Y} for a sample mean, \\SSE for sum of
squared errors) -- that substitution is better done by the LLM cleanup
pass, which can render them as readable LaTeX ($\\bar{Y}$, \\text{SSE})
with the surrounding math context in view.

Usage:
    python3 extract_tex_body.py <input.tex> [output.tex]
"""
import re
import sys


def extract_body(text: str) -> str:
    match = re.search(r"\\begin\{document\}(.*)\\end\{document\}", text, re.DOTALL)
    if not match:
        return text
    return match.group(1).strip() + "\n"


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    with open(sys.argv[1], encoding="utf-8") as f:
        raw = f.read()
    body = extract_body(raw)
    if len(sys.argv) >= 3:
        with open(sys.argv[2], "w", encoding="utf-8") as f:
            f.write(body)
    else:
        sys.stdout.write(body)


if __name__ == "__main__":
    main()
