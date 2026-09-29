#!/usr/bin/env python3
"""Fail when repository-local Markdown links point at missing paths."""

from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
FENCE_RE = re.compile(r"^\s*(```|~~~)")
LINK_RE = re.compile(r"!?(?:\[[^\]]*\])\(([^)]+)\)")


def without_fenced_code(text: str) -> str:
    out: list[str] = []
    fence: str | None = None
    for line in text.splitlines():
        match = FENCE_RE.match(line)
        if match:
            marker = match.group(1)
            if fence is None:
                fence = marker
            elif marker == fence:
                fence = None
            continue
        if fence is None:
            out.append(line)
    return "\n".join(out)


def destination(raw: str) -> str:
    value = raw.strip()
    if value.startswith("<") and ">" in value:
        return value[1 : value.index(">")].strip()
    # Markdown permits an optional quoted title after whitespace.
    return re.split(r'\s+["\']', value, maxsplit=1)[0].strip()


def iter_markdown_files() -> list[Path]:
    ignored = {".git", ".venv", "venv", "build", "dist"}
    return sorted(
        path
        for path in ROOT.rglob("*.md")
        if not any(part in ignored for part in path.relative_to(ROOT).parts)
    )


def main() -> int:
    failures: list[str] = []
    checked = 0

    for md in iter_markdown_files():
        text = without_fenced_code(md.read_text(encoding="utf-8"))
        for match in LINK_RE.finditer(text):
            raw = destination(match.group(1))
            if not raw or raw.startswith("#"):
                continue
            parts = urlsplit(raw)
            if parts.scheme or parts.netloc:
                continue

            path_text = unquote(parts.path)
            if not path_text:
                continue

            target = (md.parent / path_text).resolve()
            try:
                target.relative_to(ROOT)
            except ValueError:
                failures.append(
                    f"{md.relative_to(ROOT)}: local link escapes repository: {raw}"
                )
                continue

            checked += 1
            if not target.exists():
                failures.append(
                    f"{md.relative_to(ROOT)}: missing local target: {raw}"
                )

    if failures:
        print("Broken repository-local Markdown links:", file=sys.stderr)
        for failure in failures:
            print(f"  - {failure}", file=sys.stderr)
        return 1

    print(f"Markdown link check passed: {checked} local targets")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
