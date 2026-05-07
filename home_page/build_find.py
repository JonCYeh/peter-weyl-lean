#!/usr/bin/env python3
"""Generate home_page/find/index.html — a static redirect page that maps
\\lean{...} citations from the blueprint to GitHub source URLs.

The page expects URLs of the form
  https://JonCYeh.github.io/peter-weyl-lean/find/#doc/<NAME>
(i.e. \\dochome set to https://JonCYeh.github.io/peter-weyl-lean).
The fragment after `#doc/` is looked up in an embedded JSON map and the
browser redirects to the corresponding GitHub blob URL.
"""
import re, glob, json, os

REPO_BASE = "https://github.com/JonCYeh/peter-weyl-lean/blob/main"
LEAN_FILES = glob.glob("PeterWeylComp/*.lean") + glob.glob("PeterWeyl.lean")

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
        decls.setdefault(name, f"{REPO_BASE}/{path}#L{ln}")

print(f"Indexed {len(decls)} declarations.")

os.makedirs("home_page/find", exist_ok=True)

# Embed the map as JSON in the HTML.  Keep it small but readable.
map_json = json.dumps(decls, indent=2, sort_keys=True)

html = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Find declaration — Peter–Weyl Lean</title>
<meta name="robots" content="noindex">
<style>
  body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
         max-width: 40em; margin: 4em auto; padding: 0 1em; color: #222; }}
  code {{ background: #f4f4f4; padding: 0.1em 0.4em; border-radius: 3px;
         font-size: 0.95em; }}
  a {{ color: #0366d6; }}
  .err {{ color: #d73a49; }}
  .muted {{ color: #586069; font-size: 0.9em; }}
</style>
</head>
<body>
<h1>Find declaration</h1>
<p id="status" class="muted">Looking up declaration&hellip;</p>
<p id="result"></p>
<p class="muted">
  This page redirects blueprint citations of the form
  <code>find/#doc/&lt;name&gt;</code> to the corresponding GitHub source
  location.  See the
  <a href="../blueprint/">blueprint</a> or
  <a href="../">project home</a>.
</p>

<script>
const decls = {map_json};

function lookup() {{
  const hash = window.location.hash || "";
  const m = hash.match(/^#doc\\/(.+)$/);
  const status = document.getElementById("status");
  const result = document.getElementById("result");
  if (!m) {{
    status.textContent = "No declaration in URL fragment.";
    result.innerHTML = "Expected URL of the form <code>#doc/&lt;Name&gt;</code>.";
    return;
  }}
  const name = decodeURIComponent(m[1]);
  const url = decls[name];
  if (url) {{
    status.textContent = "Redirecting to source…";
    result.innerHTML = "<code>" + name + "</code> &rarr; <a href=\\"" + url + "\\">" + url + "</a>";
    window.location.replace(url);
  }} else {{
    status.innerHTML = '<span class="err">Declaration <code>' + name +
      '</code> not found in the project index.</span>';
    result.innerHTML = "It may be a Mathlib declaration; search at " +
      '<a href="https://leanprover-community.github.io/mathlib4_docs/find/' + hash + '">' +
      'leanprover-community.github.io/mathlib4_docs</a>.';
  }}
}}

window.addEventListener("hashchange", lookup);
lookup();
</script>
</body>
</html>
"""

with open("home_page/find/index.html", "w") as f:
    f.write(html)

print(f"Wrote home_page/find/index.html ({len(html)} bytes).")
