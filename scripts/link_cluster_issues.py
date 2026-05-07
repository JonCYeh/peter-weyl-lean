#!/usr/bin/env python3
"""
link_cluster_issues.py
======================

After ``seed.sh`` has created the issues, edit each issue's body so that
backticked blueprint-label references become clickable cross-links to the
corresponding GitHub issue.

For every fragment of the form `def:X` (or `thm:`, `cor:`, `lem:`,
`prop:`), wrapped in markdown backticks, that appears in:

  * a cluster issue body (in the checkbox list, in prose, anywhere), or
  * an atomic issue body (in the ``Dependencies`` section),

we rewrite it to `def:X` (#N) where #N is the issue number for that
blueprint label, if such an issue exists. Labels with no matching issue
(e.g. blueprint items already at \\leanok, or external assumptions) are
left untouched.

The transformation is **idempotent**: a second run is a no-op because the
regex won't re-link refs that already carry a ``(#N)`` suffix.

Usage::

    python3 scripts/link_cluster_issues.py             # patch issues live
    python3 scripts/link_cluster_issues.py --dry-run   # preview only

This script makes only ``gh`` API calls and is safe to re-run.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys

# Issues created by ``seed.sh`` always have a title of the form
# ``[def:X] Caption`` for atomics. The label inside the brackets is the
# blueprint label.
ATOMIC_TITLE_RE = re.compile(r"^\[(?P<label>[a-z]+:[A-Za-z0-9_-]+)\]")

# Backticked blueprint label, NOT followed by an existing ``(#N)`` (so this
# script is idempotent under repeated runs).
LABEL_REF_RE = re.compile(
    r"`(?P<label>(?:def|thm|cor|lem|prop):[A-Za-z0-9_-]+)`"
    r"(?!\s*\(#\d+\))"
)


def gh_json(*args: str) -> object:
    cp = subprocess.run(
        ["gh", *args],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(cp.stdout)


def fetch_by_label(label: str) -> list[dict]:
    return gh_json(  # type: ignore[return-value]
        "issue", "list",
        "--label", label,
        "--state", "all",
        "--limit", "1000",
        "--json", "number,title,body",
    )


def build_label_to_number(atomic_issues: list[dict]) -> dict[str, int]:
    out: dict[str, int] = {}
    for it in atomic_issues:
        m = ATOMIC_TITLE_RE.match(it.get("title") or "")
        if m:
            out[m.group("label")] = int(it["number"])
    return out


def patch_body(body: str, label_to_num: dict[str, int],
               exclude: str | None = None) -> str:
    def repl(m: re.Match[str]) -> str:
        label = m.group("label")
        if label == exclude:
            return m.group(0)
        num = label_to_num.get(label)
        if num is None:
            return m.group(0)
        return f"`{label}` (#{num})"

    return LABEL_REF_RE.sub(repl, body or "")


def patch_issue(num: int, new_body: str, dry_run: bool) -> None:
    if dry_run:
        print(f"DRY: gh issue edit {num} --body-file -  ({len(new_body)} chars)")
        return
    subprocess.run(
        ["gh", "issue", "edit", str(num), "--body-file", "-"],
        input=new_body,
        text=True,
        check=True,
    )


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--dry-run", action="store_true",
        help="don't call gh issue edit; just print what would change",
    )
    args = ap.parse_args()

    print("fetching atomic issues …", file=sys.stderr)
    atomics = fetch_by_label("type:atomic")
    label_to_num = build_label_to_number(atomics)
    print(
        f"  found {len(atomics)} atomic issues, "
        f"{len(label_to_num)} have a parseable [label] in the title",
        file=sys.stderr,
    )

    print("fetching cluster issues …", file=sys.stderr)
    clusters = fetch_by_label("type:cluster")
    print(f"  found {len(clusters)} cluster issues", file=sys.stderr)

    edited = 0

    # Cluster bodies first: they reference atomic labels in checkboxes.
    for cl in clusters:
        new = patch_body(cl.get("body") or "", label_to_num)
        if new != (cl.get("body") or ""):
            patch_issue(cl["number"], new, args.dry_run)
            edited += 1

    # Atomic bodies next: their Dependencies section may reference upstream
    # blueprint labels, some of which now have issues. Exclude the issue's
    # own label to avoid silly self-links.
    for at in atomics:
        m = ATOMIC_TITLE_RE.match(at.get("title") or "")
        own_label = m.group("label") if m else None
        new = patch_body(at.get("body") or "", label_to_num, exclude=own_label)
        if new != (at.get("body") or ""):
            patch_issue(at["number"], new, args.dry_run)
            edited += 1

    suffix = "would be" if args.dry_run else ""
    print(f"{edited} issue bodies {suffix} updated".strip())
    return 0


if __name__ == "__main__":
    sys.exit(main())
