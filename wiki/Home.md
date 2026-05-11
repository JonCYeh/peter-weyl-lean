# Peter–Weyl, in Lean 4

A blueprint-driven Lean 4 formalization of the Peter–Weyl theorem for compact (Hausdorff) topological groups, following Tao's exposition. The end goal is

> **Theorem (Peter–Weyl).** For a compact Hausdorff topological group $G$, the matrix coefficients of finite-dimensional continuous unitary representations are dense in $C(G)$, and $L^2(G)$ decomposes as the Hilbert sum of the isotypic components indexed by the set $\widehat G$ of (equivalence classes of) finite-dimensional continuous unitary irreducible representations.

with a Plancherel-style statement on $L^2(G)$.

## Live artifacts

| Artifact | URL |
|---|---|
| Web blueprint | https://joncyeh.github.io/peter-weyl-lean/blueprint/ |
| Dependency graph | https://joncyeh.github.io/peter-weyl-lean/blueprint/dep_graph_document.html |
| Blueprint PDF | https://joncyeh.github.io/peter-weyl-lean/blueprint.pdf |
| API docs (doc-gen4) | https://joncyeh.github.io/peter-weyl-lean/docs/ |
| Source on GitHub | https://github.com/JonCYeh/peter-weyl-lean |

The web blueprint, dep graph, PDF, and API docs are rebuilt on every push to `main` by [`blueprint.yml`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/.github/workflows/blueprint.yml).

## What's here

The project is split into 11 chapters; see the sidebar or [the per-chapter notes](#per-chapter-notes) below. The two non-trivial pieces, in headline form:

- **Schur's lemma** for continuous unitary irreducibles (compact-operator form), proved via a self-adjoint / skew-adjoint decomposition plus the compact self-adjoint spectral theorem.
- **Existence of separating finite-dimensional irreducibles**: for every $g_0 \neq 1_G$ there is a finite-dim continuous unitary irreducible representation on which $g_0$ acts non-trivially. This is the technical heart of Tao's argument; it goes through convolution operators $T_\phi$ on $L^2(G)$ and the compact self-adjoint spectral theorem.

These feed into Stone–Weierstrass to give density of matrix coefficients in $C(G)$, then Schur orthogonality and the isotypic decomposition of $L^2(G)$.

## Project status snapshot

From [`blueprint/src/status.tex`](https://github.com/JonCYeh/peter-weyl-lean/blob/main/blueprint/src/status.tex):

- 89 `\lean{...}` citations in `content_comp.tex` covering 90 distinct Lean declarations.
- 51 real declarations, 38 sorry-bodied (41 sorries total in the project, including a few not directly cited).
- Two intentional external assumptions:
  1. The compact self-adjoint spectral theorem (not in Mathlib as of Jan 2026 — the pieces are in `Analysis/InnerProductSpace/Spectrum.lean` but not bundled).
  2. Schauder's theorem (adjoint of a compact operator is compact).

See [Per-chapter notes](#per-chapter-notes) for chapter-by-chapter sorry counts.

## How this maps to Mathlib

The `PeterWeyl` Lean library wraps Mathlib's Haar measure, $L^p$ space, and inner-product-space material. The `PeterWeylComp` library is everything that is genuinely new: `UnitaryRep`, `Subrep`, `IsIrreducible`, `Intertwiner`, the right/left regular representations on $L^2(G)$, convolution operators, matrix coefficients, isotypic decomposition.

## Per-chapter notes

1. [Ch01 Setup, Haar measure, L²(G)](Ch01-Setup) — all real, Mathlib + thin wrappers.
2. [Ch02 Continuous unitary representations](Ch02-Rep) — 8 sorries (regular representations).
3. [Ch03 Convolution as a bounded operator](Ch03-Convolution) — 8 sorries (Fubini / change of variables).
4. [Ch04 Approximate identities](Ch04-ApproxIdentity) — 2 sorries (Urysohn-style bump + convergence).
5. [Ch05 Compact self-adjoint spectral theorem (external)](Ch05-Spectral) — 1 external assumption, intentional.
6. [Ch06 Schur's lemma](Ch06-Schur) — 1 sorry (distinct-irreducible Schur).
7. [Ch07 Matrix coefficients](Ch07-MatrixCoeff) — 5 sorries (tensor, contragredient).
8. [Ch08 Separating irreducibles](Ch08-Separating) — 4 sorries (downstream wiring).
9. [Ch09 Density of matrix coefficients](Ch09-Density) — all real (Stone–Weierstrass).
10. [Ch10 Schur orthogonality](Ch10-Orthogonality) — 2 sorries (Bochner integration scaffolding).
11. [Ch11 Isotypic decomposition and Plancherel](Ch11-Isotypic) — 9 sorries.

## Contributing

See [Contributing](Contributing) for how the blueprint, dep graph, and issue tracker fit together, what `\leanok` / `\uses` mean, and how to claim a sorry.

## License & citation

Apache 2.0; see [LICENSE](https://github.com/JonCYeh/peter-weyl-lean/blob/main/LICENSE) and [CITATION.bib](https://github.com/JonCYeh/peter-weyl-lean/blob/main/CITATION.bib).
