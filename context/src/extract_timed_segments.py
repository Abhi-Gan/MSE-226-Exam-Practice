#!/usr/bin/env python3
"""
Deterministic extraction of TIMED paragraph segments from a raw lecture
transcript, for estimating how much class time was spent on each topic.

Unlike strip_transcript_timestamps.py (which discards timestamps entirely
for readability), this script keeps them: it groups the transcript into
the same paragraph-sized chunks, but tags each chunk with
[start_mm:ss-end_mm:ss, duration_seconds] computed from the surrounding
caption timestamps.

This is still purely mechanical -- it does not know what topic a chunk is
about. The topic-tagging and minutes-per-topic summation is done by an LLM
pass afterwards (it needs to understand course content), using this
script's output as input.

Usage:
    python3 extract_timed_segments.py <input.md> [output.md]
"""
import re
import sys

TIMESTAMP_RE = re.compile(r"^\d{1,2}(:\d{2}){1,2}$")
PARA_EVERY = 6  # lines of spoken text per segment, before LLM topic-tagging


def to_seconds(ts: str) -> int:
    parts = [int(p) for p in ts.split(":")]
    seconds = 0
    for p in parts:
        seconds = seconds * 60 + p
    return seconds


def fmt(seconds: int) -> str:
    m, s = divmod(seconds, 60)
    return f"{m}:{s:02d}"


def extract(text: str):
    parts = text.split("\n===\n", 1)
    body = parts[1] if len(parts) == 2 else text

    # Walk the body, pairing up runs of text lines with the timestamp that
    # follows them (the timestamp marks when that run of speech ended).
    lines = [ln.strip() for ln in body.splitlines()]
    events = []  # (text_or_None, timestamp_seconds_or_None)
    pending_text = []
    for ln in lines:
        if not ln:
            continue
        if TIMESTAMP_RE.match(ln):
            events.append((" ".join(pending_text) if pending_text else None, to_seconds(ln)))
            pending_text = []
        else:
            pending_text.append(ln)
    if pending_text:
        events.append((" ".join(pending_text), None))

    segments = []
    buf_text = []
    seg_start = 0
    count = 0
    last_ts = 0
    for text_chunk, ts in events:
        if text_chunk:
            buf_text.append(text_chunk)
            count += 1
        if ts is not None:
            last_ts = ts
        if count >= PARA_EVERY and ts is not None:
            segments.append((seg_start, ts, " ".join(buf_text)))
            seg_start = ts
            buf_text = []
            count = 0
    if buf_text:
        segments.append((seg_start, last_ts, " ".join(buf_text)))

    return segments


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    with open(sys.argv[1], encoding="utf-8") as f:
        raw = f.read()
    segments = extract(raw)

    out_lines = []
    for start, end, txt in segments:
        dur = max(end - start, 0)
        out_lines.append(f"[{fmt(start)}-{fmt(end)}, {dur}s]")
        out_lines.append(txt)
        out_lines.append("")
    out = "\n".join(out_lines)

    if len(sys.argv) >= 3:
        with open(sys.argv[2], "w", encoding="utf-8") as f:
            f.write(out)
    else:
        sys.stdout.write(out)


if __name__ == "__main__":
    main()
