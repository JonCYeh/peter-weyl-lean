#!/usr/bin/env python3
"""
blueprint_to_issues.py
======================

Generate one GitHub issue draft per sorry-bodied blueprint item from
``blueprint/src/content_comp.tex``.

For every ``\\begin{theorem|lemma|definition|proposition|corollary}`` block
that has a ``\\label{...}`` and ``\\lean{...}`` directive but **no**
``\\leanok``, we emit:

  * a markdown file under ``scripts/issue-seeds/atomic/<label>.md`` with the
    body that ``gh issue create --body-file`` will consume;
  * a line in ``scripts/issue-seeds/seed.sh`` that creates the issue with
    the right title and ``--label`` flags.

Cluster issues (one per cleanup-pass priority block from
``blueprint/src/status.tex``) and external-assumption issues are
hand-written and live alongside the script's output in the same seed
directory; ``seed.sh`` lists them too.

Usage::

    python3 scripts/blueprint_to_issues.py            # write seed dir
    bash    scripts/issue-seeds/seed.sh --dry-run     # preview gh commands
    bash    scripts/issue-seeds/seed.sh                # actually create issues

The script never calls ``gh`` itself; everything it does is local file I/O,
so it is safe to re-run.
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEX = ROOT / "blueprint" / "src" / "content_comp.tex"
LEAN_DIR = ROOT / "PeterWeylComp"
OUT_DIR = ROOT / "scripts" / "issue-seeds"
ATOMIC_DIR = OUT_DIR / "atomic"
SEED_SH = OUT_DIR / "seed.sh"

CHAPTER_TO_LABEL = {
    "chap:setup":      "chapter:setup",
    "chap:rep":        "chapter:rep",
    "chap:conv":       "chapter:conv",
    "chap:approxId":   "chapter:approx-id",
    "chap:spectral":   "chapter:spectral",
    "chap:schur":      "chapter:schur",
    "chap:matCoeff":   "chapter:matrix",
    "chap:separating": "chapter:separating",
    "chap:density":    "chapter:density",
    "chap:orthog":     "chapter:orthog",
    "chap:isotypic":   "chapter:isotypic",
}

# Map a chapter label to a hint about the technique blocker, used to add an
# ``area:*`` label when the connection is well-known. Best-effort only.
CHAPTER_TO_AREA = {
    "chap:rep":      "area:dense-extension",
    "chap:conv":     "area:fubini",
    "chap:matCoeff": "area:tensor",
    "chap:orthog":   "area:bochner",
    "chap:isotypic": "area:bochner",
}

# Color map for ``gh label create`` (hex without leading #). Anything not
# listed defaults to grey.
LABEL_COLORS = {
    "type:atomic":        "0E8A16",
    "type:cluster":       "1D76DB",
    "external:mathlib-gap": "B60205",
    "area:dense-extension": "FBCA04",
    "area:fubini":          "FBCA04",
    "area:tensor":          "FBCA04",
    "area:bochner":         "FBCA04",
    "area:stone-weierstrass": "FBCA04",
    "area:hilbert-sum":     "FBCA04",
    "priority:p1":          "D93F0B",
    "priority:p2":          "FBCA04",
    "priority:p3":          "C5DEF5",
}
DEFAULT_COLOR = "BFD4F2"  # used for chapter:* and anything unlisted

THM_RE = re.compile(
    r"\\begin\{(?P<kind>theorem|lemma|definition|proposition|corollary)\}"
    r"(?:\[(?P<caption>[^\]]*)\])?"
    r"(?P<body>.*?)"
    r"\\end\{(?P=kind)\}",
    re.DOTALL,
)
LABEL_RE   = re.compile(r"\\label\{(?P<v>[^}]+)\}")
LEAN_RE    = re.compile(r"\\lean\{(?P<v>[^}]+)\}")
USES_RE    = re.compile(r"\\uses\{(?P<v>[^}]+)\}", re.DOTALL)
LEANOK_RE  = re.compile(r"\\leanok\b")
CHAPTER_RE = re.compile(
    r"\\chapter\{(?P<title>[^}]+)\}\s*\\label\{(?P<lab>chap:[^}]+)\}",
)


@dataclass
class Item:
    kind: str
    caption: str
    label: str
    lean: str
    uses: list[str]
    chapter_label: str
    chapter_title: str
    file_line: str
    statement: str

    @property
    def gh_labels(self) -> list[str]:
        labels = ["type:atomic", CHAPTER_TO_LABEL.get(self.chapter_label, "chapter:unknown")]
        area = CHAPTER_TO_AREA.get(self.chapter_label)
        if area:
            labels.append(area)
        return labels


def find_chapter(tex: str, pos: int) -> tuple[str, str]:
    """Return (label, title) of the chapter that contains the given offset."""
    title, lab = "(unknown)", "(unknown)"
    for m in CHAPTER_RE.finditer(tex):
        if m.start() > pos:
            break
        title, lab = m.group("title"), m.group("lab")
    return lab, title


def locate_lean(qualified: str) -> str:
    """Find the file:line for a Lean declaration named ``qualified`` (a
    dotted path like ``PeterWeyl.UnitaryRep.IsInvariant.orthogonalComplement``).
    We match on the last dotted segment, scoped to ``PeterWeylComp/*.lean``.
    Returns an empty string if no match is found.
    """
    suffix = qualified.rsplit(".", 1)[-1]
    decl_re = re.compile(
        rf"^(?:noncomputable\s+)?(?:def|theorem|lemma|instance|abbrev)\s+{re.escape(suffix)}\b"
    )
    for f in sorted(LEAN_DIR.glob("*.lean")):
        with f.open() as fh:
            for i, line in enumerate(fh, 1):
                if decl_re.match(line):
                    return f"{f.relative_to(ROOT)}:{i}"
    return ""


def clean_statement(body: str) -> str:
    text = body
    for r in (LABEL_RE, LEAN_RE, USES_RE, LEANOK_RE):
        text = r.sub("", text)
    text = re.sub(r"%[^\n]*", "", text)
    text = re.sub(r"\n[ \t]*\n[ \t]*\n+", "\n\n", text)
    return text.strip()


def parse_blueprint(tex: str) -> list[Item]:
    items: list[Item] = []
    for m in THM_RE.finditer(tex):
        body = m.group("body")
        if LEANOK_RE.search(body):
            continue
        lab_m, lean_m = LABEL_RE.search(body), LEAN_RE.search(body)
        if not lab_m or not lean_m:
            continue
        uses_m = USES_RE.search(body)
        uses = [u.strip() for u in uses_m.group("v").split(",")] if uses_m else []
        chap_lab, chap_title = find_chapter(tex, m.start())
        items.append(Item(
            kind=m.group("kind"),
            caption=(m.group("caption") or "").strip(),
            label=lab_m.group("v"),
            lean=lean_m.group("v"),
            uses=uses,
            chapter_label=chap_lab,
            chapter_title=chap_title,
            file_line=locate_lean(lean_m.group("v")),
            statement=clean_statement(body),
        ))
    return items


def strip_math(s: str) -> str:
    """Strip LaTeX math delimiters from a fragment used in a plain-text title.

    GitHub does not render LaTeX math in issue titles, so ``$L^2$`` shows as
    a literal dollar-sign-delimited string. We drop the ``$`` delimiters; the
    remaining backslashed commands are left as-is (fixing those would need
    a real LaTeX-to-text mapping and is overkill).
    """
    return s.replace("$", "")


def render_atomic(it: Item) -> tuple[str, str]:
    plain_caption = strip_math(it.caption) if it.caption else ""
    title = f"[{it.label}] {plain_caption or it.lean}"
    fileline = it.file_line or "_(declaration not found — verify Lean name)_"
    uses_md = ", ".join(f"`{u}`" for u in it.uses) if it.uses else "_(none)_"
    body = f"""\
**Type:** atomic — single Lean declaration, single sorry to discharge.

| Field | Value |
|---|---|
| Blueprint label | `{it.label}` |
| Blueprint kind  | {it.kind} |
| Lean target     | `{it.lean}` |
| Source location | `{fileline}` |
| Chapter         | {it.chapter_title} |

### Statement (verbatim from blueprint)

{it.statement}

### Dependencies (`\\uses{{...}}`)

{uses_md}

### Definition of done

- [ ] No `sorry` in `{it.lean}` (or any helper introduced for it).
- [ ] Add `\\leanok` to `{it.label}` in `blueprint/src/content_comp.tex`.
- [ ] `lake build` passes locally and in CI (`build-project.yml`).
- [ ] Blueprint dep-graph builds without errors (`blueprint.yml`).

### Hints

- Each item in **Dependencies** that is itself sorry-bodied has its own
  atomic issue. Cross-link with “Blocked by #N” so the project board shows
  the unblock chain.
- If the proof needs technique-level scaffolding (Bochner integration,
  dense-extension of bounded operators, Fubini, Stone–Weierstrass), prefer
  to land that in the parent **cluster** issue first and reduce this issue
  to a one-line application.
"""
    return title, body


LABELS_COMMENT_RE = re.compile(r"<!--\s*labels:\s*(?P<v>[^>]+?)\s*-->")


def parse_label_comment(path: Path) -> list[str]:
    """Extract labels listed in an HTML comment of the form
    ``<!-- labels: a, b, c -->``. Returns [] if no comment is present."""
    text = path.read_text()
    m = LABELS_COMMENT_RE.search(text)
    if not m:
        return []
    return [tok.strip() for tok in m.group("v").split(",") if tok.strip()]


def write_seeds(items: list[Item]) -> None:
    ATOMIC_DIR.mkdir(parents=True, exist_ok=True)

    # Collect every label that any issue in the run will use, so the seed
    # script can `gh label create` them up-front (idempotent via --force).
    cluster_files = sorted(OUT_DIR.glob("cluster-*.md"))
    external_files = sorted(OUT_DIR.glob("external-*.md"))
    all_labels: set[str] = set()
    for it in items:
        all_labels.update(it.gh_labels)
    for path in cluster_files + external_files:
        all_labels.update(parse_label_comment(path))

    seed_lines = [
        "#!/usr/bin/env bash",
        "# Auto-generated by scripts/blueprint_to_issues.py.",
        "# Run with --dry-run to preview, no args to actually create the issues.",
        "set -euo pipefail",
        "",
        "DRY_RUN=0",
        '[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1',
        "",
        'gh_call() {',
        '  if [[ "$DRY_RUN" -eq 1 ]]; then',
        '    printf "DRY: gh"; for a in "$@"; do printf " %q" "$a"; done; printf "\\n"',
        '  else',
        '    gh "$@"',
        '  fi',
        '}',
        "",
        "# ---------- ensure labels exist (idempotent: --force updates if present) ----------",
    ]
    for label in sorted(all_labels):
        color = LABEL_COLORS.get(label, DEFAULT_COLOR)
        seed_lines.append(
            f"gh_call label create '{label}' --color {color} --force"
        )

    seed_lines += [
        "",
        "# ---------- atomic issues (auto-generated) ----------",
    ]
    for it in items:
        title, body = render_atomic(it)
        path = ATOMIC_DIR / f"{it.label.replace(':', '_')}.md"
        path.write_text(body)
        rel = path.relative_to(ROOT)
        label_args = " ".join(f"--label {lab}" for lab in it.gh_labels)
        safe_title = title.replace("'", "'\\''")
        seed_lines.append(
            f"gh_call issue create --title '{safe_title}' --body-file {rel} {label_args}"
        )

    seed_lines += [
        "",
        "# ---------- cluster issues (hand-written; review before running) ----------",
    ]
    for cluster in cluster_files:
        rel = cluster.relative_to(ROOT)
        title = derive_title_from_md(cluster)
        safe_title = title.replace("'", "'\\''")
        labels = parse_label_comment(cluster) or ["type:cluster"]
        label_args = " ".join(f"--label {lab}" for lab in labels)
        seed_lines.append(
            f"gh_call issue create --title '{safe_title}' --body-file {rel} {label_args}"
        )

    seed_lines += [
        "",
        "# ---------- external assumption issues (hand-written) ----------",
    ]
    for ext in external_files:
        rel = ext.relative_to(ROOT)
        title = derive_title_from_md(ext)
        safe_title = title.replace("'", "'\\''")
        labels = parse_label_comment(ext) or ["external:mathlib-gap"]
        label_args = " ".join(f"--label {lab}" for lab in labels)
        seed_lines.append(
            f"gh_call issue create --title '{safe_title}' --body-file {rel} {label_args}"
        )

    seed_lines += [
        "",
        "# ---------- link cluster checkboxes to atomic issue numbers ----------",
        '# Idempotent; safe to re-run if seed.sh is partially redone.',
        'if [[ "$DRY_RUN" -eq 1 ]]; then',
        '  echo "DRY: python3 scripts/link_cluster_issues.py"',
        'else',
        '  python3 scripts/link_cluster_issues.py',
        'fi',
    ]

    SEED_SH.write_text("\n".join(seed_lines) + "\n")
    SEED_SH.chmod(0o755)


def derive_title_from_md(path: Path) -> str:
    """Cluster/external issue files start with a bold title line:
    ``**Title:** ...`` — extract it. Falls back to the filename stem."""
    with path.open() as fh:
        for line in fh:
            m = re.match(r"\*\*Title:\*\*\s*(.+)$", line.strip())
            if m:
                return m.group(1).strip()
    return path.stem.replace("-", " ").title()


def main() -> int:
    if not TEX.exists():
        print(f"missing {TEX}", file=sys.stderr)
        return 1
    items = parse_blueprint(TEX.read_text())
    write_seeds(items)
    print(f"wrote {len(items)} atomic issue drafts to {ATOMIC_DIR.relative_to(ROOT)}")
    print(f"seed script: {SEED_SH.relative_to(ROOT)}  (run with --dry-run first)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
