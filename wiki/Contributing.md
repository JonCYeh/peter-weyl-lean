# Contributing

This is a blueprint-driven formalization. The blueprint LaTeX source ([`blueprint/src/content_comp.tex`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/blueprint/src/content_comp.tex)) is the spec; the Lean code under [`PeterWeylComp/`](https://github.com/JonCYeh/peter-weyl-lean/tree/main/PeterWeylComp) is the implementation. The two are linked by the [dependency graph](https://joncyeh.github.io/peter-weyl-lean/blueprint/dep_graph_document.html), which colors each node by Lean status.

## How to read the dep graph

Each node in the graph is one blueprint item — a definition, lemma, theorem, or corollary. Color encodes status:

| Color | Meaning |
|---|---|
| Green fill | Has a `\leanok` directive: a fully formalized Lean proof with no `sorry`. |
| Blue fill | Statement formalized (`\lean{...}` points to a Lean declaration), proof still has `sorry`. |
| Green outline only | Mathlib citation (`\mathlibok`) — proof is "in Mathlib", no local Lean term to write. |
| White | No Lean declaration yet. |

Dashed edges are `\uses{...}` dependencies. A node turns green only when (a) it has `\leanok` itself and (b) every node it `\uses` is also green. So the graph propagates "fully verified" outward from the roots.

## Where to start

1. Browse the [dep graph](https://joncyeh.github.io/peter-weyl-lean/blueprint/dep_graph_document.html) and find a blue node — one that's stated in Lean but has a `sorry`.
2. Find the corresponding issue in [Issues](https://github.com/JonCYeh/peter-weyl-lean/issues). They're filed in three flavors:
   - `[Cluster] Ch.N ...` — a logically coherent chunk of multiple sorries.
   - `[External] ...` — Mathlib gaps (compact-adjoint, spectral theorem).
   - Atomic per-lemma issues for individual sorries.
3. Comment on the issue to claim it before starting work.

## Issue labels

| Label | Meaning |
|---|---|
| `chapter:setup` … `chapter:isotypic` | Which blueprint chapter the item belongs to. |
| `priority:p1` / `p2` / `p3` | Cleanup-pass priority from [`status.tex`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/blueprint/src/status.tex). |
| `type:cluster` | A multi-sorry cluster issue grouping a chapter's leftover work. |
| `external:mathlib-gap` | Depends on something not yet in Mathlib; the project treats it as a black-box assumption. |
| `area:fubini`, `area:tensor`, … | Cross-cutting math themes. |

## The blueprint workflow (per item)

Pick a blue node corresponding to a Lean declaration `Foo.bar` with `sorry`:

1. **Find the declaration.** The `\lean{Foo.bar}` directive in the blueprint tells you the exact name; the source is under [`PeterWeylComp/`](https://github.com/JonCYeh/peter-weyl-lean/tree/main/PeterWeylComp).
2. **Check `\uses{...}`** on both the statement and the proof block. Anything listed there is fair to call as a lemma — the dep-graph contract guarantees it's available (either real or sorry-bodied).
3. **Replace `sorry` with a proof.** If you discover a missing helper, write it as a separate lemma, give it a `\lean{...}` name, and cite it from the parent `\uses{...}`.
4. **Add `\leanok` to the blueprint** for the now-completed item (and to the statement if it was missing). The dep-graph color refreshes on the next CI build.

## Repeating local builds

```bash
# Lean build
lake build

# Blueprint web + dep graph (needs system graphviz + pygraphviz)
cd blueprint && leanblueprint web

# Blueprint PDF
cd blueprint && leanblueprint pdf
```

The web blueprint lives at `blueprint/web/index.html` after building; the dep graph is `blueprint/web/dep_graph_document.html`.

## Quick-serve dep graph locally

```bash
cd blueprint/web && python3 -m http.server 8000
# open http://localhost:8000/dep_graph_document.html
```

## House style

- One syntactic conclusion per lemma (no "X is closed and invariant"; split into two).
- All variables typed explicitly in the statement.
- `\uses{...}` lists *exactly* the prior items used.
- Lean proofs are decomposed into one `have` per blueprint sub-lemma.
- Every locally defined object has a `\lean{...}` directive giving its Lean name in a coherent namespace.

## External assumptions

The project intentionally keeps two items as external (`\begin{assumption}` blocks in the blueprint):

1. **Compact self-adjoint spectral theorem** (bundled form) — Mathlib has the components in `Analysis/InnerProductSpace/Spectrum.lean` but not the combined statement.
2. **Schauder's theorem** (`IsCompactOperator.adjoint`) — not in Mathlib at any name we could find.

These should remain black boxes until they land in Mathlib upstream. Don't try to prove them in this repo — file an upstream PR instead.

## Project board

A [GitHub Projects v2 board](https://github.com/users/JonCYeh/projects) groups the open issues by priority/chapter. If a board doesn't exist yet, run [`scripts/setup_project_board.sh`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/scripts/setup_project_board.sh) (requires `gh auth refresh -s project`).
