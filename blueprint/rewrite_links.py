#!/usr/bin/env python3
"""
Post-process leanblueprint web output to rewrite the doc-gen4 'find'
URLs (which point at https://leanprover-community.github.io/mathlib4_docs)
into GitHub source URLs for project-internal declarations.

Usage:
    leanblueprint web
    python3 blueprint/rewrite_links.py

Why this exists: leanblueprint hardcodes the URL pattern as
    {dochome}/find/#doc/{name}
where {dochome} is set via \\dochome{...} in web.tex.  Pointing
{dochome} at Mathlib's docs causes 404s for our PeterWeyl/UnitaryRep
declarations.  The clean alternative would be to host doc-gen4 docs
for our project; until then, this script rewrites those links to
GitHub blob URLs at the declaration site.

It scans PeterWeylComp/*.lean and PeterWeyl.lean for top-level
declarations (theorem/def/structure/abbrev/instance/class), tracking
namespace nesting (and `_root_.` prefixes) to compute the
fully-qualified name of each declaration.  For each name cited in
blueprint/lean_decls, it rewrites occurrences of
    https://leanprover-community.github.io/mathlib4_docs/find/#doc/{name}
in blueprint/web/*.html to
    https://github.com/<USER>/<REPO>/blob/main/<file>#L<line>

The regex anchors the URL ending so longer names (UnitaryRep.inner_apply)
are not partially overwritten by shorter ones (UnitaryRep).
"""
import re, glob, sys

# Read GitHub repo URL from web.tex \github{...} so we don't hardcode it.
def read_github_url():
    with open("blueprint/src/web.tex") as f:
        text = f.read()
    m = re.search(r'\\github\{([^}]+)\}', text)
    if not m:
        sys.exit("Could not find \\github{...} in blueprint/src/web.tex.")
    return m.group(1).rstrip("/")

REPO_URL = read_github_url()
REPO_BASE = f"{REPO_URL}/blob/main"
LEAN_FILES = glob.glob("PeterWeylComp/*.lean") + glob.glob("PeterWeyl.lean")
DOCHOME = "https://leanprover-community.github.io/mathlib4_docs"

DECL_PAT = re.compile(
    r'^\s*(?:'
    r'(?:noncomputable\s+)?(?:protected\s+)?(?:@\[[^\]]*\]\s*)?'
    r'(?:theorem|def|structure|abbrev|instance|class)\s+'
    r')'
    r'(_root_\.)?'
    r'([A-Za-z_][A-Za-z0-9_.]*)'
)

def scan_file(path):
    out, ns_stack = [], []
    with open(path) as f:
        for ln, line in enumerate(f, 1):
            m_ns = re.match(r'^\s*namespace\s+([A-Za-z_][A-Za-z0-9_.]*)', line)
            if m_ns:
                ns_stack.append(m_ns.group(1)); continue
            m_end = re.match(r'^\s*end\s+([A-Za-z_][A-Za-z0-9_.]*)\s*$', line)
            if m_end and ns_stack and ns_stack[-1] == m_end.group(1):
                ns_stack.pop(); continue
            m = DECL_PAT.match(line)
            if not m: continue
            full = m.group(2) if m.group(1) else (
                '.'.join(ns_stack) + '.' + m.group(2) if ns_stack else m.group(2))
            out.append((full, ln))
    return out

decls = {}
for path in LEAN_FILES:
    for name, ln in scan_file(path):
        decls.setdefault(name, (path, ln))

with open('blueprint/lean_decls') as f:
    cited = [s.strip() for s in f if s.strip()]
unresolved = [n for n in cited if n not in decls]
resolved = [n for n in cited if n in decls]
print(f"Cited names in blueprint/lean_decls: {len(cited)}")
print(f"  Resolved to source: {len(resolved)}")
print(f"  Unresolved: {len(unresolved)}")
for n in unresolved:
    print(f"    UNRESOLVED: {n}  (no link rewrite — left pointing at Mathlib)")

total = 0
for hpath in glob.glob('blueprint/web/*.html'):
    with open(hpath) as f:
        text = f.read()
    # Process longer names first as defense-in-depth; the regex anchor
    # makes order-independence the primary guarantee.
    for n in sorted(resolved, key=len, reverse=True):
        f_, ln_ = decls[n]
        old_re = re.compile(
            re.escape(f"{DOCHOME}/find/#doc/{n}") +
            r'(?=[^A-Za-z0-9_.])'
        )
        new = f"{REPO_BASE}/{f_}#L{ln_}"
        text, k = old_re.subn(new, text)
        total += k
    with open(hpath, 'w') as f:
        f.write(text)
print(f"Rewrote {total} link occurrences across {len(glob.glob('blueprint/web/*.html'))} HTML files.")

# Diagnostics: any leftover Mathlib find/#doc/ links to project decls?
leftover = 0
for hpath in glob.glob('blueprint/web/*.html'):
    with open(hpath) as f:
        text = f.read()
    for m in re.finditer(re.escape(DOCHOME) + r'/find/#doc/([^"\s]+)', text):
        name = m.group(1)
        if name in decls:
            leftover += 1
            print(f"  LEFTOVER project-decl link: {name} in {hpath}")
print(f"Leftover project-decl links: {leftover}")
print("(Mathlib citations like 'IsHilbertSum' correctly remain pointing at mathlib4_docs.)")
