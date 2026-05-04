#!/usr/bin/env python3
"""Replace the client-side WASM rendering of the blueprint dependency graph
with a statically pre-rendered SVG so it works when opened via file://.

Usage:
    python3 scripts/static_dep_graph.py [path/to/dep_graph_document.html]

Default path: blueprint/web/dep_graph_document.html.

Requires the `dot` binary (graphviz) on PATH. Re-run after every
`leanblueprint web` since plasTeX overwrites dep_graph_document.html.
"""

import re
import subprocess
import sys
from pathlib import Path

DEFAULT_HTML = Path("blueprint/web/dep_graph_document.html")


def render(html_path: Path) -> None:
    src = html_path.read_text()

    m = re.search(
        r'graphContainer\.graphviz\([^)]*\)\s*'
        r'(?:\.\w+\([^)]*\)\s*)*'
        r'\.renderDot\(`(.*?)`\)\s*'
        r'(?:\.on\("end",\s*\w+\)\s*)?;',
        src,
        re.DOTALL,
    )
    if not m:
        raise SystemExit("could not find renderDot(`...`) call")

    dot_src = m.group(1)
    # JS template literal collapses '\N' to 'N'; mirror that for parity.
    dot_src = dot_src.replace(r"\N", "N")

    proc = subprocess.run(
        ["dot", "-Tsvg"],
        input=dot_src,
        capture_output=True,
        text=True,
        check=True,
    )
    svg = proc.stdout
    # Strip the XML prolog and DOCTYPE so the SVG embeds cleanly inside HTML.
    svg = re.sub(r"^<\?xml[^>]*\?>\s*", "", svg)
    svg = re.sub(r"<!DOCTYPE[^>]*>\s*", "", svg)
    # Make the SVG fill its container.
    svg = re.sub(
        r'<svg\s+width="[^"]*"\s+height="[^"]*"',
        '<svg width="100%" height="100%"',
        svg,
        count=1,
    )

    # Replace the renderDot graphviz pipeline with a direct innerHTML insert,
    # but keep the rest of the script (click handlers, modal logic).
    replacement = (
        "document.getElementById('graph').innerHTML = "
        + repr_js(svg)
        + ";\ninteractive();"
    )
    new_script = (
        src[: m.start()]
        + replacement
        + src[m.end():]
    )

    # Drop the now-unused graphviz JS includes (saves ~1.2 MB of WASM loads).
    new_script = re.sub(
        r'<script src="js/hpcc\.min\.js"></script>\s*',
        "",
        new_script,
    )
    new_script = re.sub(
        r'<script src="js/d3-graphviz\.js"></script>\s*',
        "",
        new_script,
    )

    html_path.write_text(new_script)
    print(f"wrote static SVG into {html_path} ({len(svg):,} bytes)")


def repr_js(s: str) -> str:
    """Return a JS double-quoted string literal for s."""
    return (
        '"'
        + s.replace("\\", "\\\\")
            .replace('"', '\\"')
            .replace("\n", "\\n")
            .replace("\r", "")
        + '"'
    )


if __name__ == "__main__":
    target = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_HTML
    render(target)
